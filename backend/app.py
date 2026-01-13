from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
from feature_extraction import extract_features

app = Flask(__name__)
CORS(app)

# Load model
model = joblib.load("model/random_forest_model.joblib")

# Whitelist of known safe domains
SAFE_DOMAINS = [
    "google.com",
    "youtube.com",
    "facebook.com",
    "twitter.com",
    "x.com",
    "github.com",
    "stackoverflow.com",
    "amazon.com",
    "microsoft.com",
    "apple.com",
    "wikipedia.org",
    "reddit.com",
    "linkedin.com",
    "instagram.com",
    "whatsapp.com",
    "netflix.com",
    "zoom.us",
    "gmail.com",
    "yahoo.com",
    "bing.com",
    "outlook.com",
]


def is_safe_domain(url):
    """Check if URL is from a whitelisted safe domain"""
    url_lower = url.lower()
    return any(domain in url_lower for domain in SAFE_DOMAINS)


@app.route("/check-url", methods=["POST"])
def check_url():
    data = request.get_json()
    url = data.get("url", "")

    if not url:
        return jsonify({"error": "URL is missing"}), 400

    # Extract features
    features = extract_features(url)

    # Debug logging
    print(f"\n Checking URL: {url}")
    print(f"Features extracted: {len(features)} features")

    # Check whitelist first
    if is_safe_domain(url):
        print(" WHITELISTED - Known safe domain")
        result = "Safe"
        confidence = 99.9
        malicious_prob = 0.1
        safe_prob = 99.9
    else:
        # Make prediction for unknown URLs
        prediction = model.predict([features])[0]
        probability = model.predict_proba([features])[0]

        result = "Malicious" if prediction == 1 else "Safe"
        confidence = max(probability) * 100
        safe_prob = probability[0] * 100
        malicious_prob = probability[1] * 100

    # Debug output
    print(f" Prediction: {result} ({confidence:.2f}% confidence)")
    print(f"   Safe: {safe_prob:.2f}% | Malicious: {malicious_prob:.2f}%\n")

    # Return detailed response
    return jsonify(
        {
            "url": url,
            "prediction": result,
            "confidence": f"{confidence:.2f}%",
            "malicious_probability": f"{malicious_prob:.2f}%",
            "safe_probability": f"{safe_prob:.2f}%",
        }
    )


@app.route("/", methods=["GET"])
def home():
    return jsonify(
        {
            "status": "running",
            "service": "PhishShield API v2.1",
            "whitelisted_domains": len(SAFE_DOMAINS),
        }
    )


if __name__ == "__main__":
    print("=" * 60)
    print(" PhishShield Backend v2.1 - With Whitelist Protection")
    print("=" * 60)
    print(f" Running on: http://localhost:5000")
    print(f" Whitelisted domains: {len(SAFE_DOMAINS)}")
    print("=" * 60)

    #  Production ready
    import os

    port = int(os.environ.get("PORT", 5000))
    debug = os.environ.get("DEBUG", "False") == "True"
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
