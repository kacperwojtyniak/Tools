$rg = 'rg-kw-001'
$vnetName = 'vnet-kw-001'

az network vnet create `
--name $vnetName `
--resource-group $rg `
--address-prefixes '10.0.0.0/16' `
--location WestEurope

az network vnet subnet create `
--address-prefixes '10.0.1.0/24' `
--name 'subnet-vm-001' `
--resource-group $rg `
--vnet-name $vnetName