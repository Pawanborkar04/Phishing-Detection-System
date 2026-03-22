from flask import Flask, request, jsonify, session, render_template, redirect, url_for
from flask_cors import CORS
from flask_mail import Mail, Message
from datetime import datetime, timedelta
import mysql.connector
from mysql.connector import Error
import bcrypt
import re, json, os, random
from dotenv import load_dotenv
from scipy import stats
from scipy import stats
from werkzeug.security import generate_password_hash, check_password_hash
from urllib.parse import urlparse
import math
from collections import Counter


load_dotenv()
app = Flask(__name__)

# Configuration
app.secret_key = os.getenv('SECRET_KEY', 'kdztimaorwiojgap')
app.config.update(
    SESSION_COOKIE_SECURE=False,
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
    PERMANENT_SESSION_LIFETIME=timedelta(hours=24),
    MAIL_SERVER='smtp.gmail.com',
    MAIL_PORT=587,
    MAIL_USE_TLS=True,
    MAIL_USERNAME=os.getenv('MAIL_USERNAME', 'pavanborkar04@gmail.com'),
    MAIL_PASSWORD=os.getenv('MAIL_PASSWORD', 'kdztimaorwiojgap')
)
mail = Mail(app)
CORS(app, supports_credentials=True, origins=['http://localhost:*', 'http://127.0.0.1:*'])

# Database Config
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'Pawan@04'),
    'database': os.getenv('DB_NAME', 'phishguard_db'),
    'port': int(os.getenv('DB_PORT', 3306))
}

def get_db_connection():
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except Error as e:
        print(f"DB Error: {e}")
        return None

def close_db_connection(conn, cursor):
    if cursor: cursor.close()
    if conn: conn.close()

# Validation Functions
def validate_email(email):
    return re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email) is not None

def validate_password(password):
    if len(password) < 8: return False, "Password must be at least 8 characters"
    if not re.search(r'[A-Z]', password): return False, "Must contain uppercase"
    if not re.search(r'[a-z]', password): return False, "Must contain lowercase"
    if not re.search(r'[0-9]', password): return False, "Must contain number"
    return True, "Valid"

def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))


def shannon_entropy(text):
    if not text:
        return 0
    freq = Counter(text)
    length = len(text)
    return -sum((c/length) * math.log2(c/length) for c in freq.values())


# ========================================
# PHISHING DETECTION ENGINE
# ========================================

class PhishingDetector:
    """Enterprise-Grade Multi-Factor Phishing Detection"""
    
    # Known legitimate domains
    LEGITIMATE_DOMAINS = {
        'paypal.com', 'amazon.com', 'microsoft.com', 'apple.com', 'google.com',
        'facebook.com', 'netflix.com', 'instagram.com', 'twitter.com', 'linkedin.com',
        'ebay.com', 'chase.com', 'wellsfargo.com', 'bankofamerica.com', 'citibank.com',
        'usbank.com', 'americanexpress.com', 'discover.com', 'irs.gov', 'usps.com',
        'fedex.com', 'ups.com', 'dhl.com', 'gmail.com', 'outlook.com', 'yahoo.com'
    }
    
    URL_SHORTENERS = {'bit.ly', 'tinyurl.com', 'goo.gl', 't.co', 'ow.ly', 'is.gd', 'buff.ly'}
    SUSPICIOUS_TLDS = {'.tk', '.ml', '.ga', '.cf', '.gq', '.xyz', '.top', '.work', '.click'}

    @staticmethod
    def extract_domain_parts(url):
        """Extract domain components"""
        try:
            if not url.startswith(('http://', 'https://')):
                url = 'http://' + url
            parsed = urlparse(url)
            domain = parsed.hostname or ''
            parts = domain.split('.')
            
            tld = parts[-1] if parts else ''
            registered_domain = '.'.join(parts[-2:]) if len(parts) >= 2 else domain
            subdomain = '.'.join(parts[:-2]) if len(parts) > 2 else ''
            
            return {
                'full_domain': domain,
                'registered_domain': registered_domain,
                'subdomain': subdomain,
                'tld': tld,
                'protocol': parsed.scheme,
                'path': parsed.path,
                'query': parsed.query
            }
        except:
            return None
    
    @staticmethod
    def analyze_url(url):
        """Advanced URL Phishing Detection"""
        score = 0
        reasons = []
        
        if not url or not url.strip():
            return {'score': 0, 'status': 'safe', 'reasons': ['Empty URL'], 'url_details': None}
        
        url = url.strip()
        url_lower = url.lower()
        
        domain_info = PhishingDetector.extract_domain_parts(url)
        if not domain_info:
            return {'score': 50, 'status': 'suspicious', 'reasons': ['Malformed URL'], 'url_details': None}
        
        domain = domain_info['full_domain']
        protocol = domain_info['protocol']
        tld = domain_info['tld']
        subdomain = domain_info['subdomain']
        registered_domain = domain_info['registered_domain']
        
        HIGH_RISK_HOSTING = {
            'trycloudflare.com', 'ngrok.io', 'loca.lt', 'vercel.app',
            'netlify.app', 'pages.dev', 'github.io'
        }

        # Infrastructure abuse detection
        for risky in HIGH_RISK_HOSTING:
            if domain.endswith(risky):
                score += 35
                reasons.append(f"▸ High-risk temporary hosting provider: {risky}")
                break

        # Subdomain entropy detection
        if subdomain:
            entropy = shannon_entropy(subdomain.replace('.', '').replace('-', ''))
            if entropy > 3.5:
                score += 25
                reasons.append(f"▸ High-entropy subdomain (entropy={entropy:.2f})")

        # Excessive hyphen density
        hyphen_ratio = domain.count('-') / max(len(domain), 1)
        if hyphen_ratio > 0.15:
            score += 15
            reasons.append("▸ High hyphen density in domain")

        # Random-looking token detection
        if re.search(r'[a-z]{3,}-[a-z]{3,}-[a-z]{3,}', subdomain):
            score += 20
            reasons.append("▸ Randomized multi-token subdomain detected")
        
        # HTTPS Check
        if protocol != 'https':
            score += 20
            reasons.append("▸ No HTTPS - Connection is not encrypted")
        
        # IP Address Instead of Domain
        if re.match(r'^(\d{1,3}\.){3}\d{1,3}$', domain):
            score += 35
            reasons.append("▸ IP address used instead of domain name")
        
        # URL Length
        if len(url) > 100:
            score += 15
            reasons.append(f"▸ Abnormally long URL ({len(url)} chars)")
        elif len(url) > 75:
            score += 8
            reasons.append(f"▸ Long URL ({len(url)} chars)")
        
        # Multiple Subdomains
        subdomain_count = len(subdomain.split('.')) if subdomain else 0
        if subdomain_count >= 3:
            score += 25
            reasons.append(f"▸ Excessive subdomains ({subdomain_count}) - obfuscation attempt")
        elif subdomain_count == 2:
            score += 12
            reasons.append("▸ Multiple subdomains detected")
        
        # Suspicious TLD
        if f'.{tld}' in PhishingDetector.SUSPICIOUS_TLDS:
            score += 18
            reasons.append(f"▸ High-risk domain extension (.{tld})")
        
        # URL Shortener
        if any(short in domain for short in PhishingDetector.URL_SHORTENERS):
            score += 30
            reasons.append("▸ URL shortener - hides real destination")
        
        # Brand Impersonation
        brand_keywords = ['paypal', 'amazon', 'microsoft', 'apple', 'google', 'facebook',
                         'netflix', 'instagram', 'bank', 'secure', 'account', 'verify']
        for keyword in brand_keywords:
            if keyword in domain_info['subdomain'] or keyword in domain_info['path']:
                if not any(legit_domain in domain for legit_domain in PhishingDetector.LEGITIMATE_DOMAINS):
                    score += 40
                    reasons.append(f"▸ Possible brand impersonation: '{keyword}' in suspicious location")
                    break
        
         
        # 8. @ Symbol in URL (25 points)
        if '@' in url:
            score += 25
            reasons.append(" URL contains '@' symbol - credential phishing")
        
        # 9. Excessive Hyphens (15 points)
        hyphen_count = domain.count('-')
        if hyphen_count >= 4:
            score += 15
            reasons.append(f" Too many hyphens ({hyphen_count})")
        elif hyphen_count >= 2:
            score += 8
            reasons.append(" Multiple hyphens in domain")
        
        # 10. Digits in Domain (12 points)
        digit_count = sum(c.isdigit() for c in domain)
        if digit_count >= 4:
            score += 12
            reasons.append(f" Unusual digit count ({digit_count})")
        
        # 11. Suspicious Path Keywords (15 points)
        path_query = domain_info['path'] + domain_info['query']
        if re.search(r'(login|signin|account|verify|secure|update|confirm|password)', path_query, re.I):
            score += 15
            reasons.append(" Suspicious path: login/verify/account")
        
        # 12. Port Number (20 points)
        parsed = urlparse(url if url.startswith('http') else 'http://'+url)
        if parsed.port and parsed.port not in [80, 443]:
            score += 20
            reasons.append(f" Non-standard port: {parsed.port}")
    
        # 13. Homograph Attack (35 points)
        try:
            if domain != domain.encode('ascii').decode('ascii'):
                score += 35
                reasons.append(" Unicode/IDN homograph attack detected")
        except:
            score += 35
            reasons.append(" Non-ASCII characters - homograph attack")


        # Character Obfuscation
        obfuscation_patterns = [
            (r'[0O]', 'Zero/O substitution'),
            (r'[1lI]', 'One/l/I substitution'),
            (r'[5S]', 'Five/S substitution'),
        ]
        for pattern, desc in obfuscation_patterns:
            if re.search(pattern, domain):
                score += 10
                reasons.append(f"▸ Character obfuscation detected: {desc}")
        
        # Determine status
        if score < 30:
            status = 'safe'
        elif score < 60:
            status = 'suspicious'
        else:
            status = 'phishing'

        
        url_details = {
            'url': url,
            'domain': domain,
            'registered_domain': registered_domain,
            'subdomain': subdomain or 'none',
            'tld': tld,
            'protocol': protocol,
            'has_https': protocol == 'https',
            'url_length': len(url),
            'risk_level': status
        }
        
        return {
            'score': min(score, 100),
            'status': status,
            'reasons': reasons if reasons else ['No major threats detected'],
            'timestamp': datetime.now().isoformat(),
            'url_details': domain_info
        }
    
    @staticmethod
    def analyze_email(sender, subject, body):
        """Advanced Email Phishing Detection"""
        score = 0
        reasons = []
        
        sender_l = (sender or '').lower()
        subject_l = (subject or '').lower()
        body_l = (body or '').lower()
        full = f"{sender_l} {subject_l} {body_l}"
        
        # === EMAIL ANALYSIS ===
        
        # 1. Sender Analysis (20 points)
        if re.search(r'(no-?reply|do-?not-?reply|alert|notification|security)@', sender_l):
            score += 12
            reasons.append(" Generic sender (noreply/alert)")
        
        # Free provider for official email (20 points)
        if any(p in sender_l for p in ['gmail.com', 'yahoo.com', 'hotmail.com']):
            if re.search(r'(paypal|amazon|bank|irs|government)', full):
                score += 20
                reasons.append(" Official org using free email provider")
        
        # Brand mismatch (25 points)
        sender_domain = sender_l.split('@')[-1] if '@' in sender_l else ''
        for legit in PhishingDetector.LEGITIMATE_DOMAINS:
            brand = legit.split('.')[0]
            if brand in full and sender_domain != legit:
                score += 25
                reasons.append(f" Claims {legit} but sender is {sender_domain}")
                break
        
        # 2. Subject Analysis
        urgency_words = ['urgent', 'immediately', 'action required', 'verify now', 'act now', 
                        'expires', 'suspended', 'locked']
        if any(w in subject_l for w in urgency_words):
            score += 18
            reasons.append(" Urgency tactics in subject")
        
        if subject and subject.isupper() and len(subject) > 10:
            score += 12
            reasons.append(" ALL CAPS subject line")
        
        # 3. Body Analysis
        # Generic greeting (15 points)
        if re.search(r'dear (customer|user|member|client|account holder)', body_l):
            score += 15
            reasons.append(" Generic greeting - no personalization")
        
        # Credential requests (28 points)
        if re.search(r'(password|username|login|pin|ssn|social security|cvv)', body_l):
            score += 28
            reasons.append(" CRITICAL: Requests sensitive credentials")
        
        # Clickbait (20 points)
        if re.search(r'click (here|below|now)|follow this link|verify (now|immediately)', body_l):
            score += 20
            reasons.append(" Clickbait detected")
        
        # Account threats (25 points)
        if re.search(r'(account|service).{0,20}(suspend|close|lock|restrict|terminate)', body_l):
            score += 25
            reasons.append(" Threatens account closure")
        
        # Prize/reward (20 points)
        if re.search(r'(winner|congratulations|prize|reward|free|bonus|lottery)', body_l):
            score += 20
            reasons.append(" Prize/reward scam pattern")
        
        # Multiple URLs (15 points)
        url_count = len(re.findall(r'https?://', body))
        if url_count >= 3:
            score += 15
            reasons.append(f" Multiple URLs in body ({url_count})")
        
        # Attachment prompts (18 points)
        if re.search(r'(open|view|download|click).{0,15}(attachment|file|document)', body_l):
            score += 18
            reasons.append(" Prompts to open attachments")
        
        # Triple threat pattern (30 points)
        has_urgency = any(u in full for u in ['urgent', 'immediately', 'expires'])
        has_financial = any(f in full for f in ['payment', 'refund', 'account', 'credit card'])
        has_credential = any(c in full for c in ['password', 'verify', 'confirm', 'update'])
        
        if has_urgency and has_financial and has_credential:
            score += 30
            reasons.append(" CRITICAL: Urgency + Financial + Credential pattern")
        
        score = min(score, 100)
        
        if score >= 60:
            status, risk = 'phishing', 'HIGH RISK'
        elif score >= 30:
            status, risk = 'suspicious', 'MEDIUM RISK'
        else:
            status, risk = 'safe', 'LOW RISK'
        
        return {
            'score': score,
            'status': status,
            'reasons': reasons or [' No threats detected'],
            'timestamp': datetime.now().isoformat(),
            'email_details': {
                'sender': sender or 'N/A',
                'subject': subject or 'N/A',
                'body': (body[:200] + '...') if body and len(body) > 200 else body or 'N/A',
                'risk_level': risk
            }
        }

    

    @staticmethod
    def analyze_message(message):
        """Advanced SMS/Message Phishing Detection"""
        score = 0
        reasons = []
        
        if not message or not message.strip():
            return {'score': 0, 'status': 'safe', 'reasons': ['Empty message']}
        
        msg_l = message.lower()
        
        # === MESSAGE ANALYSIS ===
        
        # 1. Prize/Lottery/Cashback Scam (30 points)
        if re.search(r'\b(won|winner|congratulations|prize|lottery|reward|cashback|eligible)\b', msg_l):
            score += 30
            reasons.append("\u25b8 Prize/reward/cashback scam pattern")
        
        # 2. Money/Payment Requests (35 points)
        if re.search(r'(send|wire|transfer|pay).{0,20}(money|cash|payment|funds|fee)', msg_l) or \
           'gift card' in msg_l or 'bitcoin' in msg_l:
            score += 35
            reasons.append("\u25b8 CRITICAL: Money/payment request")
        
        # 3. Authority Impersonation - expanded to include Indian authorities (28 points)
        authorities = ['irs', 'fbi', 'police', 'government', 'social security', 'customs',
                       'rbi', 'sebi', 'income tax', 'trai', 'uidai', 'epfo', 'nsdl']
        for auth in authorities:
            if auth in msg_l:
                score += 28
                reasons.append(f"\u25b8 Impersonates authority: {auth.upper()}")
                break
        
        # 4. Banking/Financial Impersonation (22 points)
        if any(b in msg_l for b in ['bank', 'paypal', 'venmo', 'cashapp', 'zelle', 'upi',
                                     'credit card', 'debit card', 'card']):
            score += 22
            reasons.append("\u25b8 References financial institution or card details")
        
        # 5. URL in SMS (20 points)
        if re.search(r'https?://|www\.|hxxp', msg_l):
            score += 20
            reasons.append("\u25b8 Contains suspicious link")
            
            if any(s in msg_l for s in PhishingDetector.URL_SHORTENERS):
                score += 15
                reasons.append("\u25b8 Shortened URL - hides real destination")
        
        # 6. Urgency/Time Pressure - expanded to cover minutes too (18 points)
        if re.search(r'\b(urgent|immediately|asap|expire|within.{0,5}(24|48|12|20|30).{0,5}(hours?|mins?|hr|minutes?))\b', msg_l):
            score += 18
            reasons.append("\u25b8 Creates false urgency / time pressure")
        
        # 7. Account Threats (25 points)
        if re.search(r'(account|service|upi|wallet).{0,20}(suspend|deactivat|lock|block|restrict)', msg_l):
            score += 25
            reasons.append("\u25b8 Threatens account suspension or blocking")
        
        # 8. Credential/Sensitive Info Request - expanded to include card/CVV/OTP (32 points)
        if re.search(r'(confirm|verify|provide|update|enter|submit).{0,30}(ssn|password|pin|account number|card|cvv|otp|expiry)', msg_l):
            score += 32
            reasons.append("\u25b8 CRITICAL: Requests sensitive credentials (card/CVV/OTP/PIN)")
        
        # 9. Explicit Card Detail Harvesting (35 points)
        if re.search(r'\b(card number|card no|cvv|expiry date|card details)\b', msg_l):
            score += 35
            reasons.append("\u25b8 CRITICAL: Explicitly solicits card number, CVV, or expiry")
        
        # 10. Delivery Scam - expanded to cover 'failed' (20 points)
        if re.search(r'(package|parcel|delivery|shipment).{0,30}(pending|held|returned|failed|unpaid)', msg_l):
            score += 20
            reasons.append("\u25b8 Delivery/shipping fee scam")
        
        # 11. Verification Code Harvesting (18 points)
        if re.search(r'(verification|otp).{0,20}(code|number)', msg_l) and re.search(r'\b\d{4,8}\b', message):
            score += 18
            reasons.append("\u25b8 Unsolicited verification/OTP code harvesting")
        
        # 12. KYC Scam (25 points)
        if re.search(r'\b(kyc|know your customer)\b', msg_l):
            score += 25
            reasons.append("\u25b8 KYC update scam - common Indian phishing vector")
        
        # 13. Data Compromise / Extortion Threat (30 points)
        if re.search(r'(compromised|hacked|breach|exposed|leaked).{0,40}(data|account|financial|credential)', msg_l):
            score += 30
            reasons.append("\u25b8 CRITICAL: Data compromise/extortion threat to harvest credentials")
        
        # 14. Refund Harvesting Scam (25 points)
        if re.search(r'refund.{0,40}(pending|process|claim|receive|complete|enter)', msg_l):
            score += 25
            reasons.append("\u25b8 Refund harvesting scam - asks for card details to 'receive' refund")
        
        score = min(score, 100)
        
        if score >= 60:
            status = 'phishing'
        elif score >= 30:
            status = 'suspicious'
        else:
            status = 'safe'
        
        return {
            'score': score,
            'status': status,
            'reasons': reasons or ['\u2713 No threats detected'],
            'timestamp': datetime.now().isoformat()
        }



# Database Helper
def save_scan_to_db(user_id, scan_type, scan_subtype, input_content, risk_score, status, detection_reasons, ip_address, user_agent, extra_details=None):
    conn = get_db_connection()
    if not conn: return False
    cursor = None
    try:
        cursor = conn.cursor()
        
        query = """INSERT INTO scan_history 
                   (user_id, scan_type, scan_subtype, input_content, risk_score, status, detection_reasons, ip_address, user_agent) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        cursor.execute(query, (user_id, scan_type, scan_subtype, input_content[:1000], risk_score, status, json.dumps(detection_reasons), ip_address, user_agent))
        scan_id = cursor.lastrowid
        
        if scan_type == 'email' and extra_details:
            cursor.execute("INSERT INTO email_scan_details (scan_id, sender_email, subject, body) VALUES (%s, %s, %s, %s)",
                          (scan_id, extra_details.get('sender', ''), extra_details.get('subject', ''), extra_details.get('body', '')))
        
        elif scan_type == 'url' and extra_details:
            cursor.execute("INSERT INTO url_scan_details (scan_id, url, domain, protocol, has_https, url_length) VALUES (%s, %s, %s, %s, %s, %s)",
                          (scan_id, extra_details.get('url', '')[:500], extra_details.get('domain', '')[:255], extra_details.get('protocol', '')[:10], extra_details.get('has_https', False), extra_details.get('url_length', 0)))
        
        if user_id:
            safe_inc = 1 if status == 'safe' else 0
            susp_inc = 1 if status == 'suspicious' else 0
            phish_inc = 1 if status == 'phishing' else 0
            cursor.execute("""INSERT INTO user_statistics (user_id, total_scans, safe_scans, suspicious_scans, phishing_scans)
                             VALUES (%s, 1, %s, %s, %s)
                             ON DUPLICATE KEY UPDATE total_scans = total_scans + 1,
                             safe_scans = safe_scans + %s, suspicious_scans = suspicious_scans + %s,
                             phishing_scans = phishing_scans + %s, last_updated = CURRENT_TIMESTAMP""",
                          (user_id, safe_inc, susp_inc, phish_inc, safe_inc, susp_inc, phish_inc))
        
        conn.commit()
        print(f"✓ Saved {scan_type} scan (Score: {risk_score}, Status: {status})")
        return True
    except Error as e:
        print(f"✗ DB Error: {e}")
        if conn: conn.rollback()
        return False
    finally:
        close_db_connection(conn, cursor)


# ========================================
# ROUTE HANDLERS
# ========================================

# Home Route - Redirects to login
@app.route('/')
def home():
    return redirect(url_for('login_page'))

# Login Page Route
@app.route('/login')
def login_page():
    return render_template('login.html')

# Register Page Route
@app.route('/register')
def register_page():
    return render_template('register.html')

# Main App Route (requires login)
@app.route('/index')
def app_page():
    # In production, you'd check session here
    return render_template('index.html')

# Admin Page Route
@app.route('/admin')
def admin_page_ui():
    return render_template('admin.html')

# ========================================
# API ROUTES
# ========================================

# Health Check
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'ok', 'message': 'API is running'}), 200

# User Registration
@app.route('/api/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        
        # Validate required fields
        required = ['firstName', 'lastName', 'email', 'username', 'password']
        if not all(k in data for k in required):
            return jsonify({'success': False, 'message': 'Missing required fields'}), 400
        
        email = data['email'].strip()
        username = data['username'].strip()
        password = data['password']
        
        # Validate email
        if not validate_email(email):
            return jsonify({'success': False, 'message': 'Invalid email format'}), 400
        
        # Validate password
        valid, msg = validate_password(password)
        if not valid:
            return jsonify({'success': False, 'message': msg}), 400
        
        # Check if user exists
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id FROM users WHERE email = %s OR username = %s", (email, username))
        existing = cursor.fetchone()
        
        if existing:
            close_db_connection(conn, cursor)
            return jsonify({'success': False, 'message': 'Email or username already exists'}), 409
        
        # Hash password and insert user
        hashed = hash_password(password)
        cursor.execute("""
            INSERT INTO users (first_name, last_name, email, username, password, created_at)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (data['firstName'], data['lastName'], email, username, hashed, datetime.now()))
        
        conn.commit()
        close_db_connection(conn, cursor)
        
        return jsonify({'success': True, 'message': 'Registration successful'}), 201
        
    except Exception as e:
        print(f"Registration error: {e}")
        return jsonify({'success': False, 'message': 'Registration failed'}), 500

# User Login
@app.route('/api/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data.get('email', '').strip()
        password = data.get('password', '')
        
        if not email or not password:
            return jsonify({'success': False, 'message': 'Email and password required'}), 400
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        
        if not user:
            close_db_connection(conn, cursor)
            return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
        
        if not verify_password(password, user['password']):
            close_db_connection(conn, cursor)
            return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
        
        # Update last login
        cursor.execute("UPDATE users SET last_login = %s WHERE id = %s", (datetime.now(), user['id']))
        conn.commit()
        close_db_connection(conn, cursor)
        
        # Set session
        session['user_id'] = user['id']
        session['email'] = user['email']
        session['username'] = user['username']
        session.permanent = True
        
        return jsonify({'success': True, 'message': 'Login successful', 'user': user['username']}), 200
        
    except Exception as e:
        print(f"Login error: {e}")
        return jsonify({'success': False, 'message': 'Login failed'}), 500

# Admin Login
@app.route('/api/admin/login', methods=['POST'])
def admin_login():
    try:
        data = request.get_json()
        username = data.get('username', '').strip()
        password = data.get('password', '')
        
        print(f"[ADMIN LOGIN] Attempt - Username: {username}")
        
        # Simple admin check
        if username == 'admin' and password == 'admin123':
            session.clear()
            session['admin'] = True
            session['admin_username'] = username
            session.permanent = True
            session.modified = True
            
            print(f"[ADMIN LOGIN] Success - Session set: {dict(session)}")
            
            return jsonify({
                'success': True, 
                'message': 'Admin login successful',
                'redirect': '/admin'
            }), 200
        else:
            print(f"[ADMIN LOGIN] Failed - Invalid credentials")
            return jsonify({'success': False, 'message': 'Invalid admin credentials'}), 401
            
    except Exception as e:
        print(f"[ADMIN LOGIN ERROR] {e}")
        return jsonify({'success': False, 'message': 'Admin login failed'}), 500

# URL Scan
@app.route('/api/scan/url', methods=['POST'])
def scan_url():
    try:
        data = request.get_json()
        url = data.get('url', '').strip()
        
        if not url:
            return jsonify({'success': False, 'message': 'URL is required'}), 400
        
        result = PhishingDetector.analyze_url(url)
        
        
        url_extra = None
        if result.get('url_details'):
            d = result['url_details']
            url_extra = {
                'url': url,
                'domain': d.get('full_domain', ''),
                'protocol': d.get('protocol', ''),
                'has_https': d.get('protocol', '') == 'https',
                'url_length': len(url)
            }
        save_scan_to_db(
            user_id=session.get('user_id'),
            scan_type='url',
            scan_subtype=None,
            input_content=url,
            risk_score=result['score'],
            status=result['status'],
            detection_reasons=result['reasons'],
            ip_address=request.remote_addr,
            user_agent=request.headers.get('User-Agent', ''),
            extra_details=url_extra
        )

        # except Exception as db_error:
        #        print(f"Database error while saving scan: {db_error}")
        
        return jsonify({
            'success': True,
            'score': result['score'],
            'status': result['status'],
            'reasons': result['reasons']
        }), 200
        
    except Exception as e:
        print(f"URL scan error: {e}")
        return jsonify({'success': False, 'message': 'Scan failed'}), 500

# Email Scan
@app.route('/api/scan/email', methods=['POST'])
def scan_email():
    try:
        data = request.get_json()
        sender = data.get('sender', '').strip()
        subject = data.get('subject', '').strip()
        body = data.get('body', '').strip()
        
        
        score = 0
        reasons = []

        content = f"From: {sender}\nSubject: {subject}\n\n{body}"
        result = PhishingDetector.analyze_email(sender, subject, body)
        
        # Basic email phishing detection logic
        phishing_keywords = ['urgent', 'verify', 'suspended', 'confirm', 'click here', 
                           'winner', 'prize', 'free', 'act now', 'password']
        
        text = f"{sender} {subject} {body}".lower()
        
        for keyword in phishing_keywords:
            if keyword in text:
                score += 15
                reasons.append(f"▸ Suspicious keyword detected: '{keyword}'")
        
        # Check sender domain
        if sender and '@' in sender:
            domain = sender.split('@')[1]
            if not any(legit in domain for legit in PhishingDetector.LEGITIMATE_DOMAINS):
                score += 10
                reasons.append("▸ Unknown sender domain")

        save_scan_to_db(
            user_id=session.get('user_id'),
            scan_type='email',
            scan_subtype=None,
            input_content=content,
            risk_score=result['score'],
            status=result['status'],
            detection_reasons=result['reasons'],
            ip_address=request.remote_addr,
            user_agent=request.headers.get('User-Agent', ''),
            extra_details=result.get('email_details')
        )
        
        return jsonify({
            'success': True,
            'score': result['score'],
            'status': result['status'],
            'reasons': result['reasons'],
            'timestamp': result['timestamp']
        }), 200
        
    except Exception as e:
        print(f"Email scan error: {e}")
        return jsonify({'success': False, 'message': 'Scan failed'}), 500

# Message Scan
@app.route('/api/scan/message', methods=['POST'])
def scan_message():
    try:
        data = request.get_json()
        message = data.get('message', '').strip()

        result = PhishingDetector.analyze_message(message)
        
        score = 0
        reasons = []
        
        # Basic SMS phishing detection
        phishing_patterns = ['click', 'link', 'verify', 'urgent', 'suspended', 
                           'prize', 'won', 'free', 'confirm']
        
        text = message.lower()
        
        for pattern in phishing_patterns:
            if pattern in text:
                score += 15
                reasons.append(f"▸ Suspicious pattern detected: '{pattern}'")
        
        # Check for URLs
        if re.search(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', message):
            score += 20
            reasons.append("▸ Contains suspicious URL")
        
        save_scan_to_db(
            user_id=session.get('user_id'),
            scan_type='message',
            scan_subtype='sms',
            input_content=message,
            risk_score=result['score'],
            status=result['status'],
            detection_reasons=result['reasons'],
            ip_address=request.remote_addr,
            user_agent=request.headers.get('User-Agent', '')
        )
        
        
        return jsonify({
            'success': True,
            'score': result['score'],
            'status': result['status'],
            'reasons': result['reasons'],
            'timestamp': result['timestamp']
        }), 200
        
    except Exception as e:
        print(f"Message scan error: {e}")
        return jsonify({'success': False, 'message': 'Scan failed'}), 500


# ===================================================
# ADMIN PANEL API ROUTES (MATCHED WITH JS FETCH CALLS)
# ===================================================

# Logout
@app.route('/api/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({'success': True, 'message': 'Logged out successfully'}), 200

# ========================================
# ADMIN DASHBOARD STATS
# ========================================
@app.route('/api/admin/dashboard-stats', methods=['GET'])
def admin_dashboard_stats():
    try:
        filter_period = request.args.get('filter', 'all')

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # ---------------- TIME FILTER ----------------
        if filter_period == 'today':
            time_clause = "scan_timestamp >= CURDATE()"
        elif filter_period == 'week':
            time_clause = "scan_timestamp >= NOW() - INTERVAL 7 DAY"
        elif filter_period == 'month':
            time_clause = "scan_timestamp >= NOW() - INTERVAL 30 DAY"
        else:
            time_clause = "1=1"  # ALL TIME

        # ---------------- TOTAL SCANS ----------------
        cursor.execute(f"""
            SELECT COUNT(*) AS cnt
            FROM scan_history
            WHERE {time_clause}
        """)
        total_scans = cursor.fetchone()['cnt']

        # ---------------- TOTAL THREATS ----------------
        cursor.execute(f"""
            SELECT COUNT(*) AS cnt
            FROM scan_history
            WHERE status IN ('phishing','suspicious')
              AND {time_clause}
        """)
        total_threats = cursor.fetchone()['cnt']

        # ---------------- ACTIVE USERS ----------------
        cursor.execute("""
            SELECT COUNT(*) AS cnt
            FROM users
            WHERE last_login >= NOW() - INTERVAL 30 DAY
        """)
        active_users = cursor.fetchone()['cnt']

        # ---------------- safe Scan ----------------
        threat_rate = round((total_threats / total_scans) * 100, 2) if total_scans else 0

        close_db_connection(conn, cursor)

        return jsonify({
            "success": True,
            "stats": {
                "total_scans": total_scans,
                "total_threats": total_threats,
                "total_users": active_users ,
                "detection_accuracy": round(100 - threat_rate, 2)
            }
        }), 200

    except Exception as e:
        print("[ADMIN STATS ERROR]", e)
        return jsonify({"success": False}), 500

    
@app.route('/api/admin/recent-activity', methods=['GET'])
def admin_recent_activity():
    try:
        limit = int(request.args.get('limit', 10))

        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'}), 500

        cursor = conn.cursor(dictionary=True)
        activities = []

        # -------- SCANS --------
        cursor.execute("""
            SELECT sh.scan_type, sh.status, sh.risk_score,
                   sh.scan_timestamp, u.username
            FROM scan_history sh
            LEFT JOIN users u ON sh.user_id = u.id
            ORDER BY sh.scan_timestamp DESC
            LIMIT %s
        """, (limit,))
        for r in cursor.fetchall():
            activities.append({
                "message": f"{r['username'] or 'Anonymous'} performed {r['scan_type']} scan "
                           f"- {r['status']} (score: {r['risk_score']})",
                "timestamp": r['scan_timestamp'].strftime('%Y-%m-%d %H:%M:%S')
            })

        # -------- USERS --------
        cursor.execute("""
            SELECT username, created_at
            FROM users
            ORDER BY created_at DESC
            LIMIT %s
        """, (limit,))
        for u in cursor.fetchall():
            activities.append({
                "message": f"New user registered: {u['username']}",
                "timestamp": u['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            })

        close_db_connection(conn, cursor)

        activities.sort(key=lambda x: x['timestamp'], reverse=True)

        return jsonify({
            "success": True,
            "activities": activities[:limit]
        }), 200

    except Exception as e:
        print("[ADMIN ACTIVITY ERROR]", e)
        return jsonify({'success': False, 'message': 'Failed to fetch activity'}), 500


# ========================================
# ADMIN THREATS LIST
# ========================================
@app.route('/api/admin/threats', methods=['GET'])
def admin_threats():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT scan_type AS type,
                   status,
                   risk_score AS score,
                   scan_timestamp AS time,
                   input_content AS description
            FROM scan_history
            WHERE status IN ('suspicious','phishing')
            ORDER BY scan_timestamp DESC
            LIMIT 50
        """)

        threats = cursor.fetchall()
        close_db_connection(conn, cursor)

        return jsonify({
            "success": True,
            "threats": threats
        }), 200

    except Exception as e:
        print("[ADMIN THREATS ERROR]", e)
        return jsonify({'success': False}), 500


# ========================================
# ADMIN USERS LIST
# ========================================
@app.route("/api/admin/users", methods=["GET"])
def admin_users():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # TOTAL USERS COUNT
        cursor.execute("SELECT COUNT(*) AS total FROM users")
        total_users = cursor.fetchone()["total"]

        # USER DETAILS WITH STATS
        cursor.execute("""
            SELECT
                u.id,
                u.username,
                u.email,
                u.created_at,
                u.last_login,

                COUNT(sh.id) AS total_scans,
                SUM(
                    CASE 
                        WHEN sh.status IN ('phishing', 'suspicious') 
                        THEN 1 ELSE 0 
                    END
                ) AS total_threats

            FROM users u
            LEFT JOIN scan_history sh ON sh.user_id = u.id
            GROUP BY u.id
            ORDER BY u.created_at DESC
        """)

        users = cursor.fetchall()

        formatted_users = []
        for u in users:
            formatted_users.append({
                "name": u["username"],
                "email": u["email"],
                "joining_date": (
                    u["created_at"].strftime("%Y-%m-%d")
                    if u["created_at"] else "—"
                ),
                "last_active": (
                    u["last_login"].strftime("%Y-%m-%d %H:%M")
                    if u["last_login"] else "Never"
                ),
                "status": "Active" if u["last_login"] else "Inactive"
            })

        # close_db(conn, cursor)

        return jsonify({
            "success": True,
            "total_users": total_users,
            "users": formatted_users
        }), 200

    except Exception as e:
        print("[ADMIN USERS ERROR]", e)
        return jsonify({
            "success": False,
            "message": "Failed to fetch users"
        }), 500


# ========================================
# RUN SERVER
# ========================================  

if __name__ == '__main__':
    print("="*50)
    print("PhishGuard Pro - Backend Server")
    print("="*50)
    print(f"Database: {DB_CONFIG['database']}@{DB_CONFIG['host']}")
    print(f"Server: http://localhost:3360")
    print("\nFeatures:")
    print("✓ User Authentication")
    print("✓ Admin Panel")
    print("✓ Phishing Detection")
    print("✓ Multi-type Scanning")
    print("="*50)
    
    conn = get_db_connection()
    if conn:
        print("✓ Database Connected")
        conn.close()
    else:
        print("✗ Database Connection Failed")
    
    print("="*50)
    app.run(host='0.0.0.0', port=3360, debug=True)