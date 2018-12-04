#!/bin/bash
#
# TODO
# get a specific AMI id or assume the latest as default
# ask used to provide a path of the packer conf file
# pass the remaining args to packer

export PATH="$PATH:."
ME=$(basename $0)

if [[ $# > 0 ]] ; then
  echo "This script doesn't accept any command line options."
  echo "Usage: ./${ME}"
  exit 1
fi

which aws > /dev/null || HAS_PREREQS="false"
which packer > /dev/null || HAS_PREREQS="false"
which jq > /dev/null || HAS_PREREQS="false"

if [[ $HAS_PREREQS == "false" ]] ; then
  echo "Could not find one or more of awscli/packer/jq in the PATH."
  echo "Please ensure that you have all of these in your path."
  exit 1
else
  echo "Found awscli and packer in the PATH."
fi

subnet_id=$1
sg_id=$2

PACKER_CMD="PACKER_LOG=1 packer build create_test_ami.packer ${subnet_id} ${sg_id}"
echo "Building AMI"
echo $PACKER_CMD
$PACKER_CMD

if [[ $? != 0 ]] ; then
  echo "Packer command failed. Exiting."
  exit 1
fi

