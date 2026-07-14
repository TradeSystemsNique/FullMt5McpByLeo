//+------------------------------------------------------------------+
//|                                                       Mt5Mcp.mq5 |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property version   "1.00"
#property strict
#property description "MCP Server: remote MT5 control (trading, data, charts) from AI via MCP"
#property icon "Logo-Empresa-Nique.ico"

//+------------------------------------------------------------------+
//| Defines                                                          |
//+------------------------------------------------------------------+
#define PUBLIC_VERSION

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "Src\\All.mqh"
#include "Src\\Secrets.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
sinput group "--- FullMt5McpByLeoConfig ---"
input string InpTbpUserId=THE_BOT_PLACE_USER_ID; // Enter your TBP account ID here:
input string InpSoketAdres = "127.0.0.1"; // Socket adrres
input uint InpSoketPort = 9999;  // Socket port
input int InpMsPool = 70; // Pool ms
input int InpMsTimeoutReadNoTls = 10000; // Timeout for read (No-TLS Connections)
input int InpPowerShellCommands=0; // Permit power shell commands ? [0=no, 2=restricted, 1=all signed, 3+=all commands]

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
TSN::IMcpBase* g_mcp_server;
CTrade g_trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
 {
//---
#ifdef TSN_MCPSERVER_FUNC_CTS
  g_mcp_server = TSN_MCPSERVER_FUNC_CTS(InpTbpUserId);
#else
  g_mcp_server = McpServerByLeo_Create(InpTbpUserId);
#endif // TSN_MCPSERVER_FUNC_CTS

//---
  ::EventSetMillisecondTimer(InpMsPool);
  g_mcp_server.AddLogFlags(LOG_ALL);

//--- Graphics / Objects
  g_mcp_server.AddItemFast(new TSN::CMcpFuncObjectCreate());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncObjectDelete());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncObjectSetGet());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncObjectList());

//--- Charts
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartList());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartOpen());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartClose());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartSetGet());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartNavigate());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartInd());

  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartRedraw());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartSrenshot());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncChartGetSymbolOrPeriod());

//--- Indicators
  g_mcp_server.AddItemFast(new TSN::CMcpFuncInd());

//---
  g_mcp_server.AddItemFast(new TSN::CMcpFuncRunCommand(InpPowerShellCommands));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncTesterRep());


//--- Data / Symbol
  g_mcp_server.AddItemFast(new TSN::CMcpFuncSymbolsTotal());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncSymbolSelect());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncSymbolInfo());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncSymbolInfoSession());


//--- Data / Market Data
  g_mcp_server.AddItemFast(new TSN::CMcpFuncCopyData());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncCopyTicks());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncBarShift());

//--- Calc order
  g_mcp_server.AddItemFast(new TSN::CMcpFuncCalcOrder());

//--- Trade / Positions
  g_mcp_server.AddItemFast(new TSN::CMcpFuncPositionList());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncPositionGet());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncPositionClose(&g_trade));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncPositionModify(&g_trade));

//--- Trade / Orders
  g_mcp_server.AddItemFast(new TSN::CMcpFuncOrderList());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncOrderClose(&g_trade));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncOrderModify(&g_trade));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncOrderGet());

//--- Trade / Deals
  g_mcp_server.AddItemFast(new TSN::CMcpFuncHistoryDealList());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncHistoryDealGet());

//--- Trade / Trade
  g_mcp_server.AddItemFast(new TSN::CMcpFuncTradeTrade(&g_trade));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncTradeOpenLimit(&g_trade));
  g_mcp_server.AddItemFast(new TSN::CMcpFuncTradeOpenStop(&g_trade));

//--- Complex / Advanced
  g_mcp_server.AddItemFast(new TSN::CMcpFunctionRunBacktest());
  g_mcp_server.AddItemFast(new TSN::CMcpFunctionRunEA());
  g_mcp_server.AddItemFast(new TSN::CMcpFunctionCompile());

//--- Complex / Logs
  g_mcp_server.AddItemFast(new TSN::CMcpFunctionExpertLogs());

//--- Uitls
  g_mcp_server.AddItemFast(new TSN::CMcpFuncGetTime());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncGetErrDescription());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncTerminalInfo());
  g_mcp_server.AddItemFast(new TSN::CMcpFuncAccountInfo());

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

