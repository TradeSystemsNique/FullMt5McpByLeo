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
  const int total = SymbolsTotal(false);
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
  const string symbol = param["symbol"].ToString(_Symbol);
  const bool select = param["select"].ToBool(true) != 0;

//---
  const bool result = SymbolSelect(symbol, select);

//---
  if(!result)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"symbol_select failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%s}", result ? "true" : "false");
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
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const string property_str = param["property"].ToString("");
  const ENUM_SYMBOL_INFO_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_DOUBLE>(property_str, SYMBOL_BID);
  const double value = SymbolInfoDouble(symbol, property);
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
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const string property_str = param["property"].ToString("");
  const ENUM_SYMBOL_INFO_INTEGER property = CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_INTEGER>(property_str, SYMBOL_DIGITS);
  const long value = SymbolInfoInteger(symbol, property);

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
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const string property_str = param["property"].ToString("");
  const ENUM_SYMBOL_INFO_STRING property = CEnumReg::GetValueNoRef<ENUM_SYMBOL_INFO_STRING>(property_str, SYMBOL_DESCRIPTION);
  const string value = SymbolInfoString(symbol, property);

//---
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH
