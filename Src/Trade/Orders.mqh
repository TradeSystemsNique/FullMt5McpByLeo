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
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
//+------------------------------------------------------------------+
//| order_get_total                                                  |
//+------------------------------------------------------------------+
class CMcpFuncOrderList : public CMcpFunction
 {
public:
                     CMcpFuncOrderList() : CMcpFunction(0, false, "order_list") {}
                    ~CMcpFuncOrderList(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderList::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  const int t = OrdersTotal();
  for(int i = 0; i < t; i++)
   {
    m_shared_builder.Val((long)OrderGetTicket(i));
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
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
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderClose::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  if(!m_trade.OrderDelete(ticket))
   {
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("result").ValSWV(StringFormat("Failed close order with ticket = %I64u, last mt5 err = %d", ticket, ::GetLastError()));
   }
  else
   {
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValSWV("success");
   }
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
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
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderModify::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("order not found, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  if(!m_trade.OrderModify(ticket,
                          param["new_price"].ToDouble(OrderGetDouble(ORDER_PRICE_OPEN)),
                          param["new_sl"].ToDouble(OrderGetDouble(ORDER_SL)),
                          param["new_tp"].ToDouble(OrderGetDouble(ORDER_TP)),
                          CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE_TIME>(param["new_type_time"].ToString(), (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME)),
                          StringToTime(param["new_expiration_time"].ToString(TimeToString(OrderGetInteger(ORDER_TIME_EXPIRATION))))
                         ))
   {
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("result").ValSWV(StringFormat("Failed modify order with ticket = %I64u, last mt5 err = %d", ticket, ::GetLastError()));
   }
  else
   {
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValSWV("success");
   }
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| order_get                                                        |
//+------------------------------------------------------------------+
class CMcpFuncOrderGet : public CMcpFunction
 {
public:
                     CMcpFuncOrderGet() : CMcpFunction(0, false, "order_get") {}
                    ~CMcpFuncOrderGet(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderGet::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("order_not_found, last mt5 error = %d", ::GetLastError()));
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
      if(OrderGetDouble(
           CEnumRegBasis::GetValNoRef<ENUM_ORDER_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE),
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
      if(OrderGetInteger(
           CEnumRegBasis::GetValNoRef<ENUM_ORDER_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE),
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
      if(OrderGetString(
           CEnumRegBasis::GetValNoRef<ENUM_ORDER_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE),
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
  m_shared_builder.KeyWV("error").ValSWV(StringFormat("Failed call OrderGet*, last err mt5 = %d", ::GetLastError()));
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncCalcOrder : public CMcpFunction
 {
private:
  CGetLote           m_get_lote;

public:
                     CMcpFuncCalcOrder() : CMcpFunction(0, false, "calc_order"), m_get_lote("") {}
                    ~CMcpFuncCalcOrder(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCalcOrder::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int8_t mode = CEnumRegFullMt5Mcp::GetValNoRef<int8_t>(param["mode"].ToString(""), WRONG_VALUE);
  const ENUM_ORDER_TYPE type = CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE>(param["order_type"].ToString(""), ORDER_TYPE_CLOSE_BY);

//---
  m_get_lote.SetSymbol(param["symbol"].ToString(""));

//---
  switch(mode)
   {
    //--- CalculateSLWithLot
    case MCPFUNC_CALCORDER_CALCULATE_SL_WITH_LOT:
     {
      long v = m_get_lote.CalculateSLWithLot(
                 param["risk_per_operation"].ToDouble(0.0),
                 param["entry_price"].ToDouble(0.0),
                 param["lot_size"].ToDouble(0.0),
                 (ulong)param["deviation"].ToInt(0),
                 (ulong)param["stop_limit"].ToInt(0)
               );

      if(v <= 0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV("Failed CalculateSLWithLot, check logs");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(v);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    //--- MoneyToPoints
    case MCPFUNC_CALCORDER_MONEY_TO_POINTS:
     {
      double chosen_lot = 0.00;

      long v = m_get_lote.MoneyToPoints(
                 type,
                 param["risk_per_operation"].ToDouble(0.0),
                 param["entry_price"].ToDouble(0.0),
                 chosen_lot,
                 (ulong)param["deviation"].ToInt(0),
                 (ulong)param["stop_limit"].ToInt(0)
               );

      if(v <= 0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV("Failed MoneyToPoints, check logs");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(v);
      m_shared_builder.KeyWV("lot").Val(chosen_lot);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    //--- GetLoteByRiskPerOperationAndSL
    case MCPFUNC_CALCORDER_GET_LOTE_BY_RISK_MONEY_AND_SL_POINTS:
     {
      double new_risk = 0.0;

      double v = m_get_lote.GetLoteByRiskPerOperationAndSL(
                   param["max_lot"].ToDouble(0.0),
                   param["risk_per_operation"].ToDouble(0.0),
                   new_risk,
                   (long)param["sl"].ToInt(0)
                 );

      if(v <= 0.0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV("Failed GetLoteByRiskPerOperationAndSL, check logs");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(v);
      m_shared_builder.KeyWV("risk").Val(new_risk);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    //--- GetMaxLote
    case MCPFUNC_CALCORDER_GET_MAX_LOTE_TO_TRADE:
     {
      double v = m_get_lote.GetMaxLote(
                   type,
                   param["entry_price"].ToDouble(0.0),
                   (ulong)param["deviation"].ToInt(0),
                   (ulong)param["stop_limit"].ToInt(0)
                 );

      if(v <= 0.0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV("Failed GetMaxLote, check logs");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(v);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    //--- GetLoteByRiskPerOperation
    case MCPFUNC_CALCORDER_GET_LOTE_BY_ONLY_RISK_MONEY:
     {
      double v = m_get_lote.GetLoteByRiskPerOperation(
                   type,
                   param["risk_per_operation"].ToDouble(0.0),
                   param["entry_price"].ToDouble(0.0),
                   (ulong)param["deviation"].ToInt(0),
                   (ulong)param["stop_limit"].ToInt(0)
                 );

      if(v <= 0.0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV("Failed GetLoteByRiskPerOperation, check logs");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(v);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %d", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
   }
 }
//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH
