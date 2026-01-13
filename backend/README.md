# 🛡️ PhishShield Backend  
A machine-learning powered backend API that detects phishing websites using URL features, lexical analysis, and trained ML models.  
Built using **Flask**, **Scikit-Learn**, and **Python**.

---

## 🚀 Features
- 🔍 Predicts whether a given URL is *phishing* or *legitimate*
- 🤖 Uses trained Machine Learning models (Random Forest / ML algorithms)
- ⚙️ Simple REST API endpoint for predictions  
- 📦 Easy deployment using Render  
- 🔐 Secure backend with private model files  
- 🧹 Clean & modular code structure

---

## 📁 Project Structure
```

backend/
│── app.py                # Main Flask API
│── feature_extraction.py # URL feature extraction logic
│── requirements.txt      # Dependencies
│── render.yaml           # Render deployment config
│── model/                # (Ignored) ML models - private
│── dataset/              # (Ignored) datasets - private
│── .gitignore
└── README.md

````

---

## ⚙️ Installation & Setup (Local)

### 1️⃣ Clone the repository
```bash
git clone https://github.com/muhammadwasif12/phishshield-backend.git
cd phishshield-backend
````

### 2️⃣ Create virtual environment

```bash
python -m venv venv
venv\Scripts\activate  # Windows
```

### 3️⃣ Install requirements

```bash
pip install -r requirements.txt
```

### 4️⃣ Run the server

```bash
python app.py
```

Server will start on:

```
http://127.0.0.1:5000
```

---

## 🔮 API Usage

### **POST /predict**

Predicts if a URL is *phishing* or *legitimate*.

#### Request:

```
POST /predict
Content-Type: application/json

{
  "url": "http://example.com/login"
}
```

#### Response:

```
{
  "prediction": "phishing",
  "confidence": 0.92
}
```

---

## 🌐 Deploying on Render

1. Push code to GitHub
2. Go to [https://render.com](https://render.com)
3. Create New → **Web Service**
4. Connect repository
5. Use this Start Command:

```
gunicorn app:app --bind 0.0.0.0:$PORT
```

6. Add Environment Variables (if needed)
7. Deploy 🎉

---

## 🧠 ML Model

The ML model is kept private and **not included** in the public repository.
This ensures security and prevents misuse.

---

## 👨‍💻 Technologies Used

* Python
* Flask
* Scikit-Learn
* NumPy / Pandas
* Gunicorn
* Render Cloud

---

## 📜 License

This project is licensed under the **MIT License**.
See the LICENSE file for details.

---

## 🤝 Contributing

Pull requests are welcome.
For major changes, please open an issue first to discuss what you would like to change.

---

## ⭐ Support

If you like the project, give it a ⭐ on GitHub — it helps a lot!
