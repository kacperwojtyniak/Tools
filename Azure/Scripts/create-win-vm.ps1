# Creates Windows Server VM with RDP port opened
# visual studio community 2022 win11 MicrosoftVisualStudio:visualstudio2022:vs-2022-comm-latest-win11-n:2021.11.12

# Admin password is commited as these VMs live usually a few hours at most and are used for Azure Exploration

az vm create `
--name 'vm-kw-001' `
--resource-group 'rg-kw-001' `
--admin-username 'kacper' `
--admin-password 'AdminSecret!@#123' `
--image "MicrosoftVisualStudio:visualstudio2022:vs-2022-comm-latest-win11-n:2021.11.12" `
--size Standard_D4s_v4 `
--nsg-rule RDP `
--location WestEurope `
--vnet-name 'vnet-kw-001' `
--subnet 'subnet-vm'