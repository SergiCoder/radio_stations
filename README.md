# Radio 

A Flutter application for streaming online radio stations.

## Features

- Browse and search radio stations
- Stream audio with playback controls
- View station details and metadata
- Dark theme with purple accents
- Responsive design for all screen sizes

## Architecture

The application follows Clean Architecture principles with the following layers:

- **Presentation**: UI components and state management using Cubit
- **Domain**: Business logic and entities
- **Data**: DTOs and data sources

## Dependencies

- `audio_service`: Background audio playback service
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `hive_ce`: Local storage
- `http`: Network requests
- `just_audio`: Audio playback
- `json_annotation` & `json_serializable`: JSON serialization
- `path_provider`: File system access

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
│   │   ├── data/   # Data layer
│   │   ├── domain/ # Domain layer
│   │   └── presentation/ # UI layer
│   └── splash/     # Splash screen feature
└── main.dart       # Application entry point
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.