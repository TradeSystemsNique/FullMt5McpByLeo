#+------------------------------------------------------------------+
#| Imports                                                          |
#+------------------------------------------------------------------+
from .Def import *

# ============================================================================
# GROUP 1: TRADE OPERATIONS (19 Functions)
# ============================================================================

# === OPEN POSITIONS (3) ===

@g_registrador.register_tool_decorator()
def open_trade(payload: Dict[str, Any]) -> None:
    """
"description": "Abre una posición de mercado (compra/venta) a precio actual",
"inputSchema": {
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "description": "Tipo de operación | string:buy|sell | buy, sell | requerido"
    },
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "lot_size": {
      "type": "number",
      "description": "Volumen de la posición | double:0+ | 0.01, 0.1, 1.0 | requerido"
    },
    "price": {
      "type": "number",
      "description": "Precio de entrada (Ask para compras, Bid para ventas) | double:precio | 1.0850 | requerido"
    },
    "sl": {
      "type": "number",
      "description": "Stop Loss | double:precio | 1.0800 | 0.0"
    },
    "tp": {
      "type": "number",
      "description": "Take Profit | double:precio | 1.0900 | 0.0"
    },
    "magic": {
      "type": "integer",
      "description": "Número mágico para identificar órdenes | int:0+ | 12345 | 0"
    },
    "comment": {
      "type": "string",
      "description": "Comentario de la operación | string | Long bias signal | vacío"
    }
  },
  "required": ["type", "symbol", "lot_size", "price"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def open_limit(payload: Dict[str, Any]) -> None:
    """
"description": "Crea una orden límite pendiente (Buy Limit o Sell Limit)",
"inputSchema": {
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "description": "Tipo de orden límite | string:buy|sell | buy, sell | requerido"
    },
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "lot_size": {
      "type": "number",
      "description": "Volumen de la orden | double:0+ | 0.01, 0.1 | requerido"
    },
    "price": {
      "type": "number",
      "description": "Precio de activación de la orden | double:precio | 1.0750 | requerido"
    },
    "sl": {
      "type": "number",
      "description": "Stop Loss | double:precio | 1.0700 | 0.0"
    },
    "tp": {
      "type": "number",
      "description": "Take Profit | double:precio | 1.0850 | 0.0"
    },
    "magic": {
      "type": "integer",
      "description": "Número mágico | int:0+ | 12345 | 0"
    },
    "comment": {
      "type": "string",
      "description": "Comentario de la orden | string | Limit on support | vacío"
    },
    "time_expiration":{
      "type":"string",
      "description":"Tiempo de expiracion de la orden | string:mt5:datetime | 2021.01.01 10:00:00 | 0"
    },
    "type_time":{
      "type":"string",
      "description":"Tiempo de vida de la orden (tipo)| string:mt5:ENUM_ORDER_TYPE_TIME | ORDER_TIME_GTC, ORDER_TIME_DAY, etc... | ORDER_TIME_GTC"
    }    
  },
  "required": ["type", "symbol", "lot_size", "price"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def open_stop(payload: Dict[str, Any]) -> None:
    """
"description": "Crea una orden stop pendiente (Buy Stop o Sell Stop) para breakouts",
"inputSchema": {
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "description": "Tipo de orden stop | string:buy|sell | buy, sell | requerido"
    },
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "lot_size": {
      "type": "number",
      "description": "Volumen de la orden | double:0+ | 0.01, 0.1 | requerido"
    },
    "price": {
      "type": "number",
      "description": "Precio de activación del stop | double:precio | 1.0950 | requerido"
    },
    "sl": {
      "type": "number",
      "description": "Stop Loss | double:precio | 1.0900 | 0.0"
    },
    "tp": {
      "type": "number",
      "description": "Take Profit | double:precio | 1.1050 | 0.0"
    },
    "magic": {
      "type": "integer",
      "description": "Número mágico | int:0+ | 12345 | 0"
    },
    "comment": {
      "type": "string",
      "description": "Comentario de la orden | string | Stop on resistance | vacío"
    },
   "time_expiration":{
      "type":"string",
      "description":"Tiempo de expiracion de la orden | string:mt5:datetime | 2021.01.01 10:00:00 | 0"
    },
    "type_time":{
      "type":"string",
      "description":"Tiempo de vida de la orden (tipo)| string:mt5:ENUM_ORDER_TYPE_TIME | ORDER_TIME_GTC, ORDER_TIME_DAY, etc... | ORDER_TIME_GTC"
    }  
  },
  "required": ["type", "symbol", "lot_size", "price"]
}
    """
    pass


# === POSITION MANAGEMENT (4) ===

@g_registrador.register_tool_decorator()
def position_list(payload: Dict[str, Any]) -> None:
    """
"description": "Lista todos los tickets de posiciones abiertas en la cuenta",
"inputSchema": {
  "type": "object",
  "properties": {}
}
    """
    pass


@g_registrador.register_tool_decorator()
def position_get(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene una propiedad específica de una posición abierta",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la posición | int:0+ | 123456 | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a obtener | string:mt5:ENUM_POSITION_PROPERTY_* | POSITION_VOLUME, POSITION_PROFIT, etc.. | requerido"
    },
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    }
  },
  "required": ["ticket", "property", "mode"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def position_close(payload: Dict[str, Any]) -> None:
    """
"description": "Cierra posiciones abiertas por símbolo o ticket, con opción de cierre parcial",
"inputSchema": {
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "description": "Método de cierre | string:by_symbol|by_ticket | by_symbol, by_ticket | requerido"
    },
    "value": {
      "type": ["string", "integer"],
      "description": "Símbolo (si type=by_symbol=selecion por simbolo esto para cuentas Netting una sola posicion por simbolo) o ticket (si type=by_ticket) | string|int | EURUSD, 123456 | requerido"
    },
    "volume": {
      "type": "string",
      "description": "Volumen a cerrar (parcial) | string:double:0+ | 0.01 | si no esta definido cierra todo de lo contrario cierra el volumen especificado"
    },
    "deviation": {
      "type": "integer",
      "description": "Desviación de precio en puntos | int:0+ | 100 | 0"
    }
  },
  "required": ["type", "value"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def position_modify(payload: Dict[str, Any]) -> None:
    """
"description": "Modifica el Stop Loss y Take Profit de una posición abierta",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la posición | int:0+ | 123456 | requerido"
    },
    "sl": {
      "type": "number",
      "description": "Nuevo Stop Loss | double:precio | 1.0800 | default=sl antiguo"
    },
    "tp": {
      "type": "number",
      "description": "Nuevo Take Profit | double:precio | 1.0950 | default=tp antiguo"
    }
  },
  "required": ["ticket"]
}
    """
    pass


# === ORDER MANAGEMENT (5) ===

@g_registrador.register_tool_decorator()
def order_list(payload: Dict[str, Any]) -> None:
    """
"description": "Lista todos los tickets de órdenes pendientes (no activadas)",
"inputSchema": {
  "type": "object",
  "properties": {}
}
    """
    pass


@g_registrador.register_tool_decorator()
def order_close(payload: Dict[str, Any]) -> None:
    """
"description": "Cancela una orden pendiente (límite o stop)",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la orden a cancelar | int:0+ | 654321 | requerido"
    }
  },
  "required": ["ticket"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def order_modify(payload: Dict[str, Any]) -> None:
    """
"description": "Modifica precio, Stop Loss y Take Profit de una orden pendiente",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la orden | int:0+ | 654321 | requerido"
    },
    "new_price": {
      "type": "number",
      "description": "Nuevo precio de activación | double:precio | 1.0800 | default=precio antiguo"
    },
    "new_sl": {
      "type": "number",
      "description": "Nuevo Stop Loss | double:precio | 1.0750 | default=precio del sl antiguo"
    },
    "new_tp": {
      "type": "number",
      "description": "Nuevo Take Profit | double:precio | 1.0900 | default=precio del tp antiguo"
    },
    "new_type_time": {
      "type": "string",
      "description": "Tipo de expiración | string:mt5:ENUM_ORDER_TYPE_TIME | ORDER_TIME_GTC, ORDER_TIME_DAY | default=tipo de expiracion antiguo"
    },
    "new_expiration_time": {
      "type": "string",
      "description": "Hora de expiración | string:datetime | 2026-05-01 12:00:00 | default=tiempo de expiracion antiguo"
    }
  },
  "required": ["ticket"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def order_get(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene una propiedad específica de una orden pendiente",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la orden | int:0+ | 654321 | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a obtener | string:mt5:ENUM_ORDER_PROPERTY_* | ORDER_VOLUME, ORDER_PRICE, etc.. | requerido"
    },
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    }
  },
  "required": ["ticket", "property", "mode"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def calc_order(payload: Dict[str, Any]) -> None:
    """
"description": "Calculadora unificada MT5 para sizing, riesgo, SL y márgenes. Dispone de 5 métodos seleccionables por 'mode' (0-4). Consulta 'mode_requirements' para parámetros específicos de cada modo.",
"inputSchema": {
  "type": "object",
  "properties": {
    "mode": {
      "type": "integer",
      "description": "Índice del método de cálculo | int:0-4 | 0=SL con lote, 1=dinero a puntos, 2=lote por SL, 3=máximo lote, 4=lote por riesgo | requerido en todos los modos"
    },
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido en todos los modos"
    },
    "order_type": {
      "type": "string",
      "description": "Tipo de orden MT5 | string:mt5:ENUM_ORDER_TYPE | ORDER_TYPE_BUY, ORDER_TYPE_SELL, ORDER_TYPE_BUY_LIMIT, ORDER_TYPE_SELL_LIMIT | modos_requeridos=[1,3,4]"
    },
    "entry_price": {
      "type": "number",
      "description": "Precio de entrada | double:0+ | 1.0850 | modos_requeridos=[0,1,4]"
    },
    "risk_per_operation": {
      "type": "number",
      "description": "Riesgo por operación en moneda cuenta | double:0+ | 100.00 | modos_requeridos=[0,1,2,4]"
    },
    "lot_size": {
      "type": "number",
      "description": "Tamaño lote actual | double:0+ | 0.01 | modos_requeridos=[0]"
    },
    "sl": {
      "type": "integer",
      "description": "Stop Loss en puntos | int:0+ | 50 | modos_requeridos=[2]"
    },
    "max_lot": {
      "type": "number",
      "description": "Máximo lote permitido | double:0+ | 1.0 | modos_requeridos=[2]"
    },
    "deviation": {
      "type": "integer",
      "description": "Desviación de precio en puntos | int:0+ | 10 | modos_requeridos=[0,1,3,4] | default=0"
    },
    "stop_limit": {
      "type": "integer",
      "description": "Parámetro stop limit en puntos | int:0+ | 20 | modos_requeridos=[0,1,3,4] | default=0"
    }
  },
  "required": ["mode", "symbol"],
  "mode_requirements": {
    "0": {
      "nombre": "CalculateSLWithLot",
      "descripcion": "Calcula SL en puntos dado riesgo, precio entrada y lote",
      "requiere": ["mode", "symbol", "entry_price", "risk_per_operation", "lot_size"],
      "opcional": ["deviation", "stop_limit"],
      "retorna": "SL en puntos (long)"
    },
    "1": {
      "nombre": "MoneyToPoints",
      "descripcion": "Convierte dinero de riesgo a puntos y calcula lote óptimo",
      "requiere": ["mode", "symbol", "order_type", "risk_per_operation", "entry_price"],
      "opcional": ["deviation", "stop_limit"],
      "retorna": "Puntos (long) y lote recomendado (double)"
    },
    "2": {
      "nombre": "GetLoteByRiskPerOperationAndSL",
      "descripcion": "Calcula lote basado en riesgo por operación y SL fijo",
      "requiere": ["mode", "symbol", "risk_per_operation", "max_lot", "sl"],
      "opcional": [],
      "retorna": "Lote (double) y riesgo real (double)"
    },
    "3": {
      "nombre": "GetMaxLote",
      "descripcion": "Calcula el máximo lote posible sin exceder margen",
      "requiere": ["mode", "symbol", "order_type", "entry_price"],
      "opcional": ["deviation", "stop_limit"],
      "retorna": "Máximo lote (double)"
    },
    "4": {
      "nombre": "GetLoteByRiskPerOperation",
      "descripcion": "Calcula lote basado en riesgo por operación",
      "requiere": ["mode", "symbol", "order_type", "risk_per_operation", "entry_price"],
      "opcional": ["deviation", "stop_limit"],
      "retorna": "Lote (double)"
    }
  }
}
    """
    pass


# === TRADE HISTORY (2) ===
@g_registrador.register_tool_decorator()
def history_deal_list(payload: Dict[str, Any]) -> None:
    """
"description": "Lista tickets de operaciones completadas dentro de un rango de fechas",
"inputSchema": {
  "type": "object",
  "properties": {
    "start_date_select": {
      "type": "string",
      "description": "Fecha inicio del rango | string:datetime:mt5 | 2024.01.01 00:00:00 | requerido"
    },
    "end_date_select": {
      "type": "string",
      "description": "Fecha fin del rango | string:datetime:mt5 | 2024.12.31 23:59:59 | requerido"
    }
  },
  "required": ["start_date_select", "end_date_select"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def history_deal_get(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene una propiedad específica de una operación completada",
"inputSchema": {
  "type": "object",
  "properties": {
    "ticket": {
      "type": "integer",
      "description": "Ticket de la operación | int:0+ | 123456 | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a obtener | string:mt5:ENUM_DEAL_PROPERTY | DEAL_VOLUME, DEAL_PROFIT | requerido"
    },
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    }
  },
  "required": ["ticket", "property", "mode"]
}
    """
    pass


# ============================================================================
# GROUP 2: DATA - OHLC + SYMBOL (7 Functions)
# ============================================================================

# === MARKET DATA (3) ===

@g_registrador.register_tool_decorator()
def copy_data(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene datos Open,High,Low,Close,Time,RealVolume,TickVolume,Spread de velas (índice 0=más reciente, size-1=más antiguo)",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "timeframe": {
      "type": "string",
      "description": "Timeframe de velas | string:mt5:ENUM_TIMEFRAMES | PERIOD_H1, PERIOD_D1 | requerido"
    },
    "start": {
      "type": "integer",
      "description": "Índice inicio (0=más reciente) | int:0+ | 0, 10, 100 | requerido"
    },
    "count": {
      "type": "integer",
      "description": "Número de velas a obtener | int:1+ | 100, 500 | requerido"
    },
    "mode": {
      "type": "string",
      "description": "Tipo de dato | string:MCPFUNC_COPY_DATA_* | * = [OPEN, HIGH, LOW, OPEN, TICK_VOLUME, REAL_VOLUME, TIME, SPREAD], eg: MCPFUNC_COPY_DATA_CLOSE | requerido"
    }
  },
  "required": ["symbol", "timeframe", "start", "count", "mode"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def copy_ticks(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene datos tick (Bid/Ask/Last) con objetos completos (0=más reciente)",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "from": {
      "type": "string",
      "description": "Timestamp inicio en milisegundos Unix | string:unix_ms | 1704067200000 | vacío"
    },
    "count": {
      "type": "integer",
      "description": "Número de ticks a obtener | int:1+ | 100, 1000 | requerido"
    },
    "flags": {
      "type": "integer",
      "description": "Flags de filtro | int:ENUM_COPY_TICKS | 3=COPY_TICKS_ALL, 1=INFO, 2=TRADE | vacío"
    }
  },
  "required": ["symbol", "count"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def i_bar_shift(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene el índice de vela (shift) para un tiempo específico en el historial",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "timeframe": {
      "type": "string",
      "description": "Timeframe | string:mt5:ENUM_TIMEFRAMES | PERIOD_M1, PERIOD_H1 | requerido"
    },
    "time": {
      "type": "string",
      "description": "Tiempo buscado | string:datetime:mt5 | 2024.01.15 12:30:00 | requerido"
    },
    "exact": {
      "type": "boolean",
      "description": "Si true requiere coincidencia exacta | boolean | true, false | false"
    }
  },
  "required": ["symbol", "timeframe", "time"]
}
    """
    pass

# === SYMBOL INFO (4) ===
@g_registrador.register_tool_decorator()
def symbol_info(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene una propiedad específica de un símbolo de trading",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a obtener | string:mt5:ENUM_SYMBOL_INFO_* | SYMBOL_ASK, SYMBOL_BID, etc... | requerido"
    },
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    }
  },
  "required": ["symbol", "property", "mode"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def symbol_info_session(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene horario de sesión (trading/quote) para un símbolo y día",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "day_of_week": {
      "type": "string",
      "description": "Día de semana | string:ENUM_DAY_OF_WEEK | MONDAY, FRIDAY, etc.. | requerido"
    },
    "session_index": {
      "type": "integer",
      "description": "Índice de sesión | int:0+ | 0, 1, 2 | requerido"
    },
    "mode": {
      "type": "integer",
      "description": "Tipo de sesión | int:0-1 | 0=trading, 1=quote | requerido"
    }
  },
  "required": ["symbol", "day_of_week", "session_index", "mode"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def symbol_select(payload: Dict[str, Any]) -> None:
    """
"description": "Agrega o remueve símbolo de Market Watch",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "select": {
      "type": "boolean",
      "description": "Acción | boolean | true=agregar, false=remover | requerido"
    }
  },
  "required": ["symbol", "select"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def symbols_total(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene cantidad total de símbolos disponibles o en Market Watch",
"inputSchema": {
  "type": "object",
  "properties": {
    "only_selected_in_market_watch": {
      "type": "boolean",
      "description": "Contar solo en Market Watch | boolean | true, false | false"
    }
  }
}
    """
    pass


# ============================================================================
# GROUP 3: GRAPHIC OBJECTS (6 Functions)
# ============================================================================

@g_registrador.register_tool_decorator()
def object_create(payload: Dict[str, Any]) -> None:
    """
"description": "Crea un objeto gráfico en el gráfico (líneas de tendencia, rectángulos, etiquetas, flechas, etc.)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "object_name": {
      "type": "string",
      "description": "Nombre único del objeto | string | Trend1, RectA | requerido"
    },
    "object_type": {
      "type": "string",
      "description": "Tipo de objeto | string:mt5:ENUM_OBJECT | OBJ_TREND, OBJ_RECTANGLE, etc.. | requerido"
    },
    "sub_window": {
      "type": "integer",
      "description": "Ventana del gráfico | int | 0=principal, 1+=indicador | 0"
    },
    "mode": {
      "type": "integer",
      "description": "Modo de coordenadas | int:0-3 | 0=3 puntos, 1=2 puntos, 2=1 punto, 3=sin coords | requerido"
    },
    "time1": {
      "type": "string",
      "description": "Fecha/hora del punto 1 | string:datetime | 2025.01.01 00:00 | vacío"
    },
    "price1": {
      "type": "number",
      "description": "Precio del punto 1 | double | 1.0850 | 0.0"
    },
    "time2": {
      "type": "string",
      "description": "Fecha/hora del punto 2 | string:datetime | 2025.01.02 10:00 | vacío"
    },
    "price2": {
      "type": "number",
      "description": "Precio del punto 2 | double | 1.0900 | 0.0"
    },
    "time3": {
      "type": "string",
      "description": "Fecha/hora del punto 3 | string:datetime | 2025.01.03 14:00 | vacío"
    },
    "price3": {
      "type": "number",
      "description": "Precio del punto 3 | double | 1.0800 | 0.0"
    }
  },
  "required": ["object_name", "object_type", "mode"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def object_delete(payload: Dict[str, Any]) -> None:
    """
"description": "Elimina un objeto gráfico del gráfico",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "object_name": {
      "type": "string",
      "description": "Nombre del objeto a eliminar | string | TrendLine1, RectA | requerido"
    }
  },
  "required": ["object_name"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def object_integer(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad entera de objeto gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "object_name": {
      "type": "string",
      "description": "Nombre del objeto | string | TrendLine1, RectA | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_OBJECT_PROPERTY_INTEGER | OBJPROP_COLOR, OBJPROP_WIDTH, etc.. | requerido"
    },
    "prop_modifier": {
      "type": "integer",
      "description": "Modificador de propiedad | int:0+ | 0=punto1, 1=punto2, 2=punto3 | 0"
    },
    "value": {
      "type": "integer",
      "description": "Valor a establecer (solo para SET) | int | 16711680 | vacío"
    }
  },
  "required": ["object_name", "property"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def object_double(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad doble de objeto gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "object_name": {
      "type": "string",
      "description": "Nombre del objeto | string | TrendLine1, RectA | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_OBJECT_PROPERTY_DOUBLE | OBJPROP_PRICE, OBJPROP_SCALE, etc.. | requerido"
    },
    "prop_modifier": {
      "type": "integer",
      "description": "Modificador de propiedad | int:0+ | 0=punto1, 1=punto2, 2=punto3 | 0"
    },
    "value": {
      "type": "number",
      "description": "Valor a establecer (solo para SET) | double | 1.0900 | vacío"
    }
  },
  "required": ["object_name", "property"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def object_string(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad string de objeto gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "object_name": {
      "type": "string",
      "description": "Nombre del objeto | string | TextLabel1, RectA | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_OBJECT_PROPERTY_STRING | OBJPROP_TEXT, OBJPROP_FONT, etc.. | requerido"
    },
    "prop_modifier": {
      "type": "integer",
      "description": "Modificador de propiedad | int:0+ | 0 típico | 0"
    },
    "value": {
      "type": "string",
      "description": "Valor a establecer (solo para SET) | string | New Label Text | vacío"
    }
  },
  "required": ["object_name", "property"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def object_list(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene lista de nombres de objetos en el gráfico filtrados por tipo y ventana",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0"
    },
    "sub_window": {
      "type": "integer",
      "description": "Ventana del gráfico | int | 0=principal, -1=todas | -1"
    },
    "object_type": {
      "type": "string",
      "description": "Tipo de objeto a filtrar | string:mt5:ENUM_OBJECT | OBJ_TREND, OBJ_RECTANGLE | vacío"
    }
  },
  "required": []
}
    """
    pass




# ============================================================================
# GROUP 4: CHARTS (9 Functions)
# ============================================================================

@g_registrador.register_tool_decorator()
def chart_list(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene lista de todas las ventanas de gráficos abiertos",
"inputSchema": {
  "type": "object",
  "properties": {}
}
    """
    pass


@g_registrador.register_tool_decorator()
def chart_open(payload: Dict[str, Any]) -> None:
    """
"description": "Abre una nueva ventana de gráfico para un símbolo y marco temporal específico",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "timeframe": {
      "type": "string",
      "description": "Marco temporal del gráfico | string:mt5:ENUM_TIMEFRAMES | PERIOD_H1, PERIOD_D1, PERIOD_M15 | requerido"
    }
  },
  "required": ["symbol", "timeframe"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def chart_close(payload: Dict[str, Any]) -> None:
    """
"description": "Cierra una ventana de gráfico por su ID (no se puede cerrar ID 0)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico a cerrar | int:1+ | 1, 2, 3 | requerido"
    }
  },
  "required": ["chart_id"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def chart_integer(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad entera del gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0=current chart"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_CHART_PROPERTY_INTEGER | CHART_VISIBLE_BARS, CHART_COLOR_ASK, etc.. | requerido"
    },
    "sub_window": {
      "type": "integer",
      "description": "Ventana del gráfico (GET) | int | 0=principal, 1+=indicador | 0"
    },
    "value": {
      "type": "integer",
      "description": "Valor a establecer (solo para SET) | int | 170000000 | vacío"
    }
  },
  "required": ["chart_id", "property"]
}
    """
    pass
    
@g_registrador.register_tool_decorator()
def chart_double(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad doble del gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0=current chart"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_CHART_PROPERTY_DOUBLE | CHART_FIXED_MAX, CHART_FIXED_MIN, etc.. | requerido"
    },
    "sub_window": {
      "type": "integer",
      "description": "Ventana del gráfico (GET) | int | 0=principal, 1+=indicador | 0"
    },
    "value": {
      "type": "number",
      "description": "Valor a establecer (solo para SET) | double | 2450.00 | vacío"
    }
  },
  "required": ["chart_id", "property"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def chart_redraw(payload: Dict[str, Any]) -> None:
    """
"description": "Redibuja el gráfico actualizando todos los objetos y datos",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico a redibujar | int | 0, 1, 2 | 0"
    }
  },
  "required": []
}
    """
    pass

@g_registrador.register_tool_decorator()
def chart_string(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene o establece propiedad string del gráfico (GET si falta value, SET si incluye value)",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0=current chart"
    },
    "property": {
      "type": "string",
      "description": "Propiedad a leer/escribir | string:mt5:ENUM_CHART_PROPERTY_STRING | CHART_COMMENT, etc.. | requerido"
    },
    "value": {
      "type": "string",
      "description": "Valor a establecer (solo para SET) | string | New Comment | vacío"
    }
  },
  "required": ["chart_id", "property"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def chart_get_symbol_or_period(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene el símbolo o marco temporal del gráfico según el modo",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | 0=current chart"
    },
    "mode": {
      "type": "integer",
      "description": "Modo de consulta | int:0-1 | 0=obtener timeframe, 1=obtener símbolo | requerido"
    }
  },
  "required": ["chart_id", "mode"]
}
    """
    pass

@g_registrador.register_tool_decorator()
def chart_screenshot(payload: Dict[str, Any]) -> None:
    """
"description": "Captura screenshot del gráfico y lo guarda a archivo",
"inputSchema": {
  "type": "object",
  "properties": {
    "chart_id": {
      "type": "integer",
      "description": "ID del gráfico | int | 0, 1, 2 | requerido"
    },
    "file_name": {
      "type": "string",
      "description": "Nombre del archivo | string:ruta:relativa (vease common_flag) | screenshot.png, images/chart.png | requerido"
    },
    "width": {
      "type": "integer",
      "description": "Ancho en píxeles | int:0+ | 800 | ancho actual"
    },
    "height": {
      "type": "integer",
      "description": "Alto en píxeles | int:0+ | 600 | alto actual"
    },
    "common_flag": {
      "type": "boolean",
      "description": "Mover a carpeta común | boolean | true=Common\\\\Files, false=MQL5\\\\Files | true"
    }
  },
  "required": ["chart_id", "file_name"]
}
    """
    pass

# ============================================================================
# GROUP 5: CODE + TERMINAL (4 Functions)
# ============================================================================

@g_registrador.register_tool_decorator()
def compile_mql5(payload: Dict[str, Any]) -> None:
    """
"description": "Compila código fuente MQL5 a bytecode EX5 con set de instrucciones CPU específico",
"inputSchema": {
  "type": "object",
  "properties": {
    "full_path_code": {
      "type": "string",
      "description": "Ruta completa al archivo MQL5 | string:ruta_completa | C:\\\\Users\\\\Leo\\\\MQL5\\\\Experts\\\\MyEA.mq5 | requerido"
    },
    "instruction": {
      "type": "string",
      "description": "Set de instrucciones CPU | string:avx|avx2|avx512 | avx2, avx, avx512 | vacío"
    },
    "optimize": {
      "type": "boolean",
      "description": "Habilitar optimizaciones | boolean | true, false | false"
    },
    "timeout_ms": {
      "type": "integer",
      "description": "Timeout de compilación en milisegundos | int:0+ | 60000, 120000 | 60000"
    }
  },
  "required": ["full_path_code"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def execute_backtest(payload: Dict[str, Any]) -> None:
    """
"description": "Ejecuta backtest histórico con parámetros especificados",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "set_file_name": {
      "type": "string",
      "description": "Archivo de configuración | string:ruta:completa | MyStrategy.set | requerido"
    },
    "expert_path": {
      "type": "string",
      "description": "Ruta del EA compilado | string:ruta:relativa_a_MQL5_folder | Experts\\\\MyEA.ex5 | requerido"
    },
    "start_date": {
      "type": "string",
      "description": "Fecha inicio del backtest | string:datetime:mt5 | 2024.01.01 00:00:00 | requerido"
    },
    "end_date": {
      "type": "string",
      "description": "Fecha fin del backtest | string:datetime:mt5 | 2024.12.31 23:59:59 | requerido"
    },
    "timeframe": {
      "type": "string",
      "description": "Marco temporal | string:mt5:ENUM_TIMEFRAMES | PERIOD_H1, PERIOD_D1 | requerido"
    },
    "leverage": {
      "type": "integer",
      "description": "Apalancamiento de trading | int:1+ | 100, 50, 1 | requerido"
    },
    "visual_mode": {
      "type": "boolean",
      "description": "Mostrar animación visual | boolean | true=animado, false=rápido | false"
    },
    "modelado": {
      "type": "string",
      "description": "Modo de modelado de ticks | string:custom:ENUM_MTTESTER_MODELADO_MODE | MTTESTER_MODELADO_EVERY_TICK, MTTESTER_MODELADO_OCHLM1, MTTESTER_MODELADO_ONLY_OPEN, MTTESTER_MODELADO_REAL_TICK | requerido"
    },
    "file_in_common": {
      "type": "boolean",
      "description": "Guardar resultados en carpeta común | boolean | true, false | false"
    },
    "data_file_name": {
      "type": "string",
      "description": "Nombre del archivo de resultados | string | MyResults, output | vacío"
    }
  },
  "required": ["symbol", "set_file_name", "expert_path", "start_date", "end_date", "timeframe", "leverage", "visual_mode", "modelado"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def run_ea(payload: dict) -> None:
    """
"description": "Ejecuta Expert Advisor en tiempo real en gráfico específico",
"inputSchema": {
  "type": "object",
  "properties": {
    "symbol": {
      "type": "string",
      "description": "Símbolo de trading | string | EURUSD, XAUUSD | requerido"
    },
    "timeframe": {
      "type": "string",
      "description": "Marco temporal del gráfico | string:mt5:ENUM_TIMEFRAMES | PERIOD_H1, PERIOD_D1, PERIOD_M15 | requerido"
    },
    "ms_espera": {
      "type": "integer",
      "description": "Milisengundos de espera para sincronizar el grafico | int:100+ | 1000, 5000 | requerido"
    },
    "expert_path": {
      "type": "string",
      "description": "Ruta al archivo EA compilado | string:ruta_relativa_a_MQL5_folder | Experts\\\\MyEA.ex5 | requerido"
    },
    "run_flags": {
      "type": "string",
      "description": "Flags de ejecución separados por pipe | string | DLL, AutoTrading, DLL|AutoTrading | vacío"
    },
    "params": {
      "type": "array",
      "description": "Parámetros del EA en orden posicional | array:objects | [tipo, valor] | vacío",
      "items": {
        "type": "object",
        "properties": {
          "data_type": {
            "type": "string",
            "description": "Tipo de dato | string:mt5:ENUM_DATATYPE | TYPE_INT, TYPE_DOUBLE, TYPE_STRING, TYPE_DATETIME, TYPE_COLOR, etc.. | requerido"
          },
          "value": {
            "type": ["string", "number"],
            "description": "Valor del parámetro | string|number | 10, 0.01, MyString, 2024.01.15 12:30:00, clrRed | requerido"
          }
        },
        "required": ["data_type", "value"]
      }
    }
  },
  "required": ["symbol", "timeframe", "ms_espera", "expert_path"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def get_expert_logs(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene los logs recientes de ejecución del Expert Advisor",
"inputSchema": {
  "type": "object",
  "properties": {
    "start_date": {
      "type": "string",
      "description": "Fecha de inicio para filtrar logs | string:datetime:mt5 | 2024.01.01, 2026.04.28 10:15:00 | requerido"
    },
    "logs_lines": {
      "type": "integer",
      "description": "Número de líneas de logs | int:1+ | 50, 100, 200 | 50"
    }
  },
  "required": ["start_date"]
}
    """
    pass


# ============================================================================
# GROUP 2: Utils
# ============================================================================

@g_registrador.register_tool_decorator()
def get_time(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene la hora actual en diferentes formatos (GMT, local, servidor, etc.)",
"inputSchema": {
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "description": "Tipo de hora a obtener | string:mt5:ENUM_MCPFUNC_TYPE_TIME | MCPFUNC_TIME_GMT, MCPFUNC_TIME_CURRENT, MCPFUNC_TIME_LOCAL, MCPFUNC_TIME_SERVER | requerido"
    }
  },
  "required": ["type"]
}
    """
    pass


@g_registrador.register_tool_decorator()
def get_err_description(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene descripción legible del código de error MT5",
"inputSchema": {
  "type": "object",
  "properties": {
    "error_code": {
      "type": "integer",
      "description": "Código de error MT5 | int:0+ | 10001, 10002 | requerido"
    },
    "include_code": {
      "type": "boolean",
      "description": "Incluir número de código en resultado | boolean | true, false | true"
    }
  },
  "required": ["error_code"]
}
    """
    pass




@g_registrador.register_tool_decorator()
def account_info(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene información de la cuenta MT5 (double, integer, string)",
"inputSchema": {
  "type": "object",
  "properties": {
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad de la cuenta | string:mt5:ENUM_ACCOUNT_INFO_* | ACCOUNT_BALANCE, ACCOUNT_EQUITY, ACCOUNT_LOGIN, etc... | requerido"
    }
  },
  "required": ["mode", "property"]
}
    """
    pass



@g_registrador.register_tool_decorator()
def terminal_info(payload: Dict[str, Any]) -> None:
    """
"description": "Obtiene información del terminal MT5 (double, integer, string)",
"inputSchema": {
  "type": "object",
  "properties": {
    "mode": {
      "type": "integer",
      "description": "Tipo de propiedad | int:0-2 | 0=double, 1=integer, 2=string | requerido"
    },
    "property": {
      "type": "string",
      "description": "Propiedad del terminal | string:mt5:ENUM_TERMINAL_INFO_* | TERMINAL_CONNECTED, TERMINAL_TRADE_ALLOWED, TERMINAL_PATH, etc... | requerido"
    }
  },
  "required": ["mode", "property"]
}
    """
    pass