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
//| position_get_double                                              |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetDouble() : CMcpFunction(0, false, "position_get_double") {}
                    ~CMcpFuncPositionGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetDouble::Run(CJsonNode& param, string& res)
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
  const ENUM_POSITION_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_DOUBLE>(param["property"].ToString(""), POSITION_VOLUME);
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", PositionGetDouble(property));
 }

//+------------------------------------------------------------------+
//| position_get_integer                                             |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetInteger() : CMcpFunction(0, false, "position_get_integer") {}
                    ~CMcpFuncPositionGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_POSITION_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_INTEGER>(param["property"].ToString(""), POSITION_TICKET);
  res = StringFormat("{\"ok\":true,\"result\":%I64d}", PositionGetInteger(property));
 }

//+------------------------------------------------------------------+
//| position_get_string                                              |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetString : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetString() : CMcpFunction(0, false, "position_get_string") {}
                    ~CMcpFuncPositionGetString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_POSITION_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_STRING>(param["property"].ToString(""), POSITION_SYMBOL);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", PositionGetString(property));
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
#endif // FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
