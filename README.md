# Syslog-ng Splunk HEC Integration Script

This script automates the installation and configuration of `syslog-ng` to forward logs to a Splunk HTTP Event Collector (HEC) endpoint. It ensures that logs from your system are properly forwarded to Splunk for centralized monitoring and analysis.

---

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

---

## Features

- Installs `syslog-ng` if not already present.
- Backs up the existing `syslog-ng` configuration file.
- Configures a Splunk HEC destination with user-provided URL and token.
- Validates and applies the configuration.
- Restarts the `syslog-ng` service.

---

## Prerequisites

- A Splunk HEC endpoint URL and a valid token.
- Root or sudo privileges to run the script.

---

## Installation and Configuration Steps

### Step 1: Clone the Repository

Clone the repository to your system:

```bash
git clone https://github.com/yourusername/syslog-ng-splunk-setup.git
cd syslog-ng-splunk-setup

Step 2: Make the Script Executable

Make the script executable:

chmod +x setup_syslog_ng.sh

Step 3: Run the Script

Run the script as root:

sudo ./setup_syslog_ng.sh

Step 4: Provide Splunk HEC Details

When prompted by the script:

    Enter the Splunk HEC URL (e.g., https://splunk.example.com:8088/services/collector).
    Provide the Splunk HEC token.

The script will validate your input, confirm the details with you, and apply the configuration.
Step 5: Verify Configuration and Service

After the script completes:

    Confirm that syslog-ng is running:

    systemctl status syslog-ng

    Check that logs are being forwarded to Splunk.

Troubleshooting
Error: This Script Must Be Run as Root

Ensure you are executing the script with root privileges using sudo:

sudo ./setup_syslog_ng.sh

Unsupported Package Manager

The script supports apt and yum. If you’re using a different package manager, manually install syslog-ng and rerun the script.
Error: Syslog-ng Service Failed to Start

    Check the system logs for detailed errors:

journalctl -u syslog-ng

Validate the syslog-ng configuration:

    syslog-ng -s

Splunk Not Receiving Logs

    Verify the Splunk HEC URL and token are correct.
    Check for connectivity issues by testing the HEC endpoint:

curl -k -X POST https://splunk.example.com:8088/services/collector -H "Authorization: Splunk <TOKEN>"

Review syslog-ng logs for errors:

    tail -f /var/log/syslog

Configuration Validation Failed

If syslog-ng validation fails, the script may have encountered an issue during configuration generation. Re-run the script:

sudo ./setup_syslog_ng.sh

Service Restart Issues

If the service fails to restart, manually stop and start syslog-ng:

systemctl stop syslog-ng
systemctl start syslog-ng

License

This project is licensed under the MIT License. See the LICENSE file for details.
Contributing

Feel free to open issues or submit pull requests for enhancements or bug fixes.
