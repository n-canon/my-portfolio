import azure.functions as func
import requests 
import json
from shared.infrastructure.blob_client import blobServiceClient
from shared.infrastructure.keyvault_client import keyvaultClient
from datetime import datetime

bp_country = func.Blueprint()
@bp_country.route(route="country")
@bp_country.function_name(name="country")     
def exchange_rate_to_blob(req: func.HttpRequest) -> func.HttpResponse:
    
    name = req.params.get('name')
    if not name:
        try:
             #Get api key
            kvClient = keyvaultClient('kv-ncaproject-dvp')
            country_key = kvClient.get_secret("country-api-key")
            
            # send request and get response
            url = 'https://countryapi.io/api/all?apikey='+country_key
            data = requests.get(url).json()
            filename = 'country_'+datetime.now().strftime("%Y%m%d%H%M%S")+'.json'
            
            #save file to blob storage
            blobClient = blobServiceClient("stncaprojectdvp")
            blobClient.upload_blob_stream("landing","country/"+filename,json.dumps(data))
            
        except ValueError:
            pass

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )

   