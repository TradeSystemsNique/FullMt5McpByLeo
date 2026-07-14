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
public:
                     CMcpFunctionExpertLogs(void) : CMcpFunction(0, false, "get_expert_logs") {}
                    ~CMcpFunctionExpertLogs(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionExpertLogs::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  uchar data[];
  if(!ExtractLastLogLines(
       StringToTime(param["start_date"].ToString(TimeToString(TimeCurrent()))),
       int(param["byte_start"].ToInt(3)),
       int(param["byte_counts"].ToInt(100)),
       data
     ))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV("Error obtaining logs from the mt5 terminal");
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
  else
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValU(data);
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
 }
//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_LOGS_MQH
