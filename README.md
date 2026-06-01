\# 🚦 Toll Traffic Anomaly Detector



Synthetic German highway Mautdaten analysis pipeline for anomaly detection, monitoring, and reporting.



\## 🔍 Overview

Simulates 6 months of hourly toll traffic across 5 German highway segments (A1, A2, A7, A9, A100). Detects anomalous patterns using Z-Score and Isolation Forest — designed to reflect real operational monitoring workflows in toll data environments.



\## 🛠️ Tools

Python · Pandas · NumPy · Scikit-learn · Plotly · Jupyter Notebook



\## 📊 Methods

\- Statistical: Z-Score (±3σ rolling baseline)

\- Machine Learning: Isolation Forest (contamination=1%)

\- Combined high-confidence flagging



\## 📁 Output

\- `data/synthetic\_toll\_traffic.csv` — full hourly dataset

\- `data/anomaly\_report.csv` — flagged anomalies with severity levels



\## ▶️ Run

Open `notebooks/toll\_traffic\_anomaly\_detector.ipynb` in Jupyter or Google Colab and run all cells.



\---

\*Gaurav Bhatia | MSc Data Science, GISMA Berlin | 2026\*

