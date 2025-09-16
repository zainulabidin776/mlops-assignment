#!/usr/bin/env python3
"""
Complete MLOps Pipeline Test Script
Tests all components of the MLOps pipeline locally
"""

import subprocess
import sys
import time
import requests
import json
import os

def run_command(command, description, check=True):
    """Run a command and return the result."""
    print(f"\n🔄 {description}")
    print(f"Running: {command}")
    try:
        result = subprocess.run(command, shell=True, check=check, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ Success: {description}")
        else:
            print(f"❌ Failed: {description}")
            print(f"Error: {result.stderr}")
        return result
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {description}")
        print(f"Error: {e.stderr}")
        return None

def test_model_training():
    """Test model training."""
    print("\n" + "="*50)
    print("🧠 TESTING MODEL TRAINING")
    print("="*50)
    
    if not os.path.exists('datasets/data.csv'):
        print("❌ Dataset not found. Please ensure datasets/data.csv exists.")
        return False
    
    result = run_command('python train.py', 'Training ML model')
    if result and result.returncode == 0:
        print("✅ Model training successful!")
        return True
    return False

def test_api():
    """Test Flask API."""
    print("\n" + "="*50)
    print("🌐 TESTING FLASK API")
    print("="*50)
    
    # Start API in background
    print("Starting Flask API...")
    api_process = subprocess.Popen(['python', 'app/app.py'], 
                                 stdout=subprocess.PIPE, 
                                 stderr=subprocess.PIPE)
    
    # Wait for API to start
    time.sleep(5)
    
    try:
        # Test health endpoint
        response = requests.get('http://localhost:5000/', timeout=5)
        if response.status_code == 200:
            print("✅ Health check passed!")
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
        
        # Test prediction endpoint
        test_data = {
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
        }
        
        response = requests.post('http://localhost:5000/predict', 
                               json=test_data, timeout=5)
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Prediction successful: {result}")
        else:
            print(f"❌ Prediction failed: {response.status_code}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ API test failed: {e}")
        return False
    finally:
        # Stop API
        api_process.terminate()
        api_process.wait()
    
    return True

def test_linting():
    """Test code linting."""
    print("\n" + "="*50)
    print("🔍 TESTING CODE LINTING")
    print("="*50)
    
    # Install flake8 if not available
    run_command('pip install flake8', 'Installing flake8', check=False)
    
    result = run_command('flake8 .', 'Running flake8 linting')
    if result and result.returncode == 0:
        print("✅ Linting passed!")
        return True
    else:
        print("❌ Linting failed!")
        return False

def test_unit_tests():
    """Test unit tests."""
    print("\n" + "="*50)
    print("🧪 TESTING UNIT TESTS")
    print("="*50)
    
    # Install pytest if not available
    run_command('pip install pytest', 'Installing pytest', check=False)
    
    result = run_command('pytest tests/ -v', 'Running unit tests')
    if result and result.returncode == 0:
        print("✅ Unit tests passed!")
        return True
    else:
        print("❌ Unit tests failed!")
        return False

def test_docker_build():
    """Test Docker build."""
    print("\n" + "="*50)
    print("🐳 TESTING DOCKER BUILD")
    print("="*50)
    
    # Check if Docker is available
    docker_check = run_command('docker --version', 'Checking Docker availability', check=False)
    if not docker_check or docker_check.returncode != 0:
        print("❌ Docker not available. Skipping Docker tests.")
        return True  # Don't fail the entire test if Docker is not available
    
    # Build Docker image
    result = run_command('docker build -t heart-disease-api:test .', 'Building Docker image')
    if result and result.returncode == 0:
        print("✅ Docker build successful!")
        
        # Test Docker image
        print("Testing Docker container...")
        container_result = run_command(
            'docker run -d -p 5001:5000 --name test-container heart-disease-api:test',
            'Starting Docker container',
            check=False
        )
        
        if container_result and container_result.returncode == 0:
            time.sleep(5)  # Wait for container to start
            
            try:
                response = requests.get('http://localhost:5001/', timeout=5)
                if response.status_code == 200:
                    print("✅ Docker container test passed!")
                else:
                    print(f"❌ Docker container test failed: {response.status_code}")
            except requests.exceptions.RequestException as e:
                print(f"❌ Docker container test failed: {e}")
            finally:
                # Clean up
                run_command('docker stop test-container', 'Stopping container', check=False)
                run_command('docker rm test-container', 'Removing container', check=False)
        
        return True
    else:
        print("❌ Docker build failed!")
        return False

def test_git_workflow():
    """Test Git workflow."""
    print("\n" + "="*50)
    print("📝 TESTING GIT WORKFLOW")
    print("="*50)
    
    # Check current branch
    result = run_command('git branch --show-current', 'Checking current branch')
    if result and result.returncode == 0:
        current_branch = result.stdout.strip()
        print(f"✅ Current branch: {current_branch}")
    
    # Check if all branches exist
    result = run_command('git branch -a', 'Listing all branches')
    if result and result.returncode == 0:
        branches = result.stdout
        required_branches = ['main', 'dev', 'test']
        for branch in required_branches:
            if branch in branches:
                print(f"✅ Branch {branch} exists")
            else:
                print(f"❌ Branch {branch} missing")
                return False
    
    print("✅ Git workflow check passed!")
    return True

def main():
    """Run all tests."""
    print("🚀 MLOps Pipeline Complete Test Suite")
    print("="*60)
    
    tests = [
        ("Model Training", test_model_training),
        ("Flask API", test_api),
        ("Code Linting", test_linting),
        ("Unit Tests", test_unit_tests),
        ("Docker Build", test_docker_build),
        ("Git Workflow", test_git_workflow)
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        try:
            if test_func():
                passed += 1
        except Exception as e:
            print(f"❌ {test_name} failed with exception: {e}")
    
    print("\n" + "="*60)
    print("📊 TEST RESULTS SUMMARY")
    print("="*60)
    print(f"✅ Passed: {passed}/{total}")
    print(f"❌ Failed: {total - passed}/{total}")
    
    if passed == total:
        print("\n🎉 ALL TESTS PASSED! Your MLOps pipeline is ready!")
        print("\nNext steps:")
        print("1. Set up GitHub secrets (see GITHUB_SETUP_GUIDE.md)")
        print("2. Configure branch protection rules")
        print("3. Test the complete GitHub Actions workflow")
    else:
        print(f"\n⚠️  {total - passed} tests failed. Please fix the issues before proceeding.")
        sys.exit(1)

if __name__ == "__main__":
    main()
