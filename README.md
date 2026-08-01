# Weather App (Node.js/Express)

A small Express web app that shows current weather for any city, using the
free [wttr.in](https://wttr.in) service — no API key required.

## Prerequisites

- Node.js 18 or newer
- npm

## Install

```bash
npm install
```

## Configuration

Copy the example env file and adjust as needed:

```bash
cp .env.example .env
```

| Variable    | Default   | Purpose                                                                 |
| ----------- | --------- | ------------------------------------------------------------------------ |
| `PORT`      | `3000`    | Port the server listens on.                                              |
| `LOG_LEVEL` | `info`    | Log verbosity: `debug`, `info`, `warn`, or `error`.                      |
| `API_TOKEN` | `changeme`| Token clients must send as the `x-api-token` header to call `GET /status`. |

## Running

```bash
npm start       # run once
npm run dev      # auto-restart on file changes (nodemon)
```

Open http://localhost:3000, type a city name, and search.

## Endpoints

| Method & Path         | Description                                              |
| ---------------------- | ---------------------------------------------------------- |
| `GET /`                 | Search form.                                              |
| `GET /weather?city=NAME`| Renders the weather result (or an error) for `NAME`.     |
| `GET /health`            | Returns `{ "status": "ok" }`.                             |
| `GET /status`            | Returns app info (uptime, Node version, environment). Requires header `x-api-token: <API_TOKEN>`, otherwise responds `401`. |

## Testing

```bash
npm test
```

Runs the Jest test suite (`tests/`), covering the weather lookup logic, the
health endpoint, and the token-gated status endpoint.

## Building & Packaging

This is plain JavaScript, so there's no compile/transpile step — `npm install`
followed by `npm start` is all that's needed to run it.

To produce a distributable package (e.g. for deploying without `git clone`):

```bash
npm pack
```

This creates `weather-app-node-<version>.tgz`, a tarball of the app's files
(respecting `.gitignore`/`.npmignore`, so `node_modules` and `.env` are
excluded). Installing it elsewhere with `npm install weather-app-node-<version>.tgz`
followed by `npm install` (to pull in `dependencies`) reproduces a runnable copy.

## Project structure

```
weather-app-node/
├── package.json
├── public/
│   └── style.css
├── src/
│   ├── app.js
│   ├── server.js
│   ├── config/env.js
│   ├── errors/WeatherLookupError.js
│   ├── middleware/requireApiToken.js
│   ├── middleware/requestLogger.js
│   ├── routes/viewRoutes.js
│   ├── routes/statusRoutes.js
│   ├── services/weatherService.js
│   ├── utils/escapeHtml.js
│   ├── utils/logger.js
│   └── views/indexView.js
└── tests/
    ├── weatherService.test.js
    ├── health.test.js
    └── status.test.js
```
