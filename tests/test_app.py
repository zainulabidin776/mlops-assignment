# tests/test_app.py
import json
from app.app import app, feature_names

def test_root():
    client = app.test_client()
    res = client.get("/")
    assert res.status_code == 200
    assert b"Heart Disease Prediction API" in res.data or b"running" in res.data

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
