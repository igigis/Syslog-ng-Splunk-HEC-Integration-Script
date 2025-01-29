# Syslog-ng Splunk HEC Integration Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Splunk Compatible](https://img.shields.io/badge/Splunk-Compatible-red.svg)]()
[![Huntress Compatible](https://img.shields.io/badge/Huntress-Compatible-blue.svg)]()
[![Syslog-ng](https://img.shields.io/badge/syslog--ng-Supported-green.svg)]()

> 🚀 Automate syslog-ng configuration for Splunk HEC and Huntress log forwarding in minutes!

This script automates the installation and configuration of `syslog-ng` to forward logs to a Splunk HTTP Event Collector (HEC) endpoint. It ensures that logs from your system/s are properly forwarded to Splunk for centralized monitoring and analysis. The script is fully compatible with Huntress's Generic HEC source, allowing seamless integration with Huntress SIEM.

## 📑 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Installation Guide](#detailed-installation-guide)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## 🎯 Overview

The script streamlines log management by automating the following tasks:

1. **Privilege Check**  
   Ensures the script is executed with root or sudo privileges.

2. **Splunk/Huntress HEC Configuration**  
   - Collects and validates HEC URL and token
   - Supports both Splunk and Huntress Generic HEC endpoints
   - Validates configuration before deployment

3. **Automated Installation & Setup**  
   - Smart detection of existing syslog-ng installation
   - Automatic package manager detection (apt/yum)
   - Configuration backup and safety checks

## ✨ Key Features

- **Multi-Platform Support**
  - Compatible with both Splunk and Huntress's Generic HEC source
  - Supports Debian/Ubuntu (apt) and CentOS/RHEL (yum) systems
  - Cross-platform configuration templates

- **Robust Configuration Management**
  - Automated syslog-ng installation
  - Backup of existing configurations
  - Failover logging capability
  - Configuration validation

- **Security & Reliability**
  - Secure token handling
  - URL validation and sanitization
  - Local backup logging
  - Service health monitoring

## 🔧 Prerequisites

- Root or sudo privileges
- Splunk HEC endpoint URL and valid token
- Internet connectivity for package installation
- Compatible Linux distribution (Debian/Ubuntu or CentOS/RHEL)

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/igigis/Syslog-ng-Splunk-HEC-Integration-Script.git

# Navigate to directory
cd Syslog-ng-Splunk-HEC-Integration-Script

# Make executable
sudo chmod +x syslog-ng-splunk-hec-install.sh

# Run script
sudo ./syslog-ng-splunk-hec-install.sh
```

## 📖 Detailed Installation Guide

### Step 1: Clone the Repository

Clone the repository to your system:

```bash
git clone https://github.com/igigis/Syslog-ng-Splunk-HEC-Integration-Script.git
cd Syslog-ng-Splunk-HEC-Integration-Script


```

### Step 2: Make the Script Executable

Make the script executable:

```bash
sudo chmod +x syslog-ng-splunk-hec-install.sh
```

### Step 3: Run the Script

Run the script as root:

```bash
sudo ./syslog-ng-splunk-hec-install.sh
```

### Step 4: Configure HEC Details

When prompted:

1. Enter the Splunk/Huntress HEC URL (e.g., https://splunk.example.com:8088/services/collector)
2. Provide your HEC token
3. Confirm the configuration details

### Step 5: Verify Installation

Verify the setup:

```bash
# Check service status
systemctl status syslog-ng

# Verify log forwarding
sudo tail -f /var/log/syslog
or
sudo tail -f /var/log/messages
```

## 🔍 Troubleshooting

### Common Issues and Solutions

#### Permission Errors
```bash
sudo ./syslog-ng-splunk-hec-install.sh
```

#### Package Manager Issues
- Script supports apt and yum
- Manual installation option available for other package managers

#### Service Start Failures
```bash
# Check logs
journalctl -u syslog-ng

# Validate config
syslog-ng -s
```

#### Connection Issues
```bash
# Test HEC endpoint
curl -k -X POST https://splunk.example.com:8088/services/collector -H "Authorization: Splunk <TOKEN>"
```

## 🤝 Contributing

We welcome contributions! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

For major changes, open an issue first to discuss proposed changes.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Support

- Create an issue for bug reports
- Submit feature requests via issues
- Join our community discussions

---

**Keywords**: syslog-ng, Splunk, Huntress, HEC, log forwarding, log management, syslog configuration, system logging, log collection, security logging, SIEM integration, log automation, Linux logging, centralized logging, log shipping
