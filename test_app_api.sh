#!/bin/bash

# 🧪 Flask API Test Script for MLOps Assignment
# Group Members: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)
# Project: Heart Disease Prediction API

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Configuration
API_URL="http://localhost:5000"
FLASK_PID=""

# Function to print test results
print_test_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    elif [ "$status" = "INFO" ]; then
        echo -e "${CYAN}ℹ️  INFO${NC}: $test_name - $message"
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  WARN${NC}: $test_name - $message"
    fi
}

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to wait for service
wait_for_service() {
    local url="$1"
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            return 0
        fi
        echo "Waiting for service... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    return 1
}

# Function to start Flask app
start_flask_app() {
    print_section "🚀 Starting Flask Application"
    
    # Check if app.py exists
    if [ ! -f "app/app.py" ]; then
        print_test_result "Flask App Check" "FAIL" "app/app.py not found"
        return 1
    fi
    
    # Check if Python is available
    if ! command_exists python3 && ! command_exists python; then
        print_test_result "Python Check" "FAIL" "Python not found"
        return 1
    fi
    
    # Start Flask app in background
    if command_exists python3; then
        python3 app/app.py &
    else
        python app/app.py &
    fi
    
    FLASK_PID=$!
    print_test_result "Flask App Start" "INFO" "Started with PID: $FLASK_PID"
    
    # Wait for app to start
    if wait_for_service "$API_URL"; then
        print_test_result "Flask App Ready" "PASS" "Application is responding"
        return 0
    else
        print_test_result "Flask App Ready" "FAIL" "Application not responding"
        return 1
    fi
}

# Function to stop Flask app
stop_flask_app() {
    if [ ! -z "$FLASK_PID" ]; then
        print_test_result "Flask App Stop" "INFO" "Stopping application (PID: $FLASK_PID)"
        kill $FLASK_PID 2>/dev/null || true
        sleep 2
        print_test_result "Flask App Stop" "PASS" "Application stopped"
    fi
}

# Function to test health endpoint
test_health_endpoint() {
    print_section "🌐 Testing Health Endpoint"
    
    local response=$(curl -s "$API_URL/" 2>/dev/null)
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/" 2>/dev/null)
    
    if [ "$status_code" = "200" ]; then
        if echo "$response" | grep -q "Heart Disease Prediction API"; then
            print_test_result "Health Endpoint" "PASS" "Status: $status_code, Response: $response"
        else
            print_test_result "Health Endpoint" "FAIL" "Unexpected response: $response"
        fi
    else
        print_test_result "Health Endpoint" "FAIL" "Status code: $status_code"
    fi
}

# Function to test prediction endpoint with valid data
test_prediction_valid() {
    print_section "🔮 Testing Prediction Endpoint (Valid Data)"
    
    local test_data='{
        "age": 65,
        "sex": 1,
        "cp": 3,
        "trestbps": 145,
        "chol": 233,
        "fbs": 1,
        "restecg": 0,
        "thalach": 150,
        "exang": 0,
        "oldpeak": 2.3,
        "slope": 0
    }'
    
    local response=$(curl -s -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "$test_data" 2>/dev/null)
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "$test_data" 2>/dev/null)
    
    if [ "$status_code" = "200" ]; then
        if echo "$response" | grep -q "prediction" && echo "$response" | grep -q "probabilities"; then
            print_test_result "Prediction (Valid)" "PASS" "Response: $response"
        else
            print_test_result "Prediction (Valid)" "FAIL" "Missing required fields: $response"
        fi
    else
        print_test_result "Prediction (Valid)" "FAIL" "Status: $status_code, Response: $response"
    fi
}

# Function to test prediction endpoint with missing features
test_prediction_missing_features() {
    print_section "❌ Testing Prediction Endpoint (Missing Features)"
    
    local test_data='{
        "age": 65,
        "sex": 1
    }'
    
    local response=$(curl -s -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "$test_data" 2>/dev/null)
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "$test_data" 2>/dev/null)
    
    if [ "$status_code" = "400" ]; then
        if echo "$response" | grep -q "error"; then
            print_test_result "Prediction (Missing Features)" "PASS" "Error handling: $response"
        else
            print_test_result "Prediction (Missing Features)" "FAIL" "No error message: $response"
        fi
    else
        print_test_result "Prediction (Missing Features)" "FAIL" "Expected 400, got: $status_code"
    fi
}

# Function to test prediction endpoint with invalid JSON
test_prediction_invalid_json() {
    print_section "🔧 Testing Prediction Endpoint (Invalid JSON)"
    
    local response=$(curl -s -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "invalid json data" 2>/dev/null)
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d "invalid json data" 2>/dev/null)
    
    if [ "$status_code" = "400" ]; then
        print_test_result "Prediction (Invalid JSON)" "PASS" "Error handling: $response"
    else
        print_test_result "Prediction (Invalid JSON)" "FAIL" "Expected 400, got: $status_code"
    fi
}

# Function to test prediction endpoint with wrong method
test_prediction_wrong_method() {
    print_section "🚫 Testing Prediction Endpoint (Wrong Method)"
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/predict" 2>/dev/null)
    
    if [ "$status_code" = "405" ]; then
        print_test_result "Prediction (Wrong Method)" "PASS" "Method not allowed: $status_code"
    else
        print_test_result "Prediction (Wrong Method)" "FAIL" "Expected 405, got: $status_code"
    fi
}

# Function to test prediction endpoint with empty data
test_prediction_empty_data() {
    print_section "📭 Testing Prediction Endpoint (Empty Data)"
    
    local response=$(curl -s -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d '{}' 2>/dev/null)
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/predict" \
        -H "Content-Type: application/json" \
        -d '{}' 2>/dev/null)
    
    if [ "$status_code" = "400" ]; then
        if echo "$response" | grep -q "error"; then
            print_test_result "Prediction (Empty Data)" "PASS" "Error handling: $response"
        else
            print_test_result "Prediction (Empty Data)" "FAIL" "No error message: $response"
        fi
    else
        print_test_result "Prediction (Empty Data)" "FAIL" "Expected 400, got: $status_code"
    fi
}

# Function to test response time
test_response_time() {
    print_section "⏱️  Testing Response Time"
    
    local start_time=$(date +%s.%N)
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/" 2>/dev/null)
    local end_time=$(date +%s.%N)
    
    local response_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
    
    if [ "$status_code" = "200" ]; then
        if (( $(echo "$response_time < 2.0" | bc -l) )); then
            print_test_result "Response Time" "PASS" "Response time: ${response_time}s"
        else
            print_test_result "Response Time" "WARN" "Slow response: ${response_time}s"
        fi
    else
        print_test_result "Response Time" "FAIL" "Status: $status_code"
    fi
}

# Function to test model files
test_model_files() {
    print_section "🤖 Testing Model Files"
    
    if [ -f "model/model.pkl" ]; then
        print_test_result "Model File" "PASS" "model.pkl found"
    else
        print_test_result "Model File" "FAIL" "model.pkl not found"
    fi
    
    if [ -f "model/metadata.json" ]; then
        print_test_result "Metadata File" "PASS" "metadata.json found"
        
        # Check if metadata has required structure
        if python3 -c "import json; data=json.load(open('model/metadata.json')); print('OK' if 'feature_names' in data else 'ERROR')" 2>/dev/null | grep -q "OK"; then
            print_test_result "Metadata Structure" "PASS" "Valid metadata structure"
        else
            print_test_result "Metadata Structure" "FAIL" "Invalid metadata structure"
        fi
    else
        print_test_result "Metadata File" "FAIL" "metadata.json not found"
    fi
}

# Function to test app imports
test_app_imports() {
    print_section "📦 Testing App Imports"
    
    if python3 -c "import sys; sys.path.insert(0, 'app'); import app; print('OK')" 2>/dev/null | grep -q "OK"; then
        print_test_result "App Import" "PASS" "app.py imports successfully"
    else
        print_test_result "App Import" "FAIL" "Failed to import app.py"
    fi
}

# Function to run all tests
run_all_tests() {
    print_section "🧪 Flask API Comprehensive Testing"
    echo -e "${PURPLE}Group: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)${NC}"
    echo -e "${PURPLE}Project: Heart Disease Prediction API${NC}\n"
    
    # Test model files and imports first (don't require running server)
    test_model_files
    test_app_imports
    
    # Start Flask app
    if ! start_flask_app; then
        print_test_result "API Testing" "FAIL" "Cannot start Flask app, skipping API tests"
        return
    fi
    
    # Run API tests
    test_health_endpoint
    test_prediction_valid
    test_prediction_missing_features
    test_prediction_invalid_json
    test_prediction_wrong_method
    test_prediction_empty_data
    test_response_time
    
    # Stop Flask app
    stop_flask_app
}

# Function to print summary
print_summary() {
    print_section "📊 Test Results Summary"
    
    echo -e "${WHITE}Total Tests: $TOTAL_TESTS${NC}"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    
    if [ $TOTAL_TESTS -gt 0 ]; then
        local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        echo -e "${YELLOW}Success Rate: $success_rate%${NC}"
        
        if [ $success_rate -ge 90 ]; then
            echo -e "\n${GREEN}🎉 EXCELLENT! Your Flask API is working perfectly!${NC}"
            echo -e "${GREEN}✅ Ready for production deployment!${NC}"
        elif [ $success_rate -ge 80 ]; then
            echo -e "\n${YELLOW}⚠️  GOOD! Most API functions work, but some issues need attention.${NC}"
            echo -e "${YELLOW}🔧 Please review failed tests and fix issues.${NC}"
        else
            echo -e "\n${RED}❌ NEEDS WORK! Several API functions are not working properly.${NC}"
            echo -e "${RED}🔧 Please review failed tests and fix issues before deployment.${NC}"
        fi
    else
        echo -e "${RED}❌ No tests were executed!${NC}"
    fi
}

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}🧹 Cleaning up...${NC}"
    stop_flask_app
    exit $FAILED_TESTS
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Main execution
main() {
    # Check dependencies
    if ! command_exists curl; then
        echo -e "${RED}❌ Error: 'curl' not found. Please install it.${NC}"
        exit 1
    fi
    
    if ! command_exists python3 && ! command_exists python; then
        echo -e "${RED}❌ Error: Python not found. Please install Python 3.${NC}"
        exit 1
    fi
    
    # Run all tests
    run_all_tests
    print_summary
}

# Run main function
main "$@"
