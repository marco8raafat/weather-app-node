const { getWeather } = require('../src/services/weatherService');
const WeatherLookupError = require('../src/errors/WeatherLookupError');

function jsonResponse(body, ok = true) {
  return { ok, json: async () => body };
}

describe('getWeather', () => {
  test('returns parsed weather for a valid city', async () => {
    const fetchImpl = jest.fn().mockResolvedValue(
      jsonResponse({
        current_condition: [
          {
            temp_C: '21',
            FeelsLikeC: '20',
            humidity: '50',
            windspeedKmph: '10',
            weatherDesc: [{ value: 'Sunny' }],
          },
        ],
        nearest_area: [
          {
            areaName: [{ value: 'London' }],
            country: [{ value: 'UK' }],
          },
        ],
      })
    );

    const result = await getWeather('London', { fetchImpl });

    expect(result).toEqual({
      city: 'London',
      country: 'UK',
      temp: '21',
      feelsLike: '20',
      description: 'Sunny',
      humidity: '50',
      windSpeed: '10',
    });
  });

  test('requests the correct wttr.in URL with the city encoded', async () => {
    const fetchImpl = jest.fn().mockResolvedValue(
      jsonResponse({
        current_condition: [{ temp_C: '10', weatherDesc: [{ value: 'Cloudy' }] }],
        nearest_area: [{ areaName: [{ value: 'New York' }], country: [{ value: 'US' }] }],
      })
    );

    await getWeather('New York', { fetchImpl });

    expect(fetchImpl).toHaveBeenCalledWith(expect.stringContaining('New%20York'));
    expect(fetchImpl).toHaveBeenCalledWith(expect.stringContaining('format=j1'));
  });

  test('throws WeatherLookupError when the response has empty condition/area arrays', async () => {
    const fetchImpl = jest.fn().mockResolvedValue(jsonResponse({ current_condition: [], nearest_area: [] }));

    await expect(getWeather('Nowhereville', { fetchImpl })).rejects.toThrow(WeatherLookupError);
    await expect(getWeather('Nowhereville', { fetchImpl })).rejects.toThrow(/not found/);
  });

  test('throws WeatherLookupError when wttr.in responds not-ok', async () => {
    const fetchImpl = jest.fn().mockResolvedValue(jsonResponse({}, false));

    await expect(getWeather('Nowhereville', { fetchImpl })).rejects.toThrow(/not found/);
  });

  test('throws WeatherLookupError when fetch rejects (network failure)', async () => {
    const fetchImpl = jest.fn().mockRejectedValue(new Error('ECONNREFUSED'));

    await expect(getWeather('London', { fetchImpl })).rejects.toThrow(/reach the weather service/);
  });
});
