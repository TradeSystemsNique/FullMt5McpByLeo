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
class CMcpFuncSymbolInfoDouble : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfoDouble() : CMcpFunction(0, false, "symbol_info_double") {}
                    ~CMcpFuncSymbolInfoDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfoDouble::Run(CJsonNode& param, string& res)
 {
//---
  const string symbol = param["symbol"].ToString(_Symbol);
  const double value = SymbolInfoDouble(symbol, CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_DOUBLE>(param["property"].ToString(""), SYMBOL_BID));
  const int dig = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
//---
  res = StringFormat("{\"ok\":true,\"result\":%.*f}", dig, value);
 }

//+------------------------------------------------------------------+
//| symbol_info_integer                                              |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfoInteger : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfoInteger() : CMcpFunction(0, false, "symbol_info_integer") {}
                    ~CMcpFuncSymbolInfoInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfoInteger::Run(CJsonNode& param, string& res)
 {
//---
  const long value = SymbolInfoInteger(param["symbol"].ToString(_Symbol), CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_INTEGER>(param["property"].ToString(""), SYMBOL_DIGITS));
//---
  res = StringFormat("{\"ok\":true,\"result\":%ld}", value);
 }

//+------------------------------------------------------------------+
//| symbol_info_string                                               |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfoString : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfoString() : CMcpFunction(0, false, "symbol_info_string") {}
                    ~CMcpFuncSymbolInfoString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfoString::Run(CJsonNode& param, string& res)
 {
//---
  const string value = SymbolInfoString(param["symbol"].ToString(_Symbol), CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_STRING>(param["property"].ToString(""), SYMBOL_DESCRIPTION));
//---
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH
