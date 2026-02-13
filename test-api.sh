#!/bin/bash
# API Testing Script
# Test the multi-tenant SaaS platform API after deployment

API_BASE_URL="${1:-http://localhost:5000/api}"
echo "Testing API at: $API_BASE_URL"
echo "=========================================="

# 1. Health Check
echo "1. Testing health endpoint..."
curl -X GET "$API_BASE_URL/health" -H "Content-Type: application/json"
echo -e "\n"

# 2. Register Tenant
echo "2. Registering a test tenant..."
TENANT_RESPONSE=$(curl -s -X POST "$API_BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "tenantName": "Test Company",
    "subdomain": "test-'$(date +%s)'",
    "adminEmail": "admin@test-'$(date +%s)'.com",
    "adminPassword": "TestPass@123",
    "adminFullName": "Test Admin"
  }')
echo "$TENANT_RESPONSE"
TENANT_ID=$(echo "$TENANT_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo -e "\n"

# 3. Login
echo "3. Testing login..."
if [ -z "$TENANT_ID" ]; then
  echo "Tenant registration failed. Using demo credentials..."
  LOGIN_RESPONSE=$(curl -s -X POST "$API_BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
      "email": "admin@demo.com",
      "password": "Demo@123",
      "subdomain": "demo"
    }')
else
  LOGIN_RESPONSE=$(curl -s -X POST "$API_BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
      "email": "admin@test-'$(date +%s)'.com",
      "password": "TestPass@123",
      "subdomain": "test-'$(date +%s)'"
    }')
fi
echo "$LOGIN_RESPONSE"
TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | head -1 | cut -d'"' -f4)
echo -e "\n"

# 4. Get Profile
if [ -n "$TOKEN" ]; then
  echo "4. Get authenticated user profile..."
  curl -s -X GET "$API_BASE_URL/auth/me" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json"
  echo -e "\n"
  
  # 5. List Tenants
  echo "5. List all projects..."
  curl -s -X GET "$API_BASE_URL/projects" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json"
  echo -e "\n"
fi

echo "=========================================="
echo "API Testing Complete!"
