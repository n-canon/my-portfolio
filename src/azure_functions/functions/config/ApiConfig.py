apiConfig = {
    "country" : {
        "route" : "country",
        "name" : "country",
        "secretKey" : "country-api-key",
        "url" : "https://countryapi.io/api/all?apikey=",
        "sinkFilenamePattern" : "country_",
        "sinkBlobContainer" : "landing",
        "sinkDirectory" : "country"
    },
     "exchange_rate" : {
        "route" : "exchange-rate",
        "name" : "exchange-rate",
        "secretKey" : "exchange-rate-api-key",
        "url" : "https://v6.exchangerate-api.com/v6/",
        "relativeUrl" : "/latest/USD",
        "sinkFilenamePattern" : "exchange_rate_",
        "sinkBlobContainer" : "landing",
        "sinkDirectory" : "exchange_rate"
    },
}