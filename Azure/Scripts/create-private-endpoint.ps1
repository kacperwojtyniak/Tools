# https://docs.microsoft.com/en-us/azure/private-link/create-private-endpoint-cli#create-private-endpoint
# https://docs.microsoft.com/en-us/azure/private-link/tutorial-private-endpoint-storage-portal#create-storage-account-with-a-private-endpoint

# When adding a second storage account/sql db/web app private endpoint, you just need to add the endpoint 'az network private-endpoint create' and create a new
# DNS zone group 'az network private-endpoint dns-zone-group create'

#Resource group name
$rg = 'rg-kw-002'

# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns e.g. privatelink.blob.core.windows.net
$dnsZoneName = 'privatelink.database.windows.net'

$sql = 'sql-kw-002'

# Example for storage account
# $id = az storage account show -g $rg -n $storageName --query 'id'
$resourceId = az sql server show -n $sql -g $rg --query 'id'

# run to get the value for --group-id parameter
# https://docs.microsoft.com/en-us/cli/azure/network/private-link-resource?view=azure-cli-latest#az-network-private-link-resource-list
# For values of the --type parameters run az network private-link-resource list -h
# az network private-link-resource list -g $rg -n $storageName --type Microsoft.Storage/storageAccounts
# az network private-link-resource list -g $rg -n $sql --type Microsoft.Sql/servers
# az network private-link-resource list --id $resourceId

$groupId = az network private-link-resource list --id $resourceId --query '[0].properties.groupId'

# Name of the private endpoint
$peName = 'pesql001'

$vnetName = 'vnet-001'
$subnet = 'subnet-pe'
$location = 'swedencentral'

az network vnet subnet create `
    --address-prefixes 10.0.2.0/24 `
    --name $subnet `
    -g $rg `
    --vnet-name $vnetName `
    --disable-private-endpoint-network-policies true


# If using previously created subnet - update subnet to allow private endpoint creation
# az network vnet subnet update `
#     --name $subnet `
#     --resource-group $rg `
#     --vnet-name $vnetName `
#     --disable-private-endpoint-network-policies true

# Create private endpoint

$subnetId = az network vnet subnet show -n $subnet -g $rg --vnet-name $vnetName --query 'id'
az network private-endpoint create `
    --name $peName `
    --resource-group $rg `
    --subnet $subnetId `
    --private-connection-resource-id $resourceId `
    --group-id $groupId `
    --connection-name 'st-pe' `
    --location $location
# At this stage we can connect to the resource using private endpoint, i.e. a private IP
# However, to make it easier, we need to update DNS so that e.g. database.windows.net points to privatelink.database.windows.net
# We can create a private DNS (shown below), update our corporate DNS, set it in hosts file, etc.


# Create DNS zone, so that traffic is routed to the private IP address
az network private-dns zone create `
--resource-group $rg `
--name $dnsZoneName

# Link private DNS zone to a VNET
# Need to link the DNS zone to every VNET that wants to access the private endpoint. So even to a peered vnet
az network private-dns link vnet create `
    --resource-group $rg `
    --zone-name $dnsZoneName `
    --name 'dns-link-pe' `
    --virtual-network $vnetName `
    --registration-enabled false

# Create the A record
az network private-endpoint dns-zone-group create `
   --resource-group $rg `
   --endpoint-name $peName `
   --name 'pe-zone-group' `
   --private-dns-zone $dnsZoneName `
   --zone-name 'stpezone'