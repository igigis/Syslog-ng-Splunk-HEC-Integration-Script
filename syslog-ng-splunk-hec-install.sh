#!/bin/bash

# Exit on any error
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log "Error: This script must be run as root"
        exit 1
    fi
}

# Function to get Splunk configuration
get_splunk_config() {
    # Get Splunk HEC URL
    while true; do
        read -p "Enter Splunk HEC URL (e.g., https://splunk.example.com:8088/services/collector): " SPLUNK_URL
        if [[ $SPLUNK_URL =~ ^https?:// ]]; then
            break
        else
            log "Error: Please enter a valid URL starting with http:// or https://"
        fi
    done

    # Get Splunk Token
    while true; do
        read -p "Enter Splunk HEC Token: " SPLUNK_TOKEN
        if [[ -n "$SPLUNK_TOKEN" ]]; then
            # Validate token format (basic check for non-empty string)
            if [[ ${#SPLUNK_TOKEN} -ge 32 ]]; then
                break
            else
                log "Error: Token seems too short. Please enter a valid Splunk HEC token"
            fi
        else
            log "Error: Token cannot be empty"
        fi
    done

    # Confirm settings
    echo -e "\nSplunk Configuration:"
    echo "URL: $SPLUNK_URL"
    echo "Token: ${SPLUNK_TOKEN:0:8}..."
    read -p "Is this correct? (y/n): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log "Configuration cancelled. Please try again."
        get_splunk_config
    fi
}

# Function to backup existing configuration
backup_config() {
    if [ -f /etc/syslog-ng/syslog-ng.conf ]; then
        backup_file="/etc/syslog-ng/syslog-ng.conf.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backing up existing configuration to $backup_file"
        cp /etc/syslog-ng/syslog-ng.conf "$backup_file"
    fi
}

# Function to install syslog-ng if not present
install_syslog_ng() {
    if ! command -v syslog-ng >/dev/null 2>&1; then
        log "Installing syslog-ng..."
        if command -v apt-get >/dev/null 2>&1; then
            apt-get update
            apt-get install -y syslog-ng
        elif command -v yum >/dev/null 2>&1; then
            yum install -y syslog-ng
        else
            log "Error: Unsupported package manager"
            exit 1
        fi
    else
        log "syslog-ng is already installed"
    fi
}

# Function to create and validate configuration
create_config() {
    log "Creating new syslog-ng configuration..."
    cat > /etc/syslog-ng/syslog-ng.conf << EOL
@version: 4.3
@include "scl.conf"
# Options
options {
    chain_hostnames(no);
    flush_lines(0);
    threaded(yes);
    time_reopen(10);
    use_dns(no);
    use_fqdn(no);
    log_fifo_size(1000);
    create_dirs(yes);
    keep_hostname(yes);
};
# Sources
source s_local {
    system();
    internal();
};
# Network source for UDP on port 514
source s_network {
    network(ip("0.0.0.0") transport("udp") port(514));
};
# Splunk HEC Destination
destination d_splunk_hec {
    http(
        url("$SPLUNK_URL")
        method("POST")
        headers("Authorization: Splunk $SPLUNK_TOKEN")
        body('\$(format-json 
            time="\${ISODATE}" 
            host="\${HOST}" 
            source="\${PROGRAM}" 
            sourcetype="syslog" 
            index="main" 
            event="\${MSG}"
            severity="\${LEVEL}" 
            facility="\${FACILITY}"
            program="\${PROGRAM}"
            pid="\${PID}"
        )')
        timeout(10)
        retries(3)
        batch-lines(100)
        batch-timeout(5000)
        persist-name("splunk-hec")
        workers(4)
    );
};
# File backup destination (for failover)
destination d_backup {
    file(
        "/var/log/messages"
        create-dirs(yes)
    );
};
# Log Path
log {
    source(s_local);
    source(s_network);
    destination(d_splunk_hec);
    destination(d_backup);
    flags(flow-control);
};
EOL

    # Validate configuration
    log "Validating syslog-ng configuration..."
    if ! syslog-ng -s; then
        log "Error: Invalid configuration"
        exit 1
    fi
}

# Function to restart syslog-ng service
restart_service() {
    log "Restarting syslog-ng service..."
    if ! systemctl restart syslog-ng; then
        log "Error: Failed to restart syslog-ng service"
        exit 1
    fi
    
    # Verify service is running
    if ! systemctl is-active --quiet syslog-ng; then
        log "Error: syslog-ng service failed to start"
        exit 1
    fi
    
    log "syslog-ng service successfully restarted"
}

# Main execution
main() {
    log "Starting syslog-ng installation and configuration..."
    
    check_root
    get_splunk_config
    install_syslog_ng
    backup_config
    create_config
    restart_service
    
    log "Installation and configuration completed successfully"
    log "Splunk HEC URL: $SPLUNK_URL has been configured"
}

main
