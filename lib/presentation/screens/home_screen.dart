import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chip.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/category.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  String? _selectedCategoryId;
  Priority? _selectedPriority;
  bool? _showCompleted;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final categories = ref.watch(categoriesProvider);
    final filter = TaskFilter(
      query: _searchQuery,
      categoryId: _selectedCategoryId,
      priority: _selectedPriority,
      showCompleted: _showCompleted,
    );
    final tasks = ref.watch(filteredTasksProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => context.push('/settings'),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(user.displayName?[0] ?? 'U')
                      : null,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'Sign in',
              onPressed: () => context.push('/settings'),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchBarWidget(
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
          ),
          categories.when(
            data: (cats) => _buildCategoryFilter(cats),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          _buildFilterChips(),
          Expanded(
            child: tasks.when(
              data: (list) => list.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: list.length,
                      itemBuilder: (ctx, i) =>
                          TaskCard(task: list[i]),
                    ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/task/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildCategoryFilter(List<Category> categories) {
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          CategoryChip(
            label: 'All',
            isSelected: _selectedCategoryId == null,
            colorValue: null,
            onTap: () =>
                setState(() => _selectedCategoryId = null),
          ),
          ...categories.map((cat) => CategoryChip(
                label: cat.name,
                isSelected: _selectedCategoryId == cat.id,
                colorValue: cat.colorValue,
                onTap: () => setState(() => _selectedCategoryId =
                    _selectedCategoryId == cat.id ? null : cat.id),
              )),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Active'),
            selected: _showCompleted == false,
            onSelected: (v) =>
                setState(() => _showCompleted = v ? false : null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Done'),
            selected: _showCompleted == true,
            onSelected: (v) =>
                setState(() => _showCompleted = v ? true : null),
          ),
          const SizedBox(width: 8),
          DropdownButton<Priority?>(
            value: _selectedPriority,
            underline: const SizedBox(),
            hint: const Text('Priority'),
            items: [
              const DropdownMenuItem(
                  value: null, child: Text('All')),
              ...Priority.values.map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.name[0].toUpperCase() +
                        p.name.substring(1)),
                  )),
            ],
            onChanged: (p) =>
                setState(() => _selectedPriority = p),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text('No tasks here',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Tap + to add one',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
