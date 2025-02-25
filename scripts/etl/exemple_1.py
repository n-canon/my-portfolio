from models.connectors.http_wrapper import HttpWrapper 
from extract.httpExtract import HttpExtract
from models import file as File

data_loyer = HttpWrapper('https://object.files.data.gouv.fr/hydra-parquet/hydra-parquet/0de53e33c5b555111ffaf7a9849540c7.parquet')
loyer_file = File("data_loyer_","parquet", '')
#Permis d'amenagé csv
data_permis_amenagement =HttpWrapper('https://data.statistiques.developpement-durable.gouv.fr/dido/api/files/6a73fdde-02b1-4c7f-a81c-3c02da6bc4f6')
amenagement_file= File("data_amenagement_", "xls", '')
#Permis de construire des locaux csv
data_permis_locaux = HttpWrapper('https://data.statistiques.developpement-durable.gouv.fr/dido/api/files/38ca96c1-c8af-42db-bba1-13cd4bc713f3')
locaux_file= File("data_locaux_","xls", '')
#Permis de construire des logements csv 
data_permis_logements =HttpWrapper('https://data.statistiques.developpement-durable.gouv.fr/dido/api/files/ab799b04-0b03-4f96-949c-eb23c478a8e8')
logements_file = File("data_logement_", "xls", '')
#Liste des communes json
data_communes =HttpWrapper('https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/georef-france-commune/exports/json?lang=fr&timezone=Europe%2FBerlin')
commune_file= File("data_commune_", "json", '')
#Maires
data_list_maires = HttpWrapper(url='https://www.data.gouv.fr/fr/datasets/r/2876a346-d50c-4911-934e-19ee07b0e503')
maires_file=  File("data_maires_","csv", '')

#data_list_maires.from_http_to_filesystem(maires_file)
lst_data_to_download = [data_loyer,data_permis_amenagement, data_permis_locaux, data_permis_logements, data_communes,data_list_maires]
lst_response_File = [loyer_file, amenagement_file ,locaux_file, logements_file,commune_file , maires_file ]


HttpExtract().from_http_to_filesystem(lst_data_to_download,lst_response_File,'data/raw/')