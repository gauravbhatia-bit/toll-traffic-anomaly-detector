# Toll Maut Revenue and Traffic SQL Reporting Pipeline

Multi-table SQL analytics pipeline simulating German highway toll data.

## Tools
- DuckDB, Python, Pandas, SQL, Jupyter

## Reports
1. Weekly Revenue by Segment and Vehicle Class
2. Peak Hour Traffic Analysis
3. Heavy Vehicle Share and Revenue Contribution
4. Transaction Anomaly Flag Report

## SQL Techniques
JOINs, CTEs, Window Functions (RANK), Z-score anomaly detection, STDDEV, NULLIF

## How to Run
pip install -r requirements.txt
jupyter notebook notebooks/toll_sql_reporting_pipeline.ipynb

## Project Structure
- notebooks/ - Jupyter notebook
- sql/        - Standalone SQL files
- data/       - CSV report outputs

Gaurav Bhatia | MSc Data Science, GISMA University Berlin | 2026
