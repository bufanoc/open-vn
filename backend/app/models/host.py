"""
Host model definition
"""
from pydantic import BaseModel
from typing import Optional

class Host(BaseModel):
    """Host model"""
    id: str
    hostname: str
    ip_address: str
    status: str
    ovn_role: Optional[str] = None
