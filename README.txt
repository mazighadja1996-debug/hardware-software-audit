=============================================================================
AUTOMATED LINUX SYSTEM HARDWARE & SOFTWARE AUDIT TOOL
=============================================================================

PROJECT OVERVIEW
----------------
This automated Bash script performs comprehensive system discovery, configuration 
auditing, and security analysis on Linux-based environments. It discovers the 
current system state, evaluates security baseline gaps, and consolidates all 
findings into an organized, human-readable audit report.

Designed for system administrators and security auditors, the tool operates 
rapidly to give a complete diagnostic snapshot of target Linux hosts.


CORE FEATURES & OPTIONS
-----------------------
1. Hardware Profiling:
   - Extracts detailed processor architecture, CPU models, and core counts.
   - Monitors memory utilization (Total, Used, and Available RAM/Swap space).
   - Inspects storage devices, active partition layouts, and disk space usage.
   - Identifies active network interface cards (NICs), MAC addresses, and IPs.

2. Software & Environment Inventory:
   - Identifies OS distribution details, kernel version, and system uptime.
   - Logs running system services, background daemons, and initialization states.
   - Gathers a list of installed packages and flags pending security updates.

3. System Security & Hardening Audit:
   - Audits user accounts for empty passwords, active sessions, and root privileges.
   - Scans open network ports and maps them directly to listening services.
   - Verifies active firewall policies and packet-filtering rules (UFW/Iptables).
   - Inspects system-wide and user cron jobs for unauthorized persistence.

4. Automated Reporting:
   - Consolidates all logs into an organized, timestamped report file.
   - Generates structured plain text or Markdown format for easy integration.


TECHNICAL HIGHLIGHTS
--------------------
- Zero External Dependencies: Built entirely using native Bash and standard POSIX 
  command-line utilities (grep, awk, sed, find). Compatible across major Linux 
  distributions without third-party packages.
- Privilege Awareness: Automatically detects permission levels (Standard User vs. 
  Root) and dynamically adjusts inspection depth to maximize data collection 
  without crashing on restricted paths.


DEPENDENCIES & REQUIREMENTS
---------------------------
- Operating System: Any modern GNU/Linux distribution (Ubuntu, Debian, CentOS, RHEL, Parrot OS, etc.)
- Shell: Bash (Bourne Again SHell) 4.0 or higher
- Core utilities: coreutils, grep, gawk, sed, find, systemctl/init, ip/ifconfig


HOW TO RUN THE AUDIT
--------------------
1. Clone or download the audit script to the target system.
2. Grant execution permissions to the script:
   $ chmod +x audit_script.sh

3. Execute the script:
   - For a standard audit (limited permissions):
     $ ./audit_script.sh
   - For a comprehensive deep-system security audit (recommended):
     $ sudo ./audit_script.sh

4. View the generated report:
   The script will output the path of the generated timestamped log file upon completion.