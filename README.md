# Radio Stations

A Flutter application for streaming online radio stations with a modern design.

## Features

- Browse and search radio stations
- Stream audio with playback controls
- View station details and metadata
- Dark theme with purple accents
- Background audio playback
- Local storage for favorites and settings
- Clean and intuitive user interface

## Architecture

The application follows Clean Architecture principles with the following layers:

- **Presentation**: UI components and state management using Cubit
- **Domain**: Business logic and entities
- **Data**: DTOs and data sources

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

### Development Dependencies
- `build_runner: ^2.4.8`: Code generation
- `hive_generator: ^2.0.1`: Hive code generation
- `json_serializable: ^6.7.1`: JSON serialization code generation
- `very_good_analysis: ^7.0.0`: Static analysis

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/           # Core utilities and configurations
│   ├── di/         # Dependency injection
│   ├── theme/      # Theme configuration
│   └── utils/      # Utility classes
├── features/       # Feature modules
│   ├── radio/      # Radio station feature
│   └── splash/     # Splash screen feature
└── main.dart       # Application entry point
```

## Development

This project uses:
- Flutter SDK ^3.7.2
- Very Good Analysis for static analysis
- Clean Architecture principles
- BLoC pattern for state management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.