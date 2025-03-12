Connect-AzAccount

$secrets = Import-CSV -Path "./01-infra/azure/secrets/secrets.csv"
$secrets

# le contraire doit être fait : en fonction de la liste de secret dans le keyvault, mettre à jour où les supprimer si ils sont
#pas dans le csv
$lst_keyvault_secrets = (Get-AzKeyVaultSecret -VaultName "$env:kvname").Name

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
