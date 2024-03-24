#!/bin/bash

LOGFILE="$(realpath $(date +%s)-ubuntu-setup-script.log)"
FQDN=""
TIMEZONE=""

set_hostname ()
{
  hostnamectl --pretty set-hostname $FQDN
  hostnamectl --static set-hostname $FQDN
}

set_timezone ()
{
  timedatactl set-timezone $TIMEZONE
}

init_update ()
{
  apt update && apt dist-upgrade -y
}

init_packages ()
{
  apt -y install acct figlet openssh-server chrony vim
}

configure_root_full_name ()
{
  chfn -f "`hostname -s` System Administrator" root
}

disable_ubuntu_pro_apt_news ()
{
  pro config set apt_news=false
}

disable_motd_ubuntu_spam ()
{
  chmod -x /etc/update-motd.d/50-motd-news 
  chmod -x /etc/update-motd.d/10-help-text 
  chmod -x /etc/update-motd.d/91-contract-ua-esm-status
}

enable_init_services ()
{
  systemctl enable ssh.service acct.service chrony.service
}

generate_ssh_host_keys ()
{
  rm /etc/ssh/ssh_host_rsa_key
  rm /etc/ssh/ssh_host_ed25519_key
  ssh-keygen -N '' -a 100 -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
  ssh-keygen -N '' -a 100 -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
}

ufw_init ()
{
  ufw enable
  ufw allow ssh
  ufw reload
}

base_sshd_config ()
{
  echo "Port 22" > /etc/ssh/sshd_config.d/custom.conf
  echo "listenAddress 0.0.0.0" >> /etc/ssh/sshd_config.d/custom.conf
  echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config.d/custom.conf
  echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config.d/custom.conf
  echo "VersionAddendum none" >> /etc/ssh/sshd_config.d/custom.conf
}

set_motd ()
{
  hostname -s | figlet > /etc/motd
}

disable_cloud_init ()
{
  touch /etc/cloud/cloud-init.disabled
}

set_hostname >> "$LOGFILE" 2>&1
sleep 1

set_timezone >> "$LOGFILE" 2>&1
sleep 1

init_update >> "$LOGFILE" 2>&1
sleep 1

init_packages >> "$LOGFILE" 2>&1
sleep 1

enable_init_services >> "$LOGFILE" 2>&1
sleep 1

configure_root_pull_name >> "$LOGFILE" 2>&1
sleep 1

set_motd >> "$LOGFILE" 2>&1
sleep 1

disable_motd_ubuntu_spam >> "$LOGFILE" 2>&1
sleep 1

disable_ubuntu_pro_apt_news >> "$LOGFILE" 2>&1
sleep 1

disable_cloud_init >> "$LOGFILE" 2>&1
sleep 1

base_sshd_config >> "$LOGFILE" 2>&1
sleep 1

ufw_init >> "$LOGFILE" 2>&1
sleep 1

