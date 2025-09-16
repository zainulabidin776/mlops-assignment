# tests/test_app.py
import json
import sys
import os

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))  # noqa: E402

from app.app import app, feature_names  # noqa: E402


def test_root():
    client = app.test_client()
    res = client.get("/")
    assert res.status_code == 200
    expected_text = b"Heart Disease Prediction API" in res.data
    running_text = b"running" in res.data
    assert expected_text or running_text


def test_predict():
    client = app.test_client()
    sample = {name: 1 for name in feature_names}
    # Patch categorical fields
    sample["Sex"] = "M"
    sample["ChestPainType"] = "ATA"
    sample["RestingECG"] = "Normal"
    sample["ExerciseAngina"] = "N"
    sample["ST_Slope"] = "Up"

    res = client.post("/predict", json=sample)
    assert res.status_code == 200
    data = json.loads(res.data)
    assert "prediction" in data
    assert "probabilities" in data
