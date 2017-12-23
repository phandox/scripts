#!/usr/bin/env bash

# Script will open HTTP port on firewall and manually renew the certificate on Synology NAS
# After sucess, it will close the port again.
# TODO do some error reporting

# Stop script when error occurs
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Variables for app

SSH_IDENDITY_FILE="/var/services/homes/admin/.ssh/id_rsa.pub"
SSH_USER="synology"
FIREWALL_HOST="mikrotik.home.lukasnagy.cz" # TODO check if is resolvable

function get_rule_id() {
  # Takes expression for grep to find in Mikrotik rule base
  # TODO do sanity checking of input
  local regexp=$1
  local ssh_res=$(ssh -l ${SSH_USER} ${FIREWALL_HOST} "/ip firewall filter print" | grep "${regexp}" | cut -d' ' -f 2)
  echo $ssh_res
}

function toggle_rule() {
  # Takes ID of rule from rule base and either on for enabling or off for disabling the rule.
  # Otherwise, it will exit with error.
  local id=$1
  local action=$2
  case $action in
    on)
      ssh -l ${SSH_USER} ${FIREWALL_HOST} "/ip firewall filter enable ${id}"
      ;;
    off)
      ssh -l ${SSH_USER} ${FIREWALL_HOST} "/ip firewall filter disable ${id}"
      ;;
    *)
      echo "Action should be enable or disable"
      exit 1
  esac
}

# Open HTTP port on firewall
LE_RULE_ID=$(get_rule_id "Encrypt")
toggle_rule ${LE_RULE_ID} on

# Renew certificate
syno-letsencrypt renew-all
[ $? = 0 ] && echo "Renew sucessful"

# Close HTTP port on firewall
toggle_rule ${LE_RULE_ID} off
