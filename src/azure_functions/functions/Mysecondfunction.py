import azure.functions as func
import requests 
from shared.infrastructure.blob_client import blobServiceClient
from shared.infrastructure.keyvault_client import keyvaultClient
from datetime import datetime

bp_exchange_rate = func.Blueprint()
@bp_exchange_rate.route(route="exchangerate")
@bp_exchange_rate.function_name(name="exchangerate")     
def exchange_rate_to_blob(req: func.HttpRequest) -> func.HttpResponse:
    
    name = req.params.get('name')
    if not name:
        try:
             #Get api key
            kvClient = keyvaultClient('kv-ncaproject-dvp')
            exchange_rate_key = kvClient.get_secret("exchange-rate-api-key")
            
            # send request and get response
            url = 'https://v6.exchangerate-api.com/v6/'+exchange_rate_key+'/latest/USD'
            data = requests.get(url)
            filename = 'test3'+datetime.now().strftime("%Y%m%d%H%M%S")+'.json'
            
            #save file to blob storage
            blobClient = blobServiceClient("stncaprojectdvp")
            blobClient.upload_blob_stream("landing","exchange_rate/"+filename,str(data).encode())
        except ValueError:
            pass

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )

   