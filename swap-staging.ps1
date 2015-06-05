Start-AzureWebsite vso-deploy-test -slot staging1

Switch-AzureWebsiteSlot -name vso-deploy-test -force
