#!/usr/bin/env python3
"""
Quick Demo Test Script for MLOps Assignment
This script helps you test all components before the demo
"""

import subprocess
import sys
import time
import requests
import json
import os

def run_command(command, description):
    """Run a command and return the result."""
    print(f"\n🔄 {description}")
    print(f"Running: {command}")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ Success: {description}")
        return result
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed: {description}")
        print(f"Error: {e.stderr}")
        return None

def test_project_structure():
    """Test that all required files exist."""
    print("\n" + "="*60)
    print("📁 TESTING PROJECT STRUCTURE")
    print("="*60)
    
    required_files = [
        "app/app.py",
        "app/requirements.txt", 
        "tests/test_app.py",
        "Dockerfile",
        "Jenkinsfile",
        ".github/workflows/lint.yml",
        ".github/workflows/test.yml", 
        ".github/workflows/deploy.yml",
        ".github/workflows/notify.yml",
        "datasets/data.csv",
        "model/model.pkl",
        "model/metadata.json"
    ]
    
    missing_files = []
    for file_path in required_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} - MISSING")
            missing_files.append(file_path)
    
    if missing_files:
        print(f"\n❌ Missing {len(missing_files)} required files!")
        return False
    else:
        print(f"\n✅ All {len(required_files)} required files present!")
        return True

def test_git_branches():
    """Test that all required branches exist."""
    print("\n" + "="*60)
    print("🌿 TESTING GIT BRANCHES")
    print("="*60)
    
    result = run_command('git branch -a', 'Checking all branches')
    if not result:
        return False
    
    branches = result.stdout
    required_branches = ['dev', 'test', 'main']
    
    for branch in required_branches:
        if branch in branches:
            print(f"✅ Branch '{branch}' exists")
        else:
            print(f"❌ Branch '{branch}' missing")
            return False
    
    print("\n✅ All required branches present!")
    return True

def test_imports():
    """Test that all imports work."""
    print("\n" + "="*60)
    print("📦 TESTING IMPORTS")
    print("="*60)
    
    try:
        from app.app import app, feature_names
        print("✅ App imports successful")
        print(f"✅ Feature names loaded: {len(feature_names)} features")
        return True
    except Exception as e:
        print(f"❌ Import failed: {e}")
        return False

def test_api():
    """Test the Flask API."""
    print("\n" + "="*60)
    print("🌐 TESTING FLASK API")
    print("="*60)
    
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
        from app.app import feature_names
        test_data = {name: 1 for name in feature_names}
        test_data["Sex"] = "M"
        test_data["ChestPainType"] = "ATA"
        test_data["RestingECG"] = "Normal"
        test_data["ExerciseAngina"] = "N"
        test_data["ST_Slope"] = "Up"
        
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

def test_unit_tests():
    """Test unit tests."""
    print("\n" + "="*60)
    print("🧪 TESTING UNIT TESTS")
    print("="*60)
    
    result = run_command('pytest tests/ -v', 'Running unit tests')
    if result and result.returncode == 0:
        print("✅ Unit tests passed!")
        return True
    else:
        print("❌ Unit tests failed!")
        return False

def test_linting():
    """Test code linting."""
    print("\n" + "="*60)
    print("🔍 TESTING CODE LINTING")
    print("="*60)
    
    result = run_command('flake8 app/ tests/ --exclude=venv', 'Running flake8 linting')
    if result and result.returncode == 0:
        print("✅ Linting passed!")
        return True
    else:
        print("❌ Linting failed!")
        return False

def test_github_workflows():
    """Test GitHub workflow files."""
    print("\n" + "="*60)
    print("⚙️ TESTING GITHUB WORKFLOWS")
    print("="*60)
    
    workflow_files = [
        ".github/workflows/lint.yml",
        ".github/workflows/test.yml", 
        ".github/workflows/deploy.yml",
        ".github/workflows/notify.yml"
    ]
    
    for workflow_file in workflow_files:
        if os.path.exists(workflow_file):
            print(f"✅ {workflow_file}")
        else:
            print(f"❌ {workflow_file} - MISSING")
            return False
    
    print("\n✅ All workflow files present!")
    return True

def main():
    """Run all tests."""
    print("🚀 MLOps Assignment Quick Demo Test")
    print("="*60)
    print("This script tests all components before your demo")
    print("="*60)
    
    tests = [
        ("Project Structure", test_project_structure),
        ("Git Branches", test_git_branches),
        ("Imports", test_imports),
        ("Flask API", test_api),
        ("Unit Tests", test_unit_tests),
        ("Code Linting", test_linting),
        ("GitHub Workflows", test_github_workflows)
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
    print("📊 DEMO READINESS SUMMARY")
    print("="*60)
    print(f"✅ Passed: {passed}/{total}")
    print(f"❌ Failed: {total - passed}/{total}")
    
    if passed == total:
        print("\n🎉 ALL TESTS PASSED! Your demo is ready!")
        print("\n📋 Next steps for demo:")
        print("1. Set up GitHub secrets (see DEMO_TESTING_GUIDE.md)")
        print("2. Configure branch protection rules")
        print("3. Follow the demo script in DEMO_TESTING_GUIDE.md")
        print("4. Test the complete workflow: dev → test → main")
    else:
        print(f"\n⚠️  {total - passed} tests failed. Please fix issues before demo.")
        print("\n🔧 Common fixes:")
        print("- Install missing dependencies: pip install -r app/requirements.txt")
        print("- Install pytest: pip install pytest")
        print("- Install flake8: pip install flake8")
        print("- Check file paths and permissions")
        sys.exit(1)

if __name__ == "__main__":
    main()
