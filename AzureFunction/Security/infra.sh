
az account set -s '9cbc62c1-0683-4883-a97d-700d8740edd4'
resourcegroupname="xx999fa-rg-CDE-Sand"
resourcelocation=$(az group show --name $resourcegroupname --query location --out tsv)

resourcename='nhsazfnsecurity'
storageaccountname=${resourcename}storage
functionappname=$resourcename-fnapp
apimname=$resourcename-apim

az storage account create -n $storageaccountname -g $resourcegroupname -l $resourcelocation --sku Standard_LRS

az functionapp create --consumption-plan-location $resourcelocation --name $functionappname --os-type Windows --resource-group $resourcegroupname --runtime dotnet --storage-account $storageaccountname

az apim create --name $apimname -g $resourcegroupname -l $resourcelocation --publisher-email nhsenthilkumar@gmail.com --publisher-name 'Senthil'

apimip=$(az apim show -n $apimname -g $resourcegroupname --query publicIpAddresses --out tsv)

az functionapp config access-restriction add -g $resourcegroupname -n $functionappname --rule-name apigateway --action Allow --ip-address $apimip --priority 200
