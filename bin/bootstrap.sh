#!/usr/bin/env bash

# Determine out the OS major version
OS_MAJ_VER=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) | cut -c 1`
PLATFORM=`uname -i`

# Disable the firewall
if [ $OS_MAJ_VER -gt 6 ]; then
  systemctl stop firewalld
  systemctl disable firewalld
else
  service iptables stop
  chkconfig iptables off
fi

# Do a package upgrade at this stage
yum -y update

# Install the EPEL repository
rpm -q epel-release >/dev/null
if [ $? -ne 0 ]; then
  yum -y install epel-release
  echo "EPEL repository successfully installed."
else
  echo "EPEL repository already installed. Skipped."
fi

# Install the PuppetLabs repository
rpm -q puppetlabs-release >/dev/null
if [ $? -ne 0 ]; then
  REPO_URL="http://yum.puppetlabs.com/puppetlabs-release-el-${OS_MAJ_VER}.noarch.rpm"
  REPO_PATH=$(mktemp)
  curl -k -L "${REPO_URL}" -o "${REPO_PATH}" >/dev/null 2>&1
  rpm -i "${REPO_PATH}" >/dev/null 2>&1
  rm -f "${REPO_PATH}" >/dev/null
  echo "Puppetlabs repository successfully installed."
else
  echo "Puppetlabs repository already installed. Skipped."
fi

# Install puppet
if type puppet >/dev/null; then
  echo "Puppet already available."
else
  echo "Installing puppet and facter."
  yum -y install puppet facter
fi

# Apply manifest
puppet apply --modulepath=/vagrant/modules /vagrant/manifests/site.pp
exit 0

