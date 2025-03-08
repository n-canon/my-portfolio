Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Az -RequiredVersion 10.0.0 -Scope CurrentUser -Force -AllowClobber
Import-Module Az -RequiredVersion 10.0.0 -Force
Install-Module -Name azure.datafactory.tools -Scope CurrentUser
Import-Module -Name azure.datafactory.tools

Publish-AdfV2FromJson 
   -RootFolder            $Env:adf_root
   -ResourceGroupName     $Env:rg_name
   -DataFactoryName       $Env:data_factory_name
   -Location              $Env:rg_location

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Untrusted