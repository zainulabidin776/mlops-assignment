#!/usr/bin/env python3
"""
🧪 Flask API Test Script for MLOps Assignment
Group Members: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108)
Project: Heart Disease Prediction API
"""

import requests
import json
import time
import subprocess
import sys
import os
from typing import Dict, Any, Tuple

class Colors:
    """ANSI color codes for terminal output"""
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    WHITE = '\033[1;37m'
    NC = '\033[0m'  # No Color

class APITester:
    """Comprehensive API testing class"""
    
    def __init__(self, base_url: str = "http://localhost:5000"):
        self.base_url = base_url
        self.test_results = []
        self.flask_process = None
        
    def print_header(self, message: str):
        """Print formatted header"""
        print(f"\n{Colors.BLUE}{'='*50}{Colors.NC}")
        print(f"{Colors.BLUE}{message}{Colors.NC}")
        print(f"{Colors.BLUE}{'='*50}{Colors.NC}\n")
        
    def print_test(self, test_name: str, status: str, message: str = ""):
        """Print test result with color coding"""
        if status == "PASS":
            print(f"{Colors.GREEN}✅ PASS{Colors.NC}: {test_name} - {message}")
        elif status == "FAIL":
            print(f"{Colors.RED}❌ FAIL{Colors.NC}: {test_name} - {message}")
        elif status == "INFO":
            print(f"{Colors.CYAN}ℹ️  INFO{Colors.NC}: {test_name} - {message}")
        elif status == "WARN":
            print(f"{Colors.YELLOW}⚠️  WARN{Colors.NC}: {test_name} - {message}")
            
        self.test_results.append({
            'test': test_name,
            'status': status,
            'message': message
        })
    
    def start_flask_app(self) -> bool:
        """Check if Flask application is already running or start it"""
        try:
            print(f"{Colors.CYAN}🚀 Checking Flask application...{Colors.NC}")
            
            # First, check if Flask app is already running
            try:
                response = requests.get(f"{self.base_url}/", timeout=5)
                if response.status_code == 200:
                    self.print_test("Flask App Check", "PASS", "Flask app is already running")
                    return True
            except requests.exceptions.RequestException:
                pass  # App not running, continue to start it
            
            # Check if app.py exists
            if not os.path.exists('app/app.py'):
                self.print_test("Flask App Check", "FAIL", "app/app.py not found")
                return False
                
            # Start Flask app in background
            self.flask_process = subprocess.Popen(
                [sys.executable, 'app/app.py'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            
            # Wait for app to start
            time.sleep(5)
            
            # Check if process is running
            if self.flask_process.poll() is None:
                self.print_test("Flask App Start", "PASS", "Application started successfully")
                return True
            else:
                stdout, stderr = self.flask_process.communicate()
                self.print_test("Flask App Start", "FAIL", f"Failed to start: {stderr}")
                return False
                
        except Exception as e:
            self.print_test("Flask App Start", "FAIL", f"Exception: {str(e)}")
            return False
    
    def stop_flask_app(self):
        """Stop Flask application (only if we started it)"""
        if self.flask_process:
            try:
                self.flask_process.terminate()
                self.flask_process.wait(timeout=5)
                self.print_test("Flask App Stop", "PASS", "Application stopped successfully")
            except subprocess.TimeoutExpired:
                self.flask_process.kill()
                self.print_test("Flask App Stop", "WARN", "Application force killed")
            except Exception as e:
                self.print_test("Flask App Stop", "FAIL", f"Error stopping app: {str(e)}")
        else:
            # We didn't start the app, so don't try to stop it
            self.print_test("Flask App Stop", "INFO", "App was already running, not stopping")
    
    def test_health_endpoint(self) -> bool:
        """Test health check endpoint"""
        try:
            response = requests.get(f"{self.base_url}/", timeout=10)
            
            if response.status_code == 200:
                if "Heart Disease Prediction API" in response.text:
                    self.print_test("Health Endpoint", "PASS", f"Status: {response.status_code}, Response: {response.text.strip()}")
                    return True
                else:
                    self.print_test("Health Endpoint", "FAIL", f"Unexpected response: {response.text}")
                    return False
            else:
                self.print_test("Health Endpoint", "FAIL", f"Status code: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Health Endpoint", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_prediction_endpoint_valid(self) -> bool:
        """Test prediction endpoint with valid data"""
        try:
            # Valid test data
            test_data = {
                "Age": 65,
                "Sex": 1,
                "ChestPainType": 3,
                "RestingBP": 145,
                "Cholesterol": 233,
                "FastingBS": 1,
                "RestingECG": 0,
                "MaxHR": 150,
                "ExerciseAngina": 0,
                "Oldpeak": 2.3,
                "ST_Slope": 0
            }
            
            response = requests.post(
                f"{self.base_url}/predict",
                json=test_data,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 200:
                try:
                    result = response.json()
                    if 'prediction' in result and 'probabilities' in result:
                        self.print_test("Prediction Endpoint (Valid)", "PASS", 
                                      f"Prediction: {result['prediction']}, Probabilities: {result['probabilities']}")
                        return True
                    else:
                        self.print_test("Prediction Endpoint (Valid)", "FAIL", 
                                      f"Missing required fields: {result}")
                        return False
                except json.JSONDecodeError:
                    self.print_test("Prediction Endpoint (Valid)", "FAIL", 
                                  f"Invalid JSON response: {response.text}")
                    return False
            else:
                self.print_test("Prediction Endpoint (Valid)", "FAIL", 
                              f"Status code: {response.status_code}, Response: {response.text}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Prediction Endpoint (Valid)", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_prediction_endpoint_missing_features(self) -> bool:
        """Test prediction endpoint with missing features"""
        try:
            # Incomplete test data
            test_data = {
                "Age": 65,
                "Sex": 1
                # Missing other required features
            }
            
            response = requests.post(
                f"{self.base_url}/predict",
                json=test_data,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 400:
                try:
                    result = response.json()
                    if 'error' in result:
                        self.print_test("Prediction Endpoint (Missing Features)", "PASS", 
                                      f"Error handling: {result['error']}")
                        return True
                    else:
                        self.print_test("Prediction Endpoint (Missing Features)", "FAIL", 
                                      f"No error message: {result}")
                        return False
                except json.JSONDecodeError:
                    self.print_test("Prediction Endpoint (Missing Features)", "FAIL", 
                                  f"Invalid JSON response: {response.text}")
                    return False
            else:
                self.print_test("Prediction Endpoint (Missing Features)", "FAIL", 
                              f"Expected 400, got: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Prediction Endpoint (Missing Features)", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_prediction_endpoint_invalid_json(self) -> bool:
        """Test prediction endpoint with invalid JSON"""
        try:
            response = requests.post(
                f"{self.base_url}/predict",
                data="invalid json data",
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 400:
                self.print_test("Prediction Endpoint (Invalid JSON)", "PASS", 
                              f"Error handling: {response.text}")
                return True
            else:
                self.print_test("Prediction Endpoint (Invalid JSON)", "FAIL", 
                              f"Expected 400, got: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Prediction Endpoint (Invalid JSON)", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_prediction_endpoint_wrong_method(self) -> bool:
        """Test prediction endpoint with wrong HTTP method"""
        try:
            response = requests.get(f"{self.base_url}/predict", timeout=10)
            
            if response.status_code == 405:  # Method Not Allowed
                self.print_test("Prediction Endpoint (Wrong Method)", "PASS", 
                              f"Method not allowed: {response.status_code}")
                return True
            else:
                self.print_test("Prediction Endpoint (Wrong Method)", "FAIL", 
                              f"Expected 405, got: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Prediction Endpoint (Wrong Method)", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_prediction_endpoint_empty_data(self) -> bool:
        """Test prediction endpoint with empty data"""
        try:
            response = requests.post(
                f"{self.base_url}/predict",
                json={},
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 400:
                try:
                    result = response.json()
                    if 'error' in result:
                        self.print_test("Prediction Endpoint (Empty Data)", "PASS", 
                                      f"Error handling: {result['error']}")
                        return True
                    else:
                        self.print_test("Prediction Endpoint (Empty Data)", "FAIL", 
                                      f"No error message: {result}")
                        return False
                except json.JSONDecodeError:
                    self.print_test("Prediction Endpoint (Empty Data)", "FAIL", 
                                  f"Invalid JSON response: {response.text}")
                    return False
            else:
                self.print_test("Prediction Endpoint (Empty Data)", "FAIL", 
                              f"Expected 400, got: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Prediction Endpoint (Empty Data)", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def test_model_loading(self) -> bool:
        """Test if model files exist and can be loaded"""
        try:
            # Check if model files exist
            if not os.path.exists('model/model.pkl'):
                self.print_test("Model Files Check", "FAIL", "model.pkl not found")
                return False
                
            if not os.path.exists('model/metadata.json'):
                self.print_test("Model Files Check", "FAIL", "metadata.json not found")
                return False
            
            # Try to load model
            import joblib
            import json
            
            model = joblib.load('model/model.pkl')
            with open('model/metadata.json', 'r') as f:
                metadata = json.load(f)
            
            if 'feature_names' in metadata:
                self.print_test("Model Loading", "PASS", 
                              f"Model loaded, {len(metadata['feature_names'])} features")
                return True
            else:
                self.print_test("Model Loading", "FAIL", "Invalid metadata structure")
                return False
                
        except Exception as e:
            self.print_test("Model Loading", "FAIL", f"Error loading model: {str(e)}")
            return False
    
    def test_app_imports(self) -> bool:
        """Test if app.py can be imported without errors"""
        try:
            # Add app directory to path
            sys.path.insert(0, 'app')
            
            # Try to import app
            import app
            self.print_test("App Import", "PASS", "app.py imports successfully")
            return True
            
        except Exception as e:
            self.print_test("App Import", "FAIL", f"Import error: {str(e)}")
            return False
    
    def test_response_time(self) -> bool:
        """Test API response time"""
        try:
            start_time = time.time()
            response = requests.get(f"{self.base_url}/", timeout=10)
            end_time = time.time()
            
            response_time = end_time - start_time
            
            if response.status_code == 200 and response_time < 2.0:
                self.print_test("Response Time", "PASS", f"Response time: {response_time:.3f}s")
                return True
            elif response.status_code == 200:
                self.print_test("Response Time", "WARN", f"Slow response: {response_time:.3f}s")
                return True
            else:
                self.print_test("Response Time", "FAIL", f"Status: {response.status_code}")
                return False
                
        except requests.exceptions.RequestException as e:
            self.print_test("Response Time", "FAIL", f"Request failed: {str(e)}")
            return False
    
    def run_all_tests(self) -> Tuple[int, int, int]:
        """Run all tests and return results"""
        self.print_header("🧪 Flask API Comprehensive Testing")
        
        # Test model and imports first (don't require running server)
        self.test_model_loading()
        self.test_app_imports()
        
        # Check if Flask app is running or start it
        if not self.start_flask_app():
            self.print_test("API Testing", "FAIL", "Cannot connect to Flask app, skipping API tests")
            return self.get_test_summary()
        
        # Wait a bit more for app to be ready
        time.sleep(2)
        
        # Run API tests
        self.test_health_endpoint()
        self.test_prediction_endpoint_valid()
        self.test_prediction_endpoint_missing_features()
        self.test_prediction_endpoint_invalid_json()
        self.test_prediction_endpoint_wrong_method()
        self.test_prediction_endpoint_empty_data()
        self.test_response_time()
        
        # Stop Flask app (only if we started it)
        self.stop_flask_app()
        
        return self.get_test_summary()
    
    def get_test_summary(self) -> Tuple[int, int, int]:
        """Get test summary statistics"""
        total = len(self.test_results)
        passed = sum(1 for result in self.test_results if result['status'] == 'PASS')
        failed = sum(1 for result in self.test_results if result['status'] == 'FAIL')
        
        return total, passed, failed
    
    def print_summary(self):
        """Print test summary"""
        total, passed, failed = self.get_test_summary()
        
        self.print_header("📊 Test Results Summary")
        
        print(f"{Colors.WHITE}Total Tests: {total}{Colors.NC}")
        print(f"{Colors.GREEN}Passed: {passed}{Colors.NC}")
        print(f"{Colors.RED}Failed: {failed}{Colors.NC}")
        
        if total > 0:
            success_rate = (passed * 100) // total
            print(f"{Colors.YELLOW}Success Rate: {success_rate}%{Colors.NC}")
            
            if success_rate >= 90:
                print(f"\n{Colors.GREEN}🎉 EXCELLENT! Your Flask API is working perfectly!{Colors.NC}")
                print(f"{Colors.GREEN}✅ Ready for production deployment!{Colors.NC}")
            elif success_rate >= 80:
                print(f"\n{Colors.YELLOW}⚠️  GOOD! Most API functions work, but some issues need attention.{Colors.NC}")
                print(f"{Colors.YELLOW}🔧 Please review failed tests and fix issues.{Colors.NC}")
            else:
                print(f"\n{Colors.RED}❌ NEEDS WORK! Several API functions are not working properly.{Colors.NC}")
                print(f"{Colors.RED}🔧 Please review failed tests and fix issues before deployment.{Colors.NC}")
        else:
            print(f"{Colors.RED}❌ No tests were executed!{Colors.NC}")

def main():
    """Main function to run API tests"""
    print(f"{Colors.PURPLE}🧪 Flask API Test Script for MLOps Assignment{Colors.NC}")
    print(f"{Colors.PURPLE}Group: Zain Ul Abidin (22I-2738) & Ahmed Javed (21I-1108){Colors.NC}")
    print(f"{Colors.PURPLE}Project: Heart Disease Prediction API{Colors.NC}\n")
    
    # Check if requests library is available
    try:
        import requests
    except ImportError:
        print(f"{Colors.RED}❌ Error: 'requests' library not found. Please install it with: pip install requests{Colors.NC}")
        sys.exit(1)
    
    # Create tester instance
    tester = APITester()
    
    # Run all tests
    try:
        tester.run_all_tests()
        tester.print_summary()
        
        # Exit with appropriate code
        _, _, failed = tester.get_test_summary()
        sys.exit(failed)
        
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Testing interrupted by user{Colors.NC}")
        tester.stop_flask_app()
        sys.exit(1)
    except Exception as e:
        print(f"\n{Colors.RED}❌ Unexpected error: {str(e)}{Colors.NC}")
        tester.stop_flask_app()
        sys.exit(1)

if __name__ == "__main__":
    main()
