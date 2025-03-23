/// Configuration for the radio browser API
class RadioBrowserConfig {
  /// Creates a new [RadioBrowserConfig]
  ///
  /// [baseUrl] is the base URL for the API
  /// [timeout] is the timeout for requests in seconds
  const RadioBrowserConfig({
    this.baseUrl = 'https://de1.api.radio-browser.info/json',
    this.secondaryBaseUrl = 'https://nl1.api.radio-browser.info/json',
    this.timeout = 30,
    this.maxPageSize = 10000,
    this.minPageSize = 1,
    this.targetPages = 10,
  });

  /// The base URL for the API
  final String baseUrl;

  /// The secondary base URL for the API
  final String secondaryBaseUrl;

  /// The timeout for requests in seconds
  final int timeout;

  /// The maximum number of items to fetch per page
  final int maxPageSize;

  /// The minimum number of items to fetch per page
  final int minPageSize;

  /// The target number of pages to split the data into
  final int targetPages;
}
