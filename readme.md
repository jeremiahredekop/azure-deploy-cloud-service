
#Readme

*(Updated for June, 2012 version of Azure SDK)*

These files are intented to be used as helpers to automate the deployment of .net Cloud Services to Windows Azure

##Links
 * [Windows Azure SDK](https://www.windowsazure.com/en-us/develop/downloads/)
 * [Install Windows Azure Cmdlets](http://go.microsoft.com/?linkid=9811175&clcid=0x409)
 * [MSDN: Windows Azure Cmdlets](http://msdn.microsoft.com/en-us/library/windowsazure/jj152841)
 * [MSDN: Getting Started with Windows Azure Powershell](http://msdn.microsoft.com/en-us/library/windowsazure/jj156055) 
  
  
  
##Overview

There are 2 types of calls, setup & deployment. 

###Setup

 * Run script *setup-a-getPublishSettings.ps1* which will give you a .publishsettings file
  * Docs: [Get-AzurePublishSettingsFile](http://msdn.microsoft.com/en-us/library/windowsazure/jj152882.aspx)
 * Run script *setup-b-importPublishSettings.ps1* which imports the .publishsettings file
  * Docs: [Import-AzurePublishSettingsFile](http://msdn.microsoft.com/en-us/library/windowsazure/jj152885.aspx)
 
###Deployment

Your machine should now be set up to deploy to Azure.  We can now proceed to the following call which would be automated as part of your Continuous Integration routine:

 * Run script *deploy-new-or-upgrade.ps1*
  
  
  