import azure.functions as func
from src.azure_functions.functions.config.ApiConfig import apiConfig
from src.azure_functions.functions.GetFromApiGenerator import create_blueprint

app = func.FunctionApp(http_auth_level=func.AuthLevel.ADMIN)

for item in apiConfig:
    bp = create_blueprint(item.name)
    app.register_functions(bp)