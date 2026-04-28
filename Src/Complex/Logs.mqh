//+------------------------------------------------------------------+
//|                                                         Logs.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_COMPLEX_LOGS_MQH
#define FULLMT5MCPBYLEO_SRC_COMPLEX_LOGS_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "Complex.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFunctionExpertLogs : public CMcpFunction
 {
public:
                     CMcpFunctionExpertLogs(void) : CMcpFunction(0, false, "get_expert_logs") {}
                    ~CMcpFunctionExpertLogs(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionExpertLogs::Run(CJsonNode &param, string &res)
 {
  string log_lines = "";
  if(ExtractLastLogLines(
       StringToTime(param["start_date"].ToString(TimeToString(TimeCurrent()))),
       int(param["logs_lines"].ToInt(10)),
       log_lines
     ))
   {

    res = "\"ok\":false,\"error\":\"Error obtaining logs from the mt5 terminal\"}";
   }
  else
   {
    res = "\"ok\":true,\"result\":\"" + log_lines + "\"}";
   }
 }
//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_LOGS_MQH