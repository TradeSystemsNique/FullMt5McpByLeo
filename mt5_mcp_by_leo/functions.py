#+------------------------------------------------------------------+
#| Imports                                                          |
#+------------------------------------------------------------------+
from .Def import mcp, send
import json


# ============================================================================
# GROUP 1: TRADE OPERATIONS (19 Functions)
# ============================================================================

# === OPEN POSITIONS (3) ===

@mcp.tool()
def open_trade(payload: str) -> str:
    """
    Open a market trade (buy or sell) at current market price.

    Description:
        Opens a new market position immediately. Uses CTrade::Buy() or
        CTrade::Sell() depending on type parameter.

    Inputs (JSON):
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
def open_limit(payload: str) -> str:
    """
    Open a limit order (pending order at specific price).

    Description:
        Creates a pending Buy Limit or Sell Limit order. Triggers when price
        reaches the specified level. Uses CTrade::BuyLimit() or CTrade::SellLimit().

    Inputs (JSON):
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
def open_stop(payload: str) -> str:
    """
    Open a stop order (pending order beyond current price).

    Description:
        Creates a pending Buy Stop or Sell Stop order. Triggers when price
        breaks beyond the specified level. Uses CTrade::BuyStop() or CTrade::SellStop().

    Inputs (JSON):
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


# === POSITION MANAGEMENT (6) ===

@mcp.tool()
def position_list(payload: str) -> str:
    """
    List all open positions.

    Description:
        Returns array of all open position tickets in the trading account.

    Inputs (JSON):
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
def position_get_double(payload: str) -> str:
    """
    Get double-type property of a position (ENUM_POSITION_PROPERTY_DOUBLE).

    Description:
        Retrieves floating-point property from open position using native
        ENUM_POSITION_PROPERTY_DOUBLE enum values.

    Inputs (JSON):
        {
            "ticket": 123456 (int, required - position ticket),
            "property": "POSITION_VOLUME" (string:ENUM_POSITION_PROPERTY_DOUBLE, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 0.01}
        Error: {"ok": false, "error": "position_not_found, last mt5 error=4401"}

    Notes:
        - Ticket must reference open position
        - Results formatted with 8 decimal places
    """
    return send("position_get_double", payload)


@mcp.tool()
def position_get_integer(payload: str) -> str:
    """
    Get integer-type property of a position (ENUM_POSITION_PROPERTY_INTEGER).

    Description:
        Retrieves integer property from open position using native
        ENUM_POSITION_PROPERTY_INTEGER enum values.

    Inputs (JSON):
        {
            "ticket": 123456 (int, required - position ticket),
            "property": "POSITION_TYPE" (string:ENUM_POSITION_PROPERTY_INTEGER, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 0}
        Error: {"ok": false, "error": "position_not_found, last mt5 error=4401"}

    Notes:
        - POSITION_TYPE: 0=BUY, 1=SELL
        - TIME values are Unix timestamps
    """
    return send("position_get_integer", payload)


@mcp.tool()
def position_get_string(payload: str) -> str:
    """
    Get string-type property of a position (ENUM_POSITION_PROPERTY_STRING).

    Description:
        Retrieves string property from open position using native
        ENUM_POSITION_PROPERTY_STRING enum values.

    Inputs (JSON):
        {
            "ticket": 123456 (int, required - position ticket),
            "property": "POSITION_SYMBOL" (string:ENUM_POSITION_PROPERTY_STRING, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "EURUSD"}
        Error: {"ok": false, "error": "position_not_found, last mt5 error=4401"}
    """
    return send("position_get_string", payload)


@mcp.tool()
def position_close(payload: str) -> str:
    """
    Close open position(s) by symbol or ticket.

    Description:
        Closes one or more open positions. Supports closing by symbol name or
        by ticket number, with optional partial closure by volume.

    Inputs (JSON - Close all by symbol):
        {
            "type": "by_symbol" (string, required),
            "value": "EURUSD" (string, required - symbol to close),
            "deviation": 100 (int, optional - price deviation in points)
        }

    Inputs (JSON - Partial close by volume):
        {
            "type": "by_symbol" (string, required),
            "value": "EURUSD" (string, required),
            "volume": 0.01 (double, optional - amount to close),
            "deviation": 100 (int, optional)
        }

    Inputs (JSON - Close by ticket):
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
def position_modify(payload: str) -> str:
    """
    Modify stop loss and take profit of open position.

    Description:
        Updates the stop loss and/or take profit levels of an open position.

    Inputs (JSON):
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


# === ORDER MANAGEMENT (6) ===

@mcp.tool()
def order_list(payload: str) -> str:
    """
    List all pending orders.

    Description:
        Returns array of all pending (not yet activated) order tickets.

    Inputs (JSON):
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
def order_close(payload: str) -> str:
    """
    Cancel pending order.

    Description:
        Cancels a pending limit or stop order. Uses CTrade::OrderDelete().

    Inputs (JSON):
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
def order_modify(payload: str) -> str:
    """
    Modify pending order price, stop loss, and take profit.

    Description:
        Updates price level and protection levels for a pending order.
        Optionally updates order expiration settings.

    Inputs (JSON):
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

    Native Enums (ENUM_ORDER_TYPE_TIME):
        - ORDER_TIME_GTC: Good-Till-Cancelled (default)
        - ORDER_TIME_DAY: Valid until end of trading day
        - ORDER_TIME_SPECIFIED: Valid until specified time
        - ORDER_TIME_SPECIFIED_DAY: Valid until specified day

    Notes:
        - All parameters must be provided
        - new_type_time and new_expiration_time are optional
    """
    return send("order_modify", payload)


@mcp.tool()
def order_get_double(payload: str) -> str:
    """
    Get double-type property of pending order (ENUM_ORDER_PROPERTY_DOUBLE).

    Description:
        Retrieves floating-point property from pending order using native
        ENUM_ORDER_PROPERTY_DOUBLE enum values.

    Inputs (JSON):
        {
            "ticket": 654321 (int, required - order ticket),
            "property": "ORDER_VOLUME_INITIAL" (string:ENUM_ORDER_PROPERTY_DOUBLE, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 0.01}
        Error: {"ok": false, "error": "order not found, last mt5 error=4401"}

    Notes:
        - Results formatted with 8 decimal places
    """
    return send("order_get_double", payload)


@mcp.tool()
def order_get_integer(payload: str) -> str:
    """
    Get integer-type property of pending order (ENUM_ORDER_PROPERTY_INTEGER).

    Description:
        Retrieves integer property from pending order using native
        ENUM_ORDER_PROPERTY_INTEGER enum values.

    Inputs (JSON):
        {
            "ticket": 654321 (int, required - order ticket),
            "property": "ORDER_TYPE" (string:ENUM_ORDER_PROPERTY_INTEGER, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 2}
        Error: {"ok": false, "error": "order not found, last mt5 error=4401"}

    Notes:
        - TIME values are Unix timestamps
    """
    return send("order_get_integer", payload)


@mcp.tool()
def order_get_string(payload: str) -> str:
    """
    Get string-type property of pending order (ENUM_ORDER_PROPERTY_STRING).

    Description:
        Retrieves string property from pending order using native
        ENUM_ORDER_PROPERTY_STRING enum values.

    Inputs (JSON):
        {
            "ticket": 654321 (int, required - order ticket),
            "property": "ORDER_SYMBOL" (string:ENUM_ORDER_PROPERTY_STRING, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "EURUSD"}
        Error: {"ok": false, "error": "order not found, last mt5 error=4401"}
    """
    return send("order_get_string", payload)


# === TRADE HISTORY (4) ===

@mcp.tool()
def history_deal_list(payload: str) -> str:
    """
    Get list of deal tickets within date range.

    Description:
        Retrieves all completed deal tickets between start and end dates
        using HistorySelect() to filter deals by time range.

    Inputs (JSON):
        {
            "start_date_select": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid),
            "end_date_select": "2024.01.01 00:00:00" (string:datetime:mt5 format, requerid)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [111111, 111112, 111113]}
        Error: {"ok": false, "error": "error message"}

    Notes:
        - Start date should be earlier than end date
        - Returns deal tickets only, use history_deal_get_* for details
    """
    return send("history_deal_list", payload)


@mcp.tool()
def history_deal_get_double(payload: str) -> str:
    """
    Get double-type property of completed deal (ENUM_DEAL_PROPERTY_DOUBLE).

    Description:
        Retrieves floating-point property from completed deal using native
        ENUM_DEAL_PROPERTY_DOUBLE enum values.

    Inputs (JSON):
        {
            "deal_ticket": 111111 (int, required - deal ticket),
            "property": "DEAL_VOLUME" (string:ENUM_DEAL_PROPERTY_DOUBLE, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 0.01}
        Error: {"ok": false, "error": "deal not found, last mt5 error=4401"}

    Notes:
        - Results formatted with 8 decimal places
    """
    return send("history_deal_get_double", payload)


@mcp.tool()
def history_deal_get_integer(payload: str) -> str:
    """
    Get integer-type property of completed deal (ENUM_DEAL_PROPERTY_INTEGER).

    Description:
        Retrieves integer property from completed deal using native
        ENUM_DEAL_PROPERTY_INTEGER enum values.

    Inputs (JSON):
        {
            "deal_ticket": 111111 (int, required - deal ticket),
            "property": "DEAL_TYPE" (string:ENUM_DEAL_PROPERTY_INTEGER, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 0}
        Error: {"ok": false, "error": "deal not found, last mt5 error=4401"}
    """
    return send("history_deal_get_integer", payload)


@mcp.tool()
def history_deal_get_string(payload: str) -> str:
    """
    Get string-type property of completed deal (ENUM_DEAL_PROPERTY_STRING).

    Description:
        Retrieves string property from completed deal using native
        ENUM_DEAL_PROPERTY_STRING enum values.

    Inputs (JSON):
        {
            "deal_ticket": 111111 (int, required - deal ticket),
            "property": "DEAL_SYMBOL" (string:ENUM_DEAL_PROPERTY_STRING, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "EURUSD"}
        Error: {"ok": false, "error": "deal not found, last mt5 error=4401"}
    """
    return send("history_deal_get_string", payload)


# ============================================================================
# GROUP 2: DATA - OHLC + SYMBOL (10 Functions)
# ============================================================================

# === MARKET DATA (5) ===

@mcp.tool()
def copy_open(payload: str) -> str:
    """
    Get array of opening prices.

    Description:
        Retrieves opening price data for specified symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "start": 500 (int, required - bar start index, 0=newest),
            "count": 100 (int, required - number of bars)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [1.08500, 1.08501, 1.08502, ...]}
        Error: {"ok": false, "error": "Failed copy_open for EURUSD PERIOD_H1"}

    Notes:
        - Precision: Depend of symbol
        - The returned array is in series, so position 0 is the most recent value.
    """
    return send("copy_open", payload)


@mcp.tool()
def copy_high(payload: str) -> str:
    """
    Get array of highest prices.

    Description:
        Retrieves high price data for specified symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "start": 0 (int, required - bar start index, 0=newest),
            "count": 100 (int, required - number of bars)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [1.08600, 1.08601, ...]}
        Error: {"ok": false, "error": "Failed copy_high for EURUSD PERIOD_H1"}

    Notes:
        - Precision: Depend of symbol
        - The returned array is in series, so position 0 is the most recent value.
    """
    return send("copy_high", payload)


@mcp.tool()
def copy_low(payload: str) -> str:
    """
    Get array of lowest prices.

    Description:
        Retrieves low price data for specified symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "start": 0 (int, required - bar start index, 0=newest),
            "count": 100 (int, required - number of bars)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [1.08400, 1.08401, ...]}
        Error: {"ok": false, "error": "Failed copy_low for EURUSD PERIOD_H1"}

    Notes:
        - Precision: Depend of symbol
        - The returned array is in series, so position 0 is the most recent value.
    """
    return send("copy_low", payload)


@mcp.tool()
def copy_close(payload: str) -> str:
    """
    Get array of closing prices.

    Description:
        Retrieves closing price data for specified symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "start": 0 (int, required - bar start index, 0=newest),
            "count": 100 (int, required - number of bars)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [1.08500, 1.08501, ...]}
        Error: {"ok": false, "error": "Failed copy_close for EURUSD PERIOD_H1"}

    Notes:
        - Precision: Depend of symbol
        - The returned array is in series, so position 0 is the most recent value.
    """
    return send("copy_close", payload)


@mcp.tool()
def copy_tick_volume(payload: str) -> str:
    """
    Get array of tick volumes.

    Description:
        Retrieves tick volume (number of ticks) for each bar in specified
        symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required - native ENUM_TIMEFRAMES),
            "start": 0 (int, required - bar start index, 0=newest),
            "count": 100 (int, required - number of bars)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": [1500, 1450, 1520, ...]}
        Error: {"ok": false, "error": "Failed copy_tick_volume for EURUSD PERIOD_H1"}

    Notes:
        - Returns integer values (no decimal places)
        - Tick volume reflects number of price changes in the bar
    """
    return send("copy_tick_volume", payload)


# === SYMBOL INFO (5) ===

@mcp.tool()
def symbol_info_double(payload: str) -> str:
    """
    Get double-type symbol property (ENUM_SYMBOL_INFO_DOUBLE).

    Description:
        Retrieves floating-point properties of a trading symbol using
        native ENUM_SYMBOL_INFO_DOUBLE enum values.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "property": "SYMBOL_ASK" (string:ENUM_SYMBOL_INFO_DOUBLE, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 1.08500}
        Error: {"ok": false, "error": "symbol_info_double failed"}

    Notes:
        - Precision: Depend of symbol
        - The returned array is in series, so position 0 is the most recent value.
    """
    return send("symbol_info_double", payload)


@mcp.tool()
def symbol_info_integer(payload: str) -> str:
    """
    Get integer-type symbol property (ENUM_SYMBOL_INFO_INTEGER).

    Description:
        Retrieves integer properties of a trading symbol using native
        ENUM_SYMBOL_INFO_INTEGER enum values.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "property": "SYMBOL_DIGITS" (string:ENUM_SYMBOL_INFO_INTEGER, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 5}
        Error: {"ok": false, "error": "symbol_info_integer failed"}

    Notes:
        - SYMBOL_DIGITS: typically 3-5 for forex
        - SYMBOL_SELECT: 0=not selected, 1=selected
    """
    return send("symbol_info_integer", payload)


@mcp.tool()
def symbol_info_string(payload: str) -> str:
    """
    Get string-type symbol property (ENUM_SYMBOL_INFO_STRING).

    Description:
        Retrieves string properties of a trading symbol using native
        ENUM_SYMBOL_INFO_STRING enum values.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "property": "SYMBOL_DESCRIPTION" (string:ENUM_SYMBOL_INFO_STRING, required - native enum)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "Euro vs US Dollar"}
        Error: {"ok": false, "error": "symbol_info_string failed"}

    Notes:
        - Returns text descriptions and identifiers
    """
    return send("symbol_info_string", payload)


@mcp.tool()
def symbol_select(payload: str) -> str:
    """
    Add or remove symbol from Market Watch.

    Description:
        Adds symbol to Market Watch (select=true) or removes it (select=false).

    Inputs (JSON):
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
def symbols_total(payload: str) -> str:
    """
    Get total number of available symbols.

    Description:
        Returns count of all available trading symbols or only those selected
        in Market Watch.

    Inputs (JSON):
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
# GROUP 3: GRAPHIC OBJECTS (5 Functions)
# ============================================================================

@mcp.tool()
def object_create(payload: str) -> str:
    """
    Create graphic object on chart.

    Description:
        Creates a new graphic object (line, rectangle, text, etc.) on a chart.
        The mode parameter determines how many anchor points are required.

    Inputs (JSON - Trend line with 2 points):
        {
            "chart_id": 0 (int, required - 0=current chart),
            "object_name": "TrendLine1" (string, required - unique name),
            "object_type": "OBJ_TREND" (string, required - native ENUM_OBJECT),
            "sub_window": 0 (int, required - 0=main, 1+=indicators),
            "mode": 0 (int, required - coordinate mode, 0-4),
            "time1": "2022.01.01 01:00" (string:datetime roptional (depend of mode)),
            "price1": 1.0850 (double, optional (depend of mode)),
            "time2": "2021.01.01 00:00" (string:datetime,optional (depend of mode))
            "price2": 1.0900 (double, optional (depend of mode))
            "time3": "2023.01.01 00:00" (string:datetime, optional (depend of mode))
            "price3": 1.0900 (double, optional (depend of mode))
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "success"}
        Error: {"ok": false, "error": "object_create failed"}
 
    Native Enums (ENUM_OBJECT):
        - OBJ_VLINE: Vertical line
        - OBJ_HLINE: Horizontal line
        - OBJ_TREND: Trend line
        - OBJ_RECTANGLE: Rectangle
        - OBJ_TRIANGLE: Triangle
        - OBJ_ELLIPSE: Ellipse
        - OBJ_TEXT: Text label
        - OBJ_LABEL: Label with background
        - OBJ_ARROW: Arrow symbol
        - etc..

    Mode Parameter (coordinate requirements):
        - mode=0: 3-point mode (3 time/price pairs)
        - mode=1: 2-point mode (2 time/price pairs)
        - mode=2: 1-point mode with time (time1, price1)
        - mode=3: 1-point mode with time and price (time1, price1)
        - mode=4: 0-point mode (no coordinates)

    Notes:
        - object_name must be unique on chart
        - time values can be string:datetime:mt5_format timestamps or bar indices
        - price2 and price3 optional depending on mode
    """
    return send("object_create", payload)


@mcp.tool()
def object_delete(payload: str) -> str:
    """
    Delete graphic object from chart.

    Description:
        Removes a graphic object from a chart by name.

    Inputs (JSON):
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
def object_integer(payload: str) -> str:
    """
    Get or set integer property of graphic object (ENUM_OBJECT_PROPERTY_INTEGER).

    Description:
        Retrieves or modifies integer properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.

    Inputs (JSON - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_COLOR" (string:ENUM_OBJECT_PROPERTY_INTEGER, required),
            "prop_modifier": 0 (int, optional - default 0)
        }

    Inputs (JSON - SET Example):
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
def object_double(payload: str) -> str:
    """
    Get or set double property of graphic object (ENUM_OBJECT_PROPERTY_DOUBLE).

    Description:
        Retrieves or modifies floating-point properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.

    Inputs (JSON - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TrendLine1" (string, required),
            "property": "OBJPROP_PRICE" (string:ENUM_OBJECT_PROPERTY_DOUBLE, required),
            "prop_modifier": 0 (int, optional - default 0)
        }

    Inputs (JSON - SET Example):
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
def object_string(payload: str) -> str:
    """
    Get or set string property of graphic object (ENUM_OBJECT_PROPERTY_STRING).

    Description:
        Retrieves or modifies string properties of graphic objects.
        Operation (GET/SET) determined by presence/absence of value parameter.

    Inputs (JSON - GET Example):
        {
            "chart_id": 0 (int, required),
            "object_name": "TextLabel1" (string, required),
            "property": "OBJPROP_TEXT" (string:ENUM_OBJECT_PROPERTY_STRING, required),
            "prop_modifier": 0 (int, optional - default 0)
        }

    Inputs (JSON - SET Example):
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


# ============================================================================
# GROUP 4: CHARTS (6 Functions)
# ============================================================================

@mcp.tool()
def chart_list(payload: str) -> str:
    """
    Get list of all open chart windows.

    Description:
        Returns array of chart IDs for all currently open chart windows.

    Inputs (JSON):
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
def chart_open(payload: str) -> str:
    """
    Open new chart window.

    Description:
        Opens a new chart window for specified symbol and timeframe.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "period": "PERIOD_H1" (string:ENUM_TIMEFRAMES, required - native ENUM_TIMEFRAMES)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 2}
        Error: {"ok": false, "error": "chart_open failed"}

    Notes:
        - Returns new chart ID
    """
    return send("chart_open", payload)


@mcp.tool()
def chart_close(payload: str) -> str:
    """
    Close chart window.

    Description:
        Closes a chart window by ID.

    Inputs (JSON):
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
def chart_get_integer(payload: str) -> str:
    """
    Get integer property of chart (ENUM_CHART_PROPERTY_INTEGER).

    Description:
        Retrieves integer properties of a chart window using native
        ENUM_CHART_PROPERTY_INTEGER enum values.

    Inputs (JSON):
        {
            "chart_id": 0 (int, required),
            "property": "CHART_WIDTH_IN_PIXELS" (string:ENUM_CHART_PROPERTY_INTEGER, required),
            "sub_window": 0 (int, optional - window index, default 0)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 800}
        Error: {"ok": false, "error": "chart_get_integer failed"}
 
    Notes:
        - sub_window: 0=main chart, 1+=indicator windows
    """
    return send("chart_get_integer", payload)


@mcp.tool()
def chart_get_double(payload: str) -> str:
    """
    Get double property of chart (ENUM_CHART_PROPERTY_DOUBLE).

    Description:
        Retrieves floating-point properties of a chart window using native
        ENUM_CHART_PROPERTY_DOUBLE enum values.

    Inputs (JSON):
        {
            "chart_id": 0 (int, required),
            "property": "CHART_FIXED_MAX" (string:ENUM_CHART_PROPERTY_DOUBLE enum, required),
            "sub_window": 0 (int, optional - default 0)
        }

    Outputs (JSON):
        Success: {"ok": true, "result": 1.1000}
        Error: {"ok": false, "error": "chart_get_double failed"}

    Notes:
        - Precision: 8 decimal places
    """
    return send("chart_get_double", payload)


@mcp.tool()
def chart_redraw(payload: str) -> str:
    """
    Redraw chart.

    Description:
        Forces a chart to redraw, updating all objects and data.

    Inputs (JSON):
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


# ============================================================================
# GROUP 5: CODE + TERMINAL (4 Functions)
# ============================================================================

@mcp.tool()
def compile_mql5(payload: str) -> str:
    """
    Compile MQL5 source code.

    Description:
        Compiles MQL5 source code file to EX5 bytecode using specified
        CPU instruction set. Used for Expert Advisors, indicators, scripts.

    Inputs (JSON):
        {
            "full_path_code": "C:\\Users\\Leo\\MetaTrader5\\MQL5\\Experts\\MyEA.mq5" (string, required),
            "instruction": "avx2" (string, optional - CPU instruction set),
            "optimize": true (bool, optional - enable optimizations),
            "timeout_ms": 10000 (int, optional - compilation timeout)
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
        - Output file (.ex5) created in same directory
        - optimize=true enables compiler optimizations (slower)
        - timeout_ms: max time to wait for compilation (default 5000)
    """
    return send("compile_mql5", payload)


@mcp.tool()
def execute_backtest(payload: str) -> str:
    """
    Execute historical backtest.

    Description:
        Runs historical backtest (strategy testing) with specified parameters.
        Results saved to file for analysis.

    Inputs (JSON):
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
def run_ea(payload: str) -> str:
    """
    Run Expert Advisor (EA) on live or demo account.

    Description:
        Executes an Expert Advisor in real-time on specified symbol/timeframe.
        EA runs until manually stopped or encounters error.

    Inputs (JSON):
        {
            "symbol": "EURUSD" (string, required),
            "timeframe": "PERIOD_H1" (string, required),
            "ms_espera": 5000 (int, required - delay between ticks in milliseconds),
            "expert_path": "Experts\\MyEA.ex5" (string, required, path relative at MQL5\\ folder),
            "run_flags": "" (str, optional - execution flags = ["DLL", "AutoTrading", "DLL|AutoTrading"]),
            "params": [
                {"data_type": "TYPE_INT", "value": 10},
                {"data_type": "TYPE_DOUBLE", "value": 0.01},
                {"data_type": "TYPE_TYPE_STRING", "value": "Parameter"}
            ] (obj array, optional - EA input parameters obj structure = {"ENUM_DATATYPE", value})
        }

    Outputs (JSON):
        Success: {"ok": true, "result": "EA running"}
        Error: {"ok": false, "error": "Failed to start EA"}

    Notes:
        - ms_espera: typical range 500-5000ms
        - Expert Advisor must be compiled (.ex5 format)
        - Only one EA per symbol/timeframe pair
        - EA continues running until manually stopped
    """
    return send("run_ea", payload)


@mcp.tool()
def get_expert_logs(payload: str) -> str:
    """
    Get recent Expert Advisor logs.

    Description:
        Retrieves the most recent log entries from Expert Advisor execution.
        Useful for debugging and monitoring EA behavior.

    Inputs (JSON):
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
