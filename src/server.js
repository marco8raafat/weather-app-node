const app = require('./app');
const config = require('./config/env');
const logger = require('./utils/logger');

app.listen(config.port, () => {
  logger.info(`Weather app listening on port ${config.port}`);
});
