#!/bin/bash


# Check if user entered Resource Group. If not ask user to prompt the Resource Group Name.

if [[ -z $1 ]]
then
        read -p "Enter Resource Group Name:   " rg

else
        rg=$1

fi

if [[ -z $2 ]]
then
        read -p "Enter Location:   " location

else
        location=$2

fi



vms_list=$(az vm list -g $rg --query "[?location=='${location}']" | jq -r '.[] | .osProfile.computerName')

for vm in $vms_list;
do
    powerState=$(az vm show -n $vm -g $rg -d | jq -r '.powerState')
    if [[ $powerState = *stopped* ]]
    then
	    echo "$vm is in stopped"
    else
	    echo "$vm is running"
    fi
done
