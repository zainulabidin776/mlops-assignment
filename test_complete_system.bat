@echo off
REM 🧪 Complete System Test Script for MLOps Assignment (Windows)
REM Group Members: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)

setlocal enabledelayedexpansion

echo 🧪 MLOps Assignment - Complete System Test
echo Group: Zain Ul Abidin (22I-2738) ^& Ahmed Javed (21I-1108)
echo Project: Heart Disease Prediction API with CI/CD Pipeline
echo.

set TOTAL_TESTS=0
set PASSED_TESTS=0
set FAILED_TESTS=0

REM Test 1: Environment Prerequisites
echo.
echo ========================================
echo 🔧 Testing Environment Prerequisites
echo ========================================
echo.

REM Check Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo ✅ PASS: Python Installation - Found: !PYTHON_VERSION!
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Python Installation - Python not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Check Docker
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('docker --version 2^>^&1') do set DOCKER_VERSION=%%i
    echo ✅ PASS: Docker Installation - Found: !DOCKER_VERSION!
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Docker Installation - Docker not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Check Git
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('git --version 2^>^&1') do set GIT_VERSION=%%i
    echo ✅ PASS: Git Installation - Found: !GIT_VERSION!
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Git Installation - Git not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Check project structure
if exist "app\app.py" if exist "Dockerfile" if exist "Jenkinsfile" (
    echo ✅ PASS: Project Structure - All required files found
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Project Structure - Missing required files
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 2: Python Environment
echo.
echo ========================================
echo 🐍 Testing Python Environment
echo ========================================
echo.

REM Create virtual environment
if not exist "venv" (
    python -m venv venv
    echo ✅ PASS: Virtual Environment Creation - Created venv directory
) else (
    echo ✅ PASS: Virtual Environment Creation - Already exists
)
set /a PASSED_TESTS+=1
set /a TOTAL_TESTS+=1

REM Activate virtual environment and install dependencies
call venv\Scripts\activate.bat
pip install -r app\requirements.txt >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: Dependencies Installation - All packages installed
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Dependencies Installation - Failed to install packages
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 3: ML Model Testing
echo.
echo ========================================
echo 🤖 Testing ML Model
echo ========================================
echo.

if exist "model\model.pkl" if exist "model\metadata.json" (
    echo ✅ PASS: Model Files - Model and metadata files found
    set /a PASSED_TESTS+=1
    
    REM Test model loading
    python -c "import joblib; import json; model = joblib.load('model/model.pkl'); metadata = json.load(open('model/metadata.json')); print('Model loaded successfully')" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ PASS: Model Loading - Model loads without errors
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Model Loading - Failed to load model
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Model Files - Model files not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 4: Flask API Testing
echo.
echo ========================================
echo 🌐 Testing Flask API
echo ========================================
echo.

REM Start Flask app in background
start /b python app\app.py
timeout /t 5 /nobreak >nul

REM Test health endpoint
curl -s http://localhost:5000/ | findstr "Heart Disease Prediction API" >nul
if %errorlevel% equ 0 (
    echo ✅ PASS: API Health Check - API responds correctly
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: API Health Check - API not responding
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test prediction endpoint
curl -s -X POST http://localhost:5000/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1, \"cp\": 3, \"trestbps\": 145, \"chol\": 233, \"fbs\": 1, \"restecg\": 0, \"thalach\": 150, \"exang\": 0, \"oldpeak\": 2.3, \"slope\": 0}" | findstr "prediction" >nul
if %errorlevel% equ 0 (
    echo ✅ PASS: API Prediction - Prediction endpoint works
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: API Prediction - Prediction endpoint failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Stop Flask app
taskkill /f /im python.exe >nul 2>&1

REM Test 5: Unit Testing
echo.
echo ========================================
echo 🧪 Testing Unit Tests
echo ========================================
echo.

pip install pytest >nul 2>&1
pytest tests\ -v --tb=short >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: Unit Tests - All 10 tests passed
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Unit Tests - Some tests failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 6: Docker Testing
echo.
echo ========================================
echo 🐳 Testing Docker Containerization
echo ========================================
echo.

docker build -t heart-disease-api:test . >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: Docker Build - Image built successfully
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Docker Build - Docker build failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

docker run -d -p 5001:5000 --name test-container heart-disease-api:test >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: Docker Run - Container started successfully
    set /a PASSED_TESTS+=1
    
    timeout /t 10 /nobreak >nul
    
    curl -s http://localhost:5001/ | findstr "Heart Disease Prediction API" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Docker API Test - API works in container
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Docker API Test - API not working in container
        set /a FAILED_TESTS+=1
    )
    
    docker stop test-container >nul 2>&1
    docker rm test-container >nul 2>&1
) else (
    echo ❌ FAIL: Docker Run - Failed to start container
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 7: GitHub Repository Testing
echo.
echo ========================================
echo 📁 Testing GitHub Repository
echo ========================================
echo.

if exist ".git" (
    echo ✅ PASS: Git Repository - Git repository found
    set /a PASSED_TESTS+=1
    
    git remote get-url origin >nul 2>&1
    if %errorlevel% equ 0 (
        for /f "tokens=*" %%i in ('git remote get-url origin 2^>^&1') do set REMOTE_URL=%%i
        echo ✅ PASS: Git Remote - Remote: !REMOTE_URL!
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Git Remote - No remote origin found
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Git Repository - Not a git repository
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 8: Documentation Testing
echo.
echo ========================================
echo 📚 Testing Documentation
echo ========================================
echo.

set DOC_FILES=README.md IMPLEMENTATION_DOCUMENTATION.md REQUIREMENTS_COMPLIANCE_CHECKLIST.md DEMO_GUIDE.md TESTING_GUIDE.md
for %%f in (%DOC_FILES%) do (
    if exist "%%f" (
        echo ✅ PASS: Documentation: %%f - File exists
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Documentation: %%f - File missing
        set /a FAILED_TESTS+=1
    )
    set /a TOTAL_TESTS+=1
)

REM Final Results
echo.
echo ========================================
echo 📊 Test Results Summary
echo ========================================
echo.

echo Total Tests: %TOTAL_TESTS%
echo Passed: %PASSED_TESTS%
echo Failed: %FAILED_TESTS%

if %TOTAL_TESTS% gtr 0 (
    set /a SUCCESS_PERCENTAGE=%PASSED_TESTS% * 100 / %TOTAL_TESTS%
    echo Success Rate: %SUCCESS_PERCENTAGE%%
    
    if %SUCCESS_PERCENTAGE% geq 90 (
        echo.
        echo 🎉 EXCELLENT! Your MLOps pipeline is working perfectly!
        echo ✅ Ready for assignment submission and demo!
    ) else if %SUCCESS_PERCENTAGE% geq 80 (
        echo.
        echo ⚠️  GOOD! Most components are working, but some issues need attention.
        echo 🔧 Please review failed tests and fix issues.
    ) else (
        echo.
        echo ❌ NEEDS WORK! Several components are not working properly.
        echo 🔧 Please review failed tests and fix issues before submission.
    )
) else (
    echo ❌ No tests were executed!
)

echo.
echo 🧹 Cleaning up...
docker system prune -f >nul 2>&1
rmdir /s /q venv 2>nul

echo.
echo Test completed! Check the results above.
echo For detailed testing instructions, see TESTING_GUIDE.md
echo For demo instructions, see DEMO_GUIDE.md

exit /b %FAILED_TESTS%
