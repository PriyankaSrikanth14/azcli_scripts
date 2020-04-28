#!/bin/bash

# Check if user entered Resource Group. If not ask user to prompt the Resource Group Name.
if [[ -z $1 ]]
then
        read -p "Enter Resource Group Name: \t" rg

else
        rg=$1

fi



vms_list=$(az vm list -g $rg --query "[?location=='eastus']" | jq -r '.[] | .osProfile.computerName')

for vm in $vms_list;
do
    powerState=$(az vm show -n $vm -g $rg -d | jq -r '.powerState')
    if [[ $powerState = *running* ]]
    then
	    echo -e "$vm is already started"
    else
	    echo -e "$vm is Stopped\nStarting $vm"
           az vm start -n $vm -g $rg
    fi
done
