from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
import os


class blobServiceClient:
    def __init__(self,storageAccountName):
        self.storageAccountName = storageAccountName
        self.url = "https://"+storageAccountName+".blob.core.windows.net"
        self.client = BlobServiceClient( self.url, credential=DefaultAzureCredential())

    def upload_blob_file(self, containerName : str,filePath:str, fileName : str) -> None:
        container_client = self.client.get_container_client(container=containerName)
        with open(file=filePath+fileName, mode="rb") as data:
            container_client.upload_blob(name=fileName, data=data, overwrite=True)

    def upload_blob_stream(self, container_name: str, fileName : str, fileContent : bytes | str):
        blob_client = self.client.get_blob_client(container=container_name, blob=fileName)
        blob_client.upload_blob(fileContent, blob_type="BlockBlob", overwrite=True)
        
    def download_blob_to_file(self, container_name, fileName : str):
        blob_client = self.client.get_blob_client(container=container_name, blob=fileName)
        with open(file=os.path.join(fileName, mode="wb") ) as sample_blob:
            download_stream = blob_client.download_blob()
            sample_blob.write(download_stream.readall())
            
    def list_blobs(self, container_name: str,):
        container_client = self.client.get_container_client(container=container_name)
        blob_list = container_client.list_blobs()
        return blob_list


