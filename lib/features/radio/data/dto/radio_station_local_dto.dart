import 'package:hive_ce/hive.dart';

/// Data transfer object for radio stations stored locally
///
/// This class represents a radio station as it is stored in the local database.
/// It contains all the necessary information to display and play a radio station.
class RadioStationLocalDto extends HiveObject {
  /// Creates a new instance of [RadioStationLocalDto]
  RadioStationLocalDto({
    required this.changeuuid,
    required this.name,
    required this.url,
    required this.homepage,
    required this.favicon,
    required this.country,
    this.isFavorite = false,
    this.broken = false,
  });

  /// Creates a [RadioStationLocalDto] from a JSON map
  factory RadioStationLocalDto.fromJson(Map<String, dynamic> json) {
    return RadioStationLocalDto(
      changeuuid: json['changeuuid'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      homepage: json['homepage'] as String,
      favicon: json['favicon'] as String,
      country: json['country'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      broken: json['broken'] as bool? ?? false,
    );
  }

  /// The unique identifier for changes
  final String changeuuid;

  /// The name of the radio station
  final String name;

  /// The URL of the radio stream
  final String url;

  /// The URL of the station's website
  final String homepage;

  /// The URL of the station's favicon
  final String favicon;

  /// The country where the radio station is located
  final String country;

  /// Whether the station is marked as favorite
  final bool isFavorite;

  /// Whether the station is broken (stream is not working)
  final bool broken;

  /// Converts this [RadioStationLocalDto] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'changeuuid': changeuuid,
      'name': name,
      'url': url,
      'homepage': homepage,
      'favicon': favicon,
      'country': country,
      'isFavorite': isFavorite,
      'broken': broken,
    };
  }

  /// Creates a copy of this [RadioStationLocalDto] with the given fields replaced
  RadioStationLocalDto copyWith({
    String? changeuuid,
    String? name,
    String? url,
    String? homepage,
    String? favicon,
    String? country,
    bool? isFavorite,
    bool? broken,
  }) {
    return RadioStationLocalDto(
      changeuuid: changeuuid ?? this.changeuuid,
      name: name ?? this.name,
      url: url ?? this.url,
      homepage: homepage ?? this.homepage,
      favicon: favicon ?? this.favicon,
      country: country ?? this.country,
      isFavorite: isFavorite ?? this.isFavorite,
      broken: broken ?? this.broken,
    );
  }
}

/// Type adapter for [RadioStationLocalDto]
class RadioStationLocalDtoAdapter extends TypeAdapter<RadioStationLocalDto> {
  @override
  final int typeId = 0;

  @override
  RadioStationLocalDto read(BinaryReader reader) {
    return RadioStationLocalDto(
      changeuuid: reader.readString(),
      name: reader.readString(),
      url: reader.readString(),
      homepage: reader.readString(),
      favicon: reader.readString(),
      country: reader.readString(),
      isFavorite: reader.readBool(),
      broken: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, RadioStationLocalDto obj) {
    writer
      ..writeString(obj.changeuuid)
      ..writeString(obj.name)
      ..writeString(obj.url)
      ..writeString(obj.homepage)
      ..writeString(obj.favicon)
      ..writeString(obj.country)
      ..writeBool(obj.isFavorite)
      ..writeBool(obj.broken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioStationLocalDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
