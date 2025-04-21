import azure.functions as func
from src.azure_functions.functions.ApiExchangeRate import bp_exchange_rate
from src.azure_functions.functions.ApiCountry import bp_country
from azure_functions.functions.blueprint import blueprintfunc

app = func.FunctionApp(http_auth_level=func.AuthLevel.ADMIN)
app.register_functions(bp_exchange_rate) 
app.register_functions(bp_country)
app.register_functions(blueprintfunc) 