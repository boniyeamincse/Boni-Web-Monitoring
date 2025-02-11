# Boni-Web-Monitoring User Guide
Version: 1.0.0
Author: Boni Yeamin
Last Updated: 2024

## Table of Contents
1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
3. [Using Grafana](#3-using-grafana)
4. [Using Uptime Kuma](#4-using-uptime-kuma)
5. [Alerts & Notifications](#5-alerts--notifications)
6. [Best Practices](#6-best-practices)
7. [FAQ](#7-faq)

## 1. Introduction

### 1.1 Overview
Boni-Web-Monitoring is an integrated monitoring solution that helps you track:
- Website uptime and performance
- System metrics and resources
- Application logs
- Custom metrics
- Service health

### 1.2 Access Information
```plaintext
Main Dashboard: http://your-domain:3000
Uptime Monitor: http://your-domain:3001
Default Credentials:
  Username: admin
  Password: admin (change on first login)
```

## 2. Getting Started

### 2.1 First Login
1. Open Grafana (http://your-domain:3000)
2. Login with default credentials
3. Change your password when prompted
4. Review the welcome dashboard

### 2.2 Navigation
```plaintext
Main Menu (Left Sidebar):
├── Dashboards
├── Explore
├── Alerting
├── Configuration
└── Help
```

## 3. Using Grafana

### 3.1 Viewing Dashboards
1. Click "Dashboards" in the left sidebar
2. Select from available options:
   - System Overview
   - Service Metrics
   - Security Dashboard

### 3.2 Creating Custom Dashboards
```plaintext
1. Click "+ Create" → "Dashboard"
2. Add panels:
   - Graph
   - Stat
   - Table
   - Logs
3. Configure data sources:
   - Prometheus for metrics
   - Loki for logs
```

### 3.3 Common Operations
```plaintext
Time Range Selection:
├── Last 6 hours (default)
├── Last 12 hours
├── Last 24 hours
└── Custom range

Refresh Intervals:
├── Off
├── 5s
├── 10s
└── Custom
```

## 4. Using Uptime Kuma

### 4.1 Adding Monitors
1. Access Uptime Kuma (http://your-domain:3001)
2. Click "Add New Monitor"
3. Select monitor type:
   ```plaintext
   ├── HTTP(s)
   ├── TCP Port
   ├── Ping
   ├── DNS
   └── Docker Container
   ```

### 4.2 Monitor Configuration
```yaml
Basic Settings:
  Name: "My Website"
  URL: "https://example.com"
  Monitoring Interval: 60s
  
Advanced Options:
  Retry Count: 3
  Accept Status: 200-299
  Certificate Expiry: Enabled
```

### 4.3 Status Pages
1. Create status page
2. Add monitors to page
3. Share public URL
4. Customize appearance

## 5. Alerts & Notifications

### 5.1 Viewing Alerts
```plaintext
Alert Dashboard:
├── Active Alerts
├── Alert History
└── Alert Rules
```

### 5.2 Configuring Notifications
1. Go to Alerting → Notification channels
2. Add new channel:
   ```yaml
   Types Available:
     - Email
     - Slack
     - Teams
     - Webhook
     - Telegram
   ```

### 5.3 Alert Rules
```yaml
Example Alert Rule:
  Name: High CPU Usage
  Condition: CPU > 80%
  Duration: 5m
  Severity: Warning
  Notifications: Email Team
```

## 6. Best Practices

### 6.1 Dashboard Organization
```plaintext
Recommended Structure:
├── Overview Dashboards
├── Service-Specific Dashboards
├── Team Dashboards
└── Custom Dashboards
```

### 6.2 Monitoring Guidelines
- Set appropriate thresholds
- Use meaningful alert descriptions
- Group related metrics
- Regular dashboard reviews
- Document custom metrics

### 6.3 Security Practices
- Change default passwords
- Use strong passwords
- Regular session logout
- Review access logs
- Report suspicious activity

## 7. FAQ

### 7.1 Common Questions

**Q: How do I reset my password?**
A: Contact your system administrator or use the "Forgot Password" option.

**Q: Why can't I see certain dashboards?**
A: Check your user permissions and role assignments.

**Q: How do I export dashboard data?**
A: Use the export button in dashboard settings or API endpoints.

### 7.2 Troubleshooting

**Issue: Dashboard Not Loading**
```plaintext
Check:
1. Browser cache
2. Network connection
3. Service status
4. User permissions
```

**Issue: Missing Data**
```plaintext
Verify:
1. Time range selection
2. Data source health
3. Query syntax
4. Collection status
```

## Support Information

### Quick Contacts
- **Support Email**: boniyeamin.cse@gmail.com
- **Documentation**: [docs/](./docs/)
- **Issue Tracker**: [GitHub Issues](https://github.com/yourusername/Boni-Web-Monitoring/issues)

### Feedback
We welcome your feedback and suggestions for improvement. Please contact:
- **Author**: Boni Yeamin
- **Role**: Cyber Security Engineer
- **Organization**: Akij Group 
