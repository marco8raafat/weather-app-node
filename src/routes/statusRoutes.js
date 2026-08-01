const express = require('express');
const config = require('../config/env');
const requireApiToken = require('../middleware/requireApiToken');

const router = express.Router();

router.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

router.get('/status', requireApiToken, (req, res) => {
  res.json({
    status: 'ok',
    uptimeSeconds: Math.floor(process.uptime()),
    nodeVersion: process.version,
    environment: config.nodeEnv,
  });
});

module.exports = router;
