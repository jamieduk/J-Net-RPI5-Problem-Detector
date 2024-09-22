#!/bin/bash
# J~Net© RPI5-Problem-Detector
# https://github.com/jamieduk/J-Net-RPI5-Problem-Detector
#
# sudo ./run.sh
#

# Check if chkrootkit is installed
if command -v chkrootkit &> /dev/null; then
    echo ""
else
    echo "chkrootkit is not installed. Installing..."
    sudo apt update && sudo apt install -y chkrootkit
    echo "chkrootkit has been installed."
fi


echo "Welcome to J~Net© RPI5-Problem-Detector"

# Define available log files to check
LOG_FILES=(
    "/var/log/alternatives.log"
    "/var/log/boot.log"
    "/var/log/chkrootkit"
    "/var/log/faillog"
    "/var/log/lastlog"
    "/var/log/wtmp"
    "/var/log/apache2/error.log"  # If Apache is installed
    "/var/log/cups/error_log"      # If CUPS is installed
    "/var/log/dpkg.log"
)

# Define patterns to search for
ERROR_PATTERNS=(
    "error"
    "fail"
    "fatal"
    "segfault"
    "exception"
    "warning"
    "critical"
    "panic"
)

# Create an output file
OUTPUT_FILE="error_log_report.txt"
echo "Error Report - $(date)" > "$OUTPUT_FILE"
echo "==========================" >> "$OUTPUT_FILE"

# Check each log file
for LOG_FILE in "${LOG_FILES[@]}"; do
    if [[ -f "$LOG_FILE" ]]; then
        echo "Checking $LOG_FILE..." >> "$OUTPUT_FILE"
        for PATTERN in "${ERROR_PATTERNS[@]}"; do
            echo "Searching for '$PATTERN'..." >> "$OUTPUT_FILE"
            grep -i "$PATTERN" "$LOG_FILE" >> "$OUTPUT_FILE" || echo "No matches found for '$PATTERN'." >> "$OUTPUT_FILE"
        done
        echo "" >> "$OUTPUT_FILE"
    else
        echo "$LOG_FILE not found." >> "$OUTPUT_FILE"
    fi
done

# Display the report
cat "$OUTPUT_FILE"

dmesg | less > more.txt

#cat more.txt

chkrootkit > rootkitcheck.txt

echo "Check the text files to see if there is any issues "

ls *.txt

echo "Thanks for using J~Net© RPI5-Problem-Detector"
