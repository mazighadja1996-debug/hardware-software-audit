#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;32m'
CYAN='\033[1;36'
YELLOW='\033[1;33'

CPU_fun() {
    read -p "do you want to check the architecture of the CPU [y/n]: " an1
    if [[ "$an1" == "y" ]]; then	
        CPU_archi=$(lscpu | awk 'NR == 1 {print $2}')
        echo -e "${GREEN}---------- architecture of the CPU ----------\n"
        echo -e "${CYAN}the system architecture is:" $CPU_archi
        echo -e "\n${GREEN}---------------------------------------------\n"
    fi 

    read -p "do yo want ot check the model name [y/n]: " an2
    
    if [[ "$an2" == "y" ]]; then
        CPU_name=$(lscpu | awk 'NR == 8,13 {print}')
        echo -e "${GREEN}---------- the CPU name ----------\n"
        echo -e "${CYAN}$CPU_name"
        echo -e "\n${GREEN}----------------------------------\n"
    fi

    read -p "do you want the full information about the CPU [y/n]: " an3 
    if [[ "$an3" == "y" ]]; then
        CPU_data=$(cat /proc/cpuinfo)
        echo -e "${GREEN}---------- full information about the CPU ----------\n"
        echo -e "${CYAN}$CPU_data"
        echo -e "\n${GREEN}----------------------------------------------------\n"
    fi
}

MEM_fun(){
    read -p "do you want to check the total memory [y/n]: " an1
    if [[ "$an1" == "y" ]]; then
        mem_total=$(cat /proc/meminfo | awk 'NR == 1 {print}')
        echo -e "${GREEN}---------- the total memory ----------\n"
        echo -e "${CYAN}$mem_total"
        echo -e "\n${GREEN}--------------------------------------\n"
    fi

    read -p "do you want to see the state of the memory [y/n]: " an2
    if [[ "$an2" == "y" ]]; then
        free_mem=$(cat /proc/meminfo | awk 'NR == 2 {print}')
        avai_mem=$(cat /proc/meminfo | awk 'NR == 3 {print}')
        echo -e "${GREEN}---------- the memory status ----------\n"
        echo -e "${CYAN}the free memory size is: $free_mem \n\tthis one includes the RAM only\nthe available memory size is: $avai_mem \n\t this one includes the RAM the caches and the buffers"
        echo -e "\n${GREEN}---------------------------------------\n"
    fi

    read -p "do you want to check the full report about the memory [y/n]: " an3
    if [[ "$an3" == "y" ]]; then
        MEM_data=$(cat /proc/meminfo)
        echo -e "${GREEN}---------- the full report about the memory ----------\n"
        echo -e "${CYAN}$MEM_data"
        echo -e "\n${GREEN}------------------------------------------------------\n"
    fi
}

STORAGE_fun(){
    STORAGE_data=$(df -h)
    echo -e "${GREEN}---------- the storage status ----------\n"
    echo "$STORAGE_data"
    echo -e "\n${GREEN}----------------------------------------\n"
    echo -e "${YELLOW}if you wish to check a directory's content and the space storage enter the name here (or press Enter to skip):"
    read dir
    if [[ -z "$dir" ]]; then
        echo "${YELLOW}you may choose another function"
    else
      echo "${CYAN}the storage of the directory $dir : "
        du -h "$dir"
      echo -e "\n${GREEN}----------------------------------\n"
    fi
}

blocks_fun(){
    I_Odevices=$(iostat)
    NETWORK_data=$(ip -s addr show)
    USB_data=$(lsusb)
    PCI_data=$(lspci) 
    BLOCKS_data=$(lsblk) 
    MOUNT_data=$(cat /proc/mounts) 

    options=("I/O devices" "network devices" "PCI state" "USB ports" "blocks" "mounted devices" "Quit")
    select op in "${options[@]}"
    do 
        case $op in 
            "I/O devices")
                echo -e "${GREEN}---------- the I/O devices status ----------\n"
                echo "$I_Odevices"
                echo -e "\n${GREEN}--------------------------------------------\n"
                ;;
            "network devices")
                echo -e "${GREEN}---------- the network devices status ----------\n"
                echo "$NETWORK_data"
                echo -e \n"${GREEN}------------------------------------------------\n"
                ;;
            "PCI state")
                echo -e "${GREEN}---------- the PCI bus status ----------\n"
                echo "$PCI_data"
                echo -e "\n${GREEN}----------------------------------------\n"
                ;;
            "USB ports")
                echo -e "${GREEN}---------- the usb ports ----------\n"
                echo "$USB_data"
                echo -e "\n${GREEN}-----------------------------------\n"
                ;;
            "blocks")
                echo -e "${GREEN}---------- the blocks' status ----------\n"
                echo "$BLOCKS_data"
                echo -e "\n${GREEN}----------------------------------------\n"
                ;;
            "mounted devices")
                echo -e "${GREEN}---------- the mounted devices' status ----------\n"
                echo "$MOUNT_data"
                echo -e "${GREEN}-------------------------------------------------\n"
                ;;
            "Quit")
                break
                ;;
            *)
                echo "${YELLOW}please select one of the options"
        esac
    done
}

address_fun(){
    echo -e "${GREEN}---------- the address of the devices' interfaces ----------\n"
    echo -e "${YELLOW}please select which interface you want to check its IP and MAC"
    array=()
    for intf in $(ifconfig | cut -d" " -f1 | tr ":" " " | awk NF)
    do 
        if [[ "$intf" != "lo" ]]; then
            array+=("$intf")
        fi
    done

    for i in "${array[@]}"
    do 
        echo "$i"
    done

    read int
      if ! ip show link $int &> /dev/null; then
        echo -e "${RED}the interface does not exist"
      else
        IP=$(ip address show "$int" | awk '{print $2}' | sed -n '3p')
        MAC=$(ip address show "$int" | awk '{print $2}' | sed -n '2p')
        echo -e "${CYAN}the IP address is $IP and the MAC address is $MAC"
      fi
      echo -e "\n${GREEN}------------------------------------------------------------\n"
}

partial_report(){
    
    if [[ ! -d reports ]]; then
      sudo mkdir -p ./reports
    fi
    report_file="./reports/partial_hardware_report.txt" 
    > "$report_file"
    
    echo -e "====================================================\n\tshort report about the system hardware\t\n====================================================\n" > "$report_file"
    echo -e "Hostname: $(hostname)\nDate: $(date +'%d/%m/%Y %H:%M')\n" >> "$report_file"

    echo -e "1- about the CPU here are the most important characteristics:\n$(lscpu | head -n15)\n" >> "$report_file"
    echo -e "2- the most important information about the memory:\n$(lsmem)\n" >> "$report_file"
    echo -e "3- the most important information about the storage:\n$(df -h)\n" >> "$report_file"
    echo -e "4- information about the input output devices:\n$(iostat)\n" >> "$report_file"
    echo -e "5- information about the network devices:\n$(ip -s addr show)\n" >> "$report_file"
    
    INTF=$(ip route | grep default | awk '{print $5}')
    IP_ADDR=$(ip address show "$INTF" | awk '/inet / {print $2}')
    MAC_ADDR=$(ip link show "$INTF" | awk '/link\/ether/ {print $2}')
    
    echo -e "6- the address of the main network interface ($INTF):\nthe IP address is $IP_ADDR\nthe MAC address is $MAC_ADDR\n" >> "$report_file"
    echo "the file was edited at $(date +'%d/%m/%Y') at the time $(date +'%H:%M') by the user $(whoami)" >> "$report_file"
}

full_report(){
    if [[ ! -d reports ]]; then
      mkdir -p ./reports
    fi
    report_file="./reports/full_hardware_report.txt"
    > "$report_file"

    echo -e "===================================================\n\tfull report about the system hardware\t\n=======================================================\n" >> $report_file
    echo -e "Hostname: $(hostname)\nDate: $(date +'%d/%m/%Y %H:%M')\n" >> "$report_file"

    echo "1- the device CPU full information:" >> "$report_file"
    cat /proc/cpuinfo >> "$report_file"
    
    echo -e "\n2- the device memory full information:" >> "$report_file"
    cat /proc/meminfo >> "$report_file"
    
    echo -e "\n3- the device storage full information:" >> "$report_file"
    df -h >> "$report_file"
    
    echo -e "\n4- the device's input/output devices full information:" >> "$report_file"
    iostat >> "$report_file"
    
    echo -e "\n5- the device's network devices full report:" >> "$report_file"
    ip -s addr show >> "$report_file"
    
    echo -e "\n6- the device's USB ports' full report:" >> "$report_file"
    lsusb >> "$report_file"
    
    echo -e "\n7- the device's PCI information:" >> "$report_file"
    lspci >> "$report_file"
    
    echo -e "\n8- the device's blocks information:" >> "$report_file"
    lsblk >> "$report_file"
    
    echo -e "\n9- the device's mounted devices information:" >> "$report_file"
    cat /proc/mounts >> "$report_file"
    
    INTF=$(ip route | grep default | awk '{print $5}')
    echo -e "\n10- the device's IP and MAC address ($INTF):" >> "$report_file"
    ip address show "$INTF" | awk '/inet / {print $2}' >> "$report_file"
    ip link show "$INTF" | awk '/link\/ether/ {print $2}' >> "$report_file"

    echo -e "\nthe report was generated by the user $(whoami) at the date $(date +'%d/%m/%Y') at the time $(date +'%H:%M')" >> "$report_file"
}

hardware_menu(){

CYAN='\033[1;36m'
NC='\033[0m'
GREEN='\033[1;32m'

while true 
do
  echo -e "${NC} select one of the options to use:"
  echo -e "${GREEN}[1]${NC} the information about the CPU"
  echo -e "${GREEN}[2]${NC} information about the memory"
  echo -e "${GREEN}[3]${NC} information about the storage"
  echo -e "${GREEN}[4]${NC} information anout the blocks"
  echo -e "${GREEN}[5]${NC} getting the addresses of the device"
  echo -e "${GREEN}[6]${NC} quit"
  
  read -p "$(echo -e ${CYAN}nscs-audit\> ${NC})" num

  case $num in
    1) CPU_fun ;;
    2) MEM_fun ;;
    3) STORAGE_fun ;;
    4) blocks_fun ;;
    5) address_fun ;;
    6) break ;;
    *)echo "please select one of the options" ;;
  esac
done
}

hardware_report(){

GREEN='\033[1;32m'
CYAN='033[1;36m'
NC='\033[0m'

while true
do
  echo "select the format of the report:"
  echo -e "${GREEN}[1]${NC} create the full report"
  echo -e "${GREEN}[2]${NC} create the partial report:"
  echo -e "${GREEN}[3]${NC} quit"
  
  read -p "$(echo ${CYAN}nscs-audit\> ${NC})" num

  case $num in
    1) full_report ;;
    2) partial_report ;;
    3) break ;;
    *) echo "please select one of the options" ;;
  esac
done
}
