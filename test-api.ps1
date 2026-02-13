# API Testing Script for PowerShell
# Test the multi-tenant SaaS platform API after deployment

param(
    [string]$ApiBaseUrl = "http://localhost:5000/api"
)

Write-Host "Testing API at: $ApiBaseUrl" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Health Check
Write-Host "1. Testing health endpoint..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "$ApiBaseUrl/health" -Method Get -UseBasicParsing | ConvertTo-Json
} catch {
    Write-Host "Health check failed: $_" -ForegroundColor Red
}
Write-Host ""

# 2. Test Auth Endpoints
Write-Host "2. Testing login endpoint..." -ForegroundColor Yellow
$loginBody = @{
    email = "admin@demo.com"
    password = "Demo@123"
    subdomain = "demo"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "$ApiBaseUrl/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody `
        -UseBasicParsing
    $loginData = $loginResponse.Content | ConvertFrom-Json
    Write-Host $loginResponse.Content -ForegroundColor Green
    
    if ($loginData.data.token) {
        Write-Host "✓ Authentication successful" -ForegroundColor Green
        $token = $loginData.data.token
        
        # 3. Get Profile
        Write-Host "3. Getting user profile..." -ForegroundColor Yellow
        $profileResponse = Invoke-WebRequest -Uri "$ApiBaseUrl/auth/me" `
            -Method Get `
            -Headers @{ "Authorization" = "Bearer $token" } `
            -UseBasicParsing
        Write-Host $profileResponse.Content -ForegroundColor Green
        
        # 4. List Projects
        Write-Host "4. Listing projects..." -ForegroundColor Yellow
        $projectsResponse = Invoke-WebRequest -Uri "$ApiBaseUrl/projects" `
            -Method Get `
            -Headers @{ "Authorization" = "Bearer $token" } `
            -UseBasicParsing
        Write-Host $projectsResponse.Content -ForegroundColor Green
    }
} catch {
    Write-Host "API test failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "API Testing Complete!" -ForegroundColor Green
