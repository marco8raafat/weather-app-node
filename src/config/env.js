require('dotenv').config();

module.exports = {
  port: parseInt(process.env.PORT, 10) || 3000,
  logLevel: process.env.LOG_LEVEL || 'info',
  apiToken: process.env.API_TOKEN || '',
  nodeEnv: process.env.NODE_ENV || 'development',
};
