Connect-AzAccount

$secrets = Import-CSV -Path "01-infra/azure/secrets/secrets.csv"
$secrets

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
