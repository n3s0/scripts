#!/bin/bash

set_hostname ()
{
  hostnamectl --pretty set-hostname $HOSTNAME
  hostnamectl --static set-hostname $HOSTNAME
}

set_timzone ()
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
  chf -f "`hostname -s` System Administrator" root
}

create_motd ()
{
  hostname -s figlet > /etc/motd
}

disable_ubuntu_pro_apt_news ()
{
  pro config set_news=false
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
  ufw allow ssh
  ufw enable
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
