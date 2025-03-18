from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential

class keyvaultClient:
    def __init__(self,keyvaultName):
        self.keyvaultName = keyvaultName
        self.client = SecretClient("https://"+keyvaultName+".vault.azure.net", credential=DefaultAzureCredential())

    def set_secret(self, secretName : str, secretValue : str) -> None:
        self.client.set_secret(secretName, secretValue)


    def get_secret(self, secretName : str) -> str:
        retrieved_secret = self.client.get_secret(secretName)
        return retrieved_secret.value

    def delete_secret(self, secretName : str) -> None:
        poller = self.client.begin_delete_secret(secretName)
        poller.result()
