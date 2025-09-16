# app/app.py
from flask import Flask, request, jsonify
import joblib
import json
import os
import pandas as pd

app = Flask(__name__)
MODEL_PATH = os.path.join("model", "model.pkl")
META_PATH = os.path.join("model", "metadata.json")

model = joblib.load(MODEL_PATH)
with open(META_PATH, "r") as f:
    metadata = json.load(f)
feature_names = metadata["feature_names"]


@app.route("/")
def root():
    return "Heart Disease Prediction API running"


@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    # Expect dict with all feature names
    if not all(feat in data for feat in feature_names):
        error_msg = f"Missing features. Expected: {feature_names}"
        return jsonify({"error": error_msg}), 400

    X = pd.DataFrame([data], columns=feature_names)
    pred = model.predict(X)[0]
    proba = model.predict_proba(X)[0].tolist()

    return jsonify({
        "prediction": int(pred),
        "probabilities": proba
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
