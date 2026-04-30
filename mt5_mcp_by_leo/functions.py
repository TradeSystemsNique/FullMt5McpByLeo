#+------------------------------------------------------------------+
#| Imports                                                          |
#+------------------------------------------------------------------+
from .Def import mcp, send, Dict, Any, json

# ============================================================================
# GROUP 1: TRADE OPERATIONS (19 Functions)
# ============================================================================

# === OPEN POSITIONS (3) ===

@mcp.tool()
def open_trade(payload: Dict[str, Any]) -> str:
    """
    Open a market trade (buy or sell) at current market price.

    Description:
        Opens a new market position immediately. Uses CTrade::Buy() or
        CTrade::Sell() depending on type parameter.
    Inputs (DICT):
        {
            "type": "buy" or "sell" (string, required - case-insensitive),
            "symbol": "EURUSD" (string, required),
            "lot_size": 0.01 (double, required),
            "price": 1.0850 (double, required - current market price),
            "sl": 1.0800 (double, optional - stop loss, default 0.0),
            "tp": 1.0900 (double, optional - take profit, default 0.0),
            "magic": 12345 (int, optional - magic number, default 0),
            "comment": "Long bias signal" (string, optional - comment, default "")
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "result": "Failed open trade with symbol=EURUSD, last mt5 err=10001"}
    Notes:
        - price should be current market Ask for buys, Bid for sells
        - SL must be below entry for buys, above entry for sells
        - TP must be above entry for buys, below entry for sells
        - Trade execution depends on ACCOUNT_TRADE_MODE and ACCOUNT_MARGIN_MODE
    """
    return send("open_trade", payload)


@mcp.tool()
def open_limit(payload: Dict[str, Any]) -> str:
    """
    Open a limit order (pending order at specific price).

    Description:
        Creates a pending Buy Limit or Sell Limit order. Triggers when price
        reaches the specified level. Uses CTrade::BuyLimit() or CTrade::SellLimit().
    Inputs (DICT):
        {
            "type": "buy" or "sell" (string, required),
            "symbol": "EURUSD" (string, required),
            "lot_size": 0.01 (double, required),
            "price": 1.0750 (double, required - trigger price),
            "sl": 1.0700 (double, optional - stop loss, default 0.0),
            "tp": 1.0850 (double, optional - take profit, default 0.0),
            "magic": 12345 (int, optional - magic number, default 0),
            "comment": "Limit on support" (string, optional - comment, default "")
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "result": "Failed open limit with symbol=EURUSD, last mt5 err=10001"}
    Notes:
        - For Buy Limit: price must be BELOW current Ask
        - For Sell Limit: price must be ABOVE current Bid
        - Order activates when price reaches specified level
    """
    return send("open_limit", payload)


@mcp.tool()
def open_stop(payload: Dict[str, Any]) -> str:
    """
    Open a stop order (pending order beyond current price).

    Description:
        Creates a pending Buy Stop or Sell Stop order. Triggers when price
        breaks beyond the specified level. Uses CTrade::BuyStop() or CTrade::SellStop().
    Inputs (DICT):
        {
            "type": "buy" or "sell" (string, required),
            "symbol": "EURUSD" (string, required),
            "lot_size": 0.01 (double, required),
            "price": 1.0950 (double, required - trigger price),
            "sl": 1.0900 (double, optional - stop loss, default 0.0),
            "tp": 1.1050 (double, optional - take profit, default 0.0),
            "magic": 12345 (int, optional - magic number, default 0),
            "comment": "Stop on resistance" (string, optional - comment, default "")
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "result": "Failed open stop with symbol=EURUSD, last mt5 err=10001"}
    Notes:
        - For Buy Stop: price must be ABOVE current Ask
        - For Sell Stop: price must be BELOW current Bid
        - Typical use: breakout trading strategies
    """
    return send("open_stop", payload)


# === POSITION MANAGEMENT (4) ===

@mcp.tool()
def position_list(payload: Dict[str, Any]) -> str:
    """
    List all open positions.

    Description:
        Returns array of all open position tickets in the trading account.
    Inputs (DICT):
        {}
    Outputs (JSON):
        Success: {"ok": true, "result": [123456, 123457, 123458]}
        Error: {"ok": false, "error": "error message"}
    Notes:
        - Returns position ticket numbers only
        - Use position_get_* functions to retrieve detailed information
    """
    return send("position_list", payload)


@mcp.tool()
def position_get(payload: Dict[str, Any]) -> str:
    """
    Get property from an open position (double, integer, string).

    Description:
        Unified access to MT5 PositionGet* functions.
    Inputs (DICT):
        {
            "ticket": 123456,               # int, required - position ticket
            "property": "POSITION_VOLUME",  # string, required - ENUM_POSITION_PROPERTY_*
            "mode": "double"                # string, required:
                                            #   0 -> ENUM_POSITION_PROPERTY_DOUBLE
                                            #   1 -> ENUM_POSITION_PROPERTY_INTEGER
                                            #   2 -> ENUM_POSITION_PROPERTY_STRING
        }
    Outputs:
        Success:  {"ok": true, "result": 0.01}
        Error:  {"ok": false, "error": "position_not_found, last mt5 error=4401"}
    Notes:
        - Ticket must reference an OPEN position
        - Time fields are returned as Unix timestamps
        - Results formatted with 8 decimal places when double
    """
    return send("position_get", payload)

@mcp.tool()
def position_close(payload: Dict[str, Any]) -> str:
    """
    Close open position(s) by symbol or ticket.

    Description:
        Closes one or more open positions. Supports closing by symbol name or
        by ticket number, with optional partial closure by volume.
    Inputs (DICT - Close all by symbol):
        {
            "type": "by_symbol" (string, required),
            "value": "EURUSD" (string, required - symbol to close),
            "deviation": 100 (int, optional - price deviation in points)
        }
    Inputs (DICT - Partial close by volume):
        {
            "type": "by_symbol" (string, required),
            "value": "EURUSD" (string, required),
            "volume": 0.01 (double, optional - amount to close),
            "deviation": 100 (int, optional)
        }
    Inputs (DICT - Close by ticket):
        {
            "type": "by_ticket" (string, required),
            "value": 123456 (int, required - position ticket),
            "deviation": 100 (int, optional)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "position_close by_symbol failed, last mt5 error=10001"}
    Notes:
        - type must be "by_symbol" or "by_ticket"
        - If volume omitted: closes entire position
        - If volume provided: closes only that amount (partial)
        - Uses CTrade::PositionClose() or CTrade::PositionClosePartial() internal
    """
    return send("position_close", payload)


@mcp.tool()
def position_modify(payload: Dict[str, Any]) -> str:
    """
    Modify stop loss and take profit of open position.

    Description:
        Updates the stop loss and/or take profit levels of an open position.
    Inputs (DICT):
        {
            "ticket": 123456 (int, required - position ticket),
            "sl": 1.0800 (double, required - new stop loss price),
            "tp": 1.0950 (double, required - new take profit price)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "position_modify failed, last mt5 error=10001"}
    Notes:
        - Both sl and tp must be provided
        - For BUY: SL < current price < TP
        - For SELL: TP < current price < SL
    """
    return send("position_modify", payload)


# === ORDER MANAGEMENT (5) ===

@mcp.tool()
def order_list(payload: Dict[str, Any]) -> str:
    """
    List all pending orders.

    Description:
        Returns array of all pending (not yet activated) order tickets.
    Inputs (DICT):
        {}
    Outputs (JSON):
        Success: {"ok": true, "result": [654321, 654322]}
        Error: {"ok": false, "error": "error message"}
    Notes:
        - Returns pending order tickets only
        - Does not include open positions
        - Use order_get_* functions for details
    """
    return send("order_list", payload)


@mcp.tool()
def order_close(payload: Dict[str, Any]) -> str:
    """
    Cancel pending order.

    Description:
        Cancels a pending limit or stop order. Uses CTrade::OrderDelete().
    Inputs (DICT):
        {
            "ticket": 654321 (int, required - order ticket to cancel)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "result": "Failed close order with ticket=654321, last mt5 err=10001"}
    Notes:
        - Only cancels pending orders, not open positions
    """
    return send("order_close", payload)


@mcp.tool()
def order_modify(payload: Dict[str, Any]) -> str:
    """
    Modify pending order price, stop loss, and take profit.

    Description:
        Updates price level and protection levels for a pending order.
        Optionally updates order expiration settings.
    Inputs (DICT):
        {
            "ticket": 654321 (int, required - order ticket),
            "new_price": 1.0800 (double, required - new trigger price),
            "new_sl": 1.0750 (double, required - new stop loss),
            "new_tp": 1.0900 (double, required - new take profit),
            "new_type_time": "ORDER_TIME_GTC" (string:ENUM_ORDER_TYPE_TIME, optional - native enum),
            "new_expiration_time": "2026-05-01 12:00:00" (string, optional)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "result": "Failed modify order with ticket=654321, last mt5 err=10001"}
    Notes:
        - All parameters must be provided
        - new_type_time and new_expiration_time are optional
    """
    return send("order_modify", payload)


@mcp.tool()
def order_get(payload: Dict[str, Any]) -> str:
    """
    Get property from a pending order (double, string, int).

    Description:
        Unified access to MT5 OrderGet* functions.
    Inputs (DICT):
        {
            "ticket": 654321,               # int, required - order ticket
            "property": "ORDER_EXTERNAL_ID",       # string, required - ENUM_ORDER_PROPERTY_*
            "mode": "double"                # string, required:
                                            #   0 -> ENUM_ORDER_PROPERTY_DOUBLE
                                            #   1 -> ENUM_ORDER_PROPERTY_INTEGER
                                            #   2 -> ENUM_ORDER_PROPERTY_STRING
        }
    Outputs:
        Success:
            {"ok": true, "result": 0.01}
        Error:
            {"ok": false, "error": "order not found, last mt5 error=4401"}
    Notes:
        - Unified wrapper over MT5 pending order properties
        - TIME fields are returned as Unix timestamps when applicable
    """
    return send("order_get", payload)


@mcp.tool()
def calc_order(payload: Dict[str, Any]) -> str:
    """
    Unified MT5 trading calculator (CGetLote wrapper).

    Description:
        This tool centralizes multiple trading calculations from MT5 (lot sizing,
        risk conversion, stop-loss estimation, margin-related calculations).
        It works using a "mode" system. Each mode activates a different internal
        calculation in CGetLote.

    COMMON PARAMETERS
    - mode (int, required):  Selects the calculation to execute.
    - symbol (string, required):  Trading symbol (e.g. "EURUSD").
    - order_type (string:ENUM_ORDER_TYPE, required in most modes)
    - entry_price (double, depending on mode): Reference price used for margin / lot calculations.
    - risk_per_operation (double):  Risk in account currency (NOT %).
    - lot_size (double): Current lot size used in SL / risk calculations.
    - sl (int): Stop-loss distance in POINTS.
    

    MODES
    mode = 0 -> CalculateSLWithLot
        Computes SL distance based on lot and risk.

        REQUIRED:
            - symbol
            - risk_per_operation (double)
            - entry_price (double)
            - lot_size (double)

        OPTIONAL:
            - deviation (int)
            - stop_limit (int)
    mode = 1 -> MoneyToPoints
        Converts risk money into stop-loss points and suggests lot.

        REQUIRED:
            - symbol
            - order_type
            - risk_per_operation
            - entry_price

        OUTPUT:
            - result = SL in points
            - lot = computed lot size (output reference)

    mode = 2 -> GetLoteByRiskPerOperationAndSL
        Adjusts lot based on SL and risk constraints.
        REQUIRED:
            - symbol
            - max_lot (double)
            - risk_per_operation
            - sl (int)

    mode = 3 -> GetMaxLote
        Calculates maximum possible lot based on free margin.
        REQUIRED:
            - symbol
            - order_type
            - entry_price

        OPTIONAL:
            - deviation (int)
            - stop_limit (int)

    mode = 4 -> GetLoteByRiskPerOperation
        Calculates optimal lot based on risk and entry conditions.
        REQUIRED:
            - symbol
            - order_type
            - risk_per_operation
            - entry_price

        OPTIONAL:
            - deviation (int)
            - stop_limit (int)

    OUTPUT FORMAT
    Success:
        {"ok": true, "result": 1.25}
        {"ok": true, "result": 120}
        {"ok": true, "result": 0.12, "risk": 9.80}
    Error: {"ok": false, "error": "Invalid mode = X"}
 
    NOTES
    - This tool does NOT execute trades, only calculations.
    - deviation used for LIMIT/STOP order price adjustment
    - stop_limit used ONLY for STOP_LIMIT order construction
    """
    return send("calc_order", payload)


# === TRADE HISTORY (2) ===
@mcp.tool()
def history_deal_list(payload: Dict[str, Any]) -> str:
    """
    Get list of deal tickets within date range.

    Description:
        Retrieves all completed deal tickets between start and end dates
        using HistorySelect() to filter deals by time range.
    Inputs (DICT):
        {
            "start_date_select": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid),
            "end_date_select": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": [111111, 111112, 111113]}
        Error: {"ok": false, "error": "error message"}
    Notes:
        - Start date should be earlier than end date
        - The array ranges from the oldest deal to the most recent [oldest deal, ......, lastest deal]
        - Returns deal tickets only, use history_deal_get_* for details
    """
    return send("history_deal_list", payload)


@mcp.tool()
def history_deal_get(payload: Dict[str, Any]) -> str:
    """
    Get property from a deal (string, double, integer).

    Description:
        Unified access to MT5 HistoryDealGet* functions.
    Inputs (DICT):
        {
            "ticket": 123456,                # int, required - deal ticket
            "property": "DEAL_VOLUME",       # string, required - ENUM_DEAL_PROPERTY_*
            "mode": 1                        # int, required:
                                             #   "0"  -> ENUM_DEAL_PROPERTY_DOUBLE
                                             #   "1"  -> ENUM_DEAL_PROPERTY_INTEGER
                                             #   "2"  -> ENUM_DEAL_PROPERTY_STRING
        }
    Outputs:
        Success: {"ok": true, "result": 0.01}
        Error: {"ok": false, "error": "deal not found, last mt5 error=4401"}   
    Notes:
        - Unified wrapper over MT5 pending deal properties
        - TIME fields are returned as Unix timestamps when applicable
    """
    return send("history_deal_get", payload)


# ============================================================================
# GROUP 2: DATA - OHLC + SYMBOL (7 Functions)
# ============================================================================

# === MARKET DATA (3) ===

@mcp.tool()
def copy_data(payload: Dict[str, Any]) -> str:
    """
    Get Open,High,Low,Close,Spread,TickVolume,RealVolume,Time in array in series (0=most recent, size-1=oldest) (Internal use Copy* mt5 function)
    
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string:ENUM_TIMEFRAMES, required),
            "start": 0 (int, required - start index, 0 = most recent bar),
            "count": 100 (int, required - number of bars),
            "mode": "MCPFUNC_COPY_DATA_CLOSE" (string:ENUM_MCPFUNC_COPY_DATA, required)
        }
    Available Types (ENUM_MCPFUNC_COPY_DATA):
        - MCPFUNC_COPY_DATA_OPEN
        - MCPFUNC_COPY_DATA_CLOSE
        - MCPFUNC_COPY_DATA_HIGH
        - MCPFUNC_COPY_DATA_LOW
        - MCPFUNC_COPY_DATA_TICK_VOLUME
        - MCPFUNC_COPY_DATA_REAL_VOLUME
        - MCPFUNC_COPY_DATA_TIME
        - MCPFUNC_COPY_DATA_SPREAD
    Outputs (JSON):
        Success:
            {"ok": true, "result": [1.0850, 1.0851, 1.0852, ...]}
        Error:
            {"ok": false, "error": "copy_data failed"}
    Notes:
        - Precision depends on symbol digits
        - TIME returns in string format "YYYY:MM:DD HH:MM:SS" 
    """
    return send("copy_data", payload)

@mcp.tool()
def copy_ticks(payload: Dict[str, Any]) -> str:
    """
    Get tick-level market data (Bid/Ask/Last/...) in obj array (0=most recent, size-1=oldest) 

    Description:
        Retrieves raw tick data from MT5 including bid, ask, last price and volume.
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "from": 17000000000 (string:datetime:unix_format::ms, optional),
            "count": 100 (int, required),
            "flags": 3 (uint:ENUM_COPY_TICKS flags combination, optional)
        }
    Available Flags (ENUM_COPY_TICKS):
        - COPY_TICKS_ALL: 3
        - COPY_TICKS_INFO: 1
        - COPY_TICKS_TRADE: 2
          .. etc..
    Outputs (JSON):
        Success:
            {
                "ok": true,
                "result": [
                    {"time": "2021.01.01 10:05:01", "bid": 1.0850, "ask": 1.0852, "last": 1.0851, "volume": 1, ...},
                    ...
                ]
            }
        Error: {"ok": false, "error": "copy_ticks failed"}
    Notes:
        - Returns array of tick objects (NOT just prices)
        - Time is Unix timestamp (miliseconds) and "time" in string:time format
    """
    return send("copy_ticks", payload)


@mcp.tool()
def i_bar_shift(payload: Dict[str, Any]) -> str:
    """
    Get the shift (bar index) of a specific time in history.
    Description:
        Returns the bar index/shift of a specified time on a given symbol and timeframe.
        Uses iBarShift() MT5 Function to find the position of a bar matching the exact time or 
        the nearest bar if exact match is not required.
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_M1" (string:ENUM_TIMEFRAMES, required),
            "time": "2024.01.15 12:30:00" (string:datetime:mt5 format, required),
            "exact": true (boolean, optional, default: false)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": 42}
        Error: {"ok": false, "error": "error message"}
    Notes:
        - If exact=true: returns bar index only if exact time match exists
        - If exact=false: returns the nearest bar index (recommended for most cases)
        - Result is a string representation of the bar shift (0 = current bar, 1 = previous bar, etc.)
        - Returns -1 if bar is not found
    """
    return send("i_bar_shift", payload)

# === SYMBOL INFO (4) ===
@mcp.tool()
def symbol_info(payload: Dict[str, Any]) -> str:
    """
    Get symbol property (double, integer, string).

    Description:
        Unified access to MT5 SymbolInfo* functions.
    Inputs (JSON string):
        {
            "symbol": "EURUSD",          # string, required - symbol name
            "property": "SYMBOL_ASK",    # string, required - ENUM_SYMBOL_INFO_*
            "mode": 0                    # int, required:
                                         #   0 -> ENUM_SYMBOL_INFO_DOUBLE
                                         #   1 -> ENUM_SYMBOL_INFO_INTEGER
                                         #   2 -> ENUM_SYMBOL_INFO_STRING
        }
    Outputs:
        Success: {"ok": true, "result": 1.08500}
        Error: {"ok": false, "error": "symbol_info failed"}
    Notes:
        - Double: price/volume values (ASK, BID, POINT, etc.)
        - Integer: digits, flags, session info
        - String: symbol description, currency, name
    """
    return send("symbol_info", payload)

@mcp.tool()
def symbol_info_session(payload: Dict[str, Any]) -> str:
    """
    Get trading/quote session time for a symbol.

    Description:
        Retrieves session start/end times for trading or quote sessions
        of a symbol using MT5 SymbolInfoSessionTrade / SymbolInfoSessionQuote.
    Inputs (DICT):
        {
            "symbol": "EURUSD",        # string, required - symbol name
            "day_of_week": "MONDAY",   # string:ENUM_DAY_OF_WEEK, required
            "session_index": 0,        # int, required - session index (0..n)
            "mode": 0                  # int, required:
                                       #   0 -> trading session (SymbolInfoSessionTrade)
                                       #   1 -> quote session   (SymbolInfoSessionQuote)
        }
    Outputs:
        Success:
            {
                "ok": true,
                "result": {
                    "date_from": "2026.04.29 09:00:00",
                    "date_to": "2026.04.29 17:00:00"
                }
            }
        Error:
            {"ok": false, "error": "Invalid mode or mt5 error"}
    Notes:
        - session_index selects which session block (markets can have multiple sessions per day)
        - times are returned in server terminal time format (datetime string)
    """
    return send("symbol_info_session", payload)

@mcp.tool()
def symbol_select(payload: Dict[str, Any]) -> str:
    """
    Add or remove symbol from Market Watch.

    Description:
        Adds symbol to Market Watch (select=true) or removes it (select=false).
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "select": true (bool, required - true=add, false=remove)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "symbol_select failed"}
    Notes:
        - Must select symbol before trading it
        - Symbols in Market Watch have real-time quotes
    """
    return send("symbol_select", payload)


@mcp.tool()
def symbols_total(payload: Dict[str, Any]) -> str:
    """
    Get total number of available symbols.

    Description:
        Returns count of all available trading symbols or only those selected
        in Market Watch.
    Inputs (DICT):
        {
            "only_selected_in_market_watch": false (bool, optional - default false)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": 3500}
        Error: {"ok": false, "error": "symbols_total failed"}
    Notes:
        - only_selected_in_market_watch=false: all available symbols
        - only_selected_in_market_watch=true: only Market Watch symbols
    """
    return send("symbols_total", payload)


# ============================================================================
# GROUP 3: GRAPHIC OBJECTS (6 Functions)
# ============================================================================

@mcp.tool()
def object_create(payload: Dict[str, Any]) -> str:
    """
    Create a graphical object on a chart (MT5 ObjectCreate wrapper).

    Description:
        Creates chart objects such as trend lines, rectangles, labels, arrows, etc.
        The "mode" defines how many coordinate points are required.

    INPUT FORMAT (DICT)
    {
        "chart_id": 0,             # int, required (0 = current chart)
        "object_name": "Trend1",   # string, required (must be unique)
        "object_type": "OBJ_TREND",# string:ENUM_OBJECT, required
        "sub_window": 0,           # int, required (0=main chart, 1+=indicator window)

        "mode": 1,                # int, required:
                                  #   0 = 3 points
                                  #   1 = 2 points  
                                  #   2 = 1 point (time + price)
                                  #   3 = no coordinates

        "time1": "2025.01.01 00:00", # string:datetime, depending on mode
        "price1": 1.0850,            # double, depending on mode

        "time2": "...",              # depending on mode
        "price2": ...,               # depending on mode

        "time3": "...",              # depending on mode
        "price3": ...                # depending on mode
    }

    MODE BEHAVIOR
    mode = 0
        Uses: time1/price1 + time2/price2 + time3/price3
        For: channels, ellipses, complex shapes
    mode = 1
        Uses: time1/price1 + time2/price2
        For: trendlines, rectangles, fibo objects
    mode = 2
        Uses: time1 + price1
        For: arrows, markers, (hline, time1="0"), (vline, price1=0.00)
    mode = 3
        Uses: no coordinates
        For: labels, buttons, bitmap label, rectlabel, UI objects (position set later via ObjectSet*)

    OUTPUT
    Success:
        {"ok": true, "result": true}
    Error:
        {"ok": false, "error": "object_create failed"}
        
    NOTES
    - object_name MUST be unique per chart
    - time fields use MT5 datetime format ("YYYY.MM.DD HH:MI:SS")
    - Object type must be valid ENUM_OBJECT (OBJ_TREND, OBJ_RECTANGLE, etc.)
    - Coordinates depend strictly on mode
    """
    return send("object_create", payload)


@mcp.tool()
def object_delete(payload: Dict[str, Any]) -> str:
    """
    Delete graphic object from chart.

    Description:
        Removes a graphic object from a chart by name.
    Inputs (DICT):
        {
            "chart_id": 0 (int, required - 0=current chart),
            "object_name": "TrendLine1" (string, required - object name)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "object_delete failed"}
    Notes:
        - Immediately removes object from chart
    """
    return send("object_delete", payload)


@mcp.tool()
def object_integer(payload: Dict[str, Any]) -> str:
    """
    Get or set integer property of graphic object (ENUM_OBJECT_PROPERTY_INTEGER).

    Description:
        Retrieves or modifies integer properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.
    Inputs (DICT - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_COLOR" (string:ENUM_OBJECT_PROPERTY_INTEGER, required),
            "prop_modifier": 0 (int, optional - default 0)
        }
    Inputs (DICT - SET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_COLOR" (string:ENUM_OBJECT_PROPERTY_INTEGER, required),
            "prop_modifier": 0 (int, optional - default 0),
            "value": 16711680 (int, required for SET)
        }
    Outputs (JSON):
        GET: {"ok": true, "result": 16711680}
        SET: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "object_integer failed"}
    Notes:
        - If value omitted: returns current value (GET)
        - If value included: sets new value (SET)
        - Colors in RGB format
    """
    return send("object_integer", payload)


@mcp.tool()
def object_double(payload: Dict[str, Any]) -> str:
    """
    Get or set double property of graphic object (ENUM_OBJECT_PROPERTY_DOUBLE).

    Description:
        Retrieves or modifies floating-point properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.
    Inputs (DICT - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_PRICE" (string:ENUM_OBJECT_PROPERTY_DOUBLE, required),
            "prop_modifier": 0 (int, optional - default 0)
        }
    Inputs (DICT - SET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_PRICE" (string:ENUM_OBJECT_PROPERTY_DOUBLE, required),
            "prop_modifier": 0 (int, optional - default 0),
            "value": 1.0900 (double, required for SET)
        }
    Outputs (JSON):
        GET: {"ok": true, "result": 1.0900}
        SET: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "object_double failed"}
    Notes:
        - Precision: 8 decimal places
        - prop_modifier: 0=first point, 1=second, 2=third
        - If value omitted: returns current value (GET)
        - If value included: sets new value (SET)
    """
    return send("object_double", payload)


@mcp.tool()
def object_string(payload: Dict[str, Any]) -> str:
    """
    Get or set string property of graphic object (ENUM_OBJECT_PROPERTY_STRING).

    Description:
        Retrieves or modifies string properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.
    Inputs (DICT - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TextLabel1" (string, required),
            "property": "OBJPROP_TEXT" (string:ENUM_OBJECT_PROPERTY_STRING, required),
            "prop_modifier": 0 (int, optional - default 0)
        }
    Inputs (DICT - SET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TextLabel1" (string, required),
            "property": "OBJPROP_TEXT" (string:ENUM_OBJECT_PROPERTY_STRING, required),
            "prop_modifier": 0 (int, optional - default 0),
            "value": "New Label Text" (string, required for SET)
        }
    Outputs (JSON):
        GET: {"ok": true, "result": "Label Text"}
        SET: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "object_string failed"}
    Notes:
        - If value omitted: returns current value (GET)
        - If value included: sets new value (SET)
        - prop_modifier typically 0
    """
    return send("object_string", payload)

@mcp.tool()
def object_list(payload: Dict[str, Any]) -> str:
    """
    Get list of object names on chart.
    Description:
        Returns all object names from a chart filtered by type and subwindow.
    Inputs (DICT):
        {
            "chart_id": 0 (int, optional - default 0),
            "sub_window": 0 (int, optional - default -1 for all),
            "object_type": "OBJ_TREND" (string:ENUM_OBJECT, optional, -1 all types)
        }
    Outputs (JSON):
        Success:  {"ok": true, "result": ["Trend1", "Line2", "RectA"]}
        Error: {"ok": false, "error": "object_list failed"}
    Notes:
        - If object_type not provided → returns all objects
    """
    return send("object_list", payload)




# ============================================================================
# GROUP 4: CHARTS (9 Functions)
# ============================================================================

@mcp.tool()
def chart_list(payload: Dict[str, Any]) -> str:
    """
    Get list of all open chart windows.

    Description:
        Returns array of chart IDs for all currently open chart windows.
    Inputs (DICT):
        {}
    Outputs (JSON):
        Success: {"ok": true, "result": [0, 2, 4]}
        Error: {"ok": false, "error": "error message"}
    Notes:
        - Chart ID 0 typically refers to current chart
        - Use returned IDs with other chart functions
    """
    return send("chart_list", payload)


@mcp.tool()
def chart_open(payload: Dict[str, Any]) -> str:
    """
    Open new chart window.

    Description:
        Opens a new chart window for specified symbol and timeframe.
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string:ENUM_TIMEFRAMES, required - native ENUM_TIMEFRAMES)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": 2}
        Error: {"ok": false, "error": "chart_open failed"}
    Notes:
        - Returns new chart ID
    """
    return send("chart_open", payload)


@mcp.tool()
def chart_close(payload: Dict[str, Any]) -> str:
    """
    Close chart window.

    Description:
        Closes a chart window by ID.
    Inputs (DICT):
     {
       "chart_id": 2 (int, required - chart ID to close)
     }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "chart_close failed"}
    Notes:
        - Cannot close chart ID 0 (main chart)
    """
    return send("chart_close", payload)


@mcp.tool()
def chart_integer(payload: Dict[str, Any]) -> str:
    """
    Get\Set integer property of chart (ENUM_CHART_PROPERTY_INTEGER) (MT5 Analogous: ChartGetInteger, ChartSetInteger)
    
    Description:
        Retrieves or set integer properties of a chart window using native
        ENUM_CHART_PROPERTY_INTEGER enum values.
    Inputs (DICT) GET:
      {
       "chart_id": 0 (int, required),
       "property": "CHART_VISIBLE_BARS" (string:ENUM_CHART_PROPERTY_INTEGER enum, required),
       "sub_window": 0 (int, optional - default 0)
      }
    Inputs (DICT) SET:
     {
       "chart_id": 0 (int, required),
       "property": "CHART_COLOR_ASK" (string:ENUM_CHART_PROPERTY_INTEGER enum, required),
       "value": 170000000 (int, required)
     }    
    Outputs (JSON):
        Success: {"ok": true, "result": 800}
        Error: {"ok": false, "error": "chart_integer failed"}
    Notes:
        - sub_window: 0=main chart, 1+=indicator windows
    """
    return send("chart_integer", payload)
    
@mcp.tool()
def chart_double(payload: Dict[str, Any]) -> str:
    """
    Get double property of chart (ENUM_CHART_PROPERTY_DOUBLE) (MT5 Analogous: ChartGetDouble, ChartSetDouble).
    
    Description:
        Retrieves or set floating-point properties of a chart window using native
        ENUM_CHART_PROPERTY_DOUBLE enum values.
    Inputs (DICT) GET:
    {
     "chart_id": 0 (int, required),
     "property": "CHART_FIXED_MAX" (string:ENUM_CHART_PROPERTY_DOUBLE enum, required),
     "sub_window": 0 (int, optional - default 0)
    }
    Inputs (DICT) SET:
     {
       "chart_id": 0 (int, required),
       "property": "CHART_FIXED_MAX" (string:ENUM_CHART_PROPERTY_DOUBLE enum, required),
       "value": 2450.00 (double, required)
     }   
    Outputs (JSON):
        Success: {"ok": true, "result": 1.1000}
        Error: {"ok": false, "error": "chart_double failed"}
    Notes:
        - Precision: 8 decimal places
    """
    return send("chart_double", payload)

@mcp.tool()
def chart_redraw(payload: Dict[str, Any]) -> str:
    """
    Redraw chart.

    Description:
        Forces a chart to redraw, updating all objects and data.
    Inputs (DICT):
        {
            "chart_id": 0 (int, required - chart ID to redraw)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "chart_redraw failed"}
    Notes:
        - Useful after modifying objects or visual update needed
    """
    return send("chart_redraw", payload)

@mcp.tool()
def chart_string(payload: Dict[str, Any]) -> str:
    """
    Get/Set string property of chart (ENUM_CHART_PROPERTY_STRING).
    Description:
        Retrieves or modifies string properties of a chart.
    Inputs (DICT - GET):
        {
            "chart_id": 0 (int, required),
            "property": "CHART_COMMENT" (string:ENUM_CHART_PROPERTY_STRING, required)
        }
    Inputs (DICT - SET):
        {
            "chart_id": 0 (int, required),
            "property": "CHART_COMMENT" (string:ENUM_CHART_PROPERTY_STRING, required),
            "value": "New Comment" (string, required)
        }
    Outputs (JSON):
        GET: {"ok": true, "result": "Some text"}
        SET: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "chart_string failed"}
    """
    return send("chart_string", payload)

@mcp.tool()
def chart_get_symbol_or_period(payload: Dict[str, Any]) -> str:
    """
    Get chart symbol or period based on mode.
    Description:
        Retrieves either the timeframe or symbol of a chart based on the mode parameter.
    Inputs (DICT):
        {
            "chart_id": 0 (int, required),
            "mode": 0 (int, required) - 0=get timeframe, 1=get symbol
        }
    Outputs (JSON):
        mode=0 (timeframe): {"ok": true, "result": "PERIOD_H1"}
        mode=1 (symbol): {"ok": true, "result": "EURUSD"}
        Error: {"ok": false, "error": "Invalid mode = X, use 0=get timeframe, 1=get symbol"}
    """
    return send("chart_get_symbol_or_period", payload)

@mcp.tool()
def chart_screenshot(payload: Dict[str, Any]) -> str:
    """
    Capture chart screenshot and save to file.
    Description:
        Takes a screenshot of a chart and saves it to disk, optionally moving it 
        to the common terminal folder.
    Inputs (DICT):
        {
            "chart_id": 0 (int, required),
            "file_name": "screenshot.png" (string, required, relative at MQL5\\Files\\ folder if comon_flag=false, else relative to Common\\Files\\ folder),
            "with": 800 (int, optional) - default: chart actual width in pixels,
            "height": 600 (int, optional) - default: chart actual height in pixels,
            "common_flag": true (bool, optional) - default: true, move to common folder
        }
    Outputs (JSON):
        Success: {"ok": true, "result": {"full_path": "C:\\path\\to\\file.png"}}
        Error ChartScreenShot: {"ok": false, "error": "Failed call ChartScreenShot, last mt5 error = 1234"}
        Error FileMove: {"ok": false, "error": "Failed call FileMove, last mt5 error = 5678"}
    """
    return send("chart_screenshot", payload)

# ============================================================================
# GROUP 5: CODE + TERMINAL (4 Functions)
# ============================================================================

@mcp.tool()
def compile_mql5(payload: Dict[str, Any]) -> str:
    """
    Compile MQL5 source code.

    Description:
        Compiles MQL5 source code file to EX5 bytecode using specified
        CPU instruction set. Used for Expert Advisors, indicators, scripts.
    Inputs (DICT):
        {
            "full_path_code": "C:\\Users\\Leo\\MetaTrader5\\MQL5\\Experts\\MyEA.mq5" (string, required),
            "instruction": "avx2" (string, optional - CPU instruction set),
            "optimize": true (bool, optional - enable optimizations),
            "timeout_ms": 60000 (int, optional - compilation timeout)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "Compilation successful, log path: C:\\Users\\Leo\\MetaTrader5\\MQL5\\Experts\\MyEA.log"}
        Error: {"ok": false, "error": "Compilation failed with errors"}
    Instruction Options (CPU instruction sets):
        - "" (empty): Default, no specific instruction set
        - "avx": Advanced Vector Extensions
        - "avx2": Advanced Vector Extensions 2 (recommended)
        - "avx512": AVX-512 (latest processors)
    Notes:
        - Requires full absolute path to .mq5 file
        - Output file (.ex5) created in same directory (depend where is compiled)
        - optimize=true enables compiler optimizations (slower)
        - timeout_ms: max time to wait for compilation (default 60000)
    """
    return send("compile_mql5", payload)


@mcp.tool()
def execute_backtest(payload: Dict[str, Any]) -> str:
    """
    Execute historical backtest.

    Description:
        Runs historical backtest (strategy testing) with specified parameters.
        Results saved to file for analysis.
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required),
            "set_file_name": "MyStrategy.set" (string, required - settings file),
            "expert_path": "Experts\\MyEA.ex5" (string, required - EA path),
            "start_date": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid),
            "end_date": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "leverage": 100 (int, required - trading leverage),
            "visual_mode": false (bool, required - true=show animation),
            "modelado": "MTTESTER_MODELADO_EVERY_TICK" (string:ENUM_MTTESTER_MODELADO_MODE custom enum, required - tick simulation mode),
            "file_in_common": false (bool, optional - save location),
            "data_file_name": "MyResults" (string, optional - output file name)
        }
    Outputs (JSON):
        Success: {"ok": true, "result": "Backtest completed"}
        Error: {"ok": false, "error": "Backtest failed"}
    Modelado (ENUM_MTTESTER_MODELADO_MODE - Custom Enum):
        - MTTESTER_MODELADO_EVERY_TICK: Every Tick (most accurate, slowest)
        - MTTESTER_MODELADO_OCHLM1: 1-min OHLC (good balance)
        - MTTESTER_MODELADO_ONLY_OPEN: Open Only (fast but less accurate)
        - MTTESTER_MODELADO_REAL_TICK: Real Ticks (realistic, limited data)
    Notes:
        - Use string:datetime:mt5_format timestamps for dates
        - visual_mode=true shows animation but slows test
        - Results include profit/loss, drawdown, Sharpe ratio
        - Requires compiled EA (.ex5 format)
    """
    return send("execute_backtest", payload)


@mcp.tool()
def run_ea(payload: dict) -> str:
    """
    Run Expert Advisor (EA) on a chart in real-time.

    Description:
        Launches an Expert Advisor on a specified symbol/timeframe chart.
        The EA will execute continuously with tick-based updates until manually stopped.
        Parameters are passed by position order to match the EA's input variables.
    
    Inputs (DICT):
        {
            "symbol": "EURUSD" (string, required - trading symbol),
            "timeframe": "PERIOD_H1" (string, required - chart timeframe, e.g., PERIOD_M1, PERIOD_H1, PERIOD_D1),
            "ms_espera": 5000 (int, required - millisecond delay between ticks: 500-5000 typical),
            "expert_path": "Experts\\MyEA.ex5" (string, required - path to .ex5 file relative to MQL5\\ folder, incluyed Experts\\ folder in rute),
            "run_flags": "" (string, optional - execution permissions separated by |, e.g., "DLL|AutoTrading"),
            "params": [
                {"data_type": "TYPE_INT", "value": 10},
                {"data_type": "TYPE_DOUBLE", "value": 0.01},
                {"data_type": "TYPE_STRING", "value": "MyParam"}
            ] (array, optional - EA input parameters by position)
        }
    
    Outputs (JSON):
        Success: {"ok": true, "result": "EA successfully launched on chart with chart id = 12345"}
        Error: {"ok": false, "error": "error description"}
    
    Parameter Mapping (IMPORTANTE - Por Posición):
        Parameters are matched to EA inputs by POSITION ORDER, not by name.
        - First param object → First EA input variable (InpA)
        - Second param object → Second EA input variable (InpB)
        - If params are missing or incomplete, EA uses its default values
        
        CRITICAL - Value Format by Data Type:
        - TYPE_INT, TYPE_UINT, TYPE_SHORT, TYPE_USHORT, TYPE_CHAR, TYPE_UCHAR, TYPE_BOOL, TYPE_LONG, TYPE_ULONG::
          value: 10 (numeric)
        - TYPE_FLOAT, TYPE_DOUBLE:
          value: 0.01 (numeric, decimal)
        - TYPE_STRING:
          value: "MyString" (string text)
        - TYPE_DATETIME:
          value: "2024.01.15 12:30:00" (STRING format: "YYYY.MM.DD HH:MM:SS")
        - TYPE_COLOR:
          value: ["255,128,64" or "0xFF8040" or mt5:web_colors eg=clrBlue]
        
        IMPORTANT: Even numeric types like DATETIME and COLOR must be passed as STRING values
                   The system will convert them to the appropriate type internally.
    
    Notes:
        - EA continues running until manually stopped or MT5 closes
        - ms_espera controls tick simulation speed (lower = faster)
        - run_flags examples: "DLL" (allow DLLs), "AutoTrading" (allow auto-trading), "DLL|AutoTrading" (both)
        - If EA is already running, parameters will be updated (chart reuse mode)
    
    Example 
        {
            "symbol": "EURUSD",
            "timeframe": "PERIOD_H1",
            "ms_espera": 1000,
            "expert_path": "Experts\\MyEA.ex5",
            "run_flags": "AutoTrading",
            "params": [
                {"data_type": "TYPE_DATETIME", "value": "2024.01.15 14:30:00"},
                {"data_type": "TYPE_COLOR", "value": "clrRed"},
                {"data_type": "TYPE_STRING", "value": "MyConfig"}
            ]
        }
    """
    return send("run_ea", payload)


@mcp.tool()
def get_expert_logs(payload: Dict[str, Any]) -> str:
    """
    Get recent Expert Advisor logs.

    Description:
        Retrieves the most recent log entries from Expert Advisor execution.
        Useful for debugging and monitoring EA behavior.
    Inputs (DICT):
        {
            "start_date": "2024.01.01" (string:datetime:mt5_format, requerid),
            "logs_lines": 100 (int, optional - number of lines, default 50)
        }
    Outputs (JSON):
        Success: {
            "ok": true,
            "result": "
                [2026-04-28 10:15:22] EA started on EURUSD PERIOD_H1\\n
                [2026-04-28 10:16:05] Trade opened: Buy 0.01 EURUSD at 1.0850\\n
                [2026-04-28 10:20:30] Signal triggered, checking conditions...\\n
            "
        }
        Error: {"ok": false, "error": "get_expert_logs failed"}

    Notes:
        - Returns log entries as string
    """
    return send("get_expert_logs", payload)


# ============================================================================
# GROUP 2: Utils
# ============================================================================

@mcp.tool()
def get_time(payload: Dict[str, Any]) -> str:
    """
    Get current time in different formats (GMT, local, server, etc.).

    Description:
        Returns time based on requested type using MT5 internal functions.
    Inputs (DICT):
        {
            "type": "MCPFUNC_TIME_CURRENT" (string:ENUM_MCPFUNC_TYPE_TIME, required)
        }
    Available Types (ENUM_MCPFUNC_TYPE_TIME):
        - MCPFUNC_TIME_GMT      -> TimeGMT()
        - MCPFUNC_TIME_CURRENT  -> TimeCurrent()
        - MCPFUNC_TIME_LOCAL    -> TimeLocal()
        - MCPFUNC_TIME_SERVER   -> TimeTradeServer()
    Outputs (JSON):
        Success: {"ok": true, "result": "2026.04.28 14:35:22"}
        Error: {"ok": false, "error": "Invalid time type"}
    Notes:
        - Output format: YYYY.MM.DD HH:MM:SS
    """
    return send("get_time", payload)


@mcp.tool()
def get_err_description(payload: Dict[str, Any]) -> str:
    """
    Get human-readable description of MT5 error code.
    Description:
        Converts MT5 error code into readable message using internal
        CMt5ErrorDesc::GetError().
    Inputs (DICT):
        {
            "error_code": 10001 (int, required),
            "include_code": true (bool, optional, default true)
        }
    Outputs (JSON):
        Success:  {"ok": true, "result": "10001 - Trade server busy"}
        Error: {"ok": false, "error": "something failed"}   
    Notes:
        - Useful for debugging failed operations
        - include_code=true adds numeric code in output
        - Works with all MT5 standard error codes
    """
    return send("get_err_description", payload)




@mcp.tool()
def account_info(payload: Dict[str, Any]) -> str:
    """
    Get MT5 account information (double, integer, string).

    Description:
        Unified access to MT5 AccountInfo* functions.
        This tool groups all account properties into a single endpoint.
    Inputs (JSON string):
        {
            "mode": 0,                # int, required:
                                      #   0 -> AccountInfoDouble
                                      #   1 -> AccountInfoInteger
                                      #   2 -> AccountInfoString

            "property": "ACCOUNT_BALANCE"  # string, required - ENUM_ACCOUNT_INFO_*
        }
    Outputs:
        Success: {"ok": true, "result": 12345.67}
        Error: {"ok": false, "error": "Invalid mode or property"}
    Notes:
        - Time in unix format
    """
    return send("account_info", payload)



@mcp.tool()
def terminal_info(payload: Dict[str, Any]) -> str:
    """
    Get MT5 terminal information (double, integer, string).

    Description:
        Unified access to MT5 TerminalInfo* functions.
        This tool groups system/terminal properties into a single endpoint.
    Inputs (JSON string):
        {
            "mode": 0,                 # int, required:
                                       #   0 -> TerminalInfoDouble
                                       #   1 -> TerminalInfoInteger
                                       #   2 -> TerminalInfoString
            "property": "TERMINAL_CONNECTED"  # string, required - ENUM_TERMINAL_INFO_*
        }
    Outputs:
        Success:   {"ok": true, "result": 1}
        Error: {"ok": false, "error": "Invalid mode or property"}
            
    Notes:
        - Represents runtime terminal state (not trading data)
        - Useful for diagnostics, VPS detection, performance checks
        - Values depend on local terminal environment
    """
    return send("terminal_info", payload)