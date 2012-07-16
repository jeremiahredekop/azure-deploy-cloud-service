Param(  $pathToSettingsFile = "",
		$pathToModule = "C:\Program Files\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1",
        $outputXmlFile = ""
     )
	 
Import-Module $pathToModule
Import-AzurePublishSettingsFile -PublishSettingsFile $pathToSettingsFile -SubscriptionDataFile $outputXmlFile