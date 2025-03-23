/// Configuration for the radio browser API
class RadioBrowserConfig {
  /// Creates a new [RadioBrowserConfig]
  ///
  /// [baseUrls] is the list of base URLs for the API
  /// [timeout] is the timeout for requests in seconds
  /// [maxPageSize] is the maximum number of items to fetch per page
  /// [minPageSize] is the minimum number of items to fetch per page
  /// [targetPages] is the target number of pages to split the data into
  const RadioBrowserConfig({
    this.baseUrls = const [
      'https://de1.api.radio-browser.info/json',
      'https://nl1.api.radio-browser.info/json',
      'https://de2.api.radio-browser.info/json',
    ],
    this.timeout = 30,
    this.maxPageSize = 10000,
    this.minPageSize = 1,
    this.targetPages = 10,
  });

  /// The base URL for the API
  final List<String> baseUrls;

  /// The timeout for requests in seconds
  final int timeout;

  /// The maximum number of items to fetch per page
  final int maxPageSize;

  /// The minimum number of items to fetch per page
  final int minPageSize;

  /// The target number of pages to split the data into
  final int targetPages;
}
