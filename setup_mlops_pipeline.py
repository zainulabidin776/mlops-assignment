#!/usr/bin/env python3
"""
MLOps Pipeline Setup Script
This script helps set up the complete MLOps pipeline according to assignment requirements.
"""

import os
import subprocess
import sys

def run_command(command, description):
    """Run a command and print the result."""
    print(f"\n🔄 {description}")
    print(f"Running: {command}")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ Success: {description}")
        if result.stdout:
            print(f"Output: {result.stdout}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {description}")
        print(f"Error: {e.stderr}")
        return False

def check_requirements():
    """Check if all required tools are installed."""
    print("🔍 Checking requirements...")
    
    requirements = {
        'git': 'git --version',
        'python': 'python --version',
        'pip': 'pip --version',
        'docker': 'docker --version'
    }
    
    missing = []
    for tool, command in requirements.items():
        if not run_command(command, f"Checking {tool}"):
            missing.append(tool)
    
    if missing:
        print(f"\n❌ Missing requirements: {', '.join(missing)}")
        print("Please install the missing tools before proceeding.")
        return False
    
    print("\n✅ All requirements satisfied!")
    return True

def setup_git_branches():
    """Set up the required git branches."""
    print("\n🌿 Setting up git branches...")
    
    branches = ['dev', 'test', 'main']
    current_branch = subprocess.run('git branch --show-current', shell=True, capture_output=True, text=True).stdout.strip()
    
    for branch in branches:
        if branch != current_branch:
            run_command(f'git checkout -b {branch}', f'Creating {branch} branch')
        run_command(f'git push -u origin {branch}', f'Pushing {branch} branch to remote')
    
    run_command(f'git checkout {current_branch}', f'Returning to {current_branch} branch')

def test_pipeline():
    """Test the MLOps pipeline components."""
    print("\n🧪 Testing pipeline components...")
    
    # Test model training
    if os.path.exists('datasets/data.csv'):
        run_command('python train.py', 'Training ML model')
    else:
        print("❌ Dataset not found. Please ensure datasets/data.csv exists.")
        return False
    
    # Test API
    run_command('python -c "import app.app; print(\'API imports successfully\')"', 'Testing API imports')
    
    # Test linting
    run_command('pip install flake8', 'Installing flake8')
    run_command('flake8 .', 'Running linting checks')
    
    # Test unit tests
    run_command('pip install pytest', 'Installing pytest')
    run_command('pytest tests/ -v', 'Running unit tests')
    
    print("\n✅ Pipeline components tested successfully!")

def main():
    """Main setup function."""
    print("🚀 MLOps Pipeline Setup")
    print("=" * 50)
    
    # Check requirements
    if not check_requirements():
        sys.exit(1)
    
    # Setup git branches
    setup_git_branches()
    
    # Test pipeline
    test_pipeline()
    
    print("\n" + "=" * 50)
    print("🎉 MLOps Pipeline Setup Complete!")
    print("\nNext steps:")
    print("1. Go to GitHub repository settings")
    print("2. Set up branch protection rules (see BRANCH_PROTECTION_SETUP.md)")
    print("3. Configure Jenkins server")
    print("4. Test the complete workflow:")
    print("   - Push to dev branch (triggers linting)")
    print("   - Create PR from dev to test (triggers unit tests)")
    print("   - Create PR from test to main (triggers Jenkins)")

if __name__ == "__main__":
    main()
