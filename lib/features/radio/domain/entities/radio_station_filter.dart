/// Filter parameters for radio station list items
class RadioStationFilter {
  /// Creates a new instance of [RadioStationFilter]
  const RadioStationFilter({
    required this.favorite,
    this.country,
    this.searchTerm = '',
  });

  /// Whether to show only favorite stations
  final bool favorite;

  /// The country to filter by
  final String? country;

  /// The search term to filter station names by
  final String searchTerm;

  /// Toggles the favorite filter
  RadioStationFilter toggleFavorite() {
    return RadioStationFilter(
      favorite: !favorite,
      country: country,
      searchTerm: searchTerm,
    );
  }

  /// Creates a new filter with no country selected
  RadioStationFilter withoutCountry() {
    return RadioStationFilter(favorite: favorite, searchTerm: searchTerm);
  }

  /// Creates a new filter with the country set to the given value
  RadioStationFilter withCountry(String country) {
    return RadioStationFilter(
      favorite: favorite,
      country: country,
      searchTerm: searchTerm,
    );
  }

  /// Creates a new filter with the search term set to the given value
  RadioStationFilter withSearchTerm(String term) {
    return RadioStationFilter(
      favorite: favorite,
      country: country,
      searchTerm: term,
    );
  }
}
