#!/bin/bash

source ./hardware_functions.sh
source ./software_functions.sh

GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${GREEN}"
    echo "  ███╗   ██╗███████╗ ██████╗███████╗ "
    echo "  ████╗  ██║██╔════╝██╔════╝██╔════╝ "
    echo "  ██╔██╗ ██║███████╗██║     ███████╗ "
    echo "  ██║╚██╗██║╚════██║██║     ╚════██║ "
    echo "  ██║ ╚████║███████║╚██████╗███████║ "
    echo "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝╚══════╝ "
    echo -e "${NC}"
    echo -e "${CYAN} [+] NSCS Advanced Audit Framework [+]${NC}"
    echo -e "${CYAN} ==========================================${NC}\n"
}

report_menu(){
  
while true
  do
    echo -e "${CYAN}select the option you want to get:"
    echo -e "${GREEN}[1] the hardware report"
    echo -e "${GREEN}[2] the software report"
    echo -e "${RED}[3] quit"

    read -r -p "$(echo -e "${CYAN}nscs-audit\>")" num

    case $num in 
      1)hardware_report ;;
      2)software_report ;;
      3)break ;;
      *) echo "please select ne of the options" ;;
    esac
  done
}

pause_menu() {
    echo -e "\n${YELLOW}[*] Press Enter to return...${NC}"
    read -r
}

while true; do
    show_banner
    echo -e " ${GREEN}[1]${NC} Hardware Audit"
    echo -e " ${GREEN}[2]${NC} Software Audit"
    echo -e " ${GREEN}[3]${NC} Generate Full System Reports"
    echo -e " ${GREEN}[4]${NC} Secure Email Dispatch (SMTP)"
    echo -e " ${GREEN}[5]${NC} Remote Sync & SSH Monitoring"
    echo -e " ${GREEN}[6]${NC} Automation & Cron Scheduler"
    echo -e " ${GREEN}[7]${NC} Audit Logs & Report Comparison"
    echo -e " ${RED}[0]${NC} Exit Framework\n"
    
    read -p "$(echo -e ${CYAN}nscs-audit\> ${NC})" choice
    
    case $choice in
        1) hardware_menu; pause_menu ;;
        2) software_menu; pause_menu ;;
        3) report_menu; echo -e "${GREEN}Report Saved Successfully.${NC}"; pause_menu ;;
        4) source ./email.sh; write_email_fun; pause_menu ;;
        5) # Remote Sync Manual
           chmod +x remote_monitor.sh; ./remote_monitor.sh; pause_menu ;;
       6) # Automation Control
         echo -e "${YELLOW}--- Automation Setup ---${NC}"
         echo "1) Schedule Daily Audit at 04:00 AM"
         echo "2) Remove Scheduled Tasks"
         read -p "> " auto_c
         if [ "$auto_c" == "1" ]; then
                # نبروغراميو الـ Wrapper ماشي السكربت وحدو باش نضمنوا الـ Logs
                (crontab -l 2>/dev/null; echo "00 04 * * * $(pwd)/auto_wrapper.sh") | crontab -
                echo -e "${GREEN}Task scheduled for 04:00 AM via Wrapper.${NC}"
         elif [ "$auto_c" == "2" ]; then
             crontab -r; echo -e "${RED}All tasks removed.${NC}"
         fi
         pause_menu ;;
        7) # Logs & Comparison
           echo -e "${CYAN}--- Audit Management ---${NC}"
           echo "1) View Automation Logs"
           echo "2) Compare Two Reports (Diff)"
           read -p "> " log_c
           if [ "$log_c" == "1" ]; then
                [ -f "/var/log/nscs_audit.log" ] && tail -n 15 /var/log/nscs_audit.log || echo "No logs found."
           elif [ "$log_c" == "2" ]; then
                read -p "File 1: " f1; read -p "File 2: " f2
                [ -f "$f1" ] && [ -f "$f2" ] && diff "$f1" "$f2" || echo "Files missing."
           fi
           pause_menu ;;
        0) echo "Goodbye!"; break ;;
        *) echo "Invalid Selection"; sleep 1 ;;
    esac
done
