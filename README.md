
# Syslog-ng Splunk HEC Integration Script

This script automates the installation and configuration of `syslog-ng` to forward logs to a Splunk HTTP Event Collector (HEC) endpoint. It validates user input, backs up existing configurations, and ensures `syslog-ng` is properly installed and running.

## Description

The script performs the following tasks:

1. **Privilege Check**  
   Ensures the script is executed with root or sudo privileges.

2. **Prompt for Splunk HEC Details**  
   - Collects the Splunk HEC URL and token from the user.
   - Validates the URL format and token length.
   - Confirms the entered details with the user.

3. **Install Syslog-ng**  
   - Checks if `syslog-ng` is already installed.
   - If not, installs it using the appropriate package manager (`apt` for Debian/Ubuntu or `yum` for CentOS/Red Hat).

4. **Backup Existing Configuration**  
   - Creates a timestamped backup of the current `syslog-ng` configuration file, if it exists.

5. **Generate New Configuration**  
   - Creates a new `syslog-ng` configuration file to forward logs to the Splunk HEC endpoint.
   - Configures a failover destination to log files locally.

6. **Validate Configuration**  
   - Runs `syslog-ng` syntax validation to ensure the new configuration is error-free.

7. **Restart Syslog-ng Service**  
   - Restarts the `syslog-ng` service to apply the new configuration.
   - Verifies the service is running correctly.

8. **Completion Message**  
   - Provides a summary of the configuration, including the Splunk HEC URL.

This ensures that logs from your system are properly forwarded to Splunk for centralized monitoring and analysis.

## Features

- Installs `syslog-ng` if not already present.
- Backs up the existing `syslog-ng` configuration file.
- Configures a Splunk HEC destination with user-provided URL and token.
- Validates and applies the configuration.
- Restarts the `syslog-ng` service.

## Prerequisites

- A Splunk HEC endpoint URL and a valid token.
- Root or sudo privileges to run the script.

## Installation Guide

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/syslog-ng-splunk-setup.git
cd syslog-ng-splunk-setup

### Step 2: Make the Script Executable

chmod +x setup_syslog_ng.sh

