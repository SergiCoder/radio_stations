import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:radio_stations/features/radio/data/data.dart';

/// Remote data source for fetching radio stations
///
/// This class handles the communication with the radio-browser.info API
/// to fetch radio station data, handling pagination internally.
class RadioStationRemoteDataSource {
  /// Creates a new instance of [RadioStationRemoteDataSource]
  ///
  /// [client] is the HTTP client to use for making requests.
  /// [config] is the configuration for the API.
  RadioStationRemoteDataSource({
    http.Client? client,
    RadioBrowserConfig? config,
  }) : _client = client ?? http.Client(),
       _config = config ?? const RadioBrowserConfig();

  /// The HTTP client used for making requests
  final http.Client _client;

  /// The configuration for the API
  final RadioBrowserConfig _config;

  /// Calculates the optimal page size based on the total number of stations
  int _calculatePageSize(int totalStations) {
    if (totalStations <= 0) return _config.minPageSize;

    // Calculate the ideal page size based on target pages
    final idealPageSize = (totalStations / _config.targetPages).ceil();

    // Ensure the page size is within bounds
    return idealPageSize.clamp(_config.minPageSize, _config.maxPageSize);
  }

  /// Makes a request to the API with the specified base URL
  ///
  /// [baseUrl] is the base URL to use for the request
  /// [path] is the path to append to the base URL
  /// [queryParams] are the query parameters to include in the request
  ///
  /// Returns the response body as a string
  Future<String> _makeRequest(
    String baseUrl,
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: queryParams);

    final response = await _client
        .get(uri)
        .timeout(Duration(seconds: _config.timeout));

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  /// Gets the total number of stations from the API
  Future<int> _getTotalStationCount() async {
    for (final baseUrl in _config.baseUrls) {
      try {
        final body = await _makeRequest(baseUrl, '/stats');
        final stats = json.decode(body) as Map<String, dynamic>;
        return stats['stations'] as int;
      } catch (e) {
        log('Failed to get station count from $baseUrl: $e, trying next...');
      }
    }
    throw Exception('Failed to get station count');
  }

  /// Fetches all radio stations from the remote source
  ///
  /// Returns a list of [RadioStationRemoteDto] objects
  /// [onProgress] is an optional callback that will be called with the total
  /// number of stations and the number of stations downloaded so far.
  Future<List<RadioStationRemoteDto>> getStations({
    required void Function(int total, int downloaded) onProgress,
  }) async {
    final stations = <RadioStationRemoteDto>[];
    var currentPage = 1;
    var hasMore = true;

    // Get total station count first
    final totalStations = await _getTotalStationCount();
    onProgress.call(totalStations, 0);

    // Calculate the optimal page size
    final pageSize = _calculatePageSize(totalStations);

    while (hasMore) {
      final pageStations = await _fetchPage(currentPage, pageSize);
      stations.addAll(pageStations);

      // Notify progress
      onProgress.call(totalStations, stations.length);

      // If we got fewer stations than the page size, we've reached the end
      hasMore = pageStations.length == pageSize;
      currentPage++;
    }

    return stations;
  }

  /// Fetches a single page of radio stations
  ///
  /// [page] is the page number (1-based)
  /// [pageSize] is the number of items to fetch per page
  ///
  /// Returns a list of [RadioStationRemoteDto] objects for the current page
  Future<List<RadioStationRemoteDto>> _fetchPage(int page, int pageSize) async {
    final offset = (page - 1) * pageSize;

    // Build query parameters to filter out video content
    final queryParams = {
      'limit': pageSize.toString(),
      'offset': offset.toString(),
      'hidebroken': 'true',
      // Order by reliability
      'order': 'name',
      // Only get working stations
      'lastcheckok': 'true',
    };
    for (final baseUrl in _config.baseUrls) {
      try {
        final body = await _makeRequest(
          baseUrl,
          '/stations',
          queryParams: queryParams,
        );
        return _parseResponse(body);
      } catch (e) {
        log('Failed to fetch page from $baseUrl: $e, trying next...');
      }
    }
    throw Exception('Failed to fetch radio stations');
  }

  /// Parses the response body into a list of [RadioStationRemoteDto]
  ///
  /// [body] is the response body to parse
  ///
  /// Returns a list of [RadioStationRemoteDto] objects
  List<RadioStationRemoteDto> _parseResponse(String body) {
    try {
      final jsonList = json.decode(body) as List<dynamic>;
      return jsonList
          .map(
            (json) =>
                RadioStationRemoteDto.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  /// Closes the HTTP client
  void dispose() {
    _client.close();
  }
}
