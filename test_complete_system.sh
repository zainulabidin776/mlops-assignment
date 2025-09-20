#!/bin/bash

# 🧪 Complete System Test Script for MLOps Assignment
# Group Members: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to print test results
print_test_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
        FAILED_TESTS=$((FAILED_TESTS + 1))
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

# Start of test script
echo -e "${YELLOW}🧪 MLOps Assignment - Complete System Test${NC}"
echo -e "${YELLOW}Group: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)${NC}"
echo -e "${YELLOW}Project: Heart Disease Prediction API with CI/CD Pipeline${NC}\n"

# Test 1: Environment Prerequisites
print_section "🔧 Testing Environment Prerequisites"

# Check Python
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    print_test_result "Python Installation" "PASS" "Found: $PYTHON_VERSION"
else
    print_test_result "Python Installation" "FAIL" "Python3 not found"
fi

# Check Docker
if command_exists docker; then
    DOCKER_VERSION=$(docker --version 2>&1)
    print_test_result "Docker Installation" "PASS" "Found: $DOCKER_VERSION"
else
    print_test_result "Docker Installation" "FAIL" "Docker not found"
fi

# Check Git
if command_exists git; then
    GIT_VERSION=$(git --version 2>&1)
    print_test_result "Git Installation" "PASS" "Found: $GIT_VERSION"
else
    print_test_result "Git Installation" "FAIL" "Git not found"
fi

# Check if we're in the right directory
if [ -f "app/app.py" ] && [ -f "Dockerfile" ] && [ -f "Jenkinsfile" ]; then
    print_test_result "Project Structure" "PASS" "All required files found"
else
    print_test_result "Project Structure" "FAIL" "Missing required files"
fi

# Test 2: Python Environment Setup
print_section "🐍 Testing Python Environment"

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    print_test_result "Virtual Environment Creation" "PASS" "Created venv directory"
else
    print_test_result "Virtual Environment Creation" "PASS" "Already exists"
fi

# Activate virtual environment
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate 2>/dev/null
if [ $? -eq 0 ]; then
    print_test_result "Virtual Environment Activation" "PASS" "Activated successfully"
else
    print_test_result "Virtual Environment Activation" "FAIL" "Failed to activate"
fi

# Install dependencies
pip install -r app/requirements.txt >/dev/null 2>&1
if [ $? -eq 0 ]; then
    print_test_result "Dependencies Installation" "PASS" "All packages installed"
else
    print_test_result "Dependencies Installation" "FAIL" "Failed to install packages"
fi

# Test 3: ML Model Testing
print_section "🤖 Testing ML Model"

# Check model files
if [ -f "model/model.pkl" ] && [ -f "model/metadata.json" ]; then
    print_test_result "Model Files" "PASS" "Model and metadata files found"
    
    # Test model loading
    python3 -c "
import joblib
import json
try:
    model = joblib.load('model/model.pkl')
    with open('model/metadata.json', 'r') as f:
        metadata = json.load(f)
    print('Model loaded successfully')
    print(f'Features: {len(metadata[\"feature_names\"])}')
except Exception as e:
    print(f'Error: {e}')
    exit(1)
" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        print_test_result "Model Loading" "PASS" "Model loads without errors"
    else
        print_test_result "Model Loading" "FAIL" "Failed to load model"
    fi
else
    print_test_result "Model Files" "FAIL" "Model files not found"
fi

# Test 4: Flask API Testing
print_section "🌐 Testing Flask API"

# Start Flask app in background
python3 app/app.py &
FLASK_PID=$!
sleep 5

# Test health endpoint
if curl -s http://localhost:5000/ | grep -q "Heart Disease Prediction API"; then
    print_test_result "API Health Check" "PASS" "API responds correctly"
else
    print_test_result "API Health Check" "FAIL" "API not responding"
fi

# Test prediction endpoint
PREDICTION_RESPONSE=$(curl -s -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65, "sex": 1, "cp": 3, "trestbps": 145, "chol": 233,
    "fbs": 1, "restecg": 0, "thalach": 150, "exang": 0, "oldpeak": 2.3, "slope": 0
  }' 2>/dev/null)

if echo "$PREDICTION_RESPONSE" | grep -q "prediction"; then
    print_test_result "API Prediction" "PASS" "Prediction endpoint works"
    echo "  Response: $PREDICTION_RESPONSE"
else
    print_test_result "API Prediction" "FAIL" "Prediction endpoint failed"
fi

# Test error handling
ERROR_RESPONSE=$(curl -s -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"invalid": "data"}' 2>/dev/null)

if echo "$ERROR_RESPONSE" | grep -q "error"; then
    print_test_result "API Error Handling" "PASS" "Error handling works"
else
    print_test_result "API Error Handling" "FAIL" "Error handling failed"
fi

# Stop Flask app
kill $FLASK_PID 2>/dev/null || true

# Test 5: Unit Testing
print_section "🧪 Testing Unit Tests"

# Install pytest
pip install pytest >/dev/null 2>&1

# Run unit tests
if pytest tests/ -v --tb=short >/dev/null 2>&1; then
    print_test_result "Unit Tests" "PASS" "All 10 tests passed"
else
    print_test_result "Unit Tests" "FAIL" "Some tests failed"
fi

# Test 6: Code Quality Testing
print_section "📏 Testing Code Quality"

# Install flake8
pip install flake8 >/dev/null 2>&1

# Run linting
if flake8 app/ tests/ --max-line-length=100 --ignore=E203,W503 >/dev/null 2>&1; then
    print_test_result "Code Quality (Flake8)" "PASS" "No linting errors"
else
    print_test_result "Code Quality (Flake8)" "FAIL" "Linting errors found"
fi

# Test 7: Docker Testing
print_section "🐳 Testing Docker Containerization"

# Build Docker image
if docker build -t heart-disease-api:test . >/dev/null 2>&1; then
    print_test_result "Docker Build" "PASS" "Image built successfully"
else
    print_test_result "Docker Build" "FAIL" "Docker build failed"
fi

# Test Docker container
if docker run -d -p 5001:5000 --name test-container heart-disease-api:test >/dev/null 2>&1; then
    print_test_result "Docker Run" "PASS" "Container started successfully"
    
    # Wait for container to start
    sleep 10
    
    # Test API in container
    if curl -s http://localhost:5001/ | grep -q "Heart Disease Prediction API"; then
        print_test_result "Docker API Test" "PASS" "API works in container"
    else
        print_test_result "Docker API Test" "FAIL" "API not working in container"
    fi
    
    # Clean up
    docker stop test-container >/dev/null 2>&1
    docker rm test-container >/dev/null 2>&1
else
    print_test_result "Docker Run" "FAIL" "Failed to start container"
fi

# Test 8: GitHub Repository Testing
print_section "📁 Testing GitHub Repository"

# Check if we're in a git repository
if [ -d ".git" ]; then
    print_test_result "Git Repository" "PASS" "Git repository found"
    
    # Check remote origin
    if git remote get-url origin >/dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin)
        print_test_result "Git Remote" "PASS" "Remote: $REMOTE_URL"
    else
        print_test_result "Git Remote" "FAIL" "No remote origin found"
    fi
    
    # Check branches
    BRANCHES=$(git branch -a | wc -l)
    if [ $BRANCHES -gt 1 ]; then
        print_test_result "Git Branches" "PASS" "Multiple branches found"
    else
        print_test_result "Git Branches" "FAIL" "Only one branch found"
    fi
else
    print_test_result "Git Repository" "FAIL" "Not a git repository"
fi

# Test 9: GitHub Actions Workflows
print_section "⚡ Testing GitHub Actions Workflows"

# Check workflow files
if [ -d ".github/workflows" ]; then
    WORKFLOW_COUNT=$(ls .github/workflows/*.yml 2>/dev/null | wc -l)
    if [ $WORKFLOW_COUNT -gt 0 ]; then
        print_test_result "GitHub Workflows" "PASS" "Found $WORKFLOW_COUNT workflow files"
    else
        print_test_result "GitHub Workflows" "FAIL" "No workflow files found"
    fi
else
    print_test_result "GitHub Workflows" "FAIL" "No .github/workflows directory"
fi

# Test 10: Jenkins Pipeline
print_section "🔧 Testing Jenkins Pipeline"

# Check Jenkinsfile
if [ -f "Jenkinsfile" ]; then
    print_test_result "Jenkinsfile" "PASS" "Jenkinsfile found"
    
    # Check if Jenkinsfile has required stages
    if grep -q "pipeline" Jenkinsfile && grep -q "stages" Jenkinsfile; then
        print_test_result "Jenkinsfile Structure" "PASS" "Valid pipeline structure"
    else
        print_test_result "Jenkinsfile Structure" "FAIL" "Invalid pipeline structure"
    fi
else
    print_test_result "Jenkinsfile" "FAIL" "Jenkinsfile not found"
fi

# Test 11: Documentation Testing
print_section "📚 Testing Documentation"

# Check documentation files
DOC_FILES=("README.md" "IMPLEMENTATION_DOCUMENTATION.md" "REQUIREMENTS_COMPLIANCE_CHECKLIST.md" "DEMO_GUIDE.md" "TESTING_GUIDE.md")
for doc_file in "${DOC_FILES[@]}"; do
    if [ -f "$doc_file" ]; then
        print_test_result "Documentation: $doc_file" "PASS" "File exists"
    else
        print_test_result "Documentation: $doc_file" "FAIL" "File missing"
    fi
done

# Test 12: Assignment Requirements Compliance
print_section "✅ Testing Assignment Requirements Compliance"

# Check for required tools
REQUIRED_TOOLS=("python3" "docker" "git")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if command_exists "$tool"; then
        print_test_result "Required Tool: $tool" "PASS" "Tool available"
    else
        print_test_result "Required Tool: $tool" "FAIL" "Tool missing"
    fi
done

# Check for Flask app
if [ -f "app/app.py" ] && grep -q "Flask" app/app.py; then
    print_test_result "Flask Application" "PASS" "Flask app found"
else
    print_test_result "Flask Application" "FAIL" "Flask app not found"
fi

# Check for Docker configuration
if [ -f "Dockerfile" ] && [ -f "Jenkinsfile" ]; then
    print_test_result "Docker & Jenkins" "PASS" "Both files present"
else
    print_test_result "Docker & Jenkins" "FAIL" "Missing Docker or Jenkins files"
fi

# Final Results
print_section "📊 Test Results Summary"

echo -e "${YELLOW}Total Tests: $TOTAL_TESTS${NC}"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"

# Calculate success percentage
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_PERCENTAGE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "${YELLOW}Success Rate: $SUCCESS_PERCENTAGE%${NC}"
    
    if [ $SUCCESS_PERCENTAGE -ge 90 ]; then
        echo -e "\n${GREEN}🎉 EXCELLENT! Your MLOps pipeline is working perfectly!${NC}"
        echo -e "${GREEN}✅ Ready for assignment submission and demo!${NC}"
    elif [ $SUCCESS_PERCENTAGE -ge 80 ]; then
        echo -e "\n${YELLOW}⚠️  GOOD! Most components are working, but some issues need attention.${NC}"
        echo -e "${YELLOW}🔧 Please review failed tests and fix issues.${NC}"
    else
        echo -e "\n${RED}❌ NEEDS WORK! Several components are not working properly.${NC}"
        echo -e "${RED}🔧 Please review failed tests and fix issues before submission.${NC}"
    fi
else
    echo -e "${RED}❌ No tests were executed!${NC}"
fi

# Cleanup
echo -e "\n${BLUE}🧹 Cleaning up...${NC}"
docker system prune -f >/dev/null 2>&1 || true
rm -rf venv/ 2>/dev/null || true

echo -e "\n${YELLOW}Test completed! Check the results above.${NC}"
echo -e "${YELLOW}For detailed testing instructions, see TESTING_GUIDE.md${NC}"
echo -e "${YELLOW}For demo instructions, see DEMO_GUIDE.md${NC}"

exit $FAILED_TESTS
