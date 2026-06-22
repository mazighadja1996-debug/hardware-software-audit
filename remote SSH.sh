#!/bin/bash

source ./main_menu.sh 

# --- Helper function for Secure Remote Monitoring ---
remote_monitor() {
    read -p "Enter Remote Username: " R_USER
    read -p "Enter Remote IP/Hostname: " R_HOST
    read -p "Enter Check Interval (seconds): " R_INT
    
    # Security: BatchMode ensures we use keys and don't hang on password prompts
    echo "Connecting to $R_HOST..."
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$R_USER@$R_HOST" "uptime" &> /dev/null
    
    if [ $? -ne 0 ]; then
        echo "Error: Secure Key-Based Access Failed. Ensure ssh-copy-id has been run."
        return
    fi

    # Remote Monitoring Loop
    while true; do
        clear
        echo "Monitoring $R_USER@$R_HOST | Press CTRL+C to return to menu"
        ssh -o BatchMode=yes "$R_USER@$R_HOST" "
            echo '--- CPU/Load ---'; uptime;
            echo '--- Network ---'; ss -tuln | head -n 5;
            echo '--- Users ---'; who"
        sleep "$R_INT"
    done
}

main_menu