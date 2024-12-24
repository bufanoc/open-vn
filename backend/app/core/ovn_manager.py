"""
OVN operations manager
"""
from .ssh_manager import SSHManager

class OVNManager:
    """Manages OVN operations"""
    
    def __init__(self, ssh_manager: SSHManager):
        self.ssh = ssh_manager
    
    async def install_ovn(self, host: str):
        """Install OVN on remote host"""
        pass
    
    async def configure_ovn(self, host: str):
        """Configure OVN on remote host"""
        pass
    
    async def get_ovn_status(self, host: str):
        """Get OVN status from remote host"""
        pass
