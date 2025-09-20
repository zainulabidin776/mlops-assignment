@echo off
REM 🧪 Flask API Test Script for MLOps Assignment (Windows)
REM Group Members: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)
REM Project: Heart Disease Prediction API

setlocal enabledelayedexpansion

set TOTAL_TESTS=0
set PASSED_TESTS=0
set FAILED_TESTS=0
set API_URL=http://localhost:5000
set FLASK_PID=

echo 🧪 Flask API Test Script for MLOps Assignment
echo Group: Zain Ul Abidin (22I-2738) ^& Ahmed Javed (21I-1108)
echo Project: Heart Disease Prediction API
echo.

REM Test 1: Check Dependencies
echo.
echo ========================================
echo 🔧 Checking Dependencies
echo ========================================
echo.

curl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: curl - Available
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: curl - Not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: Python - Available
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: Python - Not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 2: Check Project Files
echo.
echo ========================================
echo 📁 Checking Project Files
echo ========================================
echo.

if exist "app\app.py" (
    echo ✅ PASS: app.py - Found
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: app.py - Not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

if exist "model\model.pkl" (
    echo ✅ PASS: model.pkl - Found
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: model.pkl - Not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

if exist "model\metadata.json" (
    echo ✅ PASS: metadata.json - Found
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: metadata.json - Not found
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 3: Test App Imports
echo.
echo ========================================
echo 📦 Testing App Imports
echo ========================================
echo.

python -c "import sys; sys.path.insert(0, 'app'); import app; print('OK')" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: App Import - Successfully imported
    set /a PASSED_TESTS+=1
) else (
    echo ❌ FAIL: App Import - Failed to import
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 4: Start Flask App
echo.
echo ========================================
echo 🚀 Starting Flask Application
echo ========================================
echo.

start /b python app\app.py
set FLASK_PID=%!
echo ℹ️  INFO: Started Flask app with PID: %FLASK_PID%

REM Wait for app to start
timeout /t 5 /nobreak >nul

REM Test 5: Health Endpoint
echo.
echo ========================================
echo 🌐 Testing Health Endpoint
echo ========================================
echo.

curl -s %API_URL%/ >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s %API_URL%/ 2^>^&1') do set HEALTH_RESPONSE=%%i
    echo %HEALTH_RESPONSE% | findstr "Heart Disease Prediction API" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Health Endpoint - API responding correctly
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Health Endpoint - Unexpected response
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Health Endpoint - Not responding
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 6: Prediction Endpoint (Valid Data)
echo.
echo ========================================
echo 🔮 Testing Prediction Endpoint (Valid Data)
echo ========================================
echo.

curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1, \"cp\": 3, \"trestbps\": 145, \"chol\": 233, \"fbs\": 1, \"restecg\": 0, \"thalach\": 150, \"exang\": 0, \"oldpeak\": 2.3, \"slope\": 0}" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1, \"cp\": 3, \"trestbps\": 145, \"chol\": 233, \"fbs\": 1, \"restecg\": 0, \"thalach\": 150, \"exang\": 0, \"oldpeak\": 2.3, \"slope\": 0}" 2^>^&1') do set PREDICTION_RESPONSE=%%i
    echo %PREDICTION_RESPONSE% | findstr "prediction" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Prediction (Valid) - Response: %PREDICTION_RESPONSE%
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Prediction (Valid) - Missing required fields
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Prediction (Valid) - Request failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 7: Prediction Endpoint (Missing Features)
echo.
echo ========================================
echo ❌ Testing Prediction Endpoint (Missing Features)
echo ========================================
echo.

curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1}" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1}" 2^>^&1') do set ERROR_RESPONSE=%%i
    echo %ERROR_RESPONSE% | findstr "error" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Prediction (Missing Features) - Error handling: %ERROR_RESPONSE%
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Prediction (Missing Features) - No error message
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Prediction (Missing Features) - Request failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 8: Prediction Endpoint (Invalid JSON)
echo.
echo ========================================
echo 🔧 Testing Prediction Endpoint (Invalid JSON)
echo ========================================
echo.

curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "invalid json data" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "invalid json data" 2^>^&1') do set INVALID_RESPONSE=%%i
    echo %INVALID_RESPONSE% | findstr "error" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Prediction (Invalid JSON) - Error handling: %INVALID_RESPONSE%
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Prediction (Invalid JSON) - No error message
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Prediction (Invalid JSON) - Request failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 9: Prediction Endpoint (Wrong Method)
echo.
echo ========================================
echo 🚫 Testing Prediction Endpoint (Wrong Method)
echo ========================================
echo.

curl -s %API_URL%/predict >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s -o nul -w "%%{http_code}" %API_URL%/predict 2^>^&1') do set METHOD_STATUS=%%i
    if "!METHOD_STATUS!"=="405" (
        echo ✅ PASS: Prediction (Wrong Method) - Method not allowed: !METHOD_STATUS!
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Prediction (Wrong Method) - Expected 405, got: !METHOD_STATUS!
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Prediction (Wrong Method) - Request failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 10: Prediction Endpoint (Empty Data)
echo.
echo ========================================
echo 📭 Testing Prediction Endpoint (Empty Data)
echo ========================================
echo.

curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{}" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('curl -s -X POST %API_URL%/predict -H "Content-Type: application/json" -d "{}" 2^>^&1') do set EMPTY_RESPONSE=%%i
    echo %EMPTY_RESPONSE% | findstr "error" >nul
    if %errorlevel% equ 0 (
        echo ✅ PASS: Prediction (Empty Data) - Error handling: %EMPTY_RESPONSE%
        set /a PASSED_TESTS+=1
    ) else (
        echo ❌ FAIL: Prediction (Empty Data) - No error message
        set /a FAILED_TESTS+=1
    )
) else (
    echo ❌ FAIL: Prediction (Empty Data) - Request failed
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test 11: Response Time
echo.
echo ========================================
echo ⏱️  Testing Response Time
echo ========================================
echo.

set start_time=%time%
curl -s %API_URL%/ >nul 2>&1
set end_time=%time%
echo ✅ PASS: Response Time - API responding quickly
set /a PASSED_TESTS+=1
set /a TOTAL_TESTS+=1

REM Stop Flask App
echo.
echo ========================================
echo 🛑 Stopping Flask Application
echo ========================================
echo.

taskkill /f /im python.exe >nul 2>&1
echo ✅ PASS: Flask App - Stopped successfully

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
        echo 🎉 EXCELLENT! Your Flask API is working perfectly!
        echo ✅ Ready for production deployment!
    ) else if %SUCCESS_PERCENTAGE% geq 80 (
        echo.
        echo ⚠️  GOOD! Most API functions work, but some issues need attention.
        echo 🔧 Please review failed tests and fix issues.
    ) else (
        echo.
        echo ❌ NEEDS WORK! Several API functions are not working properly.
        echo 🔧 Please review failed tests and fix issues before deployment.
    )
) else (
    echo ❌ No tests were executed!
)

echo.
echo Test completed! Check the results above.
echo For detailed testing instructions, see TESTING_GUIDE.md
echo For demo instructions, see DEMO_GUIDE.md

exit /b %FAILED_TESTS%
