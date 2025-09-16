# MLOps Heart Disease Prediction API

A complete MLOps pipeline for heart disease prediction using machine learning, containerization, and CI/CD practices.

## 🏗️ Project Structure

```
mlops-assignment/
├── app/
│   ├── app.py              # Flask API application
│   └── requirements.txt    # Python dependencies
├── datasets/
│   └── data.csv           # Heart disease dataset
├── model/
│   ├── model.pkl          # Trained ML model
│   └── metadata.json      # Model metadata
├── tests/
│   └── test_app.py        # Unit tests
├── .github/
│   └── workflows/         # GitHub Actions CI/CD
├── Dockerfile             # Container configuration
├── Jenkinsfile           # Jenkins CI/CD pipeline
├── train.py              # Model training script
└── test_request.py       # API testing script
```

## 🚀 Features

- **Machine Learning Pipeline**: RandomForest classifier for heart disease prediction
- **RESTful API**: Flask-based web service with prediction endpoints
- **Containerization**: Docker support for easy deployment
- **CI/CD Pipeline**: Jenkins and GitHub Actions integration
- **Automated Testing**: Unit tests and linting
- **Data Preprocessing**: Automated feature engineering and scaling

## 📋 Prerequisites

- Python 3.10+
- Docker (optional, for containerization)
- Git

## 🛠️ Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/zainulabidin776/mlops-assignment.git
cd mlops-assignment
```

### 2. Create Virtual Environment
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r app/requirements.txt
```

### 4. Train the Model
```bash
python train.py --data datasets/data.csv --test-size 0.2
```

### 5. Run the API
```bash
python app/app.py
```

The API will be available at `http://localhost:5000`

## 🔧 API Usage

### Health Check
```bash
curl http://localhost:5000/
```

### Prediction Endpoint
```bash
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

### Response Format
```json
{
  "prediction": 1,
  "probabilities": [0.2, 0.8]
}
```

## 🐳 Docker Deployment

### Build Image
```bash
docker build -t heart-disease-api .
```

### Run Container
```bash
docker run -p 5000:5000 heart-disease-api
```

## 🧪 Testing

### Run Unit Tests
```bash
pytest tests/
```

### Test API Manually
```bash
python test_request.py
```

### Run Linting
```bash
flake8 .
```

## 🔄 CI/CD Pipeline

### Complete MLOps Workflow
1. **Development**: Work on `dev` branch
2. **Code Quality**: Push to `dev` → triggers flake8 linting
3. **Testing**: PR from `dev` to `test` → triggers unit tests
4. **Production**: PR from `test` to `main` → triggers Docker deployment
5. **Deployment**: GitHub Actions builds and pushes to Docker Hub
6. **Notification**: Email notification sent to admin

### GitHub Actions Workflows
- **Lint Workflow**: Code quality check with flake8 on `dev` branch
- **Test Workflow**: Unit testing on `test` branch
- **Deploy Workflow**: Docker build and push to Docker Hub on `main` branch
- **Notify Workflow**: Email notifications on successful deployment

### Branch Protection
- **Admin Approval**: Required for all merges to `main` and `test`
- **Status Checks**: All workflows must pass before merging
- **Pull Requests**: Required for all changes

## 📊 Model Performance

The RandomForest classifier achieves:
- **Accuracy**: ~85-90% (varies with data split)
- **Features**: 11 input features
- **Preprocessing**: Automated categorical encoding and scaling

## 🔧 Configuration

### Environment Variables
- `PORT`: API port (default: 5000)
- `HOST`: API host (default: 0.0.0.0)

### Model Configuration
Edit `train.py` to modify:
- Test split ratio
- RandomForest parameters
- Feature engineering steps

## 📈 Monitoring & Logging

The API includes:
- Request/response logging
- Error handling and validation
- Health check endpoint

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Zainul Abidin**
- GitHub: [@zainulabidin776](https://github.com/zainulabidin776)

## 🆘 Support

If you encounter any issues or have questions, please:
1. Check the existing issues
2. Create a new issue with detailed description
3. Contact the author

---

**Note**: This is a demonstration project for MLOps practices. For production use, consider additional security, monitoring, and scalability measures.
