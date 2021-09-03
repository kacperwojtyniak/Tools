# Deploy template with single spot VM
# Admin name: kacper
# Check max price https://prices.azure.com/api/retail/prices?$filter=serviceName eq 'Virtual Machines' and Location eq 'UK South' and armskuName eq 'Standard_D2as_v4' and pricetype eq 'Consumption'
param(
   [Parameter(Mandatory=$true)][string]$rgName,
   [Parameter(Mandatory=$true)][string]$location,
   [Parameter(Mandatory=$true)][string]$password, #when using secure string I cannot log into the machine. need to investigate
   [Parameter()][string]$maxPrice = '0.1'
)



az deployment group create --resource-group $rgName --template-file './template.bicep' --parameters location=$location adminPassword=$password