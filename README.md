# FullMt5McpByLeo

Complete MCP (Model Context Protocol) server implementation for MT5 trading operations. This project bridges Claude AI with MetaTrader 5, enabling AI-powered trading automation through 44 comprehensive MCP functions.

## Architecture Overview

The project consists of two main components:

### 1. MQL5 Backend (Src/)
- **Mt5Mcp.mq5**: Main entry point - EA that registers all 44 MCP functions
- **All.mqh**: Master include file consolidating all MQL5 modules
- **Organized into 5 functional groups**:
  - Graphics Objects (5 functions)
  - Charts (6 functions)
  - Data/Symbol Info (10 functions)
  - Trade Operations (19 functions)
  - Code/Terminal (4 functions)

### 2. Python MCP Client (mt5_mcp_by_leo/)
- **Main.py**: Entry point that starts the FastMCP server
- **Def.py**: FastMCP instance and socket communication handler
- **functions.py**: All 44 MCP tool definitions (1300+ lines, fully documented)

## Quick Start

### Prerequisites
- Python 3.10+
- MetaTrader 5 terminal
- MetaEditor (for compiling MQL5)

### Installation

1. **Install Python dependencies**:
```bash
pip install -r requirements.txt
```

2. **Compile MQL5 Expert Advisor**:
   - Open MetaEditor
   - Open `Src/Mt5Mcp.mq5`
   - Compile (F5)
   - Move compiled `.ex5` file to MT5's `Experts` folder

3. **Attach EA to a chart**:
   - In MT5, open any chart
   - Drag Mt5Mcp.ex5 onto the chart
   - Enable AutoTrading and DLL imports when prompted

### Running the MCP Server

```bash
cd mt5_mcp_by_leo
python -m mt5_mcp_by_leo
```

Or:
```bash
python Main.py
```

The server will:
1. Start FastMCP server (default: `127.0.0.1:5000`)
2. Listen for MT5 EA connections (default: `127.0.0.1:9999`)
3. Register all 44 trading functions

## Function Groups

### GROUP 1: TRADE OPERATIONS (19 functions)
- **Open Positions**: open_trade, open_limit, open_stop
- **Position Management**: position_list, position_get_*, position_close, position_modify
- **Order Management**: order_list, order_close, order_modify, order_get_*
- **Trade History**: history_deal_get_*

### GROUP 2: DATA OHLC + SYMBOL (10 functions)
- **Market Data**: copy_open, copy_high, copy_low, copy_close, copy_tick_volume
- **Symbol Info**: symbol_info_double/integer/string, symbol_select, symbols_total

### GROUP 3: GRAPHIC OBJECTS (5 functions)
- object_create, object_delete, object_integer, object_double, object_string

### GROUP 4: CHARTS (6 functions)
- chart_list, chart_open, chart_close, chart_get_*, chart_redraw

### GROUP 5: CODE + TERMINAL (4 functions)
- compile_mql5, execute_backtest, run_ea, get_expert_logs

## Configuration

### Mt5Mcp.mq5 Inputs
```
InpSocketAddr: 127.0.0.1 (MT5 connects to this address)
InpSocketPort: 9999 (MT5 listens on this port)
InpMsPool: 10000 (Timer event interval in ms)
InpMsTimeoutReadNoTls: 10000 (Socket read timeout)
```

### Python Server (Def.py)
```python
HOST = "127.0.0.1"
PORT = 9999  # Must match MT5 input
```

## Communication Flow

```
Claude AI
    ↓
FastMCP Server (Python)
    ↓ (JSON over TCP)
Mt5Mcp.ex5 (MT5 EA)
    ↓ (MQL5 functions)
MetaTrader 5 Terminal
    ↓ (Trading operations)
Broker
```

## Function Documentation Format

Each function includes comprehensive documentation:

```python
@mcp.tool()
def function_name(payload: str) -> str:
    """
    Brief description
    
    ## Descripción
    Detailed explanation in Spanish
    
    ## Inputs (JSON)
    {
        "param1": "type" (required) - Description,
        "param2": "type" (optional) - Description
    }
    
    ## Outputs (JSON)
    {
        "ok": true | false,
        "result": "value" (si ok=true),
        "error": "message" (si ok=false)
    }
    
    ## Examples
    Entrada: {...}
    Salida: {...}
    
    ## Notas
    - Important notes
    """
    return send("function_name", payload)
```

## Development Notes

### TSN Conventions Applied
- Class names prefixed with `C`: `CMcpFuncPositionClose`, `CMcpServer`
- Member variables: `m_variable` format
- Functions: `snake_case` format
- JSON parameter handling with `CJsonNode::HasKey()` for GET/SET operations

### Key Patterns
- **GET/SET Consolidation**: object_integer, object_double, object_string use `param.HasKey("value")` to determine if GET or SET
- **Partial Closure**: position_close uses `param.HasKey("volume")` for partial vs total closure
- **CTrade Parameter Passing**: Trade operations receive `&g_trade` reference for order execution

## Testing

### 1. Verify MQL5 Compilation
```bash
# In MetaEditor
File → Compile → Mt5Mcp.mq5
# Check for 0 errors
```

### 2. Test MT5 EA Connection
- Attach Mt5Mcp.ex5 to a chart
- Check EA logs for "Connected to Python MCP server"

### 3. Test Python Server
```python
from mt5_mcp_by_leo.Def import mcp, send
result = send("symbols_total", "{}")
print(result)  # Should return {"ok": true, "result": <count>}
```

## File Structure

```
FullMt5McpByLeo/
├── Src/
│   ├── All.mqh                  # Master include
│   ├── Mt5Mcp.mq5               # Main EA
│   ├── Graphics/
│   │   └── Objects.mqh
│   ├── Charts/
│   │   └── Charts.mqh
│   ├── Data/
│   │   ├── Symbol.mqh
│   │   └── MarketData.mqh
│   ├── Trade/
│   │   ├── Trade.mqh
│   │   ├── Positions.mqh
│   │   ├── Orders.mqh
│   │   └── Deals.mqh
│   ├── Complex/
│   │   ├── Complex.mqh
│   │   └── Logs.mqh
│   └── Def/
│       └── Def.mqh
├── mt5_mcp_by_leo/
│   ├── __init__.py
│   ├── Main.py
│   ├── Def.py
│   ├── functions.py             # All 44 functions (1300+ lines)
│   └── __main__.py
├── FUNCTIONS.txt                # Function inventory
├── requirements.txt             # Python dependencies
└── README.md                    # This file
```

## Troubleshooting

### EA Won't Connect
1. Check firewall settings - allow Python on port 9999
2. Verify Mt5Mcp.mq5 inputs (InpSocketAddr, InpSocketPort)
3. Check MT5 Expert Logs for connection errors

### Functions Not Registering
1. Verify functions.py is imported in Main.py
2. Check for syntax errors: `python -m py_compile functions.py`
3. Ensure all @mcp.tool() decorators are present

### Socket Communication Issues
1. Verify JSON encoding in payloads
2. Check Mt5Mcp.mq5 is running (check status in EA list)
3. Review MT5 logs for parse errors

## Performance Notes

- **Socket Communication**: ~10-50ms per call depending on network
- **MQL5 Execution**: Synchronous, waits for completion
- **Async Operations**: compile_mql5, execute_backtest support timeouts
- **Recommended**: Max 10 parallel requests to avoid queue buildup

## Security Considerations

- Socket communication uses local loopback (127.0.0.1) by default
- No authentication - ensure secure network environment
- All monetary operations require explicit LCM approval
- Logs contain sensitive trading data - secure log files

## License

Copyright 2026, Niquel Mendoza.
https://www.mql5.com/es/users/nique_372

## Support

For issues or questions:
1. Check FUNCTIONS.txt for complete function reference
2. Review function docstrings in functions.py
3. Check MT5 Expert Logs for detailed error messages
4. Verify JSON payload structure matches function documentation
