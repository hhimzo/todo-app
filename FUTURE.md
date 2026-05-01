# V2 Roadmap

## Cloud Sync

### Option A: Supabase (Recommended — free tier)

Supabase offers a generous free tier (500 MB database, 2 GB file storage).

**Implementation plan:**
1. Add `supabase_flutter` dependency
2. Create `RemoteTaskDataSource` implementing the same interface as the local datasource
3. Implement a `SyncRepository` that merges local-first writes with remote state using last-write-wins + `updatedAt` timestamps
4. Add a background sync worker that fires on app resume and network reconnection
5. Store Supabase URL and anon key in `.env`

### Option B: Firebase (Spark plan — free)

- Use `cloud_firestore` for tasks collection
- Use `firebase_auth` to replace the Google Sign-In scaffold
- Cost: free up to 1 GB storage, 50k reads/day

## Additional v2 Features

- [ ] Recurring tasks (daily / weekly / monthly)
- [ ] Task attachments (photos via `image_picker`)
- [ ] Collaboration / shared lists (requires cloud sync)
- [ ] Android home screen widget via `home_widget`
- [ ] Wear OS companion app
- [ ] iOS / macOS targets (Flutter supports these with minimal changes)
