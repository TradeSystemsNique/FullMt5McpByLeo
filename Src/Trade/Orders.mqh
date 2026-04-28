//+------------------------------------------------------------------+
//|                                                       Orders.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH
#define FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//| order_get_total                                                  |
//+------------------------------------------------------------------+
class CMcpFuncOrderList : public CMcpFunction
 {
public:
                     CMcpFuncOrderList() : CMcpFunction(0, false, "order_list") {}
                    ~CMcpFuncOrderList(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderList::Run(CJsonNode& param, string& res)
 {
  res = "{\"ok\":true,\"result\":[";
  const int t = OrdersTotal();
  for(int i = 0; i < t; i++)
   {
    if(i == t - 1)
      res += string(OrderGetTicket(i));
    else
      res += string(OrderGetTicket(i)) + ",";
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncOrderClose : public CMcpFunction
 {
private:
  CTrade*            m_trade;
public:
                     CMcpFuncOrderClose(CTrade* tr) : CMcpFunction(0, false, "order_close"), m_trade(tr) {}
                    ~CMcpFuncOrderClose(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderClose::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  if(!m_trade.OrderDelete(ticket))
   {
    res = StringFormat("{\"ok\":false,\"result\":\"Failed close order with ticket = %I64u, last mt5 err = %d\"}", ticket, ::GetLastError());
   }
  else
   {
    res = "{\"ok\":true,\"result\":\"success\"}";
   }
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncOrderModify : public CMcpFunction
 {
private:
  CTrade*            m_trade;
public:
                     CMcpFuncOrderModify(CTrade* tr) : CMcpFunction(0, false, "order_modify"), m_trade(tr) {}
                    ~CMcpFuncOrderModify(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderModify::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  if(!m_trade.OrderModify(ticket,
                          param["new_price"].ToDouble(OrderGetDouble(ORDER_PRICE_OPEN)),
                          param["new_sl"].ToDouble(OrderGetDouble(ORDER_SL)),
                          param["new_tp"].ToDouble(OrderGetDouble(ORDER_TP)),
                          CEnumReg::GetValueNoRef<ENUM_ORDER_TYPE_TIME>(param["new_type_time"].ToString(), (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME)),
                          StringToTime(param["new_expiration_time"].ToString(TimeToString(OrderGetInteger(ORDER_TIME_EXPIRATION))))
                         ))
   {
    res = StringFormat("{\"ok\":false,\"result\":\"Failed modify order with ticket = %I64u, last mt5 err = %d\"}", ticket, ::GetLastError());
   }
  else
   {
    res = "{\"ok\":true,\"result\":\"success\"}";
   }
 }


//+------------------------------------------------------------------+
//| order_get_double                                                 |
//+------------------------------------------------------------------+
class CMcpFuncOrderGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncOrderGetDouble() : CMcpFunction(0, false, "order_get_double") {}
                    ~CMcpFuncOrderGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderGetDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_DOUBLE>(param["property"].ToString(""), ORDER_VOLUME_INITIAL);
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", OrderGetDouble(property));
 }

//+------------------------------------------------------------------+
//| order_get_integer                                                |
//+------------------------------------------------------------------+
class CMcpFuncOrderGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncOrderGetInteger() : CMcpFunction(0, false, "order_get_integer") {}
                    ~CMcpFuncOrderGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_INTEGER>(param["property"].ToString(""), ORDER_TICKET);
  res = StringFormat("{\"ok\":true,\"result\":%ld}", OrderGetInteger(property));
 }

//+------------------------------------------------------------------+
//| order_get_string                                                 |
//+------------------------------------------------------------------+
class CMcpFuncOrderGetString : public CMcpFunction
 {
public:
                     CMcpFuncOrderGetString() : CMcpFunction(0, false, "order_get_string") {}
                    ~CMcpFuncOrderGetString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderGetString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_STRING>(param["property"].ToString(""), ORDER_SYMBOL);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", OrderGetString(property));
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH
