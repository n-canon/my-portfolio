from models.connectors.file_system import FileSystem
from models.connectors.http_wrapper import HttpWrapper 
from models.file_wrapper import File

class HttpExtract:
    def __init__(self):
       pass

    def from_http_to_filesystem(self,list_http_request : list[HttpWrapper], list_files : list[File], path : str) -> bool:
        try:
            res = list(map(lambda  a, b : self.download_http_to_filesystem(a,b,path), list_http_request , list_files))
            print(res)
            return True
        except:
            return False
         
    def download_http_to_filesystem(self,http : HttpWrapper, file : File, path : str) -> bool:
        try:
            response = http.get_request()
            file.content = response.content
            FileSystem(path).create_folder()
            FileSystem(path).save_as_txt_file(file)
            return True
        except:
            return False
    

