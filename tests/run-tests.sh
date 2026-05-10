
#!/bin/bash
# tests/run-tests.sh
# Simple test script to validate application

echo "========================================="
echo "🧪 Running Application Tests"
echo "========================================="

# Counter for passed and failed tests
PASSED=0
FAILED=0

# Test 1: Check if index.html exists
echo ""
echo "Test 1: Checking if index.html exists..."
if [ -f "/var/www/html/index.html" ]; then
    echo "✅ PASS: index.html found"
    PASSED=$((PASSED + 1))
else
    echo "❌ FAIL: index.html not found"
    FAILED=$((FAILED + 1))
fi

# Test 2: Check if HTML file is not empty
echo ""
echo "Test 2: Checking if HTML content exists..."
if [ -s "/var/www/html/index.html" ]; then
    echo "✅ PASS: HTML file has content"
    PASSED=$((PASSED + 1))
else
    echo "❌ FAIL: HTML file is empty"
    FAILED=$((FAILED + 1))
fi

# Test 3: Check for required HTML tags
echo ""
echo "Test 3: Checking for required HTML structure..."
if grep -q "<html" /var/www/html/index.html; then
    echo "✅ PASS: HTML structure found"
    PASSED=$((PASSED + 1))
else
    echo "❌ FAIL: Missing HTML structure"
    FAILED=$((FAILED + 1))
fi

# Test 4: Check file permissions
echo ""
echo "Test 4: Checking file permissions..."
if [ -r "/var/www/html/index.html" ]; then
    echo "✅ PASS: File is readable"
    PASSED=$((PASSED + 1))
else
    echo "❌ FAIL: File is not readable"
    FAILED=$((FAILED + 1))
fi

# Test 5: Check directory structure
echo ""
echo "Test 5: Checking /var/www/html directory..."
if [ -d "/var/www/html" ]; then
    echo "✅ PASS: Application directory exists"
    PASSED=$((PASSED + 1))
else
    echo "❌ FAIL: Application directory missing"
    FAILED=$((FAILED + 1))
fi

# Print test summary
echo ""
echo "========================================="
echo "📊 Test Summary"
echo "========================================="
echo "Total Tests: $((PASSED + FAILED))"
echo "✅ Passed: $PASSED"
echo "❌ Failed: $FAILED"
echo "========================================="

# Exit with error if any test failed
if [ $FAILED -gt 0 ]; then
    echo ""
    echo "❌ TESTS FAILED - Pipeline will be blocked"
    exit 1
else
    echo ""
    echo "✅ ALL TESTS PASSED - Ready for deployment"
    exit 0
fi

# ============================================
# TEST SCRIPT EXPLANATION:
# ============================================
# 
# This script runs basic tests to validate:
# 
# 1. Files exist in correct location
# 2. HTML content is present
# 3. File structure is correct
# 4. Permissions are set properly
# 
# If ANY test fails:
# - Script exits with code 1
# - Jenkins pipeline STOPS
# - Deployment is BLOCKED
# 
# If ALL tests pass:
# - Script exits with code 0
# - Jenkins pipeline CONTINUES
# - Deployment proceeds (if master branch)
# 
# ============================================
# HOW TO RUN MANUALLY:
# ============================================
# 
# Make executable:
#   chmod +x tests/run-tests.sh
# 
# Run tests:
#   ./tests/run-tests.sh
# 
# ============================================
