const config = require('../config/env');

const LEVELS = { debug: 10, info: 20, warn: 30, error: 40 };

function log(level, ...args) {
  const threshold = LEVELS[config.logLevel] ?? LEVELS.info;
  if (LEVELS[level] >= threshold) {
    // eslint-disable-next-line no-console
    console[level === 'debug' ? 'log' : level](`[${level}]`, ...args);
  }
}

module.exports = {
  debug: (...args) => log('debug', ...args),
  info: (...args) => log('info', ...args),
  warn: (...args) => log('warn', ...args),
  error: (...args) => log('error', ...args),
};
