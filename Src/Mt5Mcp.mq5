//+------------------------------------------------------------------+
//|                                                       Mt5Mcp.mq5 |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Defines                                                          |
//+------------------------------------------------------------------+
#define PUBLIC_VERSION

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "All.mqh"
#include "Secrets.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string InpSoketAdres = "127.0.0.1";
input uint InpSoketPort = 9999;
input int InpMsPool = 75;
input int InpMsTimeoutReadNoTls = 10000;

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
IMcpBase* g_mcp_server;
CTrade g_trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
 {
//---
#ifdef TSN_MCPSERVER_FUNC_CTS
  g_mcp_server = TSN_MCPSERVER_FUNC_CTS(THE_BOT_PLACE_USER_ID);
#else
  g_mcp_server = McpServerByLeo_Create(THE_BOT_PLACE_USER_ID); 
#endif // TSN_MCPSERVER_FUNC_CTS

//---
  ::EventSetMillisecondTimer(InpMsPool);
  g_mcp_server.AddLogFlags(LOG_ALL);

//--- Graphics / Objects
  g_mcp_server.AddItemFast(new CMcpFuncObjectCreate());
  g_mcp_server.AddItemFast(new CMcpFuncObjectDelete());
  g_mcp_server.AddItemFast(new CMcpFuncObjectInteger());
  g_mcp_server.AddItemFast(new CMcpFuncObjectDouble());
  g_mcp_server.AddItemFast(new CMcpFuncObjectString());
  g_mcp_server.AddItemFast(new CMcpFuncObjectList());

//--- Charts
  g_mcp_server.AddItemFast(new CMcpFuncChartList());
  g_mcp_server.AddItemFast(new CMcpFuncChartOpen());
  g_mcp_server.AddItemFast(new CMcpFuncChartClose());
  g_mcp_server.AddItemFast(new CMcpFuncChartInteger());
  g_mcp_server.AddItemFast(new CMcpFuncChartDouble());
  g_mcp_server.AddItemFast(new CMcpFuncChartString());
  g_mcp_server.AddItemFast(new CMcpFuncChartRedraw());
  g_mcp_server.AddItemFast(new CMcpFuncChartSrenshot());
  g_mcp_server.AddItemFast(new CMcpFuncChartGetSymbolOrPeriod());

//--- Data / Symbol
  g_mcp_server.AddItemFast(new CMcpFuncSymbolsTotal());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolSelect());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolInfo());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolInfoSession());


//--- Data / Market Data
  g_mcp_server.AddItemFast(new CMcpFuncCopyData());
  g_mcp_server.AddItemFast(new CMcpFuncCopyTicks());
  g_mcp_server.AddItemFast(new CMcpFuncBarShift());

//--- Calc order
  g_mcp_server.AddItemFast(new CMcpFuncCalcOrder());

//--- Trade / Positions
  g_mcp_server.AddItemFast(new CMcpFuncPositionList());
  g_mcp_server.AddItemFast(new CMcpFuncPositionGet());
  g_mcp_server.AddItemFast(new CMcpFuncPositionClose(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncPositionModify(&g_trade));

//--- Trade / Orders
  g_mcp_server.AddItemFast(new CMcpFuncOrderList());
  g_mcp_server.AddItemFast(new CMcpFuncOrderClose(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncOrderModify(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncOrderGet());

//--- Trade / Deals
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealList());
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealGet());

//--- Trade / Trade
  g_mcp_server.AddItemFast(new CMcpFuncTradeTrade(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncTradeOpenLimit(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncTradeOpenStop(&g_trade));

//--- Complex / Advanced
  g_mcp_server.AddItemFast(new CMcpFunctionRunBacktest());
  g_mcp_server.AddItemFast(new CMcpFunctionRunEA());
  g_mcp_server.AddItemFast(new CMcpFunctionCompile());

//--- Complex / Logs
  g_mcp_server.AddItemFast(new CMcpFunctionExpertLogs());

//--- Uitls
  g_mcp_server.AddItemFast(new CMcpFuncGetTime());
  g_mcp_server.AddItemFast(new CMcpFuncGetErrDescription());
  g_mcp_server.AddItemFast(new CMcpFuncTerminalInfo());
  g_mcp_server.AddItemFast(new CMcpFuncAccountInfo());

//---
  g_mcp_server.Set(InpMsPool, InpMsTimeoutReadNoTls);
  if(!g_mcp_server.Conectar(InpSoketAdres, InpSoketPort, (10 * 1000))) // 10 segundos de espera para conectarse
    return INIT_FAILED;

//---
  return(INIT_SUCCEEDED);
 }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
 {
//---
  if(CheckPointer(g_mcp_server) == POINTER_DYNAMIC)
    delete g_mcp_server;
//---
 }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
 {
//---
 }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(void)
 {
  g_mcp_server.TimerEvent();
 }
//+------------------------------------------------------------------+
