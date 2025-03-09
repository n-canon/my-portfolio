import azure.functions as func
from functions.MyFirstFunction import bp

app = func.FunctionApp(http_auth_level=func.AuthLevel.ADMIN)
app.register_functions(bp) 