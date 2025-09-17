#!/usr/bin/env python3
"""
Local test script to verify the application works before pushing to GitHub
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

def test_imports():
    """Test that all imports work correctly."""
    print("\n" + "="*50)
    print("📦 TESTING IMPORTS")
    print("="*50)
    
    try:
        from app.app import app, feature_names
        print("✅ App imports successful")
        print(f"✅ Feature names loaded: {len(feature_names)} features")
        return True
    except Exception as e:
        print(f"❌ Import failed: {e}")
        return False

def test_model_files():
    """Test that model files exist."""
    print("\n" + "="*50)
    print("🧠 TESTING MODEL FILES")
    print("="*50)
    
    model_path = os.path.join("model", "model.pkl")
    meta_path = os.path.join("model", "metadata.json")
    
    if os.path.exists(model_path):
        print("✅ Model file exists")
    else:
        print(f"❌ Model file missing: {model_path}")
        return False
    
    if os.path.exists(meta_path):
        print("✅ Metadata file exists")
    else:
        print(f"❌ Metadata file missing: {meta_path}")
        return False
    
    return True

def test_api():
    """Test the Flask API."""
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

def test_pytest():
    """Test using pytest."""
    print("\n" + "="*50)
    print("🧪 TESTING WITH PYTEST")
    print("="*50)
    
    result = run_command('pytest tests/ -v', 'Running pytest tests')
    if result and result.returncode == 0:
        print("✅ Pytest tests passed!")
        return True
    else:
        print("❌ Pytest tests failed!")
        return False

def main():
    """Run all tests."""
    print("🚀 Local MLOps Application Test Suite")
    print("="*60)
    
    tests = [
        ("Imports", test_imports),
        ("Model Files", test_model_files),
        ("Flask API", test_api),
        ("Pytest", test_pytest)
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
        print("\n🎉 ALL TESTS PASSED! Your application is ready for GitHub!")
    else:
        print(f"\n⚠️  {total - passed} tests failed. Please fix the issues before pushing to GitHub.")
        sys.exit(1)

if __name__ == "__main__":
    main()
