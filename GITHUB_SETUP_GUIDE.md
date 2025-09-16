# Complete GitHub Setup Guide for MLOps Assignment

## 🚀 Step-by-Step Setup Instructions

### 1. **Set Up GitHub Secrets**

Go to your repository → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token (not password)
- `SLACK_WEBHOOK`: (Optional) Slack webhook URL for notifications

### 2. **Set Up Branch Protection Rules**

#### For `main` branch:
1. Go to Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Enable these settings:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (1 reviewer)
   - ✅ Dismiss stale PR approvals when new commits are pushed
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Restrict pushes that create files larger than 100MB

#### For `test` branch:
1. Go to Settings → Branches → Add rule
2. Branch name pattern: `test`
3. Enable these settings:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging

### 3. **Required Status Checks**

#### For `main` branch:
- ✅ Deploy to Production (Docker Hub) must pass
- ✅ All CI checks must pass

#### For `test` branch:
- ✅ Unit Testing must pass

### 4. **Admin Setup**

1. Go to Settings → Manage access
2. Add your group member as a collaborator
3. Give them "Write" access
4. You (as admin) should have "Admin" access

### 5. **Test the Complete Workflow**

#### Step 1: Test Linting (dev branch)
```bash
# Make a small change to any file
echo "# Test change" >> README.md
git add .
git commit -m "Test linting workflow"
git push origin dev
```
**Expected**: Linting workflow should run and pass

#### Step 2: Test Unit Testing (test branch)
```bash
# Create PR from dev to test
# Go to GitHub → Create Pull Request
# dev → test
```
**Expected**: Unit testing workflow should run and pass

#### Step 3: Test Deployment (main branch)
```bash
# Create PR from test to main
# Go to GitHub → Create Pull Request
# test → main
# Approve and merge
```
**Expected**: Docker deployment workflow should run and push to Docker Hub

### 6. **Verify Docker Hub Push**

After successful deployment, check your Docker Hub repository:
- Image should be pushed with tag `latest` and commit SHA
- Image should be publicly available

### 7. **Test the Deployed API**

```bash
# Pull and run the deployed image
docker pull yourusername/heart-disease-api:latest
docker run -p 5000:5000 yourusername/heart-disease-api:latest

# Test the API
curl http://localhost:5000/
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "Age": 40,
    "Sex": "M",
    "ChestPainType": "ATA",
    "RestingBP": 140,
    "Cholesterol": 289,
    "FastingBS": 0,
    "RestingECG": "Normal",
    "MaxHR": 172,
    "ExerciseAngina": "N",
    "Oldpeak": 0,
    "ST_Slope": "Up"
  }'
```

## 🎯 **Assignment Requirements Checklist**

- ✅ **Model & Dataset**: RandomForest model + Heart disease dataset
- ✅ **Required Tools**: Jenkins (replaced with GitHub Actions), GitHub, GitHub Actions, Git, Docker, Python, Flask
- ✅ **Admin Approval**: Branch protection rules configured
- ✅ **Code Quality**: Flake8 linting on dev branch
- ✅ **Unit Testing**: Automated tests on test branch
- ✅ **Docker Containerization**: GitHub Actions builds and pushes to Docker Hub
- ✅ **Email Notifications**: GitHub Actions notifications (can add email later)
- ✅ **Proper Workflow**: dev → test → main flow with PRs

## 🔧 **Troubleshooting**

### If workflows fail:
1. Check the Actions tab in your repository
2. Click on the failed workflow
3. Check the logs for specific errors
4. Common issues:
   - Missing secrets
   - Docker Hub authentication
   - Python dependency issues

### If Docker push fails:
1. Verify Docker Hub credentials
2. Check if the repository exists on Docker Hub
3. Ensure the access token has proper permissions

## 📞 **Support**

If you encounter any issues:
1. Check the GitHub Actions logs
2. Verify all secrets are set correctly
3. Ensure branch protection rules are configured
4. Test each workflow step individually
