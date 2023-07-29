$artifactUrl = Get-BCArtifactUrl -type Sandbox -version 17 -country "be" -select Latest

Write-Host $artifactUrl

#$licPath = "C:\Users\bossu\Downloads\lic.flf"
$securePassword = ConvertTo-SecureString -String "Test@1234!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -argumentList "admin", $securePassword

New-BCContainer `
    -containerName "DVDEMO" `
    -artifactUrl $artifactUrl `
    -accept_eula `
    -accept_outdated `
    -updateHosts `
    -useBestContainerOS `
    -assignPremiumPlan `
    -auth "NavUserPassword" `
    -doNotExportObjectsToText `
    -credential $credential