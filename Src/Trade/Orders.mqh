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
//| history_order_get_total                                          |
//+------------------------------------------------------------------+
class CMcpFuncHistoryOrderGetTotal : public CMcpFunction
 {
public:
                     CMcpFuncHistoryOrderGetTotal() : CMcpFunction(0, false, "history_order_get_total") {}
                    ~CMcpFuncHistoryOrderGetTotal(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryOrderGetTotal::Run(CJsonNode& param, string& res)
 {
  const uint total = HistoryOrdersTotal();
  res = StringFormat("{\"ok\":true,\"result\":%d}", total);
 }

//+------------------------------------------------------------------+
//| history_order_get_ticket                                         |
//+------------------------------------------------------------------+
class CMcpFuncHistoryOrderGetTicket : public CMcpFunction
 {
public:
                     CMcpFuncHistoryOrderGetTicket() : CMcpFunction(0, false, "history_order_get_ticket") {}
                    ~CMcpFuncHistoryOrderGetTicket(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryOrderGetTicket::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const int index = (int)param["index"].ToInt(0);
  const ulong ticket = HistoryOrderGetTicket(index);

//---
  if(ticket == 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"invalid_index, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = StringFormat("{\"ok\":true,\"result\":%lu}", ticket);
 }

//+------------------------------------------------------------------+
//| history_order_get_double                                         |
//+------------------------------------------------------------------+
class CMcpFuncHistoryOrderGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncHistoryOrderGetDouble() : CMcpFunction(0, false, "history_order_get_double") {}
                    ~CMcpFuncHistoryOrderGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryOrderGetDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!::HistoryOrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_DOUBLE>(property_str, ORDER_VOLUME_INITIAL);
  const double value = HistoryOrderGetDouble(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", value);
 }

//+------------------------------------------------------------------+
//| history_order_get_integer                                        |
//+------------------------------------------------------------------+
class CMcpFuncHistoryOrderGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncHistoryOrderGetInteger() : CMcpFunction(0, false, "history_order_get_integer") {}
                    ~CMcpFuncHistoryOrderGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryOrderGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!::HistoryOrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_INTEGER>(property_str, ORDER_TICKET);
  const long value = HistoryOrderGetInteger(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":%ld}", value);
 }

//+------------------------------------------------------------------+
//| history_order_get_string                                         |
//+------------------------------------------------------------------+
class CMcpFuncHistoryOrderGetString : public CMcpFunction
 {
public:
                     CMcpFuncHistoryOrderGetString() : CMcpFunction(0, false, "history_order_get_string") {}
                    ~CMcpFuncHistoryOrderGetString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryOrderGetString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");
  
//---
  if(!::HistoryOrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_ORDER_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_ORDER_PROPERTY_STRING>(property_str, ORDER_SYMBOL);
  const string value = HistoryOrderGetString(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH
