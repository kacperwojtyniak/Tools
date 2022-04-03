# Creates Ubuntu with SSH port open

az vm create `
--name 'vm-kw-005' `
--resource-group 'rg-kw-vm-001' `
--admin-username 'kacper' `
--generate-ssh-keys `
--image UbuntuLTS `
--size Standard_D2s_v4 `
--nsg-rule SSH `
--location WestEurope `
--vnet-name 'vnet-002' `
--subnet 'subnet2'

az vm encryption enable `
 --resource-group "rg-kw-001" `
  --name "vm-kw-001" `
   --disk-encryption-keyvault "kv-kw-001" `
   --volume-type All