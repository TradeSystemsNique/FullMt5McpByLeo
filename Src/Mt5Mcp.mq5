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
//| Include                                                          |
//+------------------------------------------------------------------+
#include "All.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string InpSoketAdres = "127.0.0.1";
input uint InpSoketPort = 9999;
input int InpMsPool = 125;
input int InpMsTimeoutReadNoTls = 10000;

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
CMcpServer g_mcp_server;
CTrade g_trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
 {
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

//--- Data / Symbol
  g_mcp_server.AddItemFast(new CMcpFuncSymbolsTotal());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolSelect());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolInfoDouble());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolInfoInteger());
  g_mcp_server.AddItemFast(new CMcpFuncSymbolInfoString());

//--- Data / Market Data
  g_mcp_server.AddItemFast(new CMcpFuncCopyData());
  g_mcp_server.AddItemFast(new CMcpFuncCopyTicks());

//--- Trade / Positions
  g_mcp_server.AddItemFast(new CMcpFuncPositionList());
  g_mcp_server.AddItemFast(new CMcpFuncPositionGetDouble());
  g_mcp_server.AddItemFast(new CMcpFuncPositionGetInteger());
  g_mcp_server.AddItemFast(new CMcpFuncPositionGetString());
  g_mcp_server.AddItemFast(new CMcpFuncPositionClose(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncPositionModify(&g_trade));

//--- Trade / Orders
  g_mcp_server.AddItemFast(new CMcpFuncOrderList());
  g_mcp_server.AddItemFast(new CMcpFuncOrderClose(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncOrderModify(&g_trade));
  g_mcp_server.AddItemFast(new CMcpFuncOrderGetDouble());
  g_mcp_server.AddItemFast(new CMcpFuncOrderGetInteger());
  g_mcp_server.AddItemFast(new CMcpFuncOrderGetString());

//--- Trade / Deals
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealList());
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealGetDouble());
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealGetInteger());
  g_mcp_server.AddItemFast(new CMcpFuncHistoryDealGetString());

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
