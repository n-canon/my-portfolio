Install-Module -Name Microsoft.PowerShell.SecretManagement -Repository PSGallery -Force
Install-Module Az -RequiredVersion 10.0.0 -Scope CurrentUser -Force -AllowClobber
Import-Module Az -RequiredVersion 10.0.0 -Force
Install-Module Az.KeyVault -Repository PSGallery -Force
Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Az.KeyVault
Connect-AzAccount

$secrets = Import-CSV -Path "./01-infra/azure/secrets/secrets.csv"
$secrets

# le contraire doit être fait : en fonction de la liste de secret dans le keyvault, mettre à jour où les supprimer si ils sont
#pas dans le csv
$lst_keyvault_secrets = (az keyvault secret list --vault-name "$env:kvname").Name

For($i=0 ; $i -lt $secrets.Length; $i++) 
{ 
    if ($lst_keyvault_secrets -contains $(secrets.name[$i])) {
        Write-Output "Creating/Updating $($secrets.name[$i])" 
        $secret = ConvertTo-SecureString -String $($secrets.value[$i]) -AsPlainText -Force
        Set-AzKeyVaultSecret -VaultName "$env:kvname" -Name $($secrets.name[$i]) -SecretValue $Secret
    }
    else {
        Write-Output "Deleting $($secrets.name[$i])"    
    } 
}
