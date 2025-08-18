## Sun Tan App — Implementation Plan

Standalone Flutter app (Android/iOS) that guides a user through the fixed multi-session "Goltis Scheme" tanning program, fully offline. The logic will be ported from the existing Telegram bot backend in `sun_tan_bot/` (notably `LevelService.java` and `TimerService.java`).

### Goals (MVP)
- Start a new tanning program from level 1.
- Automatically select the next level based on completed levels and time between sessions (per "Goltis" rules).
- Allow the user to override and pick any level manually.
- Work fully offline; store progress locally in a file (no accounts, no remote APIs).

### Non-goals (for now)
- Cloud sync, user accounts, or server connectivity.
- Complex analytics/telemetry.
- Custom design system beyond Material defaults.

## Architecture

Flutter + BLoC (unidirectional data flow), layered by feature:
- **Presentation (UI)**: Material 3 widgets and screens.
- **State Management**: `flutter_bloc` for event/state orchestration.
- **Domain**: immutable entities and rules for level advancement (ported from `sun_tan_bot`).
- **Data**: local file storage for program state; no database.

We will prefer `hydrated_bloc` to persist the core `ProgramBloc` state to a file automatically. This satisfies the "file-based" persistence requirement while simplifying I/O. For any additional metadata (e.g., history), we will store a compact JSON (`progress.json`) in the app documents directory using `path_provider`.

### Dependencies (planned)
- `flutter_bloc`, `bloc_test` — BLoC pattern and testing.
- `hydrated_bloc` — file-based persistence of BLoC state.
- `equatable` — value equality for states/models.
- `path_provider` — file path resolution for local storage.
- `json_annotation`, `json_serializable`, `build_runner` — model serialization.
- `intl` — date/time formatting.
- `mocktail` — mocking in tests.

Optional (phase 2, if we add out-of-app reminders):
- `flutter_local_notifications` (+ `timezone`) — local notifications for session steps.

## Domain Model (draft)
- `Level` — index, name, and rules (durations/structure) as defined by "Goltis Scheme".
- `SessionStep` — a single timed step inside a session (if applicable).
- `ProgramProgress` — current level, history of completions, last completion timestamp.
- `GoltisRules` — pure functions that compute the next level given `ProgramProgress` and current time. These will be ported from:
  - `sun_tan_bot/src/main/java/org/santan/services/LevelService.java`
  - `sun_tan_bot/src/main/java/org/santan/services/TimerService.java`

## BLoCs
- `ProgramBloc`
  - Events: `StartProgram`, `CompleteLevel`, `OverrideLevel(levelIndex)`, `LoadSaved`, `ResetProgram`.
  - State: `ProgramState { currentLevel, history, lastCompletedAt, isLoading }`.
  - Behavior: selects next level per `GoltisRules`; persists state via `hydrated_bloc`.

- `SessionBloc` (optional for MVP if we include guided timers)
  - Events: `StartSession(level)`, `Tick`, `Pause`, `Resume`, `FinishSession`.
  - State: current step/time remaining; may schedule local notifications in phase 2.

## Storage
- Persist `ProgramBloc` via `hydrated_bloc` (stored in app documents directory as a file).
- Additionally, a readable JSON snapshot at `progress.json` may be maintained for debugging and potential future migration.

Example `progress.json` (illustrative):
```
{
  "currentLevel": 3,
  "history": [
    { "level": 1, "completedAt": "2025-06-21T10:15:00Z" },
    { "level": 2, "completedAt": "2025-06-23T09:10:00Z" }
  ],
  "lastCompletedAt": "2025-06-23T09:10:00Z"
}
```

## UI and Navigation (MVP)
- Home Screen
  - Shows current level, recommended next level, last completion time.
  - Primary actions: Start/Complete session, Override level.
- Level Picker Screen
  - Grid/list of all levels with details; pick any to override.
- Session Screen (if timers included in MVP)
  - Shows step-by-step guidance and a countdown.
- History Screen (optional in MVP)
  - Simple list of past completions.

## Mapping from Telegram Bot Logic
- Reuse/port rules from `LevelService` (level transitions) and `TimerService` (session timing). The logic is deterministic and identical for all users, so it will be encoded locally as constants plus rule functions.
- Ensure edge cases (e.g., long gaps between sessions) map to the same level selection behavior as the bot.

## Testing Strategy
- Unit tests
  - `GoltisRules` next-level selection (covers primary and edge cases).
  - `ProgramBloc` behavior: start, complete, override, persistence round-trip.
- Widget tests
  - Home → Override → Level Picker → Apply override → Home state updated.
  - Start session flow (if timers included) basic UI state progression.
- Serialization tests
  - JSON encode/decode for models and hydrated state.

Target: high coverage for domain rules and `ProgramBloc` (80%+ for these modules), and at least one end-to-end widget test for the main flow.

## Folder Structure (planned)
```
lib/
  core/
    utils/
  features/program/
    domain/
      entities/
      rules/
      repositories/
    data/
      datasources/
      models/
      repositories/
    presentation/
      bloc/
      pages/
      widgets/
```

## Implementation Steps
1) Domain rules and models
   - Define `Level`, `ProgramProgress`, and `GoltisRules` based on `sun_tan_bot` logic.
2) Persistence
   - Set up `hydrated_bloc`; add JSON model serialization; wire to app documents directory.
3) ProgramBloc
   - Implement events/states and rule-driven next-level selection.
4) UI Skeleton
   - Home and Level Picker with Material 3 components; minimal layout.
5) Session (optional in MVP)
   - Basic in-app timer; phase 2 may add local notifications.
6) Tests
   - Unit tests for rules and bloc; widget tests for main flows.
7) Polish
   - Empty/error states, accessibility labels, basic theming.

## Assumptions & Risks
- "Goltis Scheme" details will be taken verbatim from the current `sun_tan_bot` implementation; any missing nuances will be clarified against `LevelService`/`TimerService`.
- Background timers/local notifications on iOS/Android may require additional permissions and setup; initially, timers run in-app with optional phase-2 notifications.

## Run & Test (when implemented)
- Run: `flutter run` (select Android/iOS target)
- Test: `flutter test`
