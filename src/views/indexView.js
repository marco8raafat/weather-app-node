const escapeHtml = require('../utils/escapeHtml');

function renderIndexPage({ city = '', weather = null, error = null } = {}) {
  const errorHtml = error ? `<p class="error">${escapeHtml(error)}</p>` : '';

  const resultHtml = weather
    ? `
    <section class="result">
      <h2>${escapeHtml(weather.city)}, ${escapeHtml(weather.country)}</h2>
      <p class="temp">${escapeHtml(weather.temp)}&deg;C</p>
      <p class="desc">${escapeHtml(weather.description)}</p>
      <p class="feels-like">Feels like ${escapeHtml(weather.feelsLike)}&deg;C</p>
      <div class="details">
        <span>Humidity: ${escapeHtml(weather.humidity)}%</span>
        <span>Wind: ${escapeHtml(weather.windSpeed)} km/h</span>
      </div>
    </section>`
    : '';

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Weather App</title>
  <link rel="stylesheet" href="/style.css">
</head>
<body>
  <main class="card">
    <h1>Weather</h1>
    <form method="get" action="/weather" class="search-form">
      <input type="text" name="city" placeholder="Enter a city, e.g. London" value="${escapeHtml(city)}" autofocus required>
      <button type="submit">Search</button>
    </form>
    ${errorHtml}
    ${resultHtml}
  </main>
</body>
</html>
`;
}

module.exports = { renderIndexPage };
