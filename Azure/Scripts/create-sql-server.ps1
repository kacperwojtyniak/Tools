$rg = 'rg-kw-003'
$l='swedencentral'
$server = 'sql-kw-001'

az sql server create -n $server --location $l -g $rg -u kacper -p 'abcABC123' --minimal-tls-version 1.2

# Allow access from azure services
az sql server firewall-rule create -g $rg -s $server -n azureservices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0