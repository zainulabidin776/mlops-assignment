# 🚀 Quick Start Guide - MLOps Assignment

**Group Members:**
- **Zain Ul Abidin** (22I-2738) - Primary Developer & DevOps Engineer
- **Ahmed Javed** (21I-1108) - Co-Developer & Testing Specialist

**Project:** Heart Disease Prediction API with Complete CI/CD Pipeline

---

## ⚡ **Quick Start (5 minutes)**

### **Step 1: Clone Repository**
```bash
git clone https://github.com/zainulabidin776/mlops-assignment.git
cd mlops-assignment
```

### **Step 2: Run Complete Test**
```bash
# Make script executable
chmod +x test_complete_system.sh

# Run all tests
./test_complete_system.sh
```

### **Step 3: Start Local API**
```bash
# Install dependencies
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r app/requirements.txt

# Start API
python app/app.py
```

### **Step 4: Test API**
```bash
# In another terminal
curl http://localhost:5000/
Invoke-RestMethod -Uri "http://localhost:5000/predict" -Method POST -ContentType "application/json" -Body (@{
    Age = 65
    Sex = "M"
    ChestPainType = "Asymptomatic"
    RestingBP = 145
    Cholesterol = 233
    FastingBS = 1
    RestingECG = "Normal"
    MaxHR = 150
    ExerciseAngina = "N"
    Oldpeak = 2.3
    ST_Slope = "Flat"
} | ConvertTo-Json)

```

---

## 🐳 **Docker Quick Start (3 minutes)**

### **Build and Run with Docker**
```bash
# Build image
docker build -t heart-disease-api .

# Run container
docker run -d -p 5001:5000 --name heart-api heart-disease-api

# Test API
curl http://localhost:5001/

# Stop container
docker stop heart-api
docker rm heart-api
```

---

## 🔧 **Jenkins Setup (10 minutes)**

### **Start Jenkins**
```bash
# Run Jenkins in Docker
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Get initial password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### **Configure Jenkins**
1. Open http://localhost:8080
2. Enter initial password
3. Install suggested plugins
4. Create admin user
5. Create new pipeline job:
   - Name: `mlops-heart-disease-deployment`
   - Type: Pipeline
   - Pipeline script from SCM: Git
   - Repository: `https://github.com/zainulabidin776/mlops-assignment.git`
   - Script path: `Jenkinsfile`

---

## ⚡ **GitHub Actions (Automatic)**

### **Workflows Already Configured**
- **Lint:** Triggers on push to `dev` branch
- **Test:** Triggers on PR to `test` branch  
- **Deploy:** Triggers on push to `main` branch

### **Test Workflows**
```bash
# Trigger linting
git checkout dev
echo "# Test" >> app/app.py
git add app/app.py
git commit -m "Test linting"
git push origin dev

# Check GitHub Actions
# Go to: https://github.com/zainulabidin776/mlops-assignment/actions
```

---

## 📧 **Email Notifications Setup**

### **GitHub Secrets Required**
Add these secrets in GitHub repository settings:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Your Docker Hub access token
- `EMAIL_USERNAME` - Gmail address
- `EMAIL_PASSWORD` - Gmail app password
- `ADMIN_EMAIL` - Admin notification email

### **Jenkins Credentials Required**
Add these credentials in Jenkins:
- `dockerhub-credentials` - Docker Hub username/password
- Email configuration in Jenkins settings

---

## 🎯 **Demo Preparation (15 minutes)**

### **Pre-Demo Checklist**
- [ ] Jenkins running on http://localhost:8080
- [ ] ngrok tunnel active for webhook
- [ ] GitHub webhook configured
- [ ] Test data prepared
- [ ] All services verified

### **Run Demo Test**
```bash
# Run complete system test
./test_complete_system.sh

# Expected: 90%+ success rate
```

---

## 📚 **Documentation Files**

- **`README.md`** - Project overview and setup
- **`IMPLEMENTATION_DOCUMENTATION.md`** - Complete implementation details
- **`REQUIREMENTS_COMPLIANCE_CHECKLIST.md`** - Assignment requirements verification
- **`DEMO_GUIDE.md`** - Step-by-step demo instructions
- **`TESTING_GUIDE.md`** - Comprehensive testing guide
- **`JENKINS_SETUP_GUIDE.md`** - Jenkins installation and configuration
- **`GITHUB_SETUP_GUIDE.md`** - GitHub repository setup

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Python Not Found**
```bash
# Install Python 3.10+
sudo apt-get update
sudo apt-get install python3 python3-pip python3-venv
```

#### **Docker Not Found**
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
```

#### **Jenkins Not Accessible**
```bash
# Restart Jenkins
docker restart jenkins
# Wait 30 seconds, then refresh browser
```

#### **API Not Responding**
```bash
# Check if port is in use
lsof -i :5000
# Kill process if needed
kill -9 <PID>
```

---

## ✅ **Success Indicators**

Your setup is working if:

1. ✅ **API responds** to health check
2. ✅ **Unit tests pass** (10/10)
3. ✅ **Docker container runs** successfully
4. ✅ **GitHub Actions trigger** on branch pushes
5. ✅ **Jenkins pipeline executes** without errors
6. ✅ **Email notifications** are received

---

## 🎉 **Ready for Demo!**

Once all tests pass, you're ready to:

1. **Present the project** using `DEMO_GUIDE.md`
2. **Show all features** working correctly
3. **Demonstrate compliance** with assignment requirements
4. **Answer questions** about the implementation

---

## 📞 **Support**

**For Technical Issues:**
- **Zain Ul Abidin (22I-2738):** Primary contact
- **Ahmed Javed (21I-1108):** Secondary contact

**Repository:** https://github.com/zainulabidin776/mlops-assignment
**Docker Hub:** https://hub.docker.com/r/itsmezayynn/heart-disease-api

---

*This quick start guide gets you up and running with the MLOps Assignment in minutes!*
