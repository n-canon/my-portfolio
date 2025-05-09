Param(
    [Parameter(Mandatory=$True)]
    [String] $secretFile
)

$secrets = Import-CSV -Path $secretFile
$lst_keyvault_secrets = (Get-AzKeyVaultSecret -Vaultname "$env:kvname").name

#Creating/updating secrets
For($i=0 ; $i -lt $secrets.Length; $i++) 
{ 
    if ($lst_keyvault_secrets -contains $secrets.name[$i] )
    {
        $old_secret = Get-AzKeyVaultSecret -VaultName "$env:kvname" -Name $secrets.name[$i] -AsPlainText
        if ($old_secret -ne $secrets.value[$i]) {
            Write-Output "Updating secret $secrets.name[$i]" 
            $secret = ConvertTo-SecureString -String $secrets.value[$i] -AsPlainText -Force
            Set-AzKeyVaultSecret -VaultName "$env:kvname" -Name $secrets.name[$i] -SecretValue $secret
        }     
    }
    else {      
        Write-Output "Creating secret $secrets.name[$i]" 
        $secret = ConvertTo-SecureString -String $secrets.value[$i] -AsPlainText -Force
        Set-AzKeyVaultSecret -VaultName "$env:kvname" -Name $secrets.name[$i] -SecretValue $secret
    }
}

#Delete secrets
$lst_keyvault_secrets = (Get-AzKeyVaultSecret -Vaultname "$env:kvname").name
For($i=0 ; $i -lt $lst_keyvault_secrets.Length; $i++) 
{ 
    if (-not($secrets.name -contains $lst_keyvault_secrets[$i]) )
    {
        Write-Output "Deleting secret $lst_keyvault_secrets[$i]"   
        Remove-AzKeyVaultSecret -VaultName "$env:kvname" -Name $lst_keyvault_secrets[$i] -PassThru -Force
    }
}