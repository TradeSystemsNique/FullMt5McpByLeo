//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict


#ifndef FULLMT5MCPBYLEO_SRC_TRADE_TRADE_MQH
#define FULLMT5MCPBYLEO_SRC_TRADE_TRADE_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
class CMcpFuncTradeTrade : public CMcpFunction
 {
protected:
  CTrade*            m_trade;
public:
                     CMcpFuncTradeTrade(CTrade* tr)
    :                CMcpFunction(0, false, "open_trade"),
                     m_trade(tr)
   {}
                    ~CMcpFuncTradeTrade(void) {}

  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
void               CMcpFuncTradeTrade::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  m_trade.SetExpertMagicNumber(ulong(param["magic"].ToInt(0)));
  const bool result = (param["type"].ToString("") == "buy")
                      ? m_trade.Buy(param["lot_size"].ToDouble(0.00), param["symbol"].ToString(NULL), param["price"].ToDouble(0.000), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), param["comment"].ToString(""))
                      : m_trade.Sell(param["lot_size"].ToDouble(0.00), param["symbol"].ToString(NULL), param["price"].ToDouble(0.000), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), param["comment"].ToString(""));
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  if(!result)
   {
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("trade_failed, last mt5 error = %d", ::GetLastError()));
   }
  else
   {
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").Val((long)m_trade.ResultOrder());
   }
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncTradeOpenLimit : public CMcpFunction
 {
protected:
  CTrade*            m_trade;
public:
                     CMcpFuncTradeOpenLimit(CTrade* tr)
    :                CMcpFunction(0, false, "open_limit"),
                     m_trade(tr)
   {}
                    ~CMcpFuncTradeOpenLimit(void) {}

  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
void               CMcpFuncTradeOpenLimit::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  m_trade.SetExpertMagicNumber(ulong(param["magic"].ToInt(0)));
  const ENUM_ORDER_TYPE_TIME type_time = CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE_TIME>(param["type_time"].ToString(), ORDER_TIME_GTC);
  const datetime expiration = StringToTime(param["time_expiration"].ToString("0"));
  const bool result = (param["type"].ToString("") == "buy")
                      ? m_trade.BuyLimit(param["lot_size"].ToDouble(0.00), param["price"].ToDouble(0.000), param["symbol"].ToString(NULL), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), type_time, expiration, param["comment"].ToString(""))
                      : m_trade.SellLimit(param["lot_size"].ToDouble(0.00), param["price"].ToDouble(0.000), param["symbol"].ToString(NULL), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), type_time, expiration, param["comment"].ToString(""));
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  if(!result)
   {
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("limit_order_failed, last mt5 error = %d", ::GetLastError()));
   }
  else
   {
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").Val((long)m_trade.ResultOrder());
   }
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }
 
//+------------------------------------------------------------------+
//| open_stop                                                        |
//+------------------------------------------------------------------+
class CMcpFuncTradeOpenStop : public CMcpFunction
 {
protected:
  CTrade*            m_trade;
public:
                     CMcpFuncTradeOpenStop(CTrade* tr)
    :                CMcpFunction(0, false, "open_stop"),
                     m_trade(tr)
   {}
                    ~CMcpFuncTradeOpenStop(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncTradeOpenStop::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  m_trade.SetExpertMagicNumber(ulong(param["magic"].ToInt(0)));
  const ENUM_ORDER_TYPE_TIME type_time = CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE_TIME>(param["type_time"].ToString(), ORDER_TIME_GTC);
  const datetime expiration = StringToTime(param["time_expiration"].ToString("0"));
  const bool result = (param["type"].ToString("") == "buy")
                      ? m_trade.BuyStop(param["lot_size"].ToDouble(0.00), param["price"].ToDouble(0.000), param["symbol"].ToString(NULL), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), type_time, expiration, param["comment"].ToString(""))
                      : m_trade.SellStop(param["lot_size"].ToDouble(0.00), param["price"].ToDouble(0.000), param["symbol"].ToString(NULL), param["sl"].ToDouble(0.000), param["tp"].ToDouble(0.0000), type_time, expiration, param["comment"].ToString(""));
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  if(!result)
   {
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("stop_order_failed, last mt5 error = %d", ::GetLastError()));
   }
  else
   {
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").Val((long)m_trade.ResultOrder());
   }
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_TRADE_MQH
