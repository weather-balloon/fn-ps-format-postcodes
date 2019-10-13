param(
    [String]$Path = "data/AU.txt"
)

$baseData = Import-Csv -Path $Path -Delimiter "`t" -Header "country_code", "postal_code", "place_name", "admin_name1", "admin_code1", "admin_name2", "admin_code2", "admin_name3", "admin_code3", "latitude", "longitude", "accuracy"


foreach ($entry in $baseData) {

    $id = @($entry.country_code, $entry.admin_code1, $entry.place_name, $entry.postal_code) -join "-"

    $encId = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($id))

    Add-Member -InputObject $entry -MemberType NoteProperty -Name 'id' -Value $encId

    $location = (@{
            type        = "point"
            coordinates = @($entry.longitude, $entry.latitude)
        } | ConvertTo-Json )

    Add-Member -InputObject $entry -MemberType NoteProperty -Name 'location' -Value ("$location" -replace '\r*\n', '')

}

[string]$outputCsv = ($baseData | ConvertTo-Csv -NoTypeInformation -Delimiter ',') -join "`n"

$outputCsv
