# Format postcodes

A PowerShell-based azure function that is triggered when a file is uploaded to Blob storage.

The expected file is a GeoNames postcode (zip) tab-separated data file
(e.g. <http://download.geonames.org/export/zip/AU.zip>).
The function converts the TSV to CSV. The result is then stored back into the storage account.

To validate the ARM deployment run the following (setting the RG_NAME as appropriate):

    RG_NAME=my-rg
    az group deployment validate --resource-group $RG_NAME --template-file azuredeploy.json
