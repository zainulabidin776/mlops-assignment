# 🎯 Complete Demo Guide for MLOps Assignment

**Group Members:**
- **Zain Ul Abidin** (22I-2738) - Primary Developer & DevOps Engineer
- **Ahmed Javed** (21I-1108) - Co-Developer & Testing Specialist

**Project:** Heart Disease Prediction API with Complete CI/CD Pipeline

---

## 📋 **Demo Overview**

This guide provides step-by-step instructions to demonstrate the complete MLOps pipeline for your assignment presentation. Follow these steps to showcase all implemented features and prove compliance with assignment requirements.

---

## 🚀 **Pre-Demo Setup (15 minutes before presentation)**

### **Step 1: Environment Preparation**
```bash
# 1. Start Jenkins (if not running)
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# 2. Start ngrok (for webhook)
ngrok http 8080

# 3. Verify all services are running
docker ps
curl http://localhost:8080
```

### **Step 2: GitHub Repository Setup**
```bash
# 1. Open GitHub repository
# https://github.com/zainulabidin776/mlops-assignment

# 2. Verify webhook is configured
# Go to: Settings → Webhooks
# URL: https://your-ngrok-url.ngrok-free.app/github-webhook/

# 3. Check all branches exist
git branch -a
```

### **Step 3: Test Data Preparation**
```bash
# 1. Prepare test patient data
cat > test_patient.json << EOF
{
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
}
EOF

# 2. Prepare invalid test data
cat > test_invalid.json << EOF
{
  "age": "invalid",
  "sex": 1
}
EOF
```

---

## 🎬 **Demo Script (30 minutes presentation)**

### **Part 1: Project Introduction (5 minutes)**

#### **1.1 Show Repository Structure**
```bash
# Open terminal and show project structure
tree -I '__pycache__|*.pyc|.git' mlops-assignment/

# Expected output:
mlops-assignment/
├── app/
│   ├── app.py
│   └── requirements.txt
├── model/
│   ├── model.pkl
│   └── metadata.json
├── tests/
│   └── test_app.py
├── .github/
│   └── workflows/
│       ├── lint.yml
│       ├── test.yml
│       ├── deploy.yml
│       └── notify.yml
├── Dockerfile
├── Jenkinsfile
└── README.md
```

#### **1.2 Explain Group Roles**
- **Zain Ul Abidin (22I-2738):** Primary Developer & DevOps Engineer
  - Responsible for: Jenkins setup, Docker configuration, GitHub Actions
- **Ahmed Javed (21I-1108):** Co-Developer & Testing Specialist
  - Responsible for: Unit testing, code quality, documentation

### **Part 2: Local Testing Demonstration (8 minutes)**

#### **2.1 Show ML Model**
```bash
# Navigate to project
cd mlops-assignment

# Show model files
ls -la model/
echo "Model size: $(du -h model/model.pkl)"
echo "Metadata: $(cat model/metadata.json | jq .)"
```

#### **2.2 Test Flask API Locally**
```bash
# Start Flask app
python app/app.py &

# Test health endpoint
curl http://localhost:5000/

# Test prediction endpoint
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d @test_patient.json

# Test error handling
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d @test_invalid.json

# Stop Flask app
pkill -f "python app/app.py"
```

**Expected Results:**
```bash
# Health endpoint:
Heart Disease Prediction API running

# Valid prediction:
{
  "prediction": 1,
  "probabilities": [0.2, 0.8]
}

# Invalid data:
{
  "error": "Missing required features"
}
```

#### **2.3 Run Unit Tests**
```bash
# Install dependencies
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r app/requirements.txt pytest

# Run tests
pytest tests/ -v

# Show test coverage
pytest tests/ --cov=app --cov-report=term-missing
```

**Expected Results:**
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

### **Part 3: Docker Containerization (5 minutes)**

#### **3.1 Build Docker Image**
```bash
# Build image
docker build -t heart-disease-api:demo .

# Show image details
docker images | grep heart-disease-api
docker inspect heart-disease-api:demo | jq '.[0].Config'
```

#### **3.2 Test Docker Container**
```bash
# Run container
docker run -d -p 5001:5000 --name demo-container heart-disease-api:demo

# Wait for startup
sleep 5

# Test API
curl http://localhost:5001/
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d @test_patient.json

# Show container logs
docker logs demo-container

# Cleanup
docker stop demo-container
docker rm demo-container
```

### **Part 4: GitHub Actions Workflows (7 minutes)**

#### **4.1 Show GitHub Actions**
```bash
# Open GitHub repository in browser
# https://github.com/zainulabidin776/mlops-assignment/actions

# Show workflow files
cat .github/workflows/lint.yml
cat .github/workflows/test.yml
cat .github/workflows/deploy.yml
```

#### **4.2 Demonstrate Branch Workflow**
```bash
# 1. Make change on dev branch
git checkout dev
echo "# Demo change: $(date)" >> app/app.py
git add app/app.py
git commit -m "Demo: Trigger linting workflow"
git push origin dev

# 2. Show GitHub Actions triggered
# Go to: https://github.com/zainulabidin776/mlops-assignment/actions
# Show linting workflow running

# 3. Create PR dev → test
# Go to: https://github.com/zainulabidin776/mlops-assignment/pulls
# Click "New pull request"
# Show unit testing workflow

# 4. Create PR test → main
# Show pre-deployment workflow
```

### **Part 5: Jenkins Pipeline (5 minutes)**

#### **5.1 Show Jenkins Dashboard**
```bash
# Open Jenkins in browser
# http://localhost:8080

# Show pipeline job
# Navigate to: mlops-heart-disease-deployment
# Show build history
# Show pipeline configuration
```

#### **5.2 Trigger Jenkins Build**
```bash
# Make a change and push to main
git checkout main
echo "# Jenkins demo: $(date)" >> app/app.py
git add app/app.py
git commit -m "Demo: Trigger Jenkins pipeline"
git push origin main

# Show Jenkins build triggered automatically
# Show pipeline stages executing
# Show Docker Hub push
# Show email notification
```

#### **5.3 Verify Docker Hub**
```bash
# Show Docker Hub repository
# https://hub.docker.com/r/itsmezayynn/heart-disease-api

# Pull and test latest image
docker pull itsmezayynn/heart-disease-api:latest
docker run -d -p 5002:5000 --name hub-test itsmezayynn/heart-disease-api:latest
curl http://localhost:5002/
docker stop hub-test
docker rm hub-test
```

---

## 📊 **Assignment Requirements Demonstration**

### **Requirement 1: Group of Two Members**
- ✅ **Zain Ul Abidin (22I-2738)** - Primary Developer & DevOps Engineer
- ✅ **Ahmed Javed (21I-1108)** - Co-Developer & Testing Specialist

### **Requirement 2: Admin Approval Process**
- ✅ **Show:** Pull request workflow with admin approval
- ✅ **Demonstrate:** Branch protection rules
- ✅ **Explain:** Admin role in code review process

### **Requirement 3: Code Quality Checks (Flake8)**
- ✅ **Show:** GitHub Actions linting workflow
- ✅ **Demonstrate:** Flake8 execution on dev branch
- ✅ **Explain:** Code quality enforcement

### **Requirement 4: Automated Testing**
- ✅ **Show:** Unit testing workflow on test branch
- ✅ **Demonstrate:** 10 comprehensive test cases
- ✅ **Explain:** Test coverage and validation

### **Requirement 5: Jenkins Integration**
- ✅ **Show:** Jenkins pipeline execution
- ✅ **Demonstrate:** Docker containerization
- ✅ **Explain:** Docker Hub push process

### **Requirement 6: Email Notifications**
- ✅ **Show:** Email notification system
- ✅ **Demonstrate:** Success/failure alerts
- ✅ **Explain:** Admin notification process

### **Requirement 7: Complete CI/CD Pipeline**
- ✅ **Show:** End-to-end workflow
- ✅ **Demonstrate:** Code to deployment automation
- ✅ **Explain:** Complete DevOps process

---

## 🎯 **Key Points to Emphasize**

### **Technical Excellence**
1. **Professional-grade implementation** with proper error handling
2. **Comprehensive testing** with 100% coverage of critical paths
3. **Production-ready deployment** with Docker containerization
4. **Automated quality assurance** with linting and testing

### **DevOps Best Practices**
1. **Branch protection** with admin approval workflow
2. **Automated testing** at multiple stages
3. **Code quality enforcement** with Flake8
4. **Continuous deployment** with Jenkins

### **Assignment Compliance**
1. **All 7 required tools** implemented and integrated
2. **Complete workflow** from development to production
3. **Admin approval process** properly implemented
4. **Email notifications** for all events

---

## 🚨 **Troubleshooting During Demo**

### **Common Issues & Quick Fixes**

#### **Issue 1: Jenkins Not Accessible**
```bash
# Quick fix
docker restart jenkins
# Wait 30 seconds, then refresh browser
```

#### **Issue 2: ngrok Connection Lost**
```bash
# Quick fix
# Restart ngrok and update GitHub webhook URL
ngrok http 8080
# Copy new URL to GitHub webhook settings
```

#### **Issue 3: Docker Build Fails**
```bash
# Quick fix
docker system prune -f
docker build --no-cache -t heart-disease-api:demo .
```

#### **Issue 4: GitHub Actions Not Triggering**
```bash
# Quick fix
# Check if workflows are in correct branch
git checkout main
git push origin main
```

---

## 📝 **Demo Checklist**

### **Pre-Demo (15 minutes before)**
- [ ] Jenkins running and accessible
- [ ] ngrok tunnel active
- [ ] GitHub webhook configured
- [ ] Test data prepared
- [ ] All services verified

### **During Demo (30 minutes)**
- [ ] Project structure shown
- [ ] Group roles explained
- [ ] Local API testing demonstrated
- [ ] Unit tests executed
- [ ] Docker containerization shown
- [ ] GitHub Actions workflows demonstrated
- [ ] Jenkins pipeline triggered
- [ ] Docker Hub integration shown
- [ ] Email notifications verified

### **Post-Demo (5 minutes)**
- [ ] Clean up test containers
- [ ] Answer questions
- [ ] Show documentation
- [ ] Provide contact information

---

## 🎉 **Success Metrics**

Your demo is successful if you can demonstrate:

1. ✅ **Complete CI/CD pipeline** from code to production
2. ✅ **All assignment requirements** met and functional
3. ✅ **Professional implementation** with proper error handling
4. ✅ **Automated testing** and quality assurance
5. ✅ **Docker containerization** and deployment
6. ✅ **Email notifications** working correctly
7. ✅ **Admin approval workflow** functioning
8. ✅ **All 7 required tools** integrated and working

---

## 📞 **Contact Information**

**For Questions or Issues:**
- **Zain Ul Abidin (22I-2738):** Primary contact for technical issues
- **Ahmed Javed (21I-1108):** Secondary contact for testing questions

**Repository:** https://github.com/zainulabidin776/mlops-assignment
**Docker Hub:** https://hub.docker.com/r/itsmezayynn/heart-disease-api

---

*This demo guide ensures a successful presentation of the MLOps Assignment by Zain Ul Abidin (22I-2738) and Ahmed Javed (21I-1108).*
