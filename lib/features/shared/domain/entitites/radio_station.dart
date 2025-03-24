import 'package:equatable/equatable.dart';

/// Represents a radio station in the domain layer
///
/// This class encapsulates all the essential information about a radio station,
/// including its identification, streaming details, and metadata.
///
/// The class is immutable and follows the entity pattern in clean architecture.
/// All validation is expected to be performed in the mapper layer before creating instances.
class RadioStation extends Equatable {
  /// Creates a new radio station entity
  ///
  /// All required parameters must be provided to ensure a complete radio station entity.
  /// Validation of these parameters should be performed in the mapper layer.
  const RadioStation({
    required this.uuid,
    required this.name,
    required this.url,
    required this.homepage,
    required this.favicon,
    required this.country,
    this.isFavorite = false,
    this.broken = false,
  });

  /// Unique identifier for the station
  final String uuid;

  /// Name of the radio station
  final String name;

  /// Stream URL
  final String url;

  /// Station's website
  final String homepage;

  /// Station's favicon URL
  final String favicon;

  /// Country where the station is based
  final String country;

  /// Whether this station is marked as a favorite
  final bool isFavorite;

  /// Whether the station is broken (stream is not working)
  final bool broken;

  /// Creates a copy of this [RadioStation] with the given fields replaced
  RadioStation copyWith({
    String? uuid,
    String? name,
    String? url,
    String? homepage,
    String? favicon,
    String? country,
    bool? isFavorite,
    bool? broken,
  }) {
    return RadioStation(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      url: url ?? this.url,
      homepage: homepage ?? this.homepage,
      favicon: favicon ?? this.favicon,
      country: country ?? this.country,
      isFavorite: isFavorite ?? this.isFavorite,
      broken: broken ?? this.broken,
    );
  }

  @override
  List<Object?> get props => [
    uuid,
    name,
    url,
    homepage,
    favicon,
    country,
    isFavorite,
    broken,
  ];

  @override
  String toString() {
    return 'RadioStation('
        'uuid: $uuid, '
        'name: $name, '
        'url: $url, '
        'homepage: $homepage, '
        'favicon: $favicon, '
        'country: $country, '
        'favorite: $isFavorite, '
        'broken: $broken)';
  }
}
