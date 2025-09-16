# train.py
import argparse, os, json
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score

def main(args):
    df = pd.read_csv(args.data)
    target = "HeartDisease"
    X = df.drop(columns=[target])
    y = df[target]

    # Identify categorical and numeric columns
    cat_cols = X.select_dtypes(include=["object"]).columns.tolist()
    num_cols = X.select_dtypes(exclude=["object"]).columns.tolist()

    preprocessor = ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore"), cat_cols),
            ("num", StandardScaler(), num_cols)
        ]
    )

    pipeline = Pipeline(steps=[
        ("preprocessor", preprocessor),
        ("clf", RandomForestClassifier(n_estimators=100, random_state=42))
    ])

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=args.test_size, random_state=42, stratify=y
    )

    pipeline.fit(X_train, y_train)
    preds = pipeline.predict(X_test)

    print("Accuracy:", accuracy_score(y_test, preds))
    print(classification_report(y_test, preds))

    os.makedirs("model", exist_ok=True)
    joblib.dump(pipeline, "model/model.pkl")
    with open("model/metadata.json","w") as f:
        json.dump({
            "feature_names": list(X.columns),
            "categorical": cat_cols,
            "numerical": num_cols,
            "target": target
        }, f, indent=2)

    print("Saved model and metadata.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data", default="datasets/data.csv")
    parser.add_argument("--test-size", type=float, default=0.2)
    args = parser.parse_args()
    main(args)
