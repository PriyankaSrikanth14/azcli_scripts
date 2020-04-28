#!/bin/bash

source ./variables.env

az group create --location $location --name $rg_name


az network vnet create --name $vm_name --location $location --resource-group $rg_name --address-prefixes $vnet_cidr --subnet-name $subnet_name --subnet-prefixes $subnet_cidr


for i in {1..3}
do
	az vm create --name $vm_name-$i --resource-group \
	$rg_name --image $vm_image --size $vm_size --vnet-name $vnet_name --subnet $subnet_name \
	--public-ip-sku standard 
done



