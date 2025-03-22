/// Filter parameters for radio station list items
class RadioStationListItemsFilter {
  /// Creates a new instance of [RadioStationListItemsFilter]
  const RadioStationListItemsFilter({
    required this.favorite,
    this.country,
  });

  /// Whether to show only favorite stations
  final bool favorite;

  /// The country to filter by
  final String? country;

  /// Creates a copy of this filter with the given fields replaced with new values
  RadioStationListItemsFilter copyWith({
    bool? favorite,
    String? country,
  }) {
    return RadioStationListItemsFilter(
      favorite: favorite ?? this.favorite,
      country: country ?? this.country,
    );
  }
}
