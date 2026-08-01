const express = require('express');
const path = require('path');
const requestLogger = require('./middleware/requestLogger');
const viewRoutes = require('./routes/viewRoutes');
const statusRoutes = require('./routes/statusRoutes');

const app = express();

app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(requestLogger);
app.use('/', viewRoutes);
app.use('/', statusRoutes);

module.exports = app;
