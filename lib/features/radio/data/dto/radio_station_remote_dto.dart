import 'package:json_annotation/json_annotation.dart';

part 'radio_station_remote_dto.g.dart';

/// Data Transfer Object for a radio station
///
/// This class represents the radio station data as it comes from the API.
/// It uses json_serializable for JSON serialization.
@JsonSerializable(fieldRename: FieldRename.snake)
class RadioStationRemoteDto {
  /// Creates a new instance of [RadioStationRemoteDto]
  ///
  /// This constructor creates a new [RadioStationRemoteDto] instance with
  /// all required fields.
  const RadioStationRemoteDto({
    required this.stationuuid,
    required this.name,
    required this.url,
    required this.homepage,
    required this.favicon,
    required this.tags,
    required this.language,
    required this.country,
    this.changeuuid,
    this.serveruuid,
    this.urlResolved,
    this.countrycode,
    this.state,
    this.languagecodes,
    this.votes,
    this.lastchangetime,
    this.lastchangetimeIso8601,
    this.codec,
    this.bitrate,
    this.hls,
    this.lastcheckok,
    this.lastchecktime,
    this.lastchecktimeIso8601,
    this.lastcheckoktime,
    this.lastcheckoktimeIso8601,
    this.lastlocalchecktime,
    this.lastlocalchecktimeIso8601,
    this.clicktimestamp,
    this.clicktimestampIso8601,
    this.clickcount,
    this.clicktrend,
    this.sslError,
    this.hasExtendedInfo,
    this.geoLat,
    this.geoLong,
    this.iso31662,
    this.geoDistance,
  });

  /// Creates a [RadioStationRemoteDto] from a JSON map
  factory RadioStationRemoteDto.fromJson(Map<String, dynamic> json) =>
      _$RadioStationRemoteDtoFromJson(json);

  /// The unique identifier for changes
  final String? changeuuid;

  /// The unique identifier for the station
  final String stationuuid;

  /// The unique identifier for the server
  final String? serveruuid;

  /// The name of the station
  final String name;

  /// The URL of the station
  final String url;

  /// The resolved URL of the station
  final String? urlResolved;

  /// The homepage URL of the station
  final String homepage;

  /// The favicon URL of the station
  final String favicon;

  /// The tags associated with the station
  final String tags;

  /// The country where the station is located
  final String country;

  /// The country code where the station is located
  final String? countrycode;

  /// The state where the station is located
  final String? state;

  /// The language of the station
  final String language;

  /// The language codes of the station
  final String? languagecodes;

  /// The number of votes for the station
  final int? votes;

  /// The last change time
  final String? lastchangetime;

  /// The last change time in ISO8601 format
  final String? lastchangetimeIso8601;

  /// The codec used by the station
  final String? codec;

  /// The bitrate of the station
  final int? bitrate;

  /// Whether the station uses HLS
  final int? hls;

  /// Whether the last check was OK
  final int? lastcheckok;

  /// The last check time
  final String? lastchecktime;

  /// The last check time in ISO8601 format
  final String? lastchecktimeIso8601;

  /// The last check OK time
  final String? lastcheckoktime;

  /// The last check OK time in ISO8601 format
  final String? lastcheckoktimeIso8601;

  /// The last local check time
  final String? lastlocalchecktime;

  /// The last local check time in ISO8601 format
  final String? lastlocalchecktimeIso8601;

  /// The click timestamp
  final String? clicktimestamp;

  /// The click timestamp in ISO8601 format
  final String? clicktimestampIso8601;

  /// The number of clicks
  final int? clickcount;

  /// The click trend
  final int? clicktrend;

  /// Whether there is an SSL error
  final int? sslError;

  /// The latitude of the station
  final double? geoLat;

  /// The longitude of the station
  final double? geoLong;

  /// Whether the station has extended info
  final bool? hasExtendedInfo;

  /// The ISO 3166-2 code
  final String? iso31662;

  /// The geographic distance
  final double? geoDistance;

  @override
  String toString() {
    return 'RadioStationRemoteDto('
        'stationuuid: $stationuuid, '
        'name: $name, '
        'url: $url, '
        'homepage: $homepage, '
        'favicon: $favicon, '
        'tags: $tags, '
        'language: $language, '
        'country: $country, '
        'codec: $codec, '
        'bitrate: $bitrate, '
        'hls: $hls, '
        'lastcheckok: $lastcheckok, '
        'lastchecktime: $lastchecktime, '
        'lastlocalchecktime: $lastlocalchecktime, '
        'clicktimestamp: $clicktimestamp, '
        'clickcount: $clickcount, '
        'clicktrend: $clicktrend, '
        'sslError: $sslError, '
        'hasExtendedInfo: $hasExtendedInfo)';
  }
}
