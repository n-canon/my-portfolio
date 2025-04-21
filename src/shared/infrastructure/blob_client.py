from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
import os


class blobServiceClient:
    #Generate blob client
    def __init__(self,storageAccountName):
        self.storageAccountName = storageAccountName
        self.url = "https://"+storageAccountName+".blob.core.windows.net"
        self.client = BlobServiceClient( self.url, credential=DefaultAzureCredential())

    # Upload file to blob 
    def upload_blob_file(self, containerName : str,filePath:str, fileName : str) -> None:
        container_client = self.client.get_container_client(container=containerName)
        with open(file=filePath+fileName, mode="rb") as data:
            container_client.upload_blob(name=fileName, data=data, overwrite=True)

    # Upload stream to blob 
    def upload_blob_stream(self, container_name: str, fileName : str, fileContent : bytes | str):
        blob_client = self.client.get_blob_client(container=container_name, blob=fileName)
        blob_client.upload_blob(fileContent, blob_type="BlockBlob", overwrite=True)
    
    # Download blob stream to file 
    def download_blob_to_file(self, container_name, fileName : str):
        blob_client = self.client.get_blob_client(container=container_name, blob=fileName)
        with open(file=os.path.join(fileName, mode="wb") ) as sample_blob:
            download_stream = blob_client.download_blob()
            sample_blob.write(download_stream.readall())
    
    def read_blob(self, container_name, fileName : str):
        blob_client = self.client.get_blob_client(container=container_name, blob=fileName)
        return blob_client.download_blob()
    
    # Return a list of blob names in a container        
    def list_blobs(self, container_name: str,filename_pattern: str) -> list:
        container_client = self.client.get_container_client(container=container_name)
        blob_list = container_client.list_blobs(name_starts_with=filename_pattern)
        lst = []
        for blob in blob_list:
            lst.append(blob.name)
        return lst

    def list_blobs_V1(self, container_name: str,filename_pattern: str) -> list:
        container_client = self.client.get_container_client(container=container_name)
        blob_list = container_client.list_blobs(name_starts_with=filename_pattern)
        return blob_list

