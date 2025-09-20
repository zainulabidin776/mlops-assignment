# 🚀 MLOps Project Demo Restart Guide

**Project:** Heart Disease Prediction API with Complete CI/CD Pipeline  
**Group Members:** Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)  
**Assignment:** Machine Learning Operations Assignment 1

---

## 📋 **Quick Demo Sequence (15-20 minutes)**

### **Phase 1: Environment Setup (5 minutes)**

#### **1.1 Start Jenkins Server**
```bash
# Start Jenkins in Docker
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins jenkins/jenkins:lts

# Get initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Access Jenkins at: http://localhost:8080
```

#### **1.2 Start ngrok Tunnel (for webhook)**
```bash
# Install ngrok if not installed
# Download from: https://ngrok.com/download

# Start tunnel
ngrok http 8080

# Copy the HTTPS URL (e.g., https://abc123.ngrok-free.app)
# This will be your webhook URL
```

#### **1.3 Verify Docker Hub Access**
```bash
# Login to Docker Hub
docker login

# Verify you can push images
docker images
```

---

### **Phase 2: GitHub Repository Setup (3 minutes)**

#### **2.1 Check Repository Status**
- Go to: `https://github.com/zainulabidin776/mlops-assignment`
- Verify all branches exist: `dev`, `test`, `main`
- Check that all workflows are present in `.github/workflows/`

#### **2.2 Verify GitHub Secrets**
Go to: Settings → Secrets and variables → Actions
Ensure these secrets are set:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `EMAIL_USERNAME`
- `EMAIL_PASSWORD`
- `ADMIN_EMAIL`

#### **2.3 Check Branch Protection Rules**
Go to: Settings → Branches
- **main branch**: Requires PR + admin approval
- **test branch**: Requires PR + status checks
- **dev branch**: Direct push allowed

---

### **Phase 3: Jenkins Configuration (5 minutes)**

#### **3.1 Access Jenkins**
- URL: `http://localhost:8080`
- Login with admin password from Phase 1.1

#### **3.2 Install Required Plugins**
Go to: Manage Jenkins → Manage Plugins → Available
Install these plugins:
- Git
- Docker Pipeline
- Email Extension
- GitHub Integration
- Credentials Binding
- GitHub Webhook

#### **3.3 Configure Credentials**
Go to: Manage Jenkins → Manage Credentials → Global
Add these credentials:

**GitHub Credentials:**
- Kind: Username with password
- ID: `github-credentials`
- Username: Your GitHub username
- Password: Your GitHub personal access token

**Docker Hub Credentials:**
- Kind: Username with password
- ID: `dockerhub-credentials`
- Username: Your Docker Hub username
- Password: Your Docker Hub access token

#### **3.4 Create Jenkins Job**
1. New Item → Pipeline
2. Name: `heart-disease-api-pipeline`
3. Pipeline → Definition: Pipeline script from SCM
4. SCM: Git
5. Repository URL: `https://github.com/zainulabidin776/mlops-assignment.git`
6. Branch: `*/main`
7. Script Path: `Jenkinsfile`

#### **3.5 Configure GitHub Webhook**
1. Go to your GitHub repository
2. Settings → Webhooks → Add webhook
3. Payload URL: `https://your-ngrok-url.ngrok-free.app/github-webhook/`
4. Content type: `application/json`
5. Events: Just the push event
6. Active: ✅

---

### **Phase 4: Demo Execution (7-10 minutes)**

#### **4.1 Test Local API (2 minutes)**
```bash
# Navigate to project directory
cd C:\Users\zainy\Downloads\MLOPs-Assignment\A01-MLOPS

# Test the API locally
python test_app_windows.py

# Expected: 100% test success rate
```

#### **4.2 Demonstrate GitHub Actions (3 minutes)**

**Step 1: Test Linting Workflow**
```bash
# Make a small change to any file
echo "# Demo change" >> README.md
git add .
git commit -m "Demo: Test linting workflow"
git push origin dev

# Go to GitHub → Actions tab
# Show: Linting workflow runs and passes
```

**Step 2: Test Unit Testing Workflow**
```bash
# Create PR from dev to test
# Go to GitHub → Create Pull Request
# dev → test branch
# Show: Unit testing workflow runs and passes
# Merge the PR
```

**Step 3: Test Deployment Workflow**
```bash
# Create PR from test to main
# Go to GitHub → Create Pull Request
# test → main branch
# Show: Pre-deployment validation runs
# Approve and merge the PR
```

#### **4.3 Demonstrate Jenkins Pipeline (3 minutes)**

**Step 1: Trigger Jenkins Build**
```bash
# Make a change and push to main
echo "# Jenkins trigger" >> README.md
git add .
git commit -m "Demo: Trigger Jenkins pipeline"
git push origin main

# Show: Jenkins automatically starts building
```

**Step 2: Monitor Jenkins Pipeline**
- Go to Jenkins: `http://localhost:8080`
- Click on `heart-disease-api-pipeline`
- Show each stage:
  - ✅ Checkout
  - ✅ Install Dependencies
  - ✅ Run Tests
  - ✅ Build Docker Image
  - ✅ Push to Docker Hub
  - ✅ Test Docker Image

**Step 3: Verify Docker Hub Push**
- Go to Docker Hub: `https://hub.docker.com`
- Show: New image pushed with latest tag
- Show: Image is publicly available

#### **4.4 Test Deployed API (2 minutes)**
```bash
# Pull and run the deployed image
docker pull itsmezayynn/heart-disease-api:latest
docker run -d -p 5001:5000 --name demo-container itsmezayynn/heart-disease-api:latest

# Test the API
curl http://localhost:5001/
curl -X POST http://localhost:5001/predict -H "Content-Type: application/json" -d '{"Age": 65, "Sex": "M", "ChestPainType": "ATA", "RestingBP": 145, "Cholesterol": 233, "FastingBS": 0, "RestingECG": "Normal", "MaxHR": 150, "ExerciseAngina": "N", "Oldpeak": 2.3, "ST_Slope": "Up"}'

# Clean up
docker stop demo-container
docker rm demo-container
```

---

## 🎯 **Demo Talking Points**

### **1. Project Overview (2 minutes)**
- "This is a complete MLOps pipeline for a Heart Disease Prediction API"
- "We used 7 required tools: Jenkins, GitHub, GitHub Actions, Git, Docker, Python, Flask"
- "The system demonstrates professional DevOps practices with automated testing and deployment"

### **2. Technical Architecture (3 minutes)**
- "We have a 3-branch workflow: dev → test → main"
- "Each branch has specific protection rules and automated workflows"
- "The model uses RandomForest for binary classification with 11 features"
- "Everything is containerized with Docker and deployed to Docker Hub"

### **3. CI/CD Pipeline Flow (5 minutes)**
- "When code is pushed to dev, it triggers linting with Flake8"
- "When PR is made to test, it runs comprehensive unit tests"
- "When PR is made to main, it triggers Jenkins for Docker build and deployment"
- "All stages include email notifications for success/failure"

### **4. Quality Assurance (2 minutes)**
- "We have 10 comprehensive unit tests with 100% coverage"
- "Code quality is enforced with Flake8 linting"
- "All tests must pass before code can be merged"
- "Docker images are tested before being pushed to registry"

---

## 🔧 **Troubleshooting Common Issues**

### **Issue 1: Jenkins Won't Start**
```bash
# Check if port 8080 is in use
netstat -ano | findstr :8080

# Kill process using port 8080
taskkill /PID <PID> /F

# Restart Jenkins
docker restart jenkins
```

### **Issue 2: ngrok Tunnel Issues**
```bash
# Check ngrok status
ngrok status

# Restart ngrok with different port
ngrok http 8080 --log=stdout
```

### **Issue 3: Docker Hub Push Fails**
```bash
# Re-login to Docker Hub
docker logout
docker login

# Check credentials in Jenkins
# Go to: Manage Jenkins → Manage Credentials
```

### **Issue 4: GitHub Actions Fail**
- Check GitHub Secrets are set correctly
- Verify branch protection rules
- Check workflow files in `.github/workflows/`

### **Issue 5: API Tests Fail**
```bash
# Check if Flask app is running
curl http://localhost:5000/

# Check model files exist
ls model/
# Should show: model.pkl, metadata.json
```

---

## 📊 **Demo Checklist**

### **Pre-Demo Setup**
- [ ] Jenkins running on localhost:8080
- [ ] ngrok tunnel active
- [ ] Docker Hub logged in
- [ ] GitHub repository accessible
- [ ] All credentials configured
- [ ] Test data prepared

### **During Demo**
- [ ] Show local API testing (100% success)
- [ ] Demonstrate GitHub Actions workflows
- [ ] Show Jenkins pipeline execution
- [ ] Verify Docker Hub image push
- [ ] Test deployed API endpoint
- [ ] Show email notifications

### **Post-Demo Cleanup**
- [ ] Stop Jenkins container
- [ ] Stop ngrok tunnel
- [ ] Clean up test containers
- [ ] Reset any demo changes

---

## 🎉 **Success Metrics**

### **Expected Results**
- ✅ **Local API Tests**: 100% success rate (11/11 tests pass)
- ✅ **GitHub Actions**: All workflows pass
- ✅ **Jenkins Pipeline**: All 6 stages complete successfully
- ✅ **Docker Hub**: Image pushed with latest tag
- ✅ **Deployed API**: Returns valid predictions
- ✅ **Email Notifications**: Success emails received

### **Demo Duration**
- **Total Time**: 15-20 minutes
- **Setup Time**: 5 minutes
- **Demo Time**: 10-15 minutes
- **Cleanup Time**: 2-3 minutes

---

## 📞 **Support Contacts**

- **Primary Developer**: Zain Ul Abidin (22I-2738)
- **Co-Developer**: Ahmed Javed (21I-1108)
- **Repository**: https://github.com/zainulabidin776/mlops-assignment
- **Docker Hub**: itsmezayynn/heart-disease-api

---

*This guide ensures a smooth and professional demo of the complete MLOps pipeline. Follow the sequence step-by-step for best results.*
