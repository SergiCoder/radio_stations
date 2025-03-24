# Radio Stations

A Flutter application for streaming online radio stations with a clean, modern UI and robust architecture.

## Features

- Browse, search, and filter radio stations
- Filter stations by country or favorites
- Stream audio with playback controls (play/pause, previous/next, volume)
- Background audio playback support
- Mark stations as favorites for quick access
- Automatic handling of broken station links
- Dark theme with Material 3 design
- Responsive layout for various screen sizes
- Full offline support with local storage

## Screenshots

*Add screenshots here*

## Architecture

The application follows Clean Architecture principles with a feature-first organization:

- **Presentation Layer**: UI components and BLoC for state management
- **Domain Layer**: Business logic, use cases, and entities
- **Data Layer**: Repositories, data sources, and DTOs

The app uses the following architectural patterns:
- **Repository Pattern**: For data abstraction
- **BLoC Pattern**: For state management
- **Dependency Injection**: For loose coupling between components
- **Use Case Pattern**: For business logic operations

## Tech Stack

### Core Technologies
- **Flutter**: UI framework
- **Dart**: Programming language
- **BLoC**: State management
- **GetIt**: Dependency injection
- **Hive**: Local storage

### Audio Features
- **just_audio**: Cross-platform audio playback
- **audio_service**: Background audio support

### Code Quality
- **very_good_analysis**: Strict Dart linting rules
- **Semantic versioning**: For dependency management
- **Unit testing**: For business logic validation

## Dependencies

### Core Dependencies
- `flutter_bloc: ^9.1.0`: State management
- `get_it: ^8.0.3`: Dependency injection
- `just_audio: ^0.9.46`: Audio playback
- `audio_service: ^0.18.17`: Background audio support
- `hive_ce: ^2.10.1`: Local storage
- `http: ^1.3.0`: Network requests
- `json_annotation: ^4.9.0`: JSON serialization
- `path_provider: ^2.1.2`: File system access
- `url_launcher: ^6.2.4`: Open external URLs

### Development Dependencies
- `build_runner: ^2.4.8`: Code generation
- `hive_generator: ^2.0.1`: Hive code generation
- `json_serializable: ^6.7.1`: JSON serialization code generation
- `very_good_analysis: ^7.0.0`: Static analysis

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/radio_stations.git
   cd radio_stations
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run code generation
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                  # Core functionality
│   ├── constants/         # App-wide constants
│   ├── database/          # Database configuration
│   ├── design_system/     # Design system components
│   │   └── theme/         # Theme configuration
│   ├── di/                # Dependency injection
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── audio/             # Audio playback feature
│   │   ├── data/          # Audio data layer
│   │   └── domain/        # Audio domain layer
│   ├── radio/             # Radio station feature
│   │   ├── data/          # Radio data layer
│   │   ├── domain/        # Radio domain layer
│   │   └── presentation/  # Radio UI components
│   │       ├── bloc/      # State management
│   │       └── widgets/   # UI components
│   │           ├── atoms/     # Atomic widgets
│   │           ├── molecules/ # Molecular widgets
│   │           ├── organisms/ # Organism widgets
│   │           ├── templates/ # Template widgets
│   │           └── pages/     # Page widgets
│   └── shared/            # Shared functionality
│       └── domain/        # Shared domain entities
└── main.dart              # Application entry point
```

## Design System

The app implements an atomic design system with:

- **Atoms**: Smallest UI components (buttons, icons, inputs)
- **Molecules**: Groups of atoms (search fields, list items)
- **Organisms**: Complex UI sections (lists, control bars)
- **Templates**: Page layouts without specific content
- **Pages**: Specific instances of templates with real data

## State Management

The app uses BLoC for state management with:
- **Events**: Input events that trigger state changes
- **States**: Different UI states the app can be in
- **BLoC**: Business logic that processes events and emits states

## Performance Optimizations

- Debouncing for search inputs
- Lazy loading of radio stations
- Efficient state management with BLoC selectors
- Background audio processing with audio_service
- Local caching for offline support

## Development

This project follows:
- Material 3 design guidelines
- Flutter best practices
- Clean code principles
- Consistent error handling
- Comprehensive documentation

## License

This project is licensed under the MIT License - see the LICENSE file for details.