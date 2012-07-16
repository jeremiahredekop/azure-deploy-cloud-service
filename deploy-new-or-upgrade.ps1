Param(  $serviceName = "",
        $storageAccountName = "",
        $packageLocation = "",
        $cloudConfigLocation = "",
        $Environment = "Staging",
        $deploymentLabel = "ContinuousDeploy to $servicename",
        $timeStampFormat = "g",
        $alwaysDeleteExistingDeployments = 1,
        $enableDeploymentUpgrade = 1,
        $selectedsubscription = "",
        $subscriptionDataFile = "",
		$pathToModule = "C:\Program Files\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"
     )


Import-Module $pathToModule



Select-AzureSubscription -SubscriptionName $selectedsubscription -SubscriptionDataFile $subscriptionDataFile
#Set-AzureSubscription -DefaultSubscription $selectedsubscription -CurrentStorageAccount $storageAccountName

$subscription = Get-AzureSubscription -Current
$subscriptionname = $subscription.subscriptionname
$subscriptionid = $subscription.subscriptionid
$slot = $environment

Set-AzureSubscription -SubscriptionName $selectedsubscription -SubscriptionDataFile $subscriptionDataFile -CurrentStorageAccount $storageAccountName


function SuspendDeployment()
{
    write-progress -id 1 -activity "Suspending Deployment" -status "In progress"
    Write-Output "$(Get-Date –f $timeStampFormat) - Suspending Deployment: In progress"
    $suspend = Set-AzureDeployment -Status -Slot $slot -ServiceName $serviceName -NewStatus Suspended
    Write-Output "$(Get-Date –f $timeStampFormat) - Suspended Deployment"
}

function DeleteDeployment()
{
    SuspendDeployment

    write-progress -id 2 -activity "Deleting Deployment" -Status "In progress"
    Write-Output "$(Get-Date –f $timeStampFormat) - Deleting Deployment: In progress"
    Remove-AzureDeployment -Slot $slot -ServiceName $serviceName
    Write-Output "$(Get-Date –f $timeStampFormat) - Deleted Deployment"    
}

function Publish()
{
    $deployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot -ErrorVariable a -ErrorAction silentlycontinue 
    if ($a[0] -ne $null)
    {
        write-host "No deployment is detected. Creating a new deployment. "
    }
    #check for existing deployment and then either upgrade, delete + deploy, or cancel according to $alwaysDeleteExistingDeployments and $enableDeploymentUpgrade boolean variables
    if ($deployment.Name -ne $null)
    {
        switch ($alwaysDeleteExistingDeployments)
        {
            1 
            {
                switch ($enableDeploymentUpgrade)
                {
                    1
                    {
                        Write-Output "$(Get-Date –f $timeStampFormat) - Deployment exists in $servicename.  Upgrading deployment."
                        UpgradeDeployment
                    }
                    0  #Delete then create new deployment
                    {
                        Write-Output "$(Get-Date –f $timeStampFormat) - Deployment exists in $servicename.  Deleting deployment."
                        DeleteDeployment
                        CreateNewDeployment

                    }
                } # switch ($enableDeploymentUpgrade)
            }
            0
            {
                Write-Output "$(Get-Date –f $timeStampFormat) - ERROR: Deployment exists in $servicename.  Script execution cancelled."
                exit
            }
        }
    } else {
            CreateNewDeployment
    }
}

function CreateNewDeployment()
{
    write-progress -id 3 -activity "Creating New Deployment" -Status "In progress"
    Write-Output "$(Get-Date –f $timeStampFormat) - Creating New Deployment: In progress"

    $newdeployment = New-AzureDeployment -Slot $slot -Package $packageLocation -Configuration $cloudConfigLocation -label $deploymentLabel -ServiceName $serviceName # -StorageAccountName $storageAccountName
    write-progress -id 3 -activity "Created New Deployment" 

    $completeDeployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot
    $completeDeploymentID = $completeDeployment.deploymentid
    Write-Output "$(Get-Date –f $timeStampFormat) - Created New Deployment ID: $completeDeploymentID"

}

function UpgradeDeployment()
{
    write-progress -id 3 -activity "Upgrading Deployment" -Status "In progress"
    Write-Output "$(Get-Date –f $timeStampFormat) - Upgrading Deployment: In progress"

    Set-AzureDeployment -Upgrade -ServiceName $serviceName -Package $packageLocation -Configuration $cloudConfigLocation -Slot $slot -Label $deploymentLabel -Mode Auto 

    #Update-Deployment -Slot $slot -Package $packageLocation -Configuration $cloudConfigLocation -label $deploymentLabel -ServiceName $serviceName # -StorageAccountName $storageAccountName |   

    $completeDeployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot
    $completeDeploymentID = $completeDeployment.deploymentid
    Write-Output "$(Get-Date –f $timeStampFormat) - Upgrade Deployment: Succeeded, Deployment ID: $completeDeploymentID"

}



Write-Output "$(Get-Date –f $timeStampFormat) - Azure Cloud App deploy script started."
Write-Output "$(Get-Date –f $timeStampFormat) - Preparing deployment of $deploymentLabel for $subscriptionname with Subscription ID $subscriptionid."

Publish

$deployment = Get-AzureDeployment -slot $slot -serviceName $servicename
$deploymentUrl = $deployment.Url

Write-Output "$(Get-Date –f $timeStampFormat) - Created Cloud App with URL $deploymentUrl."
Write-Output "$(Get-Date –f $timeStampFormat) - Azure Cloud App deploy script finished."