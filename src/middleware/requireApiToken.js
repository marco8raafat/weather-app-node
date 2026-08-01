const config = require('../config/env');

function requireApiToken(req, res, next) {
  const provided = req.header('x-api-token');
  if (!config.apiToken || provided !== config.apiToken) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
}

module.exports = requireApiToken;
