# Flutter Flappy Bird Clone

Started as a simple project to learn the basics of Flutter and game development with Flame, this project evolved into a comprehensive study of Software Architecture and Design Patterns applied to Flutter games.

<img src="https://github.com/user-attachments/assets/a7344ee7-b0b8-47d2-b676-31bbcfd8d98d" width="280">

## Architecture: Feature-First

The project structure is reorganized following a **Feature-First** approach, where code is grouped by business features rather than technical layers. This ensures better scalability and maintainability.

### Directory Structure

```text
lib/
├── core/                  # Constants and Utilities
├── features/
│   ├── audio/             # AudioManager (Singleton)
│   ├── background/        # Background Component
│   ├── bird/              # Bird Component
│   ├── game/              # Core Game Logic (FlappyBirdGame)
│   ├── menu/              # UI Screens (Welcome, Game Over)
│   ├── pipe/              # Pipe Component, Factory, and Pool
│   └── score/             # ScoreManager (Singleton)
└── main.dart              # Entry Point
```

## Design Patterns Used

To demonstrate clean code practices in game development, the following 5 Design Patterns were applied:

1.  **Singleton Pattern**: Used for `AudioManager` and `ScoreManager` to ensure a single global instance for managing audio and score state/persistence.
2.  **Factory Pattern**: Implemented in `PipeFactory` (`lib/features/pipe/pipe_manager.dart`) to encapsulate the creation logic of pipes, abstracting complexity from the game loop.
3.  **Object Pool Pattern**: Used in `PipePool` to reuse Pipe objects efficiently, preventing frequent garbage collection and ensuring smooth performance.
4.  **State Pattern**: Applied in handling the App Lifecycle (via `WidgetsBindingObserver`) to transition the game between Active, Paused, and Inactive states correctly.
5.  **Observer Pattern**: Utilized `ChangeNotifier` in `ScoreManager` to allow the UI to react to score changes, decoupling the game logic from the interface.

## Getting Started

1.  Clone the repository.
2.  Run `flutter pub get` to install dependencies.
3.  Run `flutter run` to start the game.
