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
  apt-get -y install $PACKAGE_LIST
}

check_updates
install_packages
