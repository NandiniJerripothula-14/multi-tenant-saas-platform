const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./authRoutes');
const tenantRoutes = require('./tenantRoutes');
const userRoutes = require('./userRoutes');
const projectRoutes = require('./projectRoutes');
const taskRoutes = require('./taskRoutes');

// API root endpoint - List available routes
router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Multi-Tenant SaaS Platform API',
    version: '1.0.0',
    endpoints: {
      health: 'GET /api/health - Check API and database status',
      auth: {
        login: 'POST /api/auth/login - User login',
        register: 'POST /api/auth/register - User registration',
        logout: 'POST /api/auth/logout - User logout',
        me: 'GET /api/auth/me - Get current user'
      },
      tenants: {
        list: 'GET /api/tenants - List all tenants',
        create: 'POST /api/tenants - Create new tenant',
        get: 'GET /api/tenants/:id - Get tenant by ID',
        update: 'PUT /api/tenants/:id - Update tenant',
        delete: 'DELETE /api/tenants/:id - Delete tenant'
      },
      users: {
        list: 'GET /api/users - List all users',
        create: 'POST /api/users - Create new user',
        get: 'GET /api/users/:id - Get user by ID',
        update: 'PUT /api/users/:id - Update user',
        delete: 'DELETE /api/users/:id - Delete user'
      },
      projects: {
        list: 'GET /api/projects - List all projects',
        create: 'POST /api/projects - Create new project',
        get: 'GET /api/projects/:id - Get project by ID',
        update: 'PUT /api/projects/:id - Update project',
        delete: 'DELETE /api/projects/:id - Delete project'
      },
      tasks: {
        list: 'GET /api/tasks - List all tasks',
        create: 'POST /api/tasks - Create new task',
        get: 'GET /api/tasks/:id - Get task by ID',
        update: 'PUT /api/tasks/:id - Update task',
        delete: 'DELETE /api/tasks/:id - Delete task'
      }
    },
    documentation: 'See /docs/API.md for detailed documentation'
  });
});

// API health endpoint (inside router)
const { pool } = require('../config/database')
router.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1')
    res.json({ success: true, message: 'OK', database: 'connected', timestamp: new Date().toISOString() })
  } catch (err) {
    res.status(500).json({ success: false, message: 'Database connection failed', error: err.message })
  }
})
// Mount routes
router.use('/auth', authRoutes);
router.use('/tenants', tenantRoutes);
router.use('/users', userRoutes);
router.use('/projects', projectRoutes);
router.use('/tasks', taskRoutes);

module.exports = router;
