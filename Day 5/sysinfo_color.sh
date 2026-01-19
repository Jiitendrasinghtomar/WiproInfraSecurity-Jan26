#!/bin/bash
clear

# ================== Styling ==================
RESET="\e[0m"
BOLD="\e[1m"
BLUE="\e[34m"
CYAN="\e[36m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"

# Print key-value pair with formatting
print_kv() {
    echo -e "${BOLD}${CYAN}$1:${RESET} $2"
}

# ================== Functions ==================

get_hostname() {
    hostname
}

get_ip_address() {
    ip -4 addr show | awk '/inet/ && !/127.0.0.1/ {print $2}' | cut -d/ -f1 | paste -sd ","
}

get_kernel_version() {
    uname -r
}

check_internet() {
    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        echo -e "${GREEN}Yes${RESET}"
    else
        echo -e "${RED}No${RESET}"
    fi
}

get_cpu_count() {
    nproc
}

get_cpu_model() {
    lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ //' | head -1
}

get_bios_version() {
    if command -v dmidecode >/dev/null 2>&1; then
        sudo dmidecode -s bios-version 2>/dev/null
    else
        echo "Not Available"
    fi
}

get_boot_size() {
    df -h /boot 2>/dev/null | awk 'NR==2 {print $2}'
}

get_default_language() {
    echo "$LANG"
}

get_ram_size() {
    free -g | awk '/Mem:/ {print $2 " GB"}'
}

get_swap_size() {
    free -g | awk '/Swap:/ {print $2 " GB"}'
}

get_driver_count() {
    lsmod | tail -n +2 | wc -l
}

get_running_tasks() {
    ps -e --no-headers | wc -l
}

get_startup_count() {
    if command -v systemctl >/dev/null 2>&1; then
        systemctl list-unit-files --type=service --state=enabled 2>/dev/null | grep enabled | wc -l
    else
        echo "N/A"
    fi
}

get_env_count() {
    printenv | wc -l
}

get_last_login_failure() {
    if command -v lastb >/dev/null 2>&1; then
        lastb -n 1 2>/dev/null | head -n 1
    else
        echo "Not Available"
    fi
}

get_logged_users() {
    who | awk '{print $1}' | sort -u | paste -sd ","
}

get_logged_username() {
    whoami
}

# ================== Output ==================

echo -e "${BOLD}${YELLOW}========== SYSTEM INFORMATION SUMMARY ==========${RESET}"

print_kv "Hostname" "$(get_hostname)"
print_kv "IP Address" "$(get_ip_address)"
print_kv "Linux kernel version" "$(get_kernel_version)"
print_kv "Connected to internet" "$(check_internet)"
print_kv "Number of Processor" "$(get_cpu_count)"
print_kv "Processor Model name" "$(get_cpu_model)"
print_kv "BIOS version" "$(get_bios_version)"
print_kv "Boot device size" "$(get_boot_size)"
print_kv "Default language" "$(get_default_language)"
print_kv "Total installed RAM (in GBs)" "$(get_ram_size)"
print_kv "Swap Space (in GBs)" "$(get_swap_size)"
print_kv "Total number of system drivers" "$(get_driver_count)"
print_kv "Running tasks" "$(get_running_tasks)"
print_kv "Total number of startup programs" "$(get_startup_count)"
print_kv "Total number of environment variables" "$(get_env_count)"
print_kv "Last login failure" "$(get_last_login_failure)"
print_kv "Currently logged in users" "$(get_logged_users)"
print_kv "Logged in username" "$(get_logged_username)"

echo -e "${BOLD}${YELLOW}================================================${RESET}"

