"""
SSH connection manager for remote host operations
"""
import paramiko
from typing import Optional

class SSHManager:
    """Manages SSH connections to remote hosts"""
    
    def __init__(self):
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    def connect(self, hostname: str, username: str, password: Optional[str] = None, key_filename: Optional[str] = None):
        """Connect to remote host"""
        self.client.connect(hostname, username=username, password=password, key_filename=key_filename)
    
    def execute_command(self, command: str) -> tuple:
        """Execute command on remote host"""
        stdin, stdout, stderr = self.client.exec_command(command)
        return stdout.read().decode(), stderr.read().decode()
    
    def close(self):
        """Close SSH connection"""
        self.client.close()
