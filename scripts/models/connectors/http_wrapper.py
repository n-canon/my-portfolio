import requests

#HttpWrapper class to make HttpRequest
class HttpWrapper:
    def __init__(self,url):
         self.url = url
         pass

    def get_request(self) -> requests.Response:
        response = requests.get(self.url)
        return response
    