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

# Get the list of VMS

vms_list=$(az vm list -g $rg --query "[?location=='${location}']" | jq -r '.[] | .osProfile.computerName')



# Check the status of VMs and Stop the running VMs

for vm in $vms_list;
do
    powerState=$(az vm show -n $vm -g $rg -d | jq -r '.powerState')
    if [[ $powerState = *stopped* ]]
    then
	    echo "$vm is already stopped"
    else
	    echo "Stopping $vm"
           az vm stop -n $vm -g $rg
    fi
done
