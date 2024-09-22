# SSHLogCleaner

# SSH Log Cleaning Script

## Overview

This script is designed to clean up SSH login-related logs on Linux systems. It removes traces of SSH login sessions from various log files, including successful and failed login attempts, current session records, authentication logs, and user command history. The script is intended for authorized security testing purposes only.

## Features

- Cleans logs from multiple sources, including:
  - `/var/log/wtmp` - records of successful logins.
  - `/var/log/btmp` - records of failed login attempts.
  - `/var/run/utmp` - current session records.
  - `/var/log/auth.log` - authentication logs (Debian/Ubuntu).
  - `/var/log/secure` - authentication logs (CentOS/RHEL).
  - `/var/log/messages` - general system logs.
  - `/var/log/syslog` - system logs (Debian/Ubuntu).
  - `/root/.bash_history` - root user command history.
  - User-specific `.bash_history` files.
  - Compressed and rotated logs (`*.gz`, `*.1`, `*.old`, etc.).
  - Audit logs (`/var/log/audit/audit.log`).
  - Custom SSH logs (e.g., `/var/log/sshd.log`).
  - Other SSH-related logs detected dynamically.
- Restarts the `rsyslog` service to refresh the logging system.

## Usage
```
bash <(curl -sL https://raw.githubusercontent.com/gmh5225/SSHLogCleaner/main/clean_ssh.sh)
```
