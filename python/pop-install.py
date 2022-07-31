import subprocess
from dataset import APP

class BasedApps:
    def __init__(self, typy_packge, dataset) -> None:
        self.typy_packge = typy_packge
        self.dataset = dataset
        
    def _pre(self, app):
        my_process = ''
        if (self.typy_packge=='deb' and self.dataset=='UPDATE'):
            my_process = ["sudo",  "apt-get", f"{app}", "-y"]
        elif (self.typy_packge=='deb'):
            my_process = ["sudo",  "apt-get", "install",  f"{app}", "-y"]
        
        print(f'INSTALL APP: {app} : {self.dataset.upper()} : Package: {my_process}')
        
        return my_process        

    def install(self):
        print(f'\nSTART INSTALL PROCESS APP {self.typy_packge.upper()}...')
        
        for app in APP[self.dataset]:
                print(subprocess.run(
                    self._pre(app=app), 
                    stderr=subprocess.PIPE, 
                    text=True
                ).stderr)
            
        print(f'FINAL INSTALL PROCESS APP {self.typy_packge.upper()}...')
                
                
BasedApps(typy_packge='deb', dataset="UPDATE").install()                
# BasedApps(typy_packge='deb', dataset="DEB_APP").install()