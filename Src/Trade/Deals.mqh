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
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
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
    res = StringFormat("{\"ok\":true,\"error\":\"Erorr selected positions, last err = %d\"}", ::GetLastError());
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
//| history_deal_get                                                 |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGet : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGet() : CMcpFunction(0, false, "history_deal_get") {}
                    ~CMcpFuncHistoryDealGet(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGet::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::HistoryDealSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"deal_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const int8_t mode = (int8_t)param["mode"].ToInt(0);

  switch(mode)
   {
    //--- DOUBLE
    case 0:
     {
      double v;
      if(HistoryDealGetDouble(
           ticket,
           CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE),
           v))
       {
        res = StringFormat("{\"ok\":true,\"result\":%.8f}", v);
        return;
       }
      break;
     }

    //--- INTEGER
    case 1:
     {
      long v;
      if(HistoryDealGetInteger(
           ticket,
           CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE),
           v))
       {
        res = StringFormat("{\"ok\":true,\"result\":%I64d}", v);
        return;
       }
      break;
     }

    //--- STRING
    case 2:
     {
      string v;
      if(HistoryDealGetString(
           ticket,
           CEnumReg::GetValueNoRef<ENUM_DEAL_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE),
           v))
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
  res = StringFormat("{\"ok\":false,\"error\":\"Failed to call HistoryDealGet*, last mt5 err = %d\"}", ::GetLastError());
 }



//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH
