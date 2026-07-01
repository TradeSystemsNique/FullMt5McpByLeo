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
namespace TSN
{
class CMcpFunctionExpertLogs : public CMcpFunction
 {
private:
  CJsonBuilder       m_json_builder;
public:
                     CMcpFunctionExpertLogs(void) : CMcpFunction(0, false, "get_expert_logs") {}
                    ~CMcpFunctionExpertLogs(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionExpertLogs::Run(CJsonNode &param, string &res)
 {
  string str = "";
  if(!ExtractLastLogLines(
       StringToTime(param["start_date"].ToString(TimeToString(TimeCurrent()))),
       int(param["byte_start"].ToInt(3)),
       int(param["byte_counts"].ToInt(100)),
       str
     ))
   {
    res = "{\"ok\":false,\"error\":\"Error obtaining logs from the mt5 terminal\"}";
   }
  else
   {
    m_json_builder.Obj();
    m_json_builder.Key("ok").Val(true);
    m_json_builder.Key("result").ValS(str);
    m_json_builder.EndObj();
   }
 }
//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_LOGS_MQH
