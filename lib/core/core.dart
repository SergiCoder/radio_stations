/// Core barrel file
///
/// This is the main barrel file for the core module, exporting all core
/// functionality used throughout the application.
///
/// It provides utilities, design system components, database access,
/// and dependency injection setup in a structured way.

// Re-export database functionality
export 'database/database.dart';
// Re-export design system with a prefix for clearer imports
export 'design_system/design_system.dart';
// Export only the main entry point for dependency injection
// The full DI implementation is available via the di barrel
export 'di/injection.dart' show getIt, init;
// Re-export core utilities
export 'utils/utils.dart';
