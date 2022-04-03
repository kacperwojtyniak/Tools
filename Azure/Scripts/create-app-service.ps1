$rg = "rg-kw-key-vault"
$planName="plan-kw-002"
$appName='app-kw-002'
$runetime = '"DOTNET|6.0"'

az appservice plan create `
    --name $planName `
    --resource-group $rg `
    --sku B1 `
    --is-linux

az webapp create `
    --name $appName `
    --runtime $runetime `
    --plan $planName `
    --resource-group $rg `
    --query 'defaultHostName' `
    --assign-identity '[system]' `
    --output tsv

    