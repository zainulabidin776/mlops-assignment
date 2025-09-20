# ⚡ Quick Demo Commands Reference

**For immediate demo restart - copy and paste these commands**

---

## 🚀 **1. Start Everything (2 minutes)**

```bash
# Start Jenkins
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins jenkins/jenkins:lts

# Get Jenkins password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Start ngrok (in separate terminal)
ngrok http 8080

# Login to Docker Hub
docker login
```

**Access Points:**
- Jenkins: http://localhost:8080
- ngrok URL: Copy from ngrok terminal

---

## 🧪 **2. Test API Locally (1 minute)**

```bash
# Navigate to project
cd C:\Users\zainy\Downloads\MLOPs-Assignment\A01-MLOPS

# Run comprehensive tests
python test_app_windows.py

# Expected: 100% success rate
```

---

## 🔄 **3. Trigger Complete Pipeline (3 minutes)**

```bash
# Test GitHub Actions - Linting
echo "# Demo change" >> README.md
git add .
git commit -m "Demo: Test workflows"
git push origin dev

# Test GitHub Actions - Unit Testing
# Go to GitHub → Create PR: dev → test
# Merge the PR

# Test Jenkins Pipeline
echo "# Jenkins trigger" >> README.md
git add .
git commit -m "Demo: Trigger Jenkins"
git push origin main

# Watch Jenkins build automatically start
```

---

## 🐳 **4. Test Deployed API (1 minute)**

```bash
# Pull and test deployed image
docker pull itsmezayynn/heart-disease-api:latest
docker run -d -p 5001:5000 --name demo itsmezayynn/heart-disease-api:latest

# Test API
curl http://localhost:5001/
curl -X POST http://localhost:5001/predict -H "Content-Type: application/json" -d '{"Age": 65, "Sex": "M", "ChestPainType": "ATA", "RestingBP": 145, "Cholesterol": 233, "FastingBS": 0, "RestingECG": "Normal", "MaxHR": 150, "ExerciseAngina": "N", "Oldpeak": 2.3, "ST_Slope": "Up"}'

# Clean up
docker stop demo && docker rm demo
```

---

## 🧹 **5. Cleanup After Demo**

```bash
# Stop Jenkins
docker stop jenkins
docker rm jenkins

# Stop ngrok (Ctrl+C in ngrok terminal)

# Clean up any test containers
docker system prune -f
```

---

## 📊 **Expected Results**

- ✅ **Local Tests**: 11/11 passed (100%)
- ✅ **GitHub Actions**: All workflows green
- ✅ **Jenkins Pipeline**: All 6 stages completed
- ✅ **Docker Hub**: Image pushed successfully
- ✅ **API Response**: Valid prediction returned

---

## 🆘 **Quick Fixes**

**Jenkins won't start:**
```bash
docker ps -a | grep jenkins
docker rm jenkins
# Then restart with command from step 1
```

**API tests fail:**
```bash
# Check if model files exist
ls model/
# Should show: model.pkl, metadata.json
```

**Docker push fails:**
```bash
docker logout
docker login
# Re-enter credentials
```

---

**Total Demo Time: 7-10 minutes** ⏱️
