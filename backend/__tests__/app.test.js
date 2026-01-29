const request = require('supertest');
const app = require('../server');

describe('Simple CMS Backend API Tests', () => {
  let agent;
  let csrfToken;

  beforeAll(() => {
    // Create a session agent to maintain cookies
    agent = request.agent(app);
  });

  // Helper function to get CSRF token
  const getCsrfToken = async () => {
    const response = await agent.get('/api/csrf-token');
    return response.body.csrfToken;
  };

  describe('Health Endpoints', () => {
    test('GET /health should return 200', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('uptime');
    });

    test('GET /ready should return 200', async () => {
      const response = await request(app).get('/ready');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'ready');
      expect(response.body).toHaveProperty('database');
    });
  });

  describe('Metrics Endpoint', () => {
    test('GET /metrics should return prometheus metrics', async () => {
      const response = await request(app).get('/metrics');
      expect(response.status).toBe(200);
      expect(response.text).toContain('http_requests_total');
      expect(response.text).toContain('http_request_duration_seconds');
    });
  });

  describe('Posts API', () => {
    test('GET /api/posts should return array', async () => {
      const response = await request(app).get('/api/posts');
      expect(response.status).toBe(200);
      expect(Array.isArray(response.body)).toBe(true);
      expect(response.body.length).toBeGreaterThan(0);
    });

    test('POST /api/posts should create post', async () => {
      // Get CSRF token first
      csrfToken = await getCsrfToken();

      const newPost = {
        title: 'Test Post',
        content: 'This is a test post'
      };

      const response = await agent
        .post('/api/posts')
        .set('CSRF-Token', csrfToken)
        .send(newPost);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
      expect(response.body.title).toBe(newPost.title);
      expect(response.body.content).toBe(newPost.content);
      expect(response.body).toHaveProperty('created_at');
    });

    test('POST /api/posts without CSRF token should fail', async () => {
      const newPost = {
        title: 'Test Post',
        content: 'This is a test post'
      };

      const response = await request(app)
        .post('/api/posts')
        .send(newPost);

      expect(response.status).toBe(403);
      expect(response.body).toHaveProperty('error');
    });
  });

  describe('Error Handling', () => {
    test('GET /invalid-route should return 404', async () => {
      const response = await request(app).get('/invalid-route');
      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('error', 'Not Found');
    });
  });
});