# 🧪 Windows Testing Guide for Flask API

**Group Members:**
- **Zain Ul Abidin** (22I-2738) - Primary Developer & DevOps Engineer
- **Ahmed Javed** (21I-1108) - Co-Developer & Testing Specialist

**Project:** Heart Disease Prediction API Testing on Windows

---

## 🚀 **Quick Start (3 Methods)**

### **Method 1: Python Script (Recommended)**
```cmd
# Install requests if not already installed
pip install requests

# Run the comprehensive Python test
python test_app_windows.py
```

### **Method 2: Batch File (Easy)**
```cmd
# Double-click or run from command prompt
test_app_windows.bat
```

### **Method 3: Manual Testing**
```cmd
# Start Flask app manually
python app/app.py

# In another command prompt, test the API
curl http://localhost:5000/
curl -X POST http://localhost:5000/predict -H "Content-Type: application/json" -d "{\"age\": 65, \"sex\": 1, \"cp\": 3, \"trestbps\": 145, \"chol\": 233, \"fbs\": 1, \"restecg\": 0, \"thalach\": 150, \"exang\": 0, \"oldpeak\": 2.3, \"slope\": 0}"
```

---

## 📋 **Prerequisites**

### **Required Software**
- ✅ **Python 3.8+** - Download from [python.org](https://python.org)
- ✅ **pip** - Usually comes with Python
- ✅ **requests library** - Will be installed automatically
- ✅ **curl** - Usually available on Windows 10+

### **Project Files**
- ✅ `app/app.py` - Flask application
- ✅ `model/model.pkl` - Trained ML model
- ✅ `model/metadata.json` - Model metadata
- ✅ `app/requirements.txt` - Python dependencies

---

## 🧪 **Test Scripts Explained**

### **`test_app_windows.py` (Python Script)**
**Features:**
- Comprehensive API testing with detailed reporting
- Automatic Flask app startup and shutdown
- Color-coded output for easy reading
- Detailed error messages and debugging info
- Response time measurement
- JSON validation

**Usage:**
```cmd
python test_app_windows.py
```

**What it tests:**
1. **Environment checks** - Python, dependencies, files
2. **Model validation** - Files exist, load correctly
3. **API testing** - All endpoints work correctly
4. **Error handling** - Proper error responses
5. **Performance** - Response time measurement

### **`test_app_windows.bat` (Batch File)**
**Features:**
- Windows-compatible batch file
- Automatic dependency installation
- API endpoint validation
- Error handling verification
- Easy execution

**Usage:**
```cmd
test_app_windows.bat
```

**What it tests:**
1. **Dependencies** - Python, pip, requests
2. **Project files** - All required files exist
3. **API endpoints** - Health and prediction endpoints
4. **Error handling** - Invalid inputs, missing data
5. **Response validation** - JSON format, error messages

---

## 🎯 **Expected Test Results**

### **Successful Test Output**
```
🧪 Flask API Test Script for Windows - MLOps Assignment
Group: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)
Project: Heart Disease Prediction API

============================================================
🔧 Checking Dependencies
============================================================

✅ PASS: Python - Found: Python 3.11.2
✅ PASS: pip - Available
✅ PASS: requests library - Available

============================================================
📁 Checking Project Files
============================================================

✅ PASS: app.py - Found
✅ PASS: model.pkl - Found
✅ PASS: metadata.json - Found
✅ PASS: requirements.txt - Found

============================================================
📦 Installing Dependencies
============================================================

✅ PASS: Dependencies - Installed successfully

============================================================
📦 Testing App Imports
============================================================

✅ PASS: App Import - Successfully imported

============================================================
🚀 Starting Flask Application
============================================================

✅ PASS: Flask App Start - Application started successfully (PID: 12345)

============================================================
🌐 Testing Health Endpoint
============================================================

✅ PASS: Health Endpoint - Status: 200, Response: Heart Disease Prediction API running

============================================================
🔮 Testing Prediction Endpoint (Valid Data)
============================================================

✅ PASS: Prediction Endpoint (Valid) - Prediction: 1, Probabilities: [0.2, 0.8]

============================================================
❌ Testing Prediction Endpoint (Missing Features)
============================================================

✅ PASS: Prediction Endpoint (Missing Features) - Error handling: Missing required features

============================================================
🔧 Testing Prediction Endpoint (Invalid JSON)
============================================================

✅ PASS: Prediction Endpoint (Invalid JSON) - Error handling: Invalid JSON

============================================================
🚫 Testing Prediction Endpoint (Wrong Method)
============================================================

✅ PASS: Prediction Endpoint (Wrong Method) - Method not allowed: 405

============================================================
📭 Testing Prediction Endpoint (Empty Data)
============================================================

✅ PASS: Prediction Endpoint (Empty Data) - Error handling: Missing required features

============================================================
⏱️  Testing Response Time
============================================================

✅ PASS: Response Time - Response time: 0.123s

============================================================
🛑 Stopping Flask Application
============================================================

✅ PASS: Flask App Stop - Application stopped successfully

============================================================
📊 Test Results Summary
============================================================

Total Tests: 12
Passed: 12
Failed: 0
Success Rate: 100%

🎉 EXCELLENT! Your Flask API is working perfectly!
✅ Ready for production deployment!
```

---

## 🔧 **Troubleshooting**

### **Common Issues & Solutions**

#### **Issue 1: Python Not Found**
```cmd
# Solution: Install Python from python.org
# Make sure to check "Add Python to PATH" during installation
python --version
```

#### **Issue 2: pip Not Found**
```cmd
# Solution: Install pip
python -m ensurepip --upgrade
# Or download get-pip.py and run it
```

#### **Issue 3: requests Library Not Found**
```cmd
# Solution: Install requests
pip install requests
```

#### **Issue 4: Flask App Not Starting**
```cmd
# Check if port 5000 is in use
netstat -an | findstr 5000

# Kill process using port 5000
taskkill /f /im python.exe

# Try different port
set FLASK_PORT=5001
python app/app.py
```

#### **Issue 5: Model Files Not Found**
```cmd
# Check if model files exist
dir model\
# Should show: model.pkl and metadata.json
```

#### **Issue 6: Import Errors**
```cmd
# Check Python path
python -c "import sys; print(sys.path)"

# Install missing dependencies
pip install -r app/requirements.txt
```

#### **Issue 7: curl Not Found**
```cmd
# Solution: Install curl or use PowerShell
# PowerShell alternative:
Invoke-WebRequest -Uri "http://localhost:5000/" -Method GET
```

---

## 📊 **Test Coverage**

### **Environment Tests**
- ✅ Python installation check
- ✅ pip availability check
- ✅ requests library check
- ✅ Project file structure validation

### **API Endpoint Tests**
- ✅ **Health Endpoint** (`GET /`)
  - Status code validation
  - Response content verification
  - Response time measurement

- ✅ **Prediction Endpoint** (`POST /predict`)
  - Valid data prediction
  - Missing features error handling
  - Invalid JSON error handling
  - Wrong HTTP method handling
  - Empty data error handling

### **Model Tests**
- ✅ Model file existence
- ✅ Metadata file validation
- ✅ Model loading verification
- ✅ Feature structure check

### **Application Tests**
- ✅ App import functionality
- ✅ Flask application startup
- ✅ Error handling mechanisms
- ✅ Response format validation

---

## 🎯 **Success Criteria**

Your API is working correctly if:

1. ✅ **All test scripts pass** (90%+ success rate)
2. ✅ **Health endpoint responds** with correct message
3. ✅ **Prediction endpoint works** with valid data
4. ✅ **Error handling works** for invalid inputs
5. ✅ **Model loads successfully** without errors
6. ✅ **Response time is acceptable** (< 3 seconds)

---

## 📚 **Additional Resources**

- **`docs/testing/API_TESTING_GUIDE.md`** - Detailed API testing guide
- **`docs/testing/TESTING_GUIDE.md`** - Comprehensive testing procedures
- **`docs/demo/DEMO_GUIDE.md`** - Demo presentation guide
- **`docs/demo/QUICK_START_GUIDE.md`** - Quick setup instructions

---

## 🎉 **Ready for Testing!**

Your Windows testing setup is now complete! Use any of the three methods above to test your Flask API and ensure it's working perfectly before your demo.

**Happy Testing!** 🚀

---

*This Windows testing guide ensures your Flask API is thoroughly tested on Windows for the MLOps Assignment by Zain Ul Abidin (22I-2738) and Ahmed Javed (21I-1108).*
