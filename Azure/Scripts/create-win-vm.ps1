# Creates Windows Server VM with RDP port opened

az vm create `
--name 'vm-kw-001' `
--resource-group 'rg-kw-001' `
--admin-username 'kacper' `
--admin-password 'AdminSecret!@#123' `
--image Win2019Datacenter `
--size Standard_D2s_v4 `
--nsg-rule RDP `
--location WestEurope