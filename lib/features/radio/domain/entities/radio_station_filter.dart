/// Filter parameters for radio station list items
class RadioStationFilter {
  /// Creates a new instance of [RadioStationFilter]
  const RadioStationFilter({required this.favorite, this.country});

  /// Whether to show only favorite stations
  final bool favorite;

  /// The country to filter by
  final String? country;

  /// Creates a copy of this filter with the given fields replaced with new values
  RadioStationFilter copyWith({bool? favorite, String? country}) {
    return RadioStationFilter(
      favorite: favorite ?? this.favorite,
      country: country ?? this.country,
    );
  }
}
