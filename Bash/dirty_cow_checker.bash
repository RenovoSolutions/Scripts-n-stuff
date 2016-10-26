#!/bin/bash

# This could be fit to check any kernel version, not just for dirty cow

# Declare the array
declare -A os_target_kernel

# Set up the OS to kernel version array
os_target_kernel=(['ubuntu 16.10']='4.8.0-26-generic #28' ['ubuntu 16.04']='4.4.0-45-generic #66' ['ubuntu 14.04']='3.13.0-100-generic #147' ['debian 8']='3.16.36-1-amd64 #2')

# Get the local OS version
os_release=$( echo "$( cat /etc/*release | grep ^ID= | sed 's/ID=//' | sed 's/"//g' ) $( cat /etc/*release | grep VERSION_ID | tr -d '[A-Za-z]_=\\"' )" )

# Set the target kernel
target_kernel=${os_target_kernel[${os_release}]}

# Get the current kernel
current_kernel=$( echo -e "$( uname -r ) $( uname -rv | grep -o \#[0-9]. )" )

# Check to make sure we actually have a target, which won't always be true, if an update is unavailable for a system
if [ -z "${target_kernel}" ]; then
  echo "INFO: No target kernel for ${os_release}"
  exit 1
fi

# Check right away if current matches target
if [[ "${current_kernel}" != "${target_kernel}" ]]; then
  # If not find higher version kernel of the two
  higher_kernel=$( echo -e "${current_kernel}\n${target_kernel}" | sort -rV | head -n1 )
  # Check if the current kernel and the higher version of the two are the same
  if [[ "${current_kernel}" != "${higher_kernel}" ]]; then
    # If not warn of the vulnerability and exit with 1
    echo "WARNING: ${current_kernel} is vulnerable"
    exit 1
  else
    echo "OK: ${current_kernel} is newer then the target"
    exit 0
  fi
else
  echo "OK: Kernel is up to date with the target."
  exit 0
fi
echo "FAIL: Something went wrong"
exit 1