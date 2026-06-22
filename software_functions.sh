#!/bin/bash 

get_os_name_version() {
    echo -e "\n--- OS Name and Version ---"
    # Extracts the pretty name from the os-release file
    grep -w "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"'
}

get_kernel_version() {
    echo -e "\n--- Kernel Version ---"
    uname -r
}

get_system_arch() {
    echo -e "\n--- System Architecture ---"
    uname -m
}

get_installed_packages() {
    echo -e "\n--- Installed Packages (Count) ---"
    # Checks for Debian/Ubuntu or RHEL/CentOS based systems to count packages
    if command -v dpkg &> /dev/null; then
        echo "$(dpkg -l | grep -c '^ii') packages installed (dpkg)"
    elif command -v rpm &> /dev/null; then
        echo "$(rpm -qa | wc -l) packages installed (rpm)"
    else
        echo "Package manager not supported for basic count."
    fi
}

get_logged_in_users() {
    echo -e "\n--- Logged-in Users ---"
    who
}

get_services_and_processes() {
    echo -e "\n--- Running Services and Active Processes ---"
    echo "Active Processes: $(ps aux | wc -l)"
    if command -v systemctl &> /dev/null; then
        echo "Running Services: $(systemctl list-units --type=service --state=running | grep -c '\.service')"
    else
        echo "Systemd not found. Cannot count running services."
    fi
}

get_open_ports() {
    echo -e "\n--- Open Ports ---"
    # Uses ss (socket statistics) to list listening TCP/UDP ports
    ss -tuln
}

# ==========================================
# 2. REPORT GENERATION FUNCTIONS
# ==========================================

os_partial_report() {
    echo -e "\n====================================="
    echo "      PARTIAL OS & SOFTWARE REPORT     "
    echo "======================================="
    get_os_name_version
    get_kernel_version
    get_system_arch
    get_logged_in_users
    echo "======================================="
}

os_full_report() {
    echo -e "\n====================================="
    echo "        FULL OS & SOFTWARE REPORT      "
    echo "======================================="
    get_os_name_version
    get_kernel_version
    get_system_arch
    get_logged_in_users
    get_installed_packages
    get_services_and_processes
    get_open_ports
    echo "======================================="
}