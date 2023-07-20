# Define default values for each field type
$default_values = @{
    "String" = ""
    "Int32" = 0
    "Boolean" = $false
}

function RecursivelyReplaceDefaults($data) {
    foreach ($key in $data.PSObject.Properties.Name) {
        $value = $data.$key
        if ($value -is [System.Management.Automation.PSCustomObject]) {
            # Recursively process sub-dictionaries, excluding the "Logging" section
            if ($key -ne "Logging") {
                $data.$key = RecursivelyReplaceDefaults $value
            }
        } else {
            # Replace the value with the default based on its type
            $type = $value.GetType().Name
            $data.$key = $default_values[$type]
        }
    }
    return $data
}

# Read the JSON file
$json_content = Get-Content -Raw -Path "appsettings.json" | ConvertFrom-Json

# Replace values with defaults
$modified_data = RecursivelyReplaceDefaults $json_content

# Convert the modified data back to JSON
$json_output = $modified_data | ConvertTo-Json -Depth 100

# Write the modified data back to the JSON file
$json_output | Out-File -FilePath "output.json"

Write-Host "Values replaced with defaults. Output written to 'output.json'."
