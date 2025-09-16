import requests

url = "http://127.0.0.1:5000/predict"

data = {
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
}

response = requests.post(url, json=data)
print(response.json())
