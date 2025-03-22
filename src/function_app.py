import azure.functions as func
#from azure_functions.functions.MyFirstFunction import bp
#from azure_functions.functions.Mysecondfunction import bp_exchange_rate
from azure_functions.functions.blueprint import blueprintfunc

app = func.FunctionApp(http_auth_level=func.AuthLevel.ADMIN)
#app.register_functions(bp) 
#app.register_functions(bp_exchange_rate) 
app.register_functions(blueprintfunc) 