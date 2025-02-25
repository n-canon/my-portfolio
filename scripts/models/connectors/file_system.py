import os.path
import pandas as pd
from pandas import DataFrame
import glob
import file as File

class FileSystem:
    def __init__(self,path):
        self.path = path

    def create_folder(self) -> bool:
        try:
            if not os.path.isdir(self.path):
                os.makedirs(self.path) 
            return True
        except:
            return False

    def save_as_txt_file(self, file : File) -> bool:
        try:
            filename = file.generate_name()
            with open(self.path+filename, mode="wb") as destinationFile:
                destinationFile.write(file.content)
                destinationFile.close()
            print(f"Downloaded file {self.path+filename}")
            return True
        except:
            return False
        
    def save_as_parquet_file(self, file : File) -> bool:
        try:
            filename = file.generate_name()
            file.content.to_parquet(path='data\\silver\\'+filename+'villes.parquet')
            return True
        except:
            return False
        
    # ajouter le list_columns en optionnel 
    def read_json(self,filePattern : str, list_columns : list) -> DataFrame:
        file_list = glob.glob(self.path+filePattern)
        data_frames = [pd.read_json(file) for file in file_list]
        df = pd.concat(data_frames)
        df = df[list_columns]
        return df
    
    def read_parquet(self,filePattern : str, list_columns : list) -> DataFrame:
        file_list = glob.glob(self.path+filePattern)
        data_frames = [pd.read_parquet(file) for file in file_list]
        df = pd.concat(data_frames)
        df = df[list_columns]
        return df
    