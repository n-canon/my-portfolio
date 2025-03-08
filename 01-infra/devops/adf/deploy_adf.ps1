Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name azure.datafactory.tools -Scope CurrentUser
Import-Module -Name azure.datafactory.tools

Publish-AdfV2FromJson 
   -RootFolder            $Env:RootFolder
   -ResourceGroupName     $Env:ResourceGroupName
   -DataFactoryName       $Env:DataFactoryName
   -Location              $Env:Location

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Untrusted