# Phishing-Detection-System
A comprehensive full-stack security application engineered to identify and mitigate cyber threats across multiple digital channels. Developed as a final-year academic project, it addresses the rising complexity of social engineering by providing a centralized platform for detecting malicious URLs, fraudulent emails, and Sms scams.

The heart of the project is the detection logic, which evaluates suspicious inputs:
URL Analysis: Inspects web links for common phishing indicators such as typosquatting, suspicious top-level domains, and hidden redirects.
Email Filtering: Scans message content for high-risk keywords and phishing patterns often used in "Business Email Compromise" (BEC) attacks.

# Features
Multi-Vector Detection: Specialized modules to analyze suspicious links and communication patterns in real-time.
User Dashboard: A secure portal for users to report potential phishing attempts and track their submission history.
Admin Command Center: A robust management interface for administrators to review reports, manage the threat database, and analyze security trends.
Persistent Logging: Real-time data storage using MySQL to categorize and archive evolving attack vectors.

#  Tech Stack
Backend: Python (Flask)
Database: MySQL
Frontend: HTML5, CSS3, JavaScript (Bootstrap)
Tools: Git, GitHub, MySQL Workbench

# 📂 Project Structure

├── app.py              # Main Flask application logic
|
├── database/           # SQL scripts for table schema
|
├── static/             # CSS, JS, and image assets
|
├── templates/          # HTML templates (User & Admin Dashboards)
|
└── requirements.txt    # List of Python dependencies

