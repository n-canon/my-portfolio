from datetime import datetime

class File:
        def __init__(self,name : str, extension : str, content : bytes):
                self.name = name
                self.extension = extension
                self.content = content

        def generate_name(self) -> str:
                now = datetime.now() 
                return self.name+ now.strftime("%d%m%Y")+'.'+self.extension   
