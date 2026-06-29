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
                          CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE_TIME>(param["new_type_time"].ToString(), (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME)),
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
//| order_get                                                        |
//+------------------------------------------------------------------+
class CMcpFuncOrderGet : public CMcpFunction
 {
public:
                     CMcpFuncOrderGet() : CMcpFunction(0, false, "order_get") {}
                    ~CMcpFuncOrderGet(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncOrderGet::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = (ulong)param["ticket"].ToInt(0);

//---
  if(!::OrderSelect(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"order_not_found, last mt5 error = %d\"}", ::GetLastError());
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
        res = StringFormat("{\"ok\":true,\"result\":%.8f}", v);
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
        res = StringFormat("{\"ok\":true,\"result\":%I64d}", v);
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
  res = StringFormat("{\"ok\":false,\"error\":\"Failed call OrderGet*, last err mt5 = %d\"}", ::GetLastError());
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

  void               Run(CJsonNode& param, string& res) override final;
 };
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCalcOrder::Run(CJsonNode &param, string &res)
 {
//---
  const int8_t mode = (int8_t)param["mode"].ToInt(0);
  const ENUM_ORDER_TYPE type = CEnumRegBasis::GetValNoRef<ENUM_ORDER_TYPE>(param["order_type"].ToString(""), ORDER_TYPE_CLOSE_BY); // ORDER_TYPE_CLOSE_BY=wrong_value

  m_get_lote.SetSymbol(param["symbol"].ToString(""));

//---
  switch(mode)
   {
    //--- CalculateSLWithLot
    case 0:
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
        res = "{\"ok\":false,\"error\":\"Failed CalculateSLWithLot, check logs\"}";
        return;
       }

      res = StringFormat("{\"ok\":true,\"result\":%I64d}", v);
      break;
     }

    //--- MoneyToPoints
    case 1:
     {
      double chosen_lot=0.00;

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
        res = "{\"ok\":false,\"error\":\"Failed MoneyToPoints, check logs\"}";
        return;
       }

      res = StringFormat("{\"ok\":true,\"result\":%I64d,\"lot\":%.2f}", v, chosen_lot);
      break;
     }

    //--- GetLoteByRiskPerOperationAndSL
    case 2:
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
        res = "{\"ok\":false,\"error\":\"Failed GetLoteByRiskPerOperationAndSL, check logs\"}";
        return;
       }

      res = StringFormat("{\"ok\":true,\"result\":%.2f,\"risk\":%.2f}", v, new_risk);
      break;
     }

    //--- GetMaxLote
    case 3:
     {
      double v = m_get_lote.GetMaxLote(
                   type,
                   param["entry_price"].ToDouble(0.0),
                   (ulong)param["deviation"].ToInt(0),
                   (ulong)param["stop_limit"].ToInt(0)
                 );

      if(v <= 0.0)
       {
        res = "{\"ok\":false,\"error\":\"Failed GetMaxLote, check logs\"}";
        return;
       }

      res = StringFormat("{\"ok\":true,\"result\":%.2f}", v);
      break;
     }

    //--- GetLoteByRiskPerOperation
    case 4:
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
        res = "{\"ok\":false,\"error\":\"Failed GetLoteByRiskPerOperation, check logs\"}";
        return;
       }

      res = StringFormat("{\"ok\":true,\"result\":%.2f}", v);
      break;
     }

    default:
      res = StringFormat("{\"ok\":false,\"error\":\"Invalid mode = %d\"}", mode);
      break;
   }
 }
//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_TRADE_ORDERS_MQH
