<!-- mcp-name: io.github.TradeSystemsNique/mt5-mcp-by-leo -->
<p align="center">
  <img src="https://img.shields.io/badge/Language-Python-3776ab?style=flat-square"/>
  <img src="https://img.shields.io/badge/MQL5-Backend-13C7DE?style=flat-square"/>
  <img src="https://img.shields.io/badge/Protocol-MCP-1B6CA8?style=flat-square"/>
  <img src="https://img.shields.io/badge/Platform-MetaTrader%205-0D1B2A?style=flat-square"/>
  <img src="https://img.shields.io/badge/Author-Niquel%20Mendoza-C9D6DF?style=flat-square"/>
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/License-Nique%26Leo%20NL--ND-red.svg"/>
  </a>
</p>

<p align="center">
  <strong>Universal MCP Server for MetaTrader 5 Trading & Data Operations</strong>
</p>

---

## Overview

FullMt5McpByLeo is a complete, production-ready MCP server that enables Claude and other AI assistants to control MetaTrader 5 directly. Execute trades, retrieve market data, manage charts, analyze trading history, and automate MT5 operations through natural language.

---

## Main Features (MCP Functions)

### Trade Operations
Execute and manage trading positions and orders:
- **Open Positions:** Execute market trades (buy/sell) with immediate or pending orders
- **Position Management:** Modify stops/profits, close positions (full or partial)
- **Order Management:** Create, modify, and cancel pending limit/stop orders
- **Trading History:** Query completed deals with profit/loss analysis

### Market Data & Symbols
Access real-time and historical data:
- **OHLC Data:** Retrieve candlestick data (open, high, low, close, volume, spread, etc..)
- **Tick data:** Retrieve Tick data (last, ask, bid, flags, etc..)
- **Symbol Information:** Get symbol properties (digits, spreads, swaps, volumes)
- **Market Watch:** Manage symbol selection and availability

### Graphic Objects
Create and modify chart visualizations:
- **Draw Objects:** Create trend lines, rectangles, text labels, arrows
- **Object Properties:** Modify colors, styles, prices, text
- **Chart Annotations:** Add visual markers and indicators to charts

### Chart Management
Control chart windows and redraw operations:
- **Chart Operations:** Open, close, list active charts
- **Chart Properties:** Read chart dimensions, colors, price ranges
- **Visual Updates:** Force chart redraw for real-time updates

### Code & Terminal
Compile and execute Expert Advisors:
- **Compilation:** Compile MQL5 source to EX5 bytecode
- **Backtesting:** Run historical tests with multiple tick modeling
- **EA Execution:** Run Expert Advisors in real-time
- **Logging:** Retrieve EA logs for debugging and monitoring
- **Terminal and Account:** Obtaing terminal and acount info_* (integer, string, double)

---

## Repository Structure

```
FullMt5McpByLeo/
├── Src/                              # MQL5 Backend Functions
│    ....
├── mt5_mcp_by_leo/                   # Json tools definition
│    ....
```

---

## Requirements

- For repo code
> - Check: [dependencies.json](./dependencies.json)

- For user use:
> - EX5 of releases (Runner an McPServer).
> - McpServer requerid a EX5 Library, and EXE for McpServer, pucharse in: [TheBotPlace - McpServerByLeo](https://www.thebotplace.com/bot/mcpserverbyleo)

---

## Installation of repo code 

```bash
cd "C:\Users\YOUR USER\AppData\Roaming\MetaQuotes\Terminal\YOUR ID\MQL5\Shared Projects"
tsndep install "https://forge.mql5.io/nique_372/FullMt5McpByLeo.git"
```
- For use tsndep command requerid tsndep pacakage (avaible in [pypi](https://pypi.org/project/tsndep)).. This command automatically downloads all dependencies and installs all requirements from the repositories.
- If any part of the system is private, then it will fail... contact me so I can give you access (if it's a product, you can buy it; if you have any questions, don't hesitate to contact me).

---

## Quick Start (for final users)

 
### 1. Create a config json 

Open Common\\Files
And create a json file with this structure:

```json
{
  "general": {
    "type_reg": "stdio_stdin",
    "json_tools_fpath": "C:\\Users\\leoxd\\AppData\\Roaming\\MetaQuotes\\Terminal\\D0E8209F77C8CF37AD8BF550E51FF075\\MQL5\\Shared Projects\\FullMt5McpByLeo\\mt5_mcp_by_leo\\tools.json"
  },
  "mt5_conn": {
    "host": "127.0.0.1",
    "port": 9999
  },
  "http_lib": {
    "name": "McpMt5Server",
    "version": "1.0.0",
    "host": "127.0.0.1",
    "port": 8080,
    "endpoint": "/"
  },
  "stdio_stdin": {
    "name": "MT5 MCP Server",
    "version": "1.0.0"
  }
}
```

### 2. Configure in Claude Desktop

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "mt5_mcp_by_leo": {
      "command": "PATH_TO_EXE",
      "args": ["PATH_TO_FILE"
      ]
    }
  }
}
```

- PATH_TO_FILE: Path to json config file
- PATH_TO_EXE: Path to exe McpServer file

### 3. Configure MetaTrader 5

In MT5: **Tools** → **Options** → **Allowed URLs for WebRequest**
- Add `127.0.0.1` or host you configured.
- Click **Accept**
- Enable AutoTrading and DLL imports

### 4. Open claude desktop 
Open Claude Desktop. At that moment, a Python script is running in the background until it establishes a connection with the EA McpServer.ex5.

### 5. Compile & Attach EA 

```
MetaEditor: Open Src/Mt5Mcp.mq5 → Compile (F5) Or Dowland Mt5Mcp.ex5 of releases (last version).
MT5: Drag Mt5Mcp.ex5 onto your chart and cofigure it, The parameters of the EA, such as port/host, must match the JSON of Claude Desktop
```

### 6. Use in Claude

```
Open a 0.01 lot BUY on EURUSD with SL at 1.0800 and TP at 1.0900
```

Note:
> You can also use HTTP Remote with the help of "mcp-remote" (see: https://forge.mql5.io/nique_372/McpServer/wiki/Running-HTTP)

---

## License

**[Read Full License](./LICENSE)**

By downloading or using this repository, you accept the license terms.

---

## Documentation
- Wiki: [https://forge.mql5.io/nique_372/FullMt5McpByLeo/wiki](https://forge.mql5.io/nique_372/FullMt5McpByLeo/wiki)

---

## Contact
- **Platform:** [MQL5 Community](https://www.mql5.com/es/users/nique_372)
- **Profile:** https://www.mql5.com/es/users/nique_372/news

---

<p align="center">Copyright © 2026 Niquel Mendoza (nique_372).<br/>
TSN Trading Systems ecosystem.</p>