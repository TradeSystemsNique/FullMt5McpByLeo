#+------------------------------------------------------------------+
#| Imports                                                          |
#+------------------------------------------------------------------+
import socket
import json
import threading
import argparse
from mcp.server.fastmcp import FastMCP

#+------------------------------------------------------------------+
#| Args                                                             |
#+------------------------------------------------------------------+
parser = argparse.ArgumentParser()
parser.add_argument("--host", type=str, default="127.0.0.1")
parser.add_argument("--port", type=int, default=9999)
args = parser.parse_args()

HOST = args.host
PORT = args.port

#+------------------------------------------------------------------+
#| General                                                          |
#+------------------------------------------------------------------+
mcp = FastMCP("Mt5McpByLeo")

# Conexion de MT5 (se llena cuando MT5 conecta)
mt5_conn = None

def esperar_mt5():
    global mt5_conn
    server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_sock.bind((HOST, PORT))
    server_sock.listen(1)
    mt5_conn, _ = server_sock.accept()  # espera a que MT5 conecte

# Arranca en hilo separado, no bloquea el MCP
# La idea esq ue exista mientras que se termine por fin de conectar con mt5
threading.Thread(target=esperar_mt5, daemon=True).start()

#+------------------------------------------------------------------+
#| Send                                                             |
#+------------------------------------------------------------------+
def send(name: str, payload: str) -> str:
    if mt5_conn is None:
        return json.dumps({"ok": False, "error": "mt5_no_conectado"})
    
    # Inline con f-string, sin conversiones innecesarias
    msg : str = f'{{"name": "{name}", "data": {payload}}}\n'
    mt5_conn.sendall(msg.encode("utf-8"))
    
    # Obtnemos la repuesta en chunks
    response : str = b""
    while not response.endswith(b"\n"):
        chunk = mt5_conn.recv(4096)
        if not chunk:
            break
        response += chunk
    
    return response.decode("utf-8").strip()