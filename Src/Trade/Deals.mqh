//+------------------------------------------------------------------+
//|                                                        Deals.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH
#define FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//| history_deal_get_total                                           |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGetTotal : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGetTotal() : CMcpFunction(0, false, "history_deal_get_total") {}
                    ~CMcpFuncHistoryDealGetTotal(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGetTotal::Run(CJsonNode& param, string& res)
 {
  const uint total = HistoryDealsTotal();
  res = StringFormat("{\"ok\":true,\"result\":%d}", total);
 }

//+------------------------------------------------------------------+
//| history_deal_get_ticket                                          |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGetTicket : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGetTicket() : CMcpFunction(0, false, "history_deal_get_ticket") {}
                    ~CMcpFuncHistoryDealGetTicket(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGetTicket::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const int index = (int)param["index"].ToInt(0);
  const ulong ticket = HistoryDealGetTicket(index);

  if(ticket == 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"invalid_index, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%lu}", ticket);
 }

//+------------------------------------------------------------------+
//| history_deal_get_double                                          |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGetDouble() : CMcpFunction(0, false, "history_deal_get_double") {}
                    ~CMcpFuncHistoryDealGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGetDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_DOUBLE>(property_str, DEAL_VOLUME);
  const double value = HistoryDealGetDouble(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", value);
 }

//+------------------------------------------------------------------+
//| history_deal_get_integer                                         |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGetInteger() : CMcpFunction(0, false, "history_deal_get_integer") {}
                    ~CMcpFuncHistoryDealGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_INTEGER>(property_str, DEAL_TICKET);
  const long value = HistoryDealGetInteger(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":%ld}", value);
 }

//+------------------------------------------------------------------+
//| history_deal_get_string                                          |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGetString : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGetString() : CMcpFunction(0, false, "history_deal_get_string") {}
                    ~CMcpFuncHistoryDealGetString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGetString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_STRING>(property_str, DEAL_SYMBOL);
  const string value = HistoryDealGetString(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH
