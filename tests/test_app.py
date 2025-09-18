# tests/test_app.py
import json
import os
import sys

import pytest

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))  # noqa: E402

from app.app import app, feature_names  # noqa: E402


class TestHeartDiseaseAPI:
    """Test cases for Heart Disease Prediction API"""

    def setup_method(self):
        """Set up test client for each test method"""
        self.client = app.test_client()

    def test_root_endpoint(self):
        """Test the root endpoint returns correct response"""
        response = self.client.get("/")
        assert response.status_code == 200
        expected_text = b"Heart Disease Prediction API" in response.data
        running_text = b"running" in response.data
        assert expected_text or running_text

    def test_predict_endpoint_success(self):
        """Test prediction endpoint with valid data"""
        # Create sample data with all required features
        sample_data = {name: 1 for name in feature_names}
        # Set categorical fields to valid values
        sample_data["Sex"] = "M"
        sample_data["ChestPainType"] = "ATA"
        sample_data["RestingECG"] = "Normal"
        sample_data["ExerciseAngina"] = "N"
        sample_data["ST_Slope"] = "Up"

        response = self.client.post("/predict", json=sample_data)
        assert response.status_code == 200

        data = json.loads(response.data)
        assert "prediction" in data
        assert "probabilities" in data
        assert isinstance(data["prediction"], int)
        assert isinstance(data["probabilities"], list)
        assert len(data["probabilities"]) == 2  # Binary classification

    def test_predict_endpoint_missing_features(self):
        """Test prediction endpoint with missing features"""
        incomplete_data = {"Age": 40, "Sex": "M"}

        response = self.client.post("/predict", json=incomplete_data)
        assert response.status_code == 400

        data = json.loads(response.data)
        assert "error" in data
        assert "Missing features" in data["error"]

    def test_predict_endpoint_invalid_json(self):
        """Test prediction endpoint with invalid JSON"""
        response = self.client.post(
            "/predict",
            data="invalid json",
            content_type='application/json'
        )
        assert response.status_code == 400

    def test_predict_endpoint_empty_data(self):
        """Test prediction endpoint with empty data"""
        response = self.client.post("/predict", json={})
        assert response.status_code == 400

    def test_predict_endpoint_wrong_method(self):
        """Test prediction endpoint with wrong HTTP method"""
        response = self.client.get("/predict")
        assert response.status_code == 405  # Method Not Allowed

    def test_feature_names_loaded(self):
        """Test that feature names are properly loaded"""
        assert isinstance(feature_names, list)
        assert len(feature_names) > 0
        # Check for some expected feature names
        expected_features = ["Age", "Sex", "ChestPainType", "RestingBP",
                             "Cholesterol"]
        for feature in expected_features:
            assert feature in feature_names

    def test_model_prediction_format(self):
        """Test that model prediction returns correct format"""
        sample_data = {name: 1 for name in feature_names}
        sample_data["Sex"] = "M"
        sample_data["ChestPainType"] = "ATA"
        sample_data["RestingECG"] = "Normal"
        sample_data["ExerciseAngina"] = "N"
        sample_data["ST_Slope"] = "Up"

        response = self.client.post("/predict", json=sample_data)
        assert response.status_code == 200

        data = json.loads(response.data)
        # Check prediction is 0 or 1 (binary classification)
        assert data["prediction"] in [0, 1]
        # Check probabilities sum to 1
        assert abs(sum(data["probabilities"]) - 1.0) < 0.001
        # Check all probabilities are between 0 and 1
        for prob in data["probabilities"]:
            assert 0 <= prob <= 1


def test_app_imports():
    """Test that the app can be imported without errors"""
    from app.app import app, feature_names
    assert app is not None
    assert feature_names is not None


def test_model_files_exist():
    """Test that required model files exist"""
    model_path = os.path.join("model", "model.pkl")
    meta_path = os.path.join("model", "metadata.json")

    assert os.path.exists(model_path), f"Model file not found: {model_path}"
    assert os.path.exists(meta_path), f"Metadata file not found: {meta_path}"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
