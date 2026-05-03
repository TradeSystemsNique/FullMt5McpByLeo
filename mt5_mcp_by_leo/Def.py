#+------------------------------------------------------------------+
#| Imports                                                          |
#+------------------------------------------------------------------+
import mcp_mt5_conection
from typing import Dict, Any 
import json
import argparse
from argparse import Namespace

#+------------------------------------------------------------------+
#| Args                                                             |
#+------------------------------------------------------------------+
g_parser : argparse.ArgumentParser = argparse.ArgumentParser()
g_parser.add_argument("--config", type=str, default="")
g_parser.add_argument("--config_encodig", type=str, default="utf-8")
g_args : Namespace = g_parser.parse_args()
 
# Leemos config 
g_config : dict = None 
with open(g_args.config, "r", encoding=g_args.config_encodig) as f:
    g_config = json.load(f)
    
    
# Config esperada:
"""
{
    "general_config" : {
        "port" : 9999,
        "host" : "localhost"
        "mode" : "fast_mcp"
    }
    "fast_mcp" : {
        "name" :  "FastMcpServer"
    }
    "http" : {
        "http_port" : 8000,
        "name" : "HTTP Server",
        "tools_namespace" : "tools"
    }
    
}
"""    
    
#+------------------------------------------------------------------+
#| General                                                          |
#+------------------------------------------------------------------+
g_conection : mcp_mt5_conection.CMt5McpConection = mcp_mt5_conection.CMt5McpConection(g_config["general_config"]["host"],g_config["general_config"]["port"]) 
g_registrador : mcp_mt5_conection.CToolRegister = mcp_mt5_conection.CToolRegisterMCP(g_config,g_conection) if g_config["general_config"]["mode"] == "fast_mcp" else mcp_mt5_conection.CToolRegisterFastApi(g_config,g_conection) 


