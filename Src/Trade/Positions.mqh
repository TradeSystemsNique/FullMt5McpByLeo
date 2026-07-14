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

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionList::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  const int t = PositionsTotal();
  for(int i = 0; i < t; i++)
   {
    m_shared_builder.Val((long)PositionGetTicket(i));
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| position_get                                                     |
//+------------------------------------------------------------------+
class CMcpFuncPositionGet : public CMcpFunction
 {
public:
                     CMcpFuncPositionGet() : CMcpFunction(0, false, "position_get") {}
                    ~CMcpFuncPositionGet(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGet::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_not_found, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
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

    //---
    case 1:
     {
      long v;
      if(PositionGetInteger(CEnumRegBasis::GetValNoRef<ENUM_POSITION_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), v))
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

    //---
    case 2:
     {
      string v;
      if(PositionGetString(CEnumRegBasis::GetValNoRef<ENUM_POSITION_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), v))
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
  m_shared_builder.KeyWV("error").ValSWV(StringFormat("Failed to call PositionGet*, last err mt5 = %d", ::GetLastError()));
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
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

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
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
void CMcpFuncPositionClose::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
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
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_close by_symbol failed (partial), last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
     }
    else
     {
      if(!m_trade.PositionClose(param["value"].ToString(""), deviation))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_close by_symbol failed, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
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
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_close by_ticket (partial) failed, last mt5 error = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
          return;
         }
       }
      else
       {
        if(!m_trade.PositionClose(ulong(param["value"].ToInt(0)), deviation))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_close by_ticket failed, last mt5 error = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
          return;
         }
       }
     }
    else
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV("invalid type, use 'by_symbol' or 'by_ticket'");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").ValSWV("success");
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
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

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionModify::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!PositionSelectByTicket(ticket))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("result").ValSWV(StringFormat("Error select ticket, last mt5 err = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  if(!m_trade.PositionModify(ticket, param["sl"].ToDouble(PositionGetDouble(POSITION_SL)), param["tp"].ToDouble(PositionGetDouble(POSITION_TP))))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("position_modify failed, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").ValSWV("success");
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
