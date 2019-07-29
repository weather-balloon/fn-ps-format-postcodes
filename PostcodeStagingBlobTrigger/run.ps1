# Input bindings are passed in via param block.
param([String] $InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"
 
$baseData = ConvertFrom-Csv -InputObject $InputBlob `
    -Delimiter "`t" `
    -Header "country_code", "postal_code", "place_name", "admin_name1", "admin_code1", "admin_name2", "admin_code2", "admin_name3", "admin_code3", "latitude", "longitude", "accuracy"

foreach ($entry in $baseData) {

    $id = @($entry.country_code, $entry.admin_code1, $entry.place_name, $entry.postal_code)
    Add-Member -InputObject $entry -MemberType NoteProperty -Name 'id' -Value ($id -join "-")

    $location = (@{
            type        = "point"
            coordinates = @([double]$entry.longitude, [double]$entry.latitude)
        } | ConvertTo-Json )
    
    Add-Member -InputObject $entry -MemberType NoteProperty -Name 'location' -Value ("$location" -replace '\r*\n', '')
}

[String]$outputCsv = ($baseData | ConvertTo-Csv -NoTypeInformation -Delimiter ',') -join "`n"

Push-OutputBinding -Name OutputBlob -Value $outputCsv


Write-Host "PowerShell Blob trigger function completed - $($baseData.Count) items"