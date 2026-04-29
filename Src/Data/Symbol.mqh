//+------------------------------------------------------------------+
//|                                                        Symbol.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH
#define FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//| symbols_total                                                    |
//+------------------------------------------------------------------+
class CMcpFuncSymbolsTotal : public CMcpFunction
 {
public:
                     CMcpFuncSymbolsTotal() : CMcpFunction(0, false, "symbols_total") {}
                    ~CMcpFuncSymbolsTotal(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolsTotal::Run(CJsonNode& param, string& res)
 {
  const int total = SymbolsTotal(param["only_selected_in_market_watch"].ToBool(false));
  res = StringFormat("{\"ok\":true,\"result\":%d}", total);
 }

//+------------------------------------------------------------------+
//| symbol_select                                                    |
//+------------------------------------------------------------------+
class CMcpFuncSymbolSelect : public CMcpFunction
 {
public:
                     CMcpFuncSymbolSelect() : CMcpFunction(0, false, "symbol_select") {}
                    ~CMcpFuncSymbolSelect(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolSelect::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const bool result = SymbolSelect(param["symbol"].ToString(_Symbol), param["select"].ToBool(true) != 0);

//---
  if(!result)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"symbol_select failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }
  res = "{\"ok\":true,\"result\":true}";
 }

//+------------------------------------------------------------------+
//| symbol_info_double                                               |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfo : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfo() : CMcpFunction(0, false, "symbol_info") {}
                    ~CMcpFuncSymbolInfo(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfo::Run(CJsonNode& param, string& res)
 {
//---
  const string symbol = param["symbol"].ToString(_Symbol);
  const int8_t mode = (int8_t)param["mode"].ToInt();

//---
  switch(mode)
   {
    case  0: // DBL
     {
      double value;
      const int dig = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
      //---
      res = SymbolInfoDouble(symbol, CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), value)
            ? StringFormat("{\"ok\":true,\"result\":%.*f}", dig, value)
            : StringFormat("{\"ok\":false,\"error\":\"Error call SymbolInfoDouble, mt5 last err = %d\"}", ::GetLastError());
      break;
     }

    case 1: // INTEGER
     {
      long value;
      //---
      res = SymbolInfoInteger(symbol, CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_INTEGER>(param["property"].ToString(""), WRONG_VALUE), value) ?
            StringFormat("{\"ok\":true,\"result\":%I64d}", value) : StringFormat("{\"ok\":false,\"error\":\"Eror call symbolinfointeger, mt5 last err = %d\"}", ::GetLastError());
      break;
     }
    case 2: // STRING
     {
      string value;
      //---
      res = SymbolInfoString(symbol, CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_STRING>(param["property"].ToString(""), WRONG_VALUE),  value)
            ? StringFormat("{\"ok\":true,\"result\":\"%s\"}", value)
            : StringFormat("{\"ok\":false,\"error\":\"Error call SymbolInfoString, mt5 last err = %d\"}", ::GetLastError());
      break;
     }
    default:
      res = StringFormat("{\"ok\":false,\"error\":\"Invalid mode = %d\"}", mode);
      break;
   }
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfoSession : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfoSession(void) : CMcpFunction(0, false, "symbol_info_session") {}
                    ~CMcpFuncSymbolInfoSession(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfoSession::Run(CJsonNode &param, string &res)
 {
  ::ResetLastError();
  const int8_t mode = (int8_t)param["mode"].ToInt();
  datetime to, from;
  switch(mode)
   {
    case  0:
     {
      if(!SymbolInfoSessionTrade(param["symbol"].ToString(), CEnumReg::GetValueNoRef<ENUM_DAY_OF_WEEK>(param["day_of_week"].ToString(""), WRONG_VALUE), uint(param["session_index"].ToInt()), from, to))
       {
        res = StringFormat("{\"ok\":false,\"error\":\"Error call SymbolInfoSessionTrade, mt5 last err = %d\"}", ::GetLastError());
        return;
       }
      break;
     }

    case 1:
     {
      if(!SymbolInfoSessionQuote(param["symbol"].ToString(), CEnumReg::GetValueNoRef<ENUM_DAY_OF_WEEK>(param["day_of_week"].ToString(""), WRONG_VALUE), uint(param["session_index"].ToInt()), from, to))
       {
        res = StringFormat("{\"ok\":false,\"error\":\"Error call SymbolInfoSessionQuote, mt5 last err = %d\"}", ::GetLastError());
        return;
       }
      break;
     }
    default:
      res = StringFormat("{\"ok\":false,\"error\":\"Invalid mode = %d\"}", mode);
      return;
   }
  res = StringFormat("{\"ok\":true,\"result\":{\"date_from\":\"%s\",\"date_to\":\"%s\"}}", TimeToString(from, TIME_DATE | TIME_MINUTES | TIME_SECONDS), TimeToString(to, TIME_DATE | TIME_MINUTES | TIME_SECONDS));
 }




//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH
