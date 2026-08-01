const WeatherLookupError = require('../errors/WeatherLookupError');

const WTTR_URL = (city) => `https://wttr.in/${encodeURIComponent(city)}?format=j1`;

function firstValue(node, arrayField) {
  const arr = node?.[arrayField];
  return Array.isArray(arr) && arr.length > 0 ? arr[0]?.value ?? '' : '';
}

async function getWeather(city, { fetchImpl = fetch } = {}) {
  let response;
  try {
    response = await fetchImpl(WTTR_URL(city));
  } catch (err) {
    throw new WeatherLookupError('Could not reach the weather service. Try again later.');
  }

  if (!response.ok) {
    throw new WeatherLookupError(`City "${city}" was not found.`);
  }

  let body;
  try {
    body = await response.json();
  } catch (err) {
    throw new WeatherLookupError(`City "${city}" was not found.`);
  }

  const currentArr = body?.current_condition;
  const areaArr = body?.nearest_area;
  if (!Array.isArray(currentArr) || currentArr.length === 0 || !Array.isArray(areaArr) || areaArr.length === 0) {
    throw new WeatherLookupError(`City "${city}" was not found.`);
  }

  const current = currentArr[0];
  const area = areaArr[0];

  const cityName = firstValue(area, 'areaName');
  const country = firstValue(area, 'country');
  const description = firstValue(current, 'weatherDesc');
  const temp = current?.temp_C ?? '';
  const feelsLike = current?.FeelsLikeC ?? '';
  const humidity = current?.humidity ?? '';
  const windSpeed = current?.windspeedKmph ?? '';

  if (!cityName || !temp) {
    throw new WeatherLookupError(`City "${city}" was not found.`);
  }

  return {
    city: cityName,
    country,
    temp,
    feelsLike,
    description,
    humidity,
    windSpeed,
  };
}

module.exports = { getWeather };
