/// Filter parameters for radio station list items
class RadioStationFilter {
  /// Creates a new instance of [RadioStationFilter]
  const RadioStationFilter({required this.favorite, this.country});

  /// Whether to show only favorite stations
  final bool favorite;

  /// The country to filter by
  final String? country;

  /// Toggles the favorite filter
  RadioStationFilter toggleFavorite() {
    return RadioStationFilter(favorite: !favorite, country: country);
  }

  /// Creates a new filter with no country selected
  RadioStationFilter withoutCountry() {
    return RadioStationFilter(favorite: favorite);
  }

  /// Creates a new filter with the country set to the given value
  RadioStationFilter withCountry(String country) {
    return RadioStationFilter(favorite: favorite, country: country);
  }
}
