import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../../domain/entities/task.dart' as domain;

/// Manages local push notifications for task due-date reminders.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialises the notification plugin. Must be called before any other method.
  static Future<void> init() async {
    if (kIsWeb) return;
    tz_data.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: (_) {},
    );
    _initialized = true;
  }

  /// Requests notification permission from the OS (Android 13+).
  static Future<bool> requestPermission() async {
    if (kIsWeb || !_initialized) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Shows a rationale dialog before requesting permission.
  static Future<void> requestPermissionWithRationale(BuildContext context) async {
    final should = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text(
          'Allow notifications to receive reminders one hour before tasks are due.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Allow')),
        ],
      ),
    );
    if (should == true) await requestPermission();
  }

  /// Schedules a reminder notification one hour before [task.dueDate].
  static Future<void> scheduleTaskReminder(domain.Task task) async {
    if (kIsWeb || !_initialized || task.dueDate == null) return;
    final scheduledDate = tz.TZDateTime.from(
      task.dueDate!.subtract(const Duration(hours: 1)),
      tz.local,
    );
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      task.id.hashCode,
      'Task due soon',
      task.title,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Reminders for upcoming tasks',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: task.id,
    );
  }

  /// Cancels any scheduled reminder for [taskId].
  static Future<void> cancelTaskReminder(String taskId) async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancel(taskId.hashCode);
  }
}
