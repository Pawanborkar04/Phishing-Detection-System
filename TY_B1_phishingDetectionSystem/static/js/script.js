// ========================================
// PhishGuard Pro - Main JavaScript with API Integration
// ========================================

const API_BASE_URL = 'http://localhost:3360/api';

// Global State
let scanHistory = [];
let currentBankingType = 'credit-card';

// ========================================
// Initialization
// ========================================

document.addEventListener('DOMContentLoaded', () => {
    loadScanHistory();
    initNavigation();
    updateDashboard();
    checkAPIHealth();
});

// Check if API is running
async function checkAPIHealth() {
    try {
        const response = await fetch(`${API_BASE_URL}/health`);
        if (response.ok) {
            console.log(' API connected successfully');
        }
    } catch (error) {
        console.error(' API connection failed:', error);
        alert('Warning: Backend API is not running. Please start the Flask server first.\n\nRun: python app.py');
    }
}

// ========================================
// Navigation
// ========================================

function initNavigation() {
    const navButtons = document.querySelectorAll('[data-page]');
    
    navButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const page = btn.getAttribute('data-page');
            navigateToPage(page);
        });
    });
}

function navigateToPage(pageName) {
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });
    
    const targetPage = document.getElementById(`page-${pageName}`);
    if (targetPage) {
        targetPage.classList.add('active');
    }
    
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-page') === pageName) {
            btn.classList.add('active');
        }
    });
    
    if (pageName === 'dashboard') {
        updateDashboard();
    }
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// ========================================
// API Scan Functions
// ========================================

async function scanURL() {
    const input = document.getElementById('url-input').value.trim();
    if (!input) {
        alert('Please enter a URL to scan');
        return;
    }
    
    showLoading();
    
    try {
        const response = await fetch(`${API_BASE_URL}/scan/url`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ url: input })
        });
        
        if (!response.ok) throw new Error('Scan failed');
        
        const data = await response.json();
        const result = createScanResult(input, 'URL Analysis', data, 'fas fa-link');
        displayResult('url-result', result);
        saveScanHistory(result);
        
    } catch (error) {
        console.error('Scan error:', error);
        alert('Scan failed. Make sure the Flask server is running (python app.py)');
    } finally {
        hideLoading();
    }
}

async function scanEmail() {
    const sender = document.getElementById('email-sender').value.trim();
    const subject = document.getElementById('email-subject').value.trim();
    const body = document.getElementById('email-body').value.trim();
    
    if (!sender && !subject && !body) {
        alert('Please enter email details to scan');
        return;
    }
    
    showLoading();
    
    try {
        const response = await fetch(`${API_BASE_URL}/scan/email`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sender, subject, body })
        });
        
        if (!response.ok) throw new Error('Scan failed');
        
        const data = await response.json();
        const emailText = `From: ${sender}\nSubject: ${subject}\n\n${body}`;
        const result = createScanResult(emailText, 'Email Analysis', data, 'fas fa-envelope');
        displayResult('email-result', result);
        saveScanHistory(result);
        
    } catch (error) {
        console.error('Scan error:', error);
        alert('Scan failed. Make sure the Flask server is running (python app.py)');
    } finally {
        hideLoading();
    }
}

async function scanMessage() {
    const input = document.getElementById('message-input').value.trim();
    if (!input) {
        alert('Please enter a message to scan');
        return;
    }
    
    showLoading();
    
    try {
        const response = await fetch(`${API_BASE_URL}/scan/message`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: input })
        });
        
        if (!response.ok) throw new Error('Scan failed');
        
        const data = await response.json();
        const result = createScanResult(input, 'Message Analysis', data, 'fas fa-comment-dots');
        displayResult('message-result', result);
        saveScanHistory(result);
        
    } catch (error) {
        console.error('Scan error:', error);
        alert('Scan failed. Make sure the Flask server is running (python app.py)');
    } finally {
        hideLoading();
    }
}


// ========================================
// Banking Type Selection
// ========================================

function selectBankingType(type) {
    currentBankingType = type;
    
    document.querySelectorAll('.banking-type-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-type') === type) {
            btn.classList.add('active');
        }
    });
    
    if (type === 'credit-card') {
        document.getElementById('credit-card-form').style.display = 'block';
        document.getElementById('account-form').style.display = 'none';
    } else {
        document.getElementById('credit-card-form').style.display = 'none';
        document.getElementById('account-form').style.display = 'block';
    }
    
    document.getElementById('banking-result').innerHTML = '';
}

// ========================================
// Result Processing
// ========================================

function createScanResult(input, type, detection, icon) {
    return {
        input: input.substring(0, 150) + (input.length > 150 ? '...' : ''),
        type: type,
        score: detection.score,
        status: detection.status,
        reasons: detection.reasons,
        timestamp: new Date(detection.timestamp).toLocaleString(),
        icon: icon
    };
}

function displayResult(containerId, result) {
    const container = document.getElementById(containerId);
    
    const config = {
        safe: {
            color: '#10b981',
            gradient: 'linear-gradient(135deg, #10b981, #34d399)',
            title: 'SECURE'
        },
        suspicious: {
            color: '#f59e0b',
            gradient: 'linear-gradient(135deg, #f59e0b, #fbbf24)',
            title: 'SUSPICIOUS'
        },
        phishing: {
            color: '#ef4444',
            gradient: 'linear-gradient(135deg, #ef4444, #f87171)',
            title: 'THREAT DETECTED'
        }
    };
    
    const cfg = config[result.status];
    const circumference = 2 * Math.PI * 60;
    const offset = circumference * (1 - result.score / 100);
    
    const statusIcons = {
        safe: 'fa-check-circle',
        suspicious: 'fa-exclamation-triangle',
        phishing: 'fa-times-circle'
    };
    
    let reasonsHTML = '';
    if (result.reasons.length > 0) {
        const itemColor = result.score >= 60 ? '#ef4444' : result.score >= 30 ? '#f59e0b' : '#10b981';
        reasonsHTML = `
            <div class="result-analysis">
                <div class="result-analysis-header">
                    <i class="fas fa-microchip" style="color: ${cfg.color}"></i>
                    <h4 style="color: #fff">THREAT ANALYSIS</h4>
                </div>
                <div class="result-reasons">
                    ${result.reasons.map((reason, idx) => `
                        <div class="result-reason" style="
                            background: ${itemColor}10;
                            border-color: ${itemColor}30;
                            box-shadow: 0 0 15px ${itemColor}20;
                        ">
                            <div class="result-reason-number" style="background: ${itemColor}">
                                ${idx + 1}
                            </div>
                            <p class="result-reason-text">${reason}</p>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    }
    
    const recommendations = {
        safe: `
            <p class="result-recommendations-title" style="color: #10b981">✓ CONTENT APPEARS LEGITIMATE</p>
            <ul class="result-recommendations-list">
                <li>• Verify sender through official channels</li>
                <li>• Never share passwords or sensitive data</li>
                <li>• Remain vigilant with unexpected communications</li>
            </ul>
        `,
        suspicious: `
            <p class="result-recommendations-title" style="color: #f59e0b"> EXERCISE EXTREME CAUTION</p>
            <ul class="result-recommendations-list">
                <li>• Verify sender identity through official methods</li>
                <li>• Do not click links or download attachments</li>
                <li>• Contact organization using known numbers</li>
                <li>• Report suspicious content to authorities</li>
            </ul>
        `,
        phishing: `
            <p class="result-recommendations-title" style="color: #ef4444; font-weight: 900"> CRITICAL THREAT DETECTED</p>
            <ul class="result-recommendations-list" style="font-weight: 700">
                <li>• DO NOT CLICK ANY LINKS</li>
                <li>• DO NOT PROVIDE ANY INFORMATION</li>
                <li>• DO NOT DOWNLOAD ATTACHMENTS</li>
                <li>• DELETE IMMEDIATELY</li>
                <li>• REPORT TO: reportphishing@apwg.org</li>
            </ul>
        `
    };
    
    container.innerHTML = `
        <div class="result-card" style="border-color: ${cfg.color}">
            <div class="result-grid-bg" style="
                background-image: 
                    linear-gradient(${cfg.color} 1px, transparent 1px),
                    linear-gradient(90deg, ${cfg.color} 1px, transparent 1px);
                background-size: 30px 30px;
                animation: gridMove 20s linear infinite;
            "></div>
            
            <div class="result-corners result-corner-tl" style="background: ${cfg.color}"></div>
            <div class="result-corners result-corner-br" style="background: ${cfg.color}"></div>
            
            <div style="position: relative;">
                <div class="result-header">
                    <div class="result-status">
                        <div class="result-status-icon" style="
                            background: ${cfg.gradient};
                            box-shadow: 0 0 30px ${cfg.color}50;
                        ">
                            <i class="fas ${statusIcons[result.status]}"></i>
                        </div>
                        <div class="result-status-text">
                            <h3 style="color: #fff">${cfg.title}</h3>
                            <div class="result-type" style="color: ${cfg.color}">
                                <i class="${result.icon}"></i>
                                <span>${result.type}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="result-progress">
                        <svg>
                            <defs>
                                <linearGradient id="grad-${result.score}">
                                    <stop offset="0%" stop-color="${cfg.color}" stop-opacity="0.3" />
                                    <stop offset="100%" stop-color="${cfg.color}" />
                                </linearGradient>
                                <filter id="glow">
                                    <feGaussianBlur stdDeviation="4" result="coloredBlur"/>
                                    <feMerge>
                                        <feMergeNode in="coloredBlur"/>
                                        <feMergeNode in="SourceGraphic"/>
                                    </feMerge>
                                </filter>
                            </defs>
                            <circle cx="65" cy="65" r="60" stroke="#ffffff15" stroke-width="8" fill="none"/>
                            <circle 
                                cx="65" cy="65" r="60" 
                                stroke="url(#grad-${result.score})"
                                stroke-width="8" fill="none"
                                stroke-dasharray="${circumference}"
                                stroke-dashoffset="${offset}"
                                stroke-linecap="round"
                                filter="url(#glow)"
                                style="transition: stroke-dashoffset 1s ease;"
                            />
                        </svg>
                        <div class="result-progress-value">
                            <div class="result-progress-score">${result.score}</div>
                            <div class="result-progress-label">RISK LEVEL</div>
                        </div>
                    </div>
                </div>
                
                <div class="result-zones">
                    <div class="result-zone ${result.score >= 30 ? 'result-zone-inactive' : ''}" style="
                        border-color: ${result.score < 30 ? '#10b981' : '#ffffff20'};
                        background: ${result.score < 30 ? '#10b98120' : '#ffffff05'};
                        box-shadow: ${result.score < 30 ? '0 0 20px #10b98140' : 'none'};
                    ">
                        <div class="result-zone-range" style="color: #10b981">0-30</div>
                        <div class="result-zone-label">SAFE</div>
                    </div>
                    <div class="result-zone ${result.score < 30 || result.score >= 60 ? 'result-zone-inactive' : ''}" style="
                        border-color: ${result.score >= 30 && result.score < 60 ? '#f59e0b' : '#ffffff20'};
                        background: ${result.score >= 30 && result.score < 60 ? '#f59e0b20' : '#ffffff05'};
                        box-shadow: ${result.score >= 30 && result.score < 60 ? '0 0 20px #f59e0b40' : 'none'};
                    ">
                        <div class="result-zone-range" style="color: #f59e0b">31-60</div>
                        <div class="result-zone-label">SUSPICIOUS</div>
                    </div>
                    <div class="result-zone ${result.score < 60 ? 'result-zone-inactive' : ''}" style="
                        border-color: ${result.score >= 60 ? '#ef4444' : '#ffffff20'};
                        background: ${result.score >= 60 ? '#ef444420' : '#ffffff05'};
                        box-shadow: ${result.score >= 60 ? '0 0 20px #ef444440' : 'none'};
                    ">
                        <div class="result-zone-range" style="color: #ef4444">61+</div>
                        <div class="result-zone-label">PHISHING</div>
                    </div>
                </div>
                
                <div class="result-content">
                    <div class="result-content-header">
                        <i class="fas fa-eye" style="color: ${cfg.color}"></i>
                        <span>Analyzed Content</span>
                    </div>
                    <p class="result-content-text">${result.input}</p>
                </div>
                
                ${reasonsHTML}
                
                <div class="result-recommendations" style="
                    background: ${cfg.color}10;
                    border-color: ${cfg.color}50;
                    box-shadow: 0 0 30px ${cfg.color}20;
                ">
                    <div class="result-recommendations-header">
                        <i class="fas fa-shield-alt" style="color: ${cfg.color}"></i>
                        <h4 style="color: #fff">SECURITY PROTOCOL</h4>
                    </div>
                    <div class="result-recommendations-content">
                        ${recommendations[result.status]}
                    </div>
                </div>
                
                <div class="result-timestamp">
                    <i class="fas fa-clock"></i>
                    <span>Scan completed: ${result.timestamp}</span>
                </div>
            </div>
        </div>
    `;
    
    setTimeout(() => {
        container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }, 100);
}

// ========================================
// Dashboard
// ========================================

function updateDashboard() {
    const container = document.getElementById('dashboard-content');
    
    if (scanHistory.length === 0) {
        container.innerHTML = `
            <div class="dashboard-empty">
                <i class="fas fa-file-alt"></i>
                <h3>NO SCANS RECORDED</h3>
                <p>Initiate threat analysis to populate dashboard</p>
                <button class="dashboard-btn" onclick="navigateToPage('home')">
                    <i class="fas fa-rocket"></i>
                    <span>START SCANNING</span>
                </button>
            </div>
        `;
        return;
    }
    
    const stats = {
        total: scanHistory.length,
        safe: scanHistory.filter(s => s.status === 'safe').length,
        suspicious: scanHistory.filter(s => s.status === 'suspicious').length,
        phishing: scanHistory.filter(s => s.status === 'phishing').length
    };
    
    container.innerHTML = `
        <div class="dashboard-stats">
            <div class="dashboard-stat">
                <div class="dashboard-stat-value" style="color: #61deed">${stats.total}</div>
                <div class="dashboard-stat-label">TOTAL</div>
            </div>
            <div class="dashboard-stat">
                <div class="dashboard-stat-value" style="color: #10b981">${stats.safe}</div>
                <div class="dashboard-stat-label">SECURE</div>
            </div>
            <div class="dashboard-stat">
                <div class="dashboard-stat-value" style="color: #f59e0b">${stats.suspicious}</div>
                <div class="dashboard-stat-label">SUSPICIOUS</div>
            </div>
            <div class="dashboard-stat">
                <div class="dashboard-stat-value" style="color: #ef4444">${stats.phishing}</div>
                <div class="dashboard-stat-label">THREATS</div>
            </div>
        </div>
        
        <div class="dashboard-history">
            <h3>RECENT ACTIVITY</h3>
            ${scanHistory.map(scan => {
                const colors = {
                    safe: { bg: '#10b98110', border: '#10b981', text: '#10b981' },
                    suspicious: { bg: '#f59e0b10', border: '#f59e0b', text: '#f59e0b' },
                    phishing: { bg: '#ef444410', border: '#ef4444', text: '#ef4444' }
                };
                const color = colors[scan.status];
                
                return `
                    <div class="dashboard-item" style="
                        background: ${color.bg};
                        border-color: ${color.border};
                    ">
                        <div class="dashboard-item-header">
                            <div class="dashboard-item-type">
                                <i class="${scan.icon}" style="color: ${color.text}"></i>
                                <span>${scan.type}</span>
                            </div>
                            <div class="dashboard-item-status">
                                <div class="dashboard-item-badge" style="color: ${color.text}">
                                    ${scan.status.toUpperCase()}
                                </div>
                                <div class="dashboard-item-score" style="color: ${color.text}">
                                    ${scan.score}
                                </div>
                            </div>
                        </div>
                        <p class="dashboard-item-content">${scan.input}</p>
                        <div class="dashboard-item-time">
                            <i class="fas fa-clock"></i>
                            <span>${scan.timestamp}</span>
                        </div>
                    </div>
                `;
            }).join('')}
        </div>
    `;
}

// ========================================
// LocalStorage Functions
// ========================================

function loadScanHistory() {
    try {
        const saved = localStorage.getItem('phishguard_history');
        if (saved) {
            scanHistory = JSON.parse(saved);
        }
    } catch (e) {
        console.error('Error loading scan history:', e);
        scanHistory = [];
    }
}

function saveScanHistory(result) {
    try {
        scanHistory.unshift(result);
        scanHistory = scanHistory.slice(0, 20);
        localStorage.setItem('phishguard_history', JSON.stringify(scanHistory));
    } catch (e) {
        console.error('Error saving scan history:', e);
    }
}

// ========================================
// Loading Overlay
// ========================================

function showLoading() {
    document.getElementById('loading-overlay').classList.add('active');
}

function hideLoading() {
    document.getElementById('loading-overlay').classList.remove('active');
}
// Logout function
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '/login';
            }
        }