# 🚀 Complete Jenkins Setup Guide for MLOps Pipeline

## 📋 **Table of Contents**
1. [Prerequisites](#prerequisites)
2. [Jenkins Installation](#jenkins-installation)
3. [Required Plugins](#required-plugins)
4. [System Configuration](#system-configuration)
5. [Docker Setup](#docker-setup)
6. [Python Setup](#python-setup)
7. [GitHub Integration](#github-integration)
8. [Pipeline Configuration](#pipeline-configuration)
9. [Testing the Pipeline](#testing-the-pipeline)
10. [Troubleshooting](#troubleshooting)

---

## 🔧 **Prerequisites**

### **System Requirements**
- **OS**: Ubuntu 20.04+ / CentOS 7+ / Windows 10+
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: 10GB free space
- **Java**: OpenJDK 11 or 17
- **Docker**: Latest version
- **Git**: Latest version

### **Required Accounts**
- GitHub account with repository access
- Docker Hub account
- Email account for notifications

---

## 🛠️ **Jenkins Installation**

### **Method 1: Docker Installation (Recommended)**

```bash
# Create Jenkins directory
mkdir -p ~/jenkins-data
cd ~/jenkins-data

# Run Jenkins in Docker
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  jenkins/jenkins:lts

# Check if Jenkins is running
docker ps
```

### **Method 2: Direct Installation (Ubuntu)**

```bash
# Update system
sudo apt update

# Install Java
sudo apt install openjdk-11-jdk -y

# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check status
sudo systemctl status jenkins
```

### **Method 3: Direct Installation (CentOS/RHEL)**

```bash
# Install Java
sudo yum install java-11-openjdk-devel -y

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Install Jenkins
sudo yum install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

---

## 🔌 **Required Plugins**

### **Access Jenkins**
1. Open browser: `http://localhost:8080` (or your server IP)
2. Get initial admin password:
   ```bash
   # For Docker installation
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   
   # For direct installation
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

### **Install Essential Plugins**
Go to: **Manage Jenkins** → **Manage Plugins** → **Available**

Install these plugins:
- ✅ **Git** (for Git integration)
- ✅ **Docker Pipeline** (for Docker support)
- ✅ **Docker** (for Docker integration)
- ✅ **Email Extension** (for email notifications)
- ✅ **GitHub** (for GitHub integration)
- ✅ **Pipeline** (for pipeline support)
- ✅ **Credentials Binding** (for secure credentials)
- ✅ **Workspace Cleanup** (for cleanup)

### **Restart Jenkins**
After installing plugins, restart Jenkins:
```bash
# For Docker
docker restart jenkins

# For direct installation
sudo systemctl restart jenkins
```

---

## ⚙️ **System Configuration**

### **1. Configure Global Tools**

Go to: **Manage Jenkins** → **Global Tool Configuration**

#### **Git Configuration**
- **Name**: `Default`
- **Path to Git executable**: `/usr/bin/git` (or auto-detect)

#### **Docker Configuration**
- **Name**: `Docker`
- **Installation root**: `/usr/bin/docker`

### **2. Configure System**

Go to: **Manage Jenkins** → **Configure System**

#### **Email Configuration**
- **SMTP server**: `smtp.gmail.com`
- **SMTP port**: `587`
- **Use SMTP Authentication**: ✅
- **Username**: `your-email@gmail.com`
- **Password**: `your-app-password`
- **Use SSL**: ✅

---

## 🐳 **Docker Setup**

### **Install Docker (if not already installed)**

```bash
# Update system
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Test Docker
docker --version
docker run hello-world
```

### **Configure Docker for Jenkins**

```bash
# Add Jenkins user to docker group
sudo usermod -aG docker jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Test Docker from Jenkins
sudo -u jenkins docker --version
```

---

## 🐍 **Python Setup**

### **Install Python on Jenkins Server**

```bash
# Update system
sudo apt update

# Install Python3 and pip
sudo apt install python3 python3-pip python3-venv -y

# Verify installation
python3 --version
pip3 --version

# Create symlink for 'python' command (optional)
sudo ln -s /usr/bin/python3 /usr/bin/python
```

### **Install Required Python Packages**

```bash
# Install packages globally (optional)
pip3 install --upgrade pip
pip3 install pytest flask scikit-learn pandas numpy
```

---

## 🔗 **GitHub Integration**

### **1. Create GitHub Personal Access Token**

1. Go to GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Select scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `write:packages` (Write packages to GitHub Package Registry)
4. Copy the token (save it securely)

### **2. Configure GitHub Credentials in Jenkins**

1. Go to: **Manage Jenkins** → **Manage Credentials** → **System** → **Global credentials**
2. Click **Add Credentials**
3. Fill in:
   - **Kind**: `Username with password`
   - **Username**: `your-github-username`
   - **Password**: `your-github-token`
   - **ID**: `github-credentials`
   - **Description**: `GitHub Personal Access Token`

### **3. Configure Docker Hub Credentials**

1. Go to: **Manage Jenkins** → **Manage Credentials** → **System** → **Global credentials**
2. Click **Add Credentials**
3. Fill in:
   - **Kind**: `Username with password`
   - **Username**: `your-dockerhub-username`
   - **Password**: `your-dockerhub-token`
   - **ID**: `dockerhub-credentials`
   - **Description**: `Docker Hub Credentials`

---

## 🚀 **Pipeline Configuration**

### **1. Create New Pipeline Job**

1. Go to Jenkins dashboard
2. Click **New Item**
3. Enter name: `mlops-heart-disease-deployment`
4. Select **Pipeline**
5. Click **OK**

### **2. Configure Pipeline**

#### **General Settings**
- ✅ **GitHub project**: `https://github.com/your-username/mlops-assignment`
- ✅ **Discard old builds**: Keep 10 builds

#### **Pipeline Configuration**
- **Definition**: `Pipeline script from SCM`
- **SCM**: `Git`
- **Repository URL**: `https://github.com/your-username/mlops-assignment.git`
- **Credentials**: Select your GitHub credentials
- **Branch Specifier**: `*/main`
- **Script Path**: `Jenkinsfile`

#### **Build Triggers**
- ✅ **GitHub hook trigger for GITScm polling**
- ✅ **Poll SCM**: `H/5 * * * *` (every 5 minutes)

### **3. Configure Webhooks (Optional)**

1. Go to your GitHub repository
2. **Settings** → **Webhooks** → **Add webhook**
3. **Payload URL**: `http://your-jenkins-server:8080/github-webhook/`
4. **Content type**: `application/json`
5. **Events**: Select **Just the push event**
6. Click **Add webhook**

---

## 🧪 **Testing the Pipeline**

### **1. Manual Test Run**

1. Go to your pipeline job
2. Click **Build Now**
3. Monitor the build progress
4. Check console output for any errors

### **2. Expected Build Stages**

Your pipeline should run these stages:
1. ✅ **Checkout** - Clone repository
2. ✅ **Install Dependencies** - Install Python packages
3. ✅ **Run Tests** - Execute unit tests
4. ✅ **Build Docker Image** - Build Docker image
5. ✅ **Push to Docker Hub** - Push image to registry
6. ✅ **Test Docker Image** - Test the built image

### **3. Verify Results**

- **Docker Hub**: Check if image was pushed
- **Email**: Check for success/failure notifications
- **Logs**: Review build logs for any issues

---

## 🔧 **Troubleshooting**

### **Common Issues & Solutions**

#### **Issue 1: "python: not found"**
```bash
# Solution: Install Python
sudo apt update
sudo apt install python3 python3-pip -y
sudo ln -s /usr/bin/python3 /usr/bin/python
```

#### **Issue 2: "docker: not found"**
```bash
# Solution: Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

#### **Issue 3: "sudo: not found"**
```bash
# Solution: Install sudo
apt update
apt install sudo -y
```

#### **Issue 4: Permission Denied for Docker**
```bash
# Solution: Fix Docker permissions
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart jenkins
```

#### **Issue 5: Email Notifications Not Working**
- Check SMTP settings in Jenkins configuration
- Verify Gmail app password (not regular password)
- Test email configuration

#### **Issue 6: GitHub Authentication Failed**
- Verify GitHub personal access token
- Check repository permissions
- Ensure credentials are correctly configured

### **Debug Commands**

```bash
# Check Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Check Docker status
docker ps
docker images

# Check Python installation
python3 --version
pip3 --version

# Check Git configuration
git --version
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

---

## 📊 **Pipeline Monitoring**

### **Build Status Indicators**
- 🔵 **Blue**: Success
- 🔴 **Red**: Failed
- 🟡 **Yellow**: Unstable
- ⚪ **Gray**: Not built

### **Useful Jenkins URLs**
- **Dashboard**: `http://your-jenkins-server:8080/`
- **Job Status**: `http://your-jenkins-server:8080/job/mlops-heart-disease-deployment/`
- **Build Logs**: `http://your-jenkins-server:8080/job/mlops-heart-disease-deployment/lastBuild/console`

---

## 🎯 **Best Practices**

### **Security**
- Use strong passwords and tokens
- Regularly update Jenkins and plugins
- Limit user permissions
- Use HTTPS in production

### **Performance**
- Allocate sufficient memory (8GB+)
- Use SSD storage for better performance
- Clean up old builds regularly
- Monitor disk space

### **Maintenance**
- Backup Jenkins configuration
- Keep plugins updated
- Monitor build logs
- Test pipeline changes in development first

---

## 🆘 **Getting Help**

### **Jenkins Documentation**
- [Official Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)

### **Community Support**
- [Jenkins Community Forum](https://community.jenkins.io/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/jenkins)

### **Your Project Files**
- **Jenkinsfile**: Pipeline configuration
- **Dockerfile**: Container configuration
- **Requirements**: Python dependencies
- **Tests**: Unit test suite

---

## ✅ **Quick Setup Checklist**

- [ ] Jenkins installed and running
- [ ] Required plugins installed
- [ ] Docker installed and configured
- [ ] Python installed
- [ ] GitHub credentials configured
- [ ] Docker Hub credentials configured
- [ ] Pipeline job created
- [ ] First build successful
- [ ] Email notifications working
- [ ] Docker image pushed to registry

**🎉 Congratulations! Your Jenkins MLOps pipeline is now ready!**
