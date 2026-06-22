source ./hardware_functions.sh
source ./software_functions.sh

echo "Welcome to the System Audit Tool"
PS3="Please select a system module to check (or 'quit' to exit): "

select fun in "CPU" "MEMORY" "STORAGE" "blocks" "address" "os_name" "kernel_version" "system_architecture" "installed_packages" "logged_in_users" "services_&_processes" "open_ports" "quit"
do 
    case $fun in
        "CPU")
            CPU_fun
            ;;
        "MEMORY")
            MEM_fun
            ;;
        "STORAGE")
            STORAGE_fun
            ;;
        "blocks")
            blocks_fun
            ;;
        "address")
            address_fun
            ;;
	"os_name")
		get_os_name_version
		;;
	"kernel_version")
		get_kernel_version
		;;
	"system_architecture")
		get_system_arch
		;;
	"installed_packages")
		get_installed_packages
		;;
	"logged_in_users")	
		get_logged_in_users
		;;
	"services_&_processes")
		get_services_and_processes
		;;
	"open_ports")
		get_open_ports
		;;
        "quit")
            echo "Exiting script."
            exit 0
            ;;
        *) 
            echo "please select one of the options" [cite: 2]
            ;;
    esac
done

echo -e "\nHow would you like to view the final report?"
PS3="Please select a report format: "

select report_format in "full report" "partial report" "quit"
do 
    case $report_format in
        "full report")
            # Calls the hardware full report (from your sourced file) then the OS full report
            full_report 2>/dev/null || echo "Hardware full_report function missing."
            os_full_report 2>/dev.null || echo "software full report function missing" 
            break
            ;;
        "partial report")
            # Calls the hardware partial report then the OS partial report
            partial_report 2>/dev/null || echo "Hardware partial_report function missing."
            os_partial_report 2>/dev/null || echo "software partial report function missing"
            break
            ;;
        "quit")
            echo "Exiting report."
            break
            ;;
        *) 
            echo "please select one of the options"
            ;;
    esac
done