#!/bin/bash
#
# Author: Timothy Loftus (n3s0)
#
# Script will automate moving the mysql data directory to a directory of
# your choosing. Just need to edit some variables.
#
# Some things to note. Do not add trailing / at the end of these paths.
# The script does that on it's own and doing so may break the
# installation.
#
# This installation script provides output to and provides the path to a
# log file at the end of it's execution. Please look at that should you
# be having any issues.
#
# 03-14-2024 - TIL
#   - First revision of the setup script.

echo "This script installs and configured MySQL Server in a custom data directory"
echo "on Ubuntu Server 22.04."
echo""

# Geenrates the log path for later use.
LOGPATH=$(realpath "mysql_ubuntu_install_custom_datadir_$(date +s).log")
# Default data directory for MySQL Server
CURRENT_MYSQL_DATADIR_PATH="/var/lib/mysql"
# Database root for the database
DBROOT_PATH=""
# The updated MySQL data directory that will be moved.
NEW_MYSQL_DATADIR_PATH=""

export DEBIAN_FRONTEND=noninteractive

# Provides output for general informational messages
function info_msg ()
{
  echo "$1"
}

# Warning output
function warning_msg ()
{
  echo "[-] $1"
}

# Error output (indicates there's an error)
function fatal_error ()
{
  echo "[!] $1"
}

# Checks that the script is being run as root, DBROOT_PATH variable is
# set, and if k
function pre_run_checks ()
{
  if [[ $EUID -ne 0 ]]; then
    fatal_error "Not running as root. Please run as sudo/root"
    exit 1
  fi
  
  if [[ $DBROOT_PATH == null ]]; then
    fatal_error "The CUSTOM_MYSQL_DATADIR_PATH variable needs to be set"
    exit 1
  fi

  if [[ ! -d $DBROOT_PATH ]]; then
    fatal_error "The CUSTOM_MYSQL_DATADIR_PATH doesn't exist"
    fatal_error  "Please consider creating the path or specifying the correct one"
    exit 1
  fi
}

function package_install ()
{
  apt update
  apt -y install mysql-server rsync
}

function start_mysql_service ()
{
  systemctl start mysql.service
}

function stop_mysql_service ()
{
  systemctl stop mysql.service
}

function restart_apparmor_service ()
{
  systemctl restart apparmor.service
}

function migrate_mysql_datadir ()
{
  rsync -av /var/lib/mysql $NEW_MYSQL_DATADIR_PATH
  mv /var/lib/mysql /var/lib/mysql.bak
}

function cleanup_before_mysql_start ()
{
  chown -R mysql:mysql $NEW_MYSQL_DATADIR_PATH
  mkdir -p /var/lib/mysql/mysql
}

function edit_mysqld_config ()
{
  SED_EXPRESSION="s/# datadir.*$/datadir = "${NEW_MYSQL_DATADIR_PATH//\//\\\/}""
  sed -i -e $SED_EXPRESSION /etc/mysql/mysql.conf.d/mysqld.conf
}

funtion edit_apparmor_aliases ()
{
  SED_EXPRESSION="s/#alias \/var\/lib\/mysql\/ ->.*$/alias \/var\/lib\/mysql\/ -> ${NEW_MYSQL_DATADIR_PATH//\//\\/}\/,/"
  sed -i -e $SED_EXPRESSION /etc/apparmor.d/tunables/alias
}

function cleanup_after_install ()
{
  rm -rf /var/lib/mysql.bak
}

info_msg "This script will log output to $LOGPATH to assist with any issues"
sleep 1

pre_run_checks >> "$LOGPATH" 2>&1
sleep 1

info_msg "[1/9] Installing system packages (This may take several minutes"
package_install >> "$LOGPATH" 2>&1
sleep 1

info_msg "[2/9] Stopping MySQL service so the work can begin"
stop_mysql_service >> "$LOGPATH" 2>&1
sleep 1

info_msg "[3/9] Moving the mysql datadirectory to its new location"
migrate_mysql_datadir >> "$LOGPATH" 2>&1
sleep 1

info_msg "[4/9] Cleaning up some things"
cleanup_before_mysql_start >> "$LOGPATH" 2>&1
sleep 1

info_msg "[5/9] Updating the mysqld configuration"
edit_mysqld_config >> "$LOGPATH" 2>&1
sleep 1

info_msg "[6/9] Editing the AppArmor alias for MySQL" 
edit_apparmor_aliases >> "$LOGPATH" 2>&1
sleep 1

info_msg "[7/9] Restarting AppArmor and starting MySQL"
restart_apparmor_service >> "$LOGPATH" 2>&1
start_mysql_service >> "$LOGPATH" 2>&1
sleep 1

info_msg "[8/9] Finished soon... Cleaning up a little"
cleanup_after_install >> "$LOGPATH" 2>&1
sleep 1

info_msg "[9/9] Obtaining troubleshooting data data about mysql service and appending to log"
systemctl status mysql >> "$LOGPATH" 2>&1
tail -n 100 /var/log/mysql/error.log >> "$LOGPATH" 2>&1
sleep 1

info_msg ""
info_msg "MySQL data directory migration is complete!"
info_msg "If you need a more detailed description of what his script has done"
info_msg "please check the log file for it."
info_msg "Logfile: $LOGPATH"
info_msg "New MySQL Datadir: $CUSTOM_MYSQL_DATADIR_PATH"
info_msg "MySQL Service Status: $(systemctl is-active mysql)"
info_msg ""
info_msg "Please make sure to check the full output of the mysql service status"
info_msg "to make sure it's running. the output for this will also be in the log."
info_msg ""
