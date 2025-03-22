import 'package:flutter/foundation.dart';

/// Represents a radio station list item in the domain layer
///
/// This class contains only the essential information needed for displaying
/// a radio station in a list view. It is designed to be lightweight and
/// efficient for use in list-based UI components.
@immutable
class RadioStationListItem {
  /// Creates a new instance of [RadioStationListItem]
  ///
  /// [uuid] is the unique identifier for the station
  /// [name] is the display name of the station
  /// [favorite] indicates if this station is marked as a favorite
  const RadioStationListItem({
    required this.uuid,
    required this.name,
    required this.broken,
    required this.favicon,
    required this.favorite,
  });

  /// Unique identifier for the station
  ///
  /// This identifier is used to uniquely identify the radio station
  /// across the application.
  final String uuid;

  /// Name of the radio station
  ///
  /// The display name used to represent the station in the UI.
  /// This is typically the name shown in lists and menus.
  final String name;

  /// URL of the station's favicon
  ///
  /// The URL of the station's favicon image.
  final String favicon;

  /// Whether this station is marked as a favorite
  ///
  /// Indicates if the user has marked this station as a favorite.
  final bool favorite;

  /// Whether this station is broken
  ///
  /// Indicates if the station is broken and cannot be played.
  final bool broken;

  /// Compares this radio station list item with another object for equality
  ///
  /// Returns true if the other object is a [RadioStationListItem] with
  /// identical [uuid], [name], and [favorite] values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioStationListItem &&
        other.uuid == uuid &&
        other.name == name &&
        other.favorite == favorite;
  }

  /// Generates a hash code for this radio station list item
  ///
  /// The hash code is based on the [uuid], [name], and [favorite] values.
  /// This ensures that equal objects have equal hash codes.
  @override
  int get hashCode => Object.hash(uuid, name, favorite);

  /// Returns a string representation of this radio station list item
  ///
  /// The string includes the [uuid], [name], and [favorite] values in a format
  /// suitable for debugging and logging purposes.
  @override
  String toString() =>
      'RadioStationListItem(uuid: $uuid, name: $name, favorite: $favorite)';
}
