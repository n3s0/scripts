#!/bin/bash
#

PACKAGE_LIST="mysql-server"

function check_root ()
{
  echo "Make sure you run this as root!"
}

function check_updates ()
{
  apt update
}

function install_packages ()
{
  apt -y install mysql-server
}

check_updates
install_packages
