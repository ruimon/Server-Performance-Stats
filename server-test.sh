#!/bin/bash

PS3="-----------------------------------------------------
Select the required functionality (1-5, or 6 to exit):"

Overall_CPU() {
        vmstat 1 2 | awk '
BEGIN { 
    printf "%-6s %-6s %-6s %-6s %-6s\n", "User", "Sys", "Idle", "Wait", "Stolen"
    print "-----------------------------------------------------"
} 
NR==4 { 
    printf "  %-4d   %-4d   %-4d   %-4d   %-4d\n", $13, $14, $15, $16, $17 
}'
}

Total_memory(){
        echo "-----------------------------------------------------"
        free -h
        free | awk '/Mem:/ {printf "busy: %.2f%%\nfree: %.2f%%\n", $3/$2*100, $4/$2*100}' 
}

Disk_info(){
        df -h | awk '
BEGIN { 
    printf "%-6s %-6s %-5s \n", "Used", "Avail", "Use%"
    print "----------------------------------"
} 
    NR>1 && $1 !~ /^(none|tmpfs|rootfs)$/ { 
        printf "%-15s %-6s %-6s %-5s\n", $1, $3, $4, $5 
    }'
}

Top_5_processes_cpu(){
        echo "-----------------------------------------------------"
        ps aux --sort=-%cpu | head -n 5
}

Top_5_processes_mem(){
        echo "-----------------------------------------------------"
        ps aux --sort=-%mem | head -n 5
}
# Задаем массив с пунктами меню
options=(
    "Overall CPU usage"
    "Total memory used (free/used, %)"
    "Total disk space usage (free/used, %)"
    "Top 5 processes by CPU load"
    "Top 5 processes by memory consumption"
    "Exit"
)

# Запускаем меню
select opt in "${options[@]}"
do
    case $opt in
        "Overall CPU usage")
            echo "Displaying CPU usage..."
            Overall_CPU
            ;;
        "Total memory used (free/used, %)")
            echo "Displaying memory info..."
            Total_memory
            ;;
        "Total disk space usage (free/used, %)")
            echo "Displaying disk info..."
            Disk_info
            ;;
        "Top 5 processes by CPU load")
            echo "Displaying top CPU processes..."
            Top_5_processes_cpu
            ;;
        "Top 5 processes by memory consumption")
            echo "Displaying top memory processes..."
            Top_5_processes_mem
            ;;
        "Exit")
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done

