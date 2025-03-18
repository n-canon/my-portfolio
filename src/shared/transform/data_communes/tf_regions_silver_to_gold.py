from models.connectors.file_system import FileSystem
import pandas as pd
from pandas import DataFrame

region_columns = ['reg_code','reg_name']
df = FileSystem('data/silver/').read_parquet('departement*.parquet', region_columns)
df
