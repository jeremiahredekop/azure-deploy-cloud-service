Param(  
		$pathToModule = "C:\Program Files\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"       
     )
	 
Import-Module $pathToModule
Get-AzurePublishSettingsFile
