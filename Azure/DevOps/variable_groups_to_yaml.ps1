$variableGroupId = 32
$project = "CFPortal"
$variables = az pipelines variable-group variable list --id $variableGroupId -p $project | ConvertFrom-Json


$yaml = ""

foreach ($property in $variables.PSObject.Properties) {
    Write-Output "$($property.Name): $($property.Value.value)"    
    $yaml += "  $($property.Name): $($property.Value.value)`n"    
}

$yaml | Set-Clipboard