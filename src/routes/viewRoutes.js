const express = require('express');
const { getWeather } = require('../services/weatherService');
const { renderIndexPage } = require('../views/indexView');
const WeatherLookupError = require('../errors/WeatherLookupError');

const router = express.Router();

router.get('/', (req, res) => {
  res.type('html').send(renderIndexPage({}));
});

router.get('/weather', async (req, res) => {
  const city = (req.query.city || '').trim();

  if (!city) {
    res.type('html').send(renderIndexPage({ error: 'Please enter a city name.' }));
    return;
  }

  try {
    const weather = await getWeather(city);
    res.type('html').send(renderIndexPage({ city, weather }));
  } catch (err) {
    if (err instanceof WeatherLookupError) {
      res.type('html').send(renderIndexPage({ city, error: err.message }));
      return;
    }
    res.status(500).type('html').send(renderIndexPage({ city, error: 'Something went wrong. Try again later.' }));
  }
});

module.exports = router;
