# Deployment Guide

This document provides instructions for deploying the Multi-Tenant SaaS Platform to production environments.

## Option 1: Railway.app (Recommended)

Railway.app is the easiest way to deploy this application.

### Steps:

1. **Push code to GitHub** (already done)
2. **Visit [Railway.app](https://railway.app)**
3. **Click "New Project" → "Deploy from GitHub"**
4. **Select this repository**
5. **Add PostgreSQL plugin** (Railway will auto-detect and set up database)
6. **Set environment variables:**
   - `NODE_ENV=production`
   - `JWT_SECRET=your-secure-random-key-here-min-32-chars`
   - `JWT_EXPIRES_IN=24h`
   - Database variables are auto-set by Railway PostgreSQL plugin
7. **Deploy!** (typically 2-3 minutes)
Backend URL will be provided by Railway (e.g., `https://your-project-api.railway.app`)

---

## Option 2: Heroku

### Prerequisites:
- Heroku CLI installed
- PostgreSQL add-on

### Steps:

```bash
# Login to Heroku
heroku login

# Create app
heroku create your-app-name

# Add PostgreSQL database
heroku addons:create heroku-postgresql:hobby-dev

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your-secure-random-key-here

# Deploy
git push heroku main

# Run migrations
heroku run 'cd backend && npm run migrate'
```

Backend URL: `https://your-app-name.herokuapp.com`

---

## Option 3: Docker (Local or Cloud)

### Requirements:
- Docker Engine running
- PostgreSQL database available

### Steps:

```bash
# Build and start with Docker Compose
docker-compose up -d

# Run migrations
docker-compose exec backend npm run migrate

# Check logs
docker-compose logs -f backend
```

Access at: `http://localhost:5000`

---

## Environment Variables Required

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=saas_db
DB_USER=postgres
DB_PASSWORD=postgres

# JWT Security
JWT_SECRET=your-secure-random-key-here-minimum-32-characters-required
JWT_EXPIRES_IN=24h

# Framework
PORT=5000
NODE_ENV=production
FRONTEND_URL=https://your-frontend-domain.com

# Logging
LOG_LEVEL=info
```

---

## Post-Deployment

1. **Test health endpoint:** `GET /api/health`
2. **Create test tenant:** `POST /api/auth/register`
3. **Login:** `POST /api/auth/login`
4. **Verify API:** Test endpoints from `/docs/API.md`

---

## Troubleshooting

### "Database connection failed"
- Ensure PostgreSQL is running and accessible
- Verify database credentials in environment variables
- Check DB_HOST is correct (localhost for local, service name for Docker, managed DB for cloud)

### "Cannot find module"
- Run `npm install` in backend directory
- Ensure Node.js v18+ is installed

### Migrations won't run
- Ensure migrations folder has SQL files with proper names
- Check migration script has correct path
- Verify database user has DDL permissions

---

## Monitoring

After deployment, monitor:
- Health endpoint: `GET /api/health`
- Error logs via cloud provider's logging
- Database connections and query performance
- User authentication and authorization

---

## Security Notes

⚠️ **DO NOT commit `.env` files to git**
- Use `.env.example` for reference
- Set production secrets via cloud provider's configuration
- Rotate `JWT_SECRET` periodically
- Use strong database passwords
