/// Audio feature barrel file
///
/// This is the main barrel file for the audio feature, providing access to
/// all components including implementations. This approach favors convenience
/// over strict encapsulation, making all parts of the feature accessible from
/// a single import.

// Data layer exports - including implementations
export 'data/data.dart';

// Domain layer exports - interfaces and models
export 'domain/domain.dart';
