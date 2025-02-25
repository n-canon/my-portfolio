from models.connectors.file_system import FileSystem
from scripts.transform import df_utils

list_columns = ['reg_code', 'reg_name', 'dep_code', 'dep_name', 'com_code',
       'com_current_code', 'com_name', 'com_name_upper', 'com_name_lower',
       'com_type']
df = FileSystem('data/raw/').read_json('data_commune*.json', list_columns)

#df_region table
region_columns = ['reg_code','reg_name']
df_region = df[region_columns]
df_region = df_utils.columns_from_list_to_string(df_region,region_columns)
df_region = df_utils.remove_duplicated_lines(df_region)
df_region.to_parquet(path='data\\silver\\regions.parquet')

# df_departement
department_columns = ['dep_code','dep_name','reg_code']
df_departement = df[department_columns]
df_departement = df_utils.columns_from_list_to_string(df_region,department_columns)
df_departement = df_utils.remove_duplicated_lines(df_departement)
df_departement.to_parquet(path='data\\silver\\departements.parquet')

# df_villes
villes_columns = ['dep_code','com_code','com_name_upper']
df_villes = df[villes_columns]
df_villes = df_utils.columns_from_list_to_string(df_villes,villes_columns)
df_villes = df_utils.remove_duplicated_lines(df_villes)
df_villes.to_parquet(path='data\\silver\\villes.parquet')