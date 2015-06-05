Param(
    [string]$websiteName
)

echo "Swapping staging and production slots on $websiteName"
Switch-AzureWebsiteSlot -name vso-deploy-test -force
