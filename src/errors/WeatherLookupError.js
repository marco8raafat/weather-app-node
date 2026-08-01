class WeatherLookupError extends Error {
  constructor(message) {
    super(message);
    this.name = 'WeatherLookupError';
  }
}

module.exports = WeatherLookupError;
