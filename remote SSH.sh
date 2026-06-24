#!/bin/bash

CONFIG_FILE=".monitor_cfg"

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

setup_config() {
    echo -e "${YELLOW}[!] Configuration missing. Starting Setup Wizard...${NC}"
    read -p "Enter Admin Username: " ADMIN_USER
    read -p "Enter Admin IP Address: " ADMIN_IP
    read -p "Enter Remote Base Directory [/home/$ADMIN_USER/logs]: " REMOTE_BASE
    REMOTE_BASE=${REMOTE_BASE:-/home/$ADMIN_USER/logs}

    echo "ADMIN_USER=\"$ADMIN_USER\"" > "$CONFIG_FILE"
    echo "ADMIN_IP=\"$ADMIN_IP\"" >> "$CONFIG_FILE"
    echo "REMOTE_DIR=\"$REMOTE_BASE/\$(hostname)\"" >> "$CONFIG_FILE"
    
    # sec step
    chmod 600 "$CONFIG_FILE"
    echo -e "${GREEN}[+] Config saved and secured in $CONFIG_FILE${NC}\n"
}

# check
if [ ! -f "$CONFIG_FILE" ]; then
    setup_config
fi

# (Sourcing the configs)
source "./$CONFIG_FILE"

check_alerts() {
    cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
    if [ "$cpu_load" -gt 80 ]; then
        ssh -o ConnectTimeout=5 "$ADMIN_USER@$ADMIN_IP" "wall 'ALERT: $(hostname) CPU at $cpu_load%'" 2>/dev/null
    fi
}

send_report() {
    local report_file=$1
    if [ -f "$report_file" ]; then
        #creating the doc remotlly 
        ssh "$ADMIN_USER@$ADMIN_IP" "mkdir -p $REMOTE_DIR"
        sha256sum "$report_file" > "${report_file}.sha256"
        scp "$report_file" "${report_file}.sha256" "$ADMIN_USER@$ADMIN_IP:$REMOTE_DIR/"
    fi
}

# Log Rotation (erase the old reports than 7 days )
clean_old_logs() {
    find ~/ -name "audit_$(hostname)_*.txt" -mtime +7 -exec rm {} \;
    find ~/ -name "audit_$(hostname)_*.txt.sha256" -mtime +7 -exec rm {} \;
}

source ./software_functions.sh
REPORT_NAME=~/audit_$(hostname)_$(date +%F).txt
os_full_report > "$REPORT_NAME"

check_alerts
send_report "$REPORT_NAME"
clean_old_logs

