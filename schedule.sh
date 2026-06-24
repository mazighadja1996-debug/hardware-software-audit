#!/bin/bash

# Configuration
LOG_FILE="/var/log/nscs_automation.log"
# نعيطو لسكربت الـ Remote اللي خدمناه (هو اللي فيه الـ SSH والـ Sync والـ Alerts)
SCRIPT_PATH="$(pwd)/remote_monitor.sh"

log_event() {
	
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# (Handle Failures)
if [ -f "$SCRIPT_PATH" ]; then
    chmod +x "$SCRIPT_PATH"
    if "$SCRIPT_PATH"; then
        log_event "SUCCESS: Automated sync and monitoring completed."
    else
        log_event "FAILURE: Remote monitoring script exited with an error."
    fi
else
    log_event "CRITICAL: Script not found at $SCRIPT_PATH"
    exit 1
fi
