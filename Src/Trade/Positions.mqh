//+------------------------------------------------------------------+
//|                                                    Positions.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
#define FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
//+------------------------------------------------------------------+
//| position_list                                                    |
//+------------------------------------------------------------------+
class CMcpFuncPositionList : public CMcpFunction
 {
public:
                     CMcpFuncPositionList() : CMcpFunction(0, false, "position_list") {}
                    ~CMcpFuncPositionList(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionList::Run(CJsonNode& param, string& res)
 {
  res = "{\"ok\":true,\"result\":[";
  const int t = PositionsTotal();
  for(int i = 0; i < t; i++)
   {
    if(i == t - 1)
      res += string(PositionGetTicket(i));
    else
      res += string(PositionGetTicket(i)) + ",";
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| position_get                                                     |
//+------------------------------------------------------------------+
class CMcpFuncPositionGet : public CMcpFunction
 {
public:
                     CMcpFuncPositionGet() : CMcpFunction(0, false, "position_get") {}
                    ~CMcpFuncPositionGet(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGet::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const int8_t mode = (int8_t)param["mode"].ToInt(0);
  switch(mode)
   {

    //---
    case 0:
     {
      double v;
      if(PositionGetDouble(CEnumRegBasis::GetValNoRef<ENUM_POSITION_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), v))
       {
        res = StringFormat("{\"ok\":true,\"result\":%.8f}", v);
        return;
       }
      break;
     }

    //---
    case 1:
     {
      long v;
      if(PositionGetInteger(CEnumRegBasis::GetValNoRef<ENUM_POSITION_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), v))
       {
        res = StringFormat("{\"ok\":true,\"result\":%I64d}", v);
        return;
       }
      break;
     }

    //---
    case 2:
     {
      string v;
      if(PositionGetString(CEnumRegBasis::GetValNoRef<ENUM_POSITION_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), v))
       {
        res = "{\"ok\":true,\"result\":\"" + v + "\"}";
        return;
       }
      break;
     }

    default:
      res = StringFormat("{\"ok\":false,\"error\":\"Invalid mode = %d\"}", mode);
      return;
   }


//---
  res = StringFormat("{\"ok\":false,\"error\":\"Failed to call PositionGet*, last err mt5 = %d\"}", ::GetLastError());
 }

 
//+------------------------------------------------------------------+
//| position_close                                                   |
//+------------------------------------------------------------------+
class CMcpFuncPositionClose : public CMcpFunction
 {
private:
  CTrade*            m_trade;
public:
                     CMcpFuncPositionClose(CTrade* tr) : CMcpFunction(0, false, "position_close"), m_trade(tr) {}
                    ~CMcpFuncPositionClose(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//---
/*
{
"type": "by_symbol",
"value": "XAUUSD",
"deviation": 100
"volume" : 0.01 // Campo opcional (si no se indica se cierra todo)
}
*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionClose::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string type = param["type"].ToString("by_ticket");
  const ulong deviation = (ulong)param["deviation"].ToInt(ULONG_MAX);

//---
  if(type == "by_symbol")
   {
    if(param.HasKey("volume"))
     {
      if(!m_trade.PositionClosePartial(param["value"].ToString(""), param["volume"].ToDouble(0.00), deviation))
       {
        res = StringFormat("{\"ok\":false,\"error\":\"position_close by_symbol failed (partial), last mt5 error = %d\"}", ::GetLastError());
        return;
       }
     }
    else
     {
      if(!m_trade.PositionClose(param["value"].ToString(""), deviation))
       {
        res = StringFormat("{\"ok\":false,\"error\":\"position_close by_symbol failed, last mt5 error = %d\"}", ::GetLastError());
        return;
       }
     }
   }
  else
    if(type == "by_ticket")
     {
      if(param.HasKey("volume"))
       {
        if(!m_trade.PositionClosePartial(ulong(param["value"].ToInt(0)), param["volume"].ToDouble(0.00), deviation))
         {
          res = StringFormat("{\"ok\":false,\"error\":\"position_close by_ticket (partial) failed, last mt5 error = %d\"}", ::GetLastError());
          return;
         }
       }
      else
       {
        if(!m_trade.PositionClose(ulong(param["value"].ToInt(0)), deviation))
         {
          res = StringFormat("{\"ok\":false,\"error\":\"position_close by_ticket failed, last mt5 error = %d\"}", ::GetLastError());
          return;
         }
       }
     }
    else
     {
      res = "{\"ok\":false,\"error\":\"invalid type, use 'by_symbol' or 'by_ticket'\"}";
      return;
     }

//---
  res = "{\"ok\":true,\"result\":\"success\"}";
 }

//+------------------------------------------------------------------+
//| position_modify                                                  |
//+------------------------------------------------------------------+
class CMcpFuncPositionModify : public CMcpFunction
 {
private:
  CTrade*            m_trade;
public:
                     CMcpFuncPositionModify(CTrade* tr) : CMcpFunction(0, false, "position_modify"), m_trade(tr) {}
                    ~CMcpFuncPositionModify(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionModify::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"result\":\"Error select ticket, last mt5 err = %d\"}", ::GetLastError());
    return;
   }

//---
  if(!m_trade.PositionModify(ticket, param["sl"].ToDouble(PositionGetDouble(POSITION_SL)), param["tp"].ToDouble(PositionGetDouble(POSITION_TP))))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_modify failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = "{\"ok\":true,\"result\":\"success\"}";
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
