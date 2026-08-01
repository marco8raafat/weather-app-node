process.env.API_TOKEN = 'test-token';

const request = require('supertest');
const app = require('../src/app');

describe('GET /status', () => {
  test('rejects with 401 when no token header is sent', async () => {
    const res = await request(app).get('/status');

    expect(res.status).toBe(401);
  });

  test('rejects with 401 when the wrong token is sent', async () => {
    const res = await request(app).get('/status').set('x-api-token', 'wrong');

    expect(res.status).toBe(401);
  });

  test('returns app status when the correct token is sent', async () => {
    const res = await request(app).get('/status').set('x-api-token', 'test-token');

    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body.nodeVersion).toBe(process.version);
    expect(typeof res.body.uptimeSeconds).toBe('number');
    expect(typeof res.body.environment).toBe('string');
  });
});
