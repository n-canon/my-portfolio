# import azure.functions as func
# import requests 
# import json
# from shared.infrastructure.blob_client import blobServiceClient
# from shared.infrastructure.keyvault_client import keyvaultClient
# from datetime import datetime
# from .config.ApiConfig import apiConfig

# kvClient = keyvaultClient('kv-ncaproject-dvp')
# blobClient = blobServiceClient("stncaprojectdvp")

# def create_blueprint(item_name : str):
#     bp = func.Blueprint()
#     @bp.route(route=item_name)
#     @bp.function_name(name=item_name)
    
#     def api_handler(req: func.HttpRequest) -> func.HttpResponse:
        
#         name = req.params.get('name')
#         if not name:
#             try:
#                 # send request and get response
#                 url = item.url + item.relativeUrl # => ajouter une méthode de construction d'url
#                 data = requests.get(url).json()
#                 filename = item.sinkFilenamePattern+datetime.now().strftime("%Y%m%d%H%M%S")+'.json'      
#                 #save file to blob storage
#                 blobClient.upload_blob_stream(item.sinkBlobContainer,item.sinkDirectory+"/"+filename,json.dumps(data))               
#             except ValueError:
#                 pass
#         if name:
#             return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
#         else:
#             return func.HttpResponse(
#                 "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
#                 status_code=200
#             )

#     return bp

# def generate_url(item_name: str,source : str) -> str :
#     if source == "exchange_rate":
#         secret_key = kvClient.get_secret(apiConfig.item_name.secretKey)
#         return apiConfig.item_name.url+secret_key
