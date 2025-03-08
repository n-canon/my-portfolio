Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Az -RequiredVersion 10.0.0 -Scope CurrentUser -Force -AllowClobber
Import-Module Az -RequiredVersion 10.0.0 -Force
Install-Module -Name azure.datafactory.tools -Scope CurrentUser
Import-Module -Name azure.datafactory.tools

Publish-AdfV2FromJson -RootFolder "$env:adf_root" -ResourceGroupName "$env:rg_name" -DataFactoryName "$env:data_factory_name" -Location "$env:rg_location"

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Untrusted