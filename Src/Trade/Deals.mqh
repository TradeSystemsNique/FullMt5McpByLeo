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

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealList::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  if(!HistorySelect(
       StringToTime(param["start_date_select"].ToString("0")),
       StringToTime(param["end_date_select"].ToString(TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS)))
     ))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("Erorr selected positions, last err = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  const int t = HistoryDealsTotal();
  for(int i = 0; i < t; i++)
   {
    m_shared_builder.Val((long)HistoryDealGetTicket(i));
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }


//+------------------------------------------------------------------+
//| history_deal_get                                                 |
//+------------------------------------------------------------------+
class CMcpFuncHistoryDealGet : public CMcpFunction
 {
public:
                     CMcpFuncHistoryDealGet() : CMcpFunction(0, false, "history_deal_get") {}
                    ~CMcpFuncHistoryDealGet(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncHistoryDealGet::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::HistoryDealSelect(ticket))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("deal_not_found, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
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
           CEnumRegBasis::GetValNoRef<ENUM_DEAL_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE),
           v))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(v);
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
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
           CEnumRegBasis::GetValNoRef<ENUM_DEAL_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE),
           v))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(v);
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
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
           CEnumRegBasis::GetValNoRef<ENUM_DEAL_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE),
           v))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(v);
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %d", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(false);
  m_shared_builder.KeyWV("error").ValSWV(StringFormat("Failed to call HistoryDealGet*, last mt5 err = %d", ::GetLastError()));
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }



//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_DEALS_MQH
