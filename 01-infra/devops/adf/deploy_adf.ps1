Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Az -RequiredVersion 10.0.0 -Scope CurrentUser -Force -AllowClobber
Import-Module Az -RequiredVersion 10.0.0 -Force
Install-Module -Name azure.datafactory.tools -Scope CurrentUser
Import-Module -Name azure.datafactory.tools

Publish-AdfV2FromJson 
   -RootFolder            $Env:RootFolder
   -ResourceGroupName     $Env:ResourceGroupName
   -DataFactoryName       $Env:DataFactoryName
   -Location              $Env:Location

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Untrusted