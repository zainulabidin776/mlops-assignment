# Branch Protection Setup Guide

## Required GitHub Repository Settings

### 1. Enable Branch Protection Rules

Go to your GitHub repository → Settings → Branches → Add rule

#### For `main` branch:
- ✅ Require a pull request before merging
- ✅ Require approvals (1 reviewer)
- ✅ Dismiss stale PR approvals when new commits are pushed
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Restrict pushes that create files larger than 100MB

#### For `test` branch:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging

### 2. Required Status Checks

#### For `main` branch:
- ✅ Jenkins build must pass
- ✅ All CI checks must pass

#### For `test` branch:
- ✅ Unit tests must pass

### 3. Admin Setup

1. Go to Settings → Manage access
2. Add your group member as a collaborator
3. Give them "Write" access
4. You (as admin) should have "Admin" access

## Workflow Process

### Development Flow:
1. **Feature Development**: Work on `dev` branch
2. **Code Quality**: Push to `dev` triggers flake8 linting
3. **Testing**: Create PR from `dev` to `test` branch
4. **Unit Testing**: PR to `test` triggers unit tests
5. **Production**: Create PR from `test` to `main` branch
6. **Deployment**: PR to `main` triggers Jenkins pipeline
7. **Notification**: Admin receives email on successful deployment

### Pull Request Requirements:
- All status checks must pass
- At least 1 admin approval required
- No merge conflicts
- Up-to-date with target branch
