# 🧪 API Testing Guide - Flask Application

**Group Members:**
- **Zain Ul Abidin** (22I-2738) - Primary Developer & DevOps Engineer
- **Ahmed Javed** (21I-1108) - Co-Developer & Testing Specialist

**Project:** Heart Disease Prediction API Testing

---

## 📋 **Overview**

This guide provides comprehensive testing scripts for the Flask API (`app.py`) in your MLOps assignment. The scripts test all API endpoints, error handling, and functionality to ensure your application works correctly.

---

## 🚀 **Quick Start**

### **Option 1: Python Test Script (Recommended)**
```bash
# Install required dependencies
pip install requests

# Run comprehensive Python test
python test_app_api.py
```

### **Option 2: Shell Script (Linux/Mac)**
```bash
# Make executable and run
chmod +x test_app_api.sh
./test_app_api.sh
```

### **Option 3: Windows Batch Script**
```cmd
# Run Windows batch script
test_app_api.bat
```

---

## 📊 **Test Coverage**

### **🔧 Environment Tests**
- ✅ Python installation check
- ✅ Required dependencies check
- ✅ Project file structure validation
- ✅ Model files existence check

### **🌐 API Endpoint Tests**
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

### **🤖 Model Tests**
- ✅ Model file existence
- ✅ Metadata file validation
- ✅ Model loading verification
- ✅ Feature structure check

### **📦 Application Tests**
- ✅ App import functionality
- ✅ Flask application startup
- ✅ Error handling mechanisms
- ✅ Response format validation

---

## 🎯 **Test Scripts Details**

### **1. Python Test Script (`test_app_api.py`)**

**Features:**
- Comprehensive API testing with detailed reporting
- Automatic Flask app startup and shutdown
- Color-coded output for easy reading
- Detailed error messages and debugging info
- Response time measurement
- JSON validation

**Usage:**
```bash
python test_app_api.py
```

**Output Example:**
```
🧪 Flask API Test Script for MLOps Assignment
Group: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)
Project: Heart Disease Prediction API

==================================================
🔧 Testing Environment Prerequisites
==================================================

✅ PASS: Python Installation - Found: Python 3.11.2
✅ PASS: Dependencies Installation - All packages installed

==================================================
🤖 Testing ML Model
==================================================

✅ PASS: Model Files - Model and metadata files found
✅ PASS: Model Loading - Model loads without errors

==================================================
🌐 Testing Flask API
==================================================

✅ PASS: API Health Check - API responds correctly
✅ PASS: API Prediction - Prediction endpoint works
✅ PASS: API Error Handling - Error handling works

==================================================
📊 Test Results Summary
==================================================

Total Tests: 10
Passed: 10
Failed: 0
Success Rate: 100%

🎉 EXCELLENT! Your Flask API is working perfectly!
✅ Ready for production deployment!
```

### **2. Shell Script (`test_app_api.sh`)**

**Features:**
- Bash-compatible testing
- Automatic Flask app management
- Comprehensive API endpoint testing
- Error handling validation
- Response time measurement

**Usage:**
```bash
chmod +x test_app_api.sh
./test_app_api.sh
```

### **3. Windows Batch Script (`test_app_api.bat`)**

**Features:**
- Windows-compatible testing
- Batch file execution
- API endpoint validation
- Error handling verification

**Usage:**
```cmd
test_app_api.bat
```

---

## 🔍 **Test Cases Explained**

### **Health Endpoint Test**
```bash
# Tests: GET http://localhost:5000/
# Validates:
# - Status code 200
# - Response contains "Heart Disease Prediction API"
# - Response time < 2 seconds
```

### **Prediction Endpoint Test (Valid Data)**
```bash
# Tests: POST http://localhost:5000/predict
# Data: Complete patient information
# Validates:
# - Status code 200
# - Response contains "prediction" and "probabilities"
# - JSON format validation
```

### **Prediction Endpoint Test (Missing Features)**
```bash
# Tests: POST http://localhost:5000/predict
# Data: Incomplete patient information
# Validates:
# - Status code 400
# - Error message present
# - Proper error handling
```

### **Prediction Endpoint Test (Invalid JSON)**
```bash
# Tests: POST http://localhost:5000/predict
# Data: Invalid JSON format
# Validates:
# - Status code 400
# - Error message present
# - JSON parsing error handling
```

### **Prediction Endpoint Test (Wrong Method)**
```bash
# Tests: GET http://localhost:5000/predict
# Validates:
# - Status code 405 (Method Not Allowed)
# - Proper HTTP method validation
```

### **Prediction Endpoint Test (Empty Data)**
```bash
# Tests: POST http://localhost:5000/predict
# Data: Empty JSON object {}
# Validates:
# - Status code 400
# - Error message present
# - Empty data handling
```

---

## 🛠️ **Manual Testing**

### **Start Flask App Manually**
```bash
# Install dependencies
pip install -r app/requirements.txt

# Start Flask app
python app/app.py
```

### **Test Health Endpoint**
```bash
curl http://localhost:5000/
```

**Expected Response:**
```
Heart Disease Prediction API running
```

### **Test Prediction Endpoint**
```bash
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65, "sex": 1, "cp": 3, "trestbps": 145, "chol": 233,
    "fbs": 1, "restecg": 0, "thalach": 150, "exang": 0, "oldpeak": 2.3, "slope": 0
  }'
```

**Expected Response:**
```json
{
  "prediction": 1,
  "probabilities": [0.2, 0.8]
}
```

### **Test Error Handling**
```bash
# Missing features
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"age": 65, "sex": 1}'

# Invalid JSON
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d 'invalid json'

# Wrong method
curl http://localhost:5000/predict
```

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Issue 1: Flask App Not Starting**
```bash
# Check if port 5000 is in use
netstat -an | grep 5000

# Kill process using port 5000
lsof -ti:5000 | xargs kill -9

# Try different port
export FLASK_PORT=5001
python app/app.py
```

#### **Issue 2: Model Files Not Found**
```bash
# Check if model files exist
ls -la model/
# Should show: model.pkl and metadata.json
```

#### **Issue 3: Dependencies Missing**
```bash
# Install required packages
pip install -r app/requirements.txt
pip install requests  # For test scripts
```

#### **Issue 4: Import Errors**
```bash
# Check Python path
python -c "import sys; print(sys.path)"

# Add app directory to path
export PYTHONPATH="${PYTHONPATH}:$(pwd)/app"
```

---

## 📈 **Success Criteria**

Your API is working correctly if:

1. ✅ **All test scripts pass** (90%+ success rate)
2. ✅ **Health endpoint responds** with correct message
3. ✅ **Prediction endpoint works** with valid data
4. ✅ **Error handling works** for invalid inputs
5. ✅ **Model loads successfully** without errors
6. ✅ **Response time is acceptable** (< 2 seconds)

---

## 🎯 **Integration with CI/CD**

### **GitHub Actions Integration**
```yaml
# Add to your GitHub Actions workflow
- name: Test Flask API
  run: |
    python test_app_api.py
    if [ $? -ne 0 ]; then
      echo "API tests failed"
      exit 1
    fi
```

### **Jenkins Integration**
```groovy
// Add to your Jenkinsfile
stage('Test API') {
    steps {
        sh 'python test_app_api.py'
    }
}
```

---

## 📚 **Additional Resources**

- **`TESTING_GUIDE.md`** - Complete system testing guide
- **`DEMO_GUIDE.md`** - Demo presentation guide
- **`IMPLEMENTATION_DOCUMENTATION.md`** - Complete implementation details
- **`REQUIREMENTS_COMPLIANCE_CHECKLIST.md`** - Assignment compliance

---

## 🎉 **Conclusion**

These test scripts provide comprehensive validation of your Flask API, ensuring it works correctly before deployment. Use them regularly during development and before submitting your assignment.

**Happy Testing!** 🚀

---

*This API testing guide ensures your Flask application is thoroughly tested and ready for the MLOps Assignment by Zain Ul Abidin (22I-2738) and Ahmed Javed (21I-1108).*
