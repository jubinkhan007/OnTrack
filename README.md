# OnTrack (kick_track)

A task management mobile app built with Flutter for internal corporate use at RFL Group. Staff members can create tasks, assign them to colleagues across business units, track progress, and collaborate through comments.

## Features

- **Authentication** — Login via HRIS staff ID/password or email account. Supports remember-me for auto-login.
- **Task Dashboard** — Two views: "Created By Me" and "Assigned To Me". Filter by business unit, staff member, and status (Pending/Overdue/Completed).
- **Task Creation** — Create tasks with title, description, assignees, due date, priority (Urgent/High/Normal/Low), and type (TO DO/Project).
- **Task Details & Sub-tasks** — Each assignee gets a sub-task. Assignees can update their progress (0-100%) and status.
- **Comments** — Chat-style comment threads on tasks and sub-tasks.
- **Notifications** — Push notifications via Firebase Cloud Messaging when tasks are assigned.
- **Staff Sync** — Downloads staff directory from all business units to local SQLite for offline access.
- **Account Management** — Signup (iOS), logout, and account deletion.

## User Types

| Type | Login | Capabilities |
|------|-------|-------------|
| HRIS Staff | Staff ID + password | Create tasks, assign to others, view both tabs, filter by BU/staff, delete own tasks |
| Email User | Email + password | View assigned tasks only, create self-assigned tasks |

## Tech Stack

- **Framework:** Flutter (SDK ^3.5.3)
- **State Management:** Provider (MVVM pattern)
- **Networking:** Dio with custom interceptors
- **Local Database:** SQLite (staff directory cache)
- **Local Storage:** SharedPreferences (credentials/session)
- **Push Notifications:** Firebase Cloud Messaging + flutter_local_notifications
- **UI:** Google Fonts, Shimmer loading, CachedNetworkImage

## Project Structure

```
lib/
├── config/          # Constants, enums, themes, routes, extensions, notifications
├── network/         # Dio setup, interceptors, UI state, error handling
├── db/              # SQLite database, DAOs (staff, sync)
├── models/          # Data models (task, sub-task, comment, user, BU)
├── repo/            # Repository layer (API calls)
├── viewmodel/       # Business logic (ChangeNotifier providers)
├── screens/         # UI screens (login, dashboard, task details, comments, sync, signup)
└── widgets/         # Reusable UI components (task items, filters, drawers, bottom sheets)
```

## Architecture

MVVM with a repository layer:

```
Screen (UI) → ViewModel (ChangeNotifier) → Repository → Dio (API)
                                         → DAO (SQLite)
```

## Getting Started

1. Ensure Flutter SDK ^3.5.3 is installed
2. Clone the repository
3. Run `flutter pub get`
4. Configure Firebase (`firebase_options.dart` must be present)
5. Run the app: `flutter run`

## API

- **Main API:** `https://ego.rflgroupbd.com:8077/ords/rpro/kickall/`
- **File Upload:** `http://swift.prangroup.com:8521/alphan/`
- Communication uses custom headers (`vm`, `va`, `vb`, `vc`, etc.) to specify operation type and parameters.
