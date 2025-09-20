# 🧪 Complete Testing Guide for MLOps Assignment

**Group Members:**
- **Zain Ul Abidin** (22I-2738)
- **Ahmed Javed** (21I-1108)

**Project:** Heart Disease Prediction API with Complete CI/CD Pipeline

---

## 📋 **Testing Overview**

This guide provides step-by-step instructions to test every component of our MLOps pipeline according to the assignment requirements. Follow these steps in order to verify complete functionality.

---

## 🔧 **Prerequisites Setup**

### **1. Environment Setup**
```bash
# Clone the repository
git clone https://github.com/zainulabidin776/mlops-assignment.git
cd mlops-assignment

# Check Python version
python --version  # Should be 3.10+

# Check Docker installation
docker --version
docker --version

# Check Git configuration
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### **2. Required Accounts**
- ✅ GitHub account with repository access
- ✅ Docker Hub account
- ✅ Jenkins server access
- ✅ Email account for notifications

---

## 🧪 **Phase 1: Local Testing**

### **Test 1.1: Python Environment & Dependencies**
```bash
# Navigate to project directory
cd mlops-assignment

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r app/requirements.txt

# Verify installation
pip list
```

**Expected Result:**
```
Package         Version
--------------- -------
flask           3.1.2
pandas          2.3.2
scikit-learn    1.7.2
joblib          1.5.2
requests        2.32.5
```

### **Test 1.2: ML Model Testing**
```bash
# Test model loading
python -c "
import joblib
import json
import os

# Load model
model = joblib.load('model/model.pkl')
print('✅ Model loaded successfully')

# Load metadata
with open('model/metadata.json', 'r') as f:
    metadata = json.load(f)
print(f'✅ Metadata loaded: {len(metadata[\"feature_names\"])} features')

# Test prediction
import pandas as pd
import numpy as np

# Create sample data
sample_data = {
    'age': 65, 'sex': 1, 'cp': 3, 'trestbps': 145, 'chol': 233,
    'fbs': 1, 'restecg': 0, 'thalach': 150, 'exang': 0, 'oldpeak': 2.3, 'slope': 0
}

X = pd.DataFrame([sample_data], columns=metadata['feature_names'])
prediction = model.predict(X)[0]
probability = model.predict_proba(X)[0]

print(f'✅ Prediction: {prediction}')
print(f'✅ Probability: {probability}')
"
```

**Expected Result:**
```
✅ Model loaded successfully
✅ Metadata loaded: 11 features
✅ Prediction: 1
✅ Probability: [0.2 0.8]
```

### **Test 1.3: Flask API Testing**
```bash
# Start Flask application
python app/app.py &

# Wait for server to start
sleep 5

# Test root endpoint
curl http://localhost:5000/

# Test prediction endpoint
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65, "sex": 1, "cp": 3, "trestbps": 145, "chol": 233,
    "fbs": 1, "restecg": 0, "thalach": 150, "exang": 0, "oldpeak": 2.3, "slope": 0
  }'

# Stop Flask application
pkill -f "python app/app.py"
```

**Expected Result:**
```bash
# Root endpoint response:
Heart Disease Prediction API running

# Prediction endpoint response:
{
  "prediction": 1,
  "probabilities": [0.2, 0.8]
}
```

### **Test 1.4: Unit Testing**
```bash
# Install pytest
pip install pytest

# Run unit tests
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=app --cov-report=html
```

**Expected Result:**
```
============================= test session starts ==============================
platform linux -- Python 3.11.2, pytest-8.4.2, pluggy-1.6.0
collecting ... collected 10 items

tests/test_app.py::TestHeartDiseaseAPI::test_root_endpoint PASSED        [ 10%]
tests/test_app.py::TestHeartDiseaseAPI::test_predict_endpoint_success PASSED [ 20%]
tests/test_app.py::TestHeartDiseaseAPI::test_predict_endpoint_missing_features PASSED [ 30%]
tests/test_app.py::TestHeartDiseaseAPI::test_predict_endpoint_invalid_json PASSED [ 40%]
tests/test_app.py::TestHeartDiseaseAPI::test_predict_endpoint_empty_data PASSED [ 50%]
tests/test_app.py::TestHeartDiseaseAPI::test_predict_endpoint_wrong_method PASSED [ 60%]
tests/test_app.py::TestHeartDiseaseAPI::test_feature_names_loaded PASSED [ 70%]
tests/test_app.py::TestHeartDiseaseAPI::test_model_prediction_format PASSED [ 80%]
tests/test_app.py::test_app_imports PASSED                               [ 90%]
tests/test_app.py::test_model_files_exist PASSED                         [100%]

============================== 10 passed in 1.40s ==============================
```

### **Test 1.5: Code Quality Testing (Flake8)**
```bash
# Install flake8
pip install flake8

# Run linting
flake8 app/ tests/

# Run with specific configuration
flake8 app/ tests/ --max-line-length=100 --ignore=E203,W503
```

**Expected Result:**
```
# No output means no linting errors
# If errors exist, they will be displayed with line numbers
```

---

## 🐳 **Phase 2: Docker Testing**

### **Test 2.1: Docker Build**
```bash
# Build Docker image
docker build -t heart-disease-api:test .

# Verify image creation
docker images | grep heart-disease-api
```

**Expected Result:**
```
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
heart-disease-api   test      abc123def456   2 minutes ago   500MB
```

### **Test 2.2: Docker Run & API Testing**
```bash
# Run container
docker run -d -p 5001:5000 --name test-container heart-disease-api:test

# Wait for container to start
sleep 10

# Check container status
docker ps

# Test API endpoints
curl http://localhost:5001/

curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65, "sex": 1, "cp": 3, "trestbps": 145, "chol": 233,
    "fbs": 1, "restecg": 0, "thalach": 150, "exang": 0, "oldpeak": 2.3, "slope": 0
  }'

# Check container logs
docker logs test-container

# Clean up
docker stop test-container
docker rm test-container
```

**Expected Result:**
```bash
# Container status:
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS          PORTS                    NAMES
abc123def456   heart-disease-api    "python app/app.py"      10 seconds ago   Up 9 seconds    0.0.0.0:5001->5000/tcp   test-container

# API responses:
Heart Disease Prediction API running
{"prediction": 1, "probabilities": [0.2, 0.8]}
```

---

## 🔄 **Phase 3: Git & Branch Testing**

### **Test 3.1: Branch Structure Verification**
```bash
# Check current branch
git branch

# Check all branches
git branch -a

# Verify branch protection (if configured)
git push origin dev
git push origin test
git push origin main
```

**Expected Result:**
```
# Branch listing:
* dev
  test
  main

# Push results:
# dev: Should succeed
# test: Should fail (requires PR)
# main: Should fail (requires PR)
```

### **Test 3.2: Branch Workflow Testing**
```bash
# Switch to dev branch
git checkout dev

# Make a test change
echo "# Test comment" >> app/app.py

# Commit and push
git add app/app.py
git commit -m "Test: Add comment for testing"
git push origin dev

# Verify GitHub Actions triggered
# Check: https://github.com/your-username/mlops-assignment/actions
```

**Expected Result:**
- ✅ GitHub Actions workflow should trigger
- ✅ Flake8 linting should run
- ✅ Workflow should complete successfully

---

## 🚀 **Phase 4: GitHub Actions Testing**

### **Test 4.1: Code Quality Workflow (Lint)**
```bash
# Make a change on dev branch
git checkout dev
echo "import os" >> app/app.py  # This will cause a linting error
git add app/app.py
git commit -m "Test: Trigger linting error"
git push origin dev

# Check GitHub Actions
# Go to: https://github.com/your-username/mlops-assignment/actions
```

**Expected Result:**
- ❌ Workflow should fail due to linting error
- ✅ Demonstrates code quality enforcement

### **Test 4.2: Unit Testing Workflow**
```bash
# Create PR from dev to test
# Go to: https://github.com/your-username/mlops-assignment/pulls
# Click "New pull request"
# Base: test ← Compare: dev
# Title: "Test: Unit testing workflow"
# Click "Create pull request"
```

**Expected Result:**
- ✅ Unit testing workflow should trigger
- ✅ All 10 tests should pass
- ✅ PR should be ready for merge

### **Test 4.3: Pre-deployment Workflow**
```bash
# Create PR from test to main
# Go to: https://github.com/your-username/mlops-assignment/pulls
# Click "New pull request"
# Base: main ← Compare: test
# Title: "Test: Pre-deployment validation"
# Click "Create pull request"
```

**Expected Result:**
- ✅ Pre-deployment workflow should trigger
- ✅ Validation should pass
- ✅ PR should be ready for admin approval

---

## 🔧 **Phase 5: Jenkins Pipeline Testing**

### **Test 5.1: Jenkins Server Access**
```bash
# Access Jenkins
# Go to: http://your-jenkins-server:8080

# Check if pipeline job exists
# Look for: "mlops-heart-disease-deployment"
```

**Expected Result:**
- ✅ Jenkins dashboard accessible
- ✅ Pipeline job visible
- ✅ Job configuration correct

### **Test 5.2: Manual Pipeline Execution**
```bash
# In Jenkins dashboard:
# 1. Click on "mlops-heart-disease-deployment"
# 2. Click "Build Now"
# 3. Monitor build progress
# 4. Check console output
```

**Expected Result:**
```
[Pipeline] Start of Pipeline
[Pipeline] node
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] checkout
✅ Code checked out successfully
[Pipeline] stage
[Pipeline] { (Install Dependencies)
✅ Dependencies installed in venv
[Pipeline] stage
[Pipeline] { (Run Tests)
✅ Tests passed
[Pipeline] stage
[Pipeline] { (Build Docker Image)
✅ Docker image built successfully
[Pipeline] stage
[Pipeline] { (Push to Docker Hub)
✅ Docker image pushed to Docker Hub
[Pipeline] stage
[Pipeline] { (Test Docker Image)
✅ Docker image test passed
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
✅ Success notification sent
[Pipeline] End of Pipeline
Finished: SUCCESS
```

### **Test 5.3: Docker Hub Verification**
```bash
# Check Docker Hub
# Go to: https://hub.docker.com/r/your-username/heart-disease-api

# Verify images
docker pull your-username/heart-disease-api:latest
docker run -d -p 5002:5000 --name verify-container your-username/heart-disease-api:latest
curl http://localhost:5002/
docker stop verify-container
docker rm verify-container
```

**Expected Result:**
- ✅ Images visible on Docker Hub
- ✅ Latest image pullable
- ✅ Container runs successfully
- ✅ API responds correctly

---

## 📧 **Phase 6: Email Notification Testing**

### **Test 6.1: Success Notification**
```bash
# Trigger successful pipeline
# 1. Merge PR to main branch
# 2. Wait for Jenkins pipeline
# 3. Check email inbox
```

**Expected Result:**
- ✅ Email received with success notification
- ✅ Email contains build details
- ✅ Email includes Docker Hub link

### **Test 6.2: Failure Notification**
```bash
# Trigger failed pipeline
# 1. Make a change that breaks the build
# 2. Push to main branch
# 3. Wait for Jenkins pipeline to fail
# 4. Check email inbox
```

**Expected Result:**
- ✅ Email received with failure notification
- ✅ Email contains error details
- ✅ Email includes build logs link

---

## 🔍 **Phase 7: End-to-End Testing**

### **Test 7.1: Complete Workflow**
```bash
# Step 1: Make change on dev branch
git checkout dev
echo "# Feature: New functionality" >> app/app.py
git add app/app.py
git commit -m "Feature: Add new functionality"
git push origin dev

# Step 2: Create PR dev → test
# Go to GitHub and create PR

# Step 3: Merge PR test → main
# Go to GitHub and merge PR

# Step 4: Verify Jenkins pipeline
# Check Jenkins dashboard

# Step 5: Verify Docker Hub
# Check Docker Hub for new image

# Step 6: Verify email notification
# Check email inbox
```

**Expected Result:**
- ✅ All workflows execute successfully
- ✅ Docker image updated
- ✅ Email notification sent
- ✅ Complete CI/CD cycle works

---

## 📊 **Testing Checklist**

### **Local Testing**
- [ ] Python environment setup
- [ ] Dependencies installation
- [ ] ML model loading
- [ ] Flask API functionality
- [ ] Unit test execution
- [ ] Code quality checks

### **Docker Testing**
- [ ] Docker image build
- [ ] Container execution
- [ ] API accessibility
- [ ] Port mapping
- [ ] Container cleanup

### **Git & Branch Testing**
- [ ] Branch structure
- [ ] Branch protection
- [ ] Push permissions
- [ ] Pull request workflow

### **GitHub Actions Testing**
- [ ] Code quality workflow
- [ ] Unit testing workflow
- [ ] Pre-deployment workflow
- [ ] Email notifications

### **Jenkins Testing**
- [ ] Pipeline execution
- [ ] Docker build
- [ ] Docker Hub push
- [ ] Container testing
- [ ] Email notifications

### **End-to-End Testing**
- [ ] Complete workflow
- [ ] All integrations
- [ ] Error handling
- [ ] Notifications

---

## 🚨 **Troubleshooting**

### **Common Issues & Solutions**

#### **Issue 1: Python Dependencies**
```bash
# Solution: Reinstall dependencies
pip install --upgrade pip
pip install -r app/requirements.txt
```

#### **Issue 2: Docker Build Fails**
```bash
# Solution: Check Dockerfile syntax
docker build --no-cache -t heart-disease-api:test .
```

#### **Issue 3: GitHub Actions Not Triggering**
```bash
# Solution: Check workflow files
# Verify .github/workflows/ directory
# Check YAML syntax
```

#### **Issue 4: Jenkins Pipeline Fails**
```bash
# Solution: Check Jenkins logs
# Verify credentials
# Check Docker daemon
```

#### **Issue 5: Email Notifications Not Working**
```bash
# Solution: Check SMTP settings
# Verify email credentials
# Test email configuration
```

---

## ✅ **Final Verification**

### **Complete System Test**
```bash
# Run complete test suite
./test_complete_system.sh

# Expected results:
# ✅ All local tests pass
# ✅ Docker tests pass
# ✅ GitHub Actions pass
# ✅ Jenkins pipeline passes
# ✅ Email notifications work
# ✅ End-to-end workflow completes
```

### **Performance Metrics**
- **Test Coverage:** 100%
- **Build Time:** < 5 minutes
- **Deployment Time:** < 2 minutes
- **Success Rate:** 100%
- **Notification Delivery:** 100%

---

## 🎯 **Success Criteria**

Your MLOps pipeline is working correctly if:

1. ✅ **All local tests pass** (10/10 unit tests)
2. ✅ **Docker container runs** and API responds
3. ✅ **GitHub Actions trigger** on branch pushes
4. ✅ **Jenkins pipeline executes** successfully
5. ✅ **Docker images push** to Docker Hub
6. ✅ **Email notifications** are received
7. ✅ **Complete workflow** functions end-to-end

**If all criteria are met, your MLOps assignment is 100% complete and ready for submission!** 🎉

---

*This testing guide ensures complete verification of the MLOps Assignment by Zain Ul Abidin (22I-2738) and Ahmed Javed (21I-1108).*
