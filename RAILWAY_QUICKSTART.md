# Quick Deployment to Railway.app (5 minutes)

Your repository is already on GitHub, so deployment is just a few clicks away.

## Step 1: Create Railway Account & Deploy

1. Go to https://railway.app
2. Click **"Start New Project"** (top right)
3. Click **"Deploy from GitHub repo"**
4. Authorize Railway to access GitHub
5. Select: `NandiniJerripothula-14/multi-tenant-saas-platform`
6. Click **"Deploy Now"**

Railway will automatically detect:
- Node.js backend in `/backend`
- React frontend in `/frontend`

## Step 2: Add PostgreSQL Database

1. In your Railway project, click **"+ New"** (top right)
2. Select **"Database"** → **"PostgreSQL"**
3. Railway auto-creates: `postgres` user, random password, database `railway`
4. **Copy the DATABASE_URL** (you'll see it in the PostgreSQL service)

## Step 3: Configure Backend Environment Variables

In Railway dashboard:

1. Click the **`backend`** service
2. Go to **"Variables"** tab
3. Set these variables:
   ```
   NODE_ENV=production
   JWT_SECRET=your-super-secure-random-32-character-key-here-example-abc123def456
   JWT_EXPIRES_IN=24h
   PORT=5000
   ```
4. Railway auto-sets database variables from PostgreSQL plugin

4. Click **"Deploy"** button

## Step 4: Configure Frontend Environment Variables

1. Click the **`frontend`** service
2. Go to **"Variables"** tab
3. Set:
   ```
   REACT_APP_API_URL=https://[backend-service-url]/api
   ```
   *(Use the backend URL you'll get in Step 5)*

## Step 5: Get Your Live URLs

Once deployed (should take 2-3 minutes):

1. Click **`backend`** service → **"Deployments"** tab
2. Look for **"Service Domain"** (e.g., `https://multi-tenant-saas-backend-production.railway.app`)
   - Copy this - this is your **BACKEND_URL**

3. Click **`frontend`** service → **"Deployments"** tab
4. Find **"Service Domain"** (e.g., `https://multi-tenant-saas-frontend-production.railway.app`)
   - Copy this - this is your **FRONTEND_URL**

## Step 6: Test Your API

Test the backend is working:
```powershell
$backendUrl = "https://your-backend-url-from-step-5/api"
Invoke-WebRequest -Uri "$backendUrl/health" -UseBasicParsing
```

Expected response:
```json
{"success":true,"message":"OK","database":"connected"}
```

## Step 7: Test Login

```powershell
$response = Invoke-WebRequest -Uri "$backendUrl/auth/login" `
  -Method Post `
  -ContentType "application/json" `
  -Body @{
    email = "admin@demo.com"
    password = "Demo@123"
    subdomain = "demo"
  } | ConvertFrom-Json -AsHashtable

# If successful, you'll get a token
$response.data.token
```

## Step 8: Update submission.json

Once you have the URLs, replace in `submission.json`:

```json
{
  "deploymentInfo": {
    "backendUrl": "https://your-actual-backend-url-from-railway.app/api",
    "frontendUrl": "https://your-actual-frontend-url-from-railway.app",
    "deploymentPlatform": "Railway.app",
    ...
  }
}
```

## Troubleshooting

**"Service crashed" / "No logs"**
- Check Railway logs tab for errors
- Ensure DATABASE_URL and JWT_SECRET are set
- Make sure migrations ran: `npm run migrate`

**"Port already in use"**
- Railway manages ports automatically, no action needed

**"Cannot connect to database"**
- Verify PostgreSQL service is deployed
- Check DATABASE_URL variable is set
- Migrations run automatically on deployment

**"Frontend can't call backend API"**
- Verify `REACT_APP_API_URL` is set in frontend service
- Should point to backend service domain
- Restart frontend deployment after setting

## Success Checklist

- [ ] Code pushed to GitHub
- [ ] Railway.app project created
- [ ] PostgreSQL database deployed
- [ ] Backend service deployed (green checkmark)
- [ ] Frontend service deployed (green checkmark)
- [ ] Backend URL tested at `/api/health`
- [ ] Login test successful (got token)
- [ ] submission.json updated with URLs
- [ ] All 19 API endpoints documented in submission

**Next:** Once you have URLs, run `test-api.ps1` with your backend URL to verify all endpoints.
