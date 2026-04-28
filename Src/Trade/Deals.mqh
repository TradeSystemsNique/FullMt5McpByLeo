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
class CMcpFuncHistoryDealList : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealList() : CMcpFunction(0, false, "history_deal_list") {}
                    ~CMcpFuncHistoryDealList(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealList::Run(CJsonNode& param, string& res)
 {
//---
  if(!HistorySelect(
       StringToTime(param["start_date_select"].ToString("0")),
       StringToTime(param["end_date_select"].ToString(TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS)))
     ))
   {
    res = StringFormat("{\"ok\":true,\"result\":\"Erorr selected positions, last err = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  const int t = HistoryDealsTotal();
  for(int i = 0; i < t; i++)
   {
    if(i == t - 1)
      res += string(HistoryDealGetTicket(i));
    else
      res += string(HistoryDealGetTicket(i)) + ",";
   }
  res += "]}";
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

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_DOUBLE>(param["property"].ToString(""), DEAL_VOLUME);
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

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_INTEGER>(param["property"].ToString(""), DEAL_TICKET);
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

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal not found in history, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_DEAL_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_STRING>(param["property"].ToString(""), DEAL_SYMBOL);
  const string value = HistoryDealGetString(ticket, property);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH
