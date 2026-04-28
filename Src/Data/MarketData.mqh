//+------------------------------------------------------------------+
//|                                                     MarketData.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH
#define FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//| copy_open                                                        |
//+------------------------------------------------------------------+
class CMcpFuncCopyOpen : public CMcpFunction
 {
protected:
  double             m_buffer[];
public:
                     CMcpFuncCopyOpen() : CMcpFunction(0, false, "copy_open")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyOpen(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyOpen::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyOpen(symbol, timeframe, start, count, m_buffer);
  const int8_t dig = (int8_t)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_open failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%.*f", dig, m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| copy_high                                                        |
//+------------------------------------------------------------------+
class CMcpFuncCopyHigh : public CMcpFunction
 {
protected:
  double             m_buffer[];
public:
                     CMcpFuncCopyHigh() : CMcpFunction(0, false, "copy_high")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyHigh(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyHigh::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyHigh(symbol, timeframe, start, count, m_buffer);
  const int dig = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_high failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%.*f", dig, m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| copy_low                                                         |
//+------------------------------------------------------------------+
class CMcpFuncCopyLow : public CMcpFunction
 {
protected:
  double             m_buffer[];
public:
                     CMcpFuncCopyLow() : CMcpFunction(0, false, "copy_low")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyLow(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyLow::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyLow(symbol, timeframe, start, count, m_buffer);
  const int8_t dig = (int8_t)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_low failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%.*f", dig, m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| copy_close                                                       |
//+------------------------------------------------------------------+
class CMcpFuncCopyClose : public CMcpFunction
 {
protected:
  double             m_buffer[];
public:
                     CMcpFuncCopyClose() : CMcpFunction(0, false, "copy_close")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyClose(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyClose::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyClose(symbol, timeframe, start, count, m_buffer);
  const int8_t dig = (int8_t)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_close failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%.*f", dig, m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| copy_tick_volume                                                 |
//+------------------------------------------------------------------+
class CMcpFuncCopyTickVolume : public CMcpFunction
 {
protected:
  long               m_buffer[];
public:
                     CMcpFuncCopyTickVolume() : CMcpFunction(0, false, "copy_tick_volume")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyTickVolume(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyTickVolume::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyTickVolume(symbol, timeframe, start, count, m_buffer);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_tick_volume failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%ld", m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
//| copy_real_volume                                                 |
//+------------------------------------------------------------------+
class CMcpFuncCopyRealVolume : public CMcpFunction
 {
protected:
  long               m_buffer[];
public:
                     CMcpFuncCopyRealVolume() : CMcpFunction(0, false, "copy_real_volume")
   {
    ArraySetAsSeries(m_buffer, true);
   }
                    ~CMcpFuncCopyRealVolume(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyRealVolume::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(100);
  const int copied = CopyRealVolume(symbol, timeframe, start, count, m_buffer);

//---
  if(copied != count)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"copy_real_volume failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < copied; i++)
   {
    if(i > 0)
      res += ",";
    res += StringFormat("%ld", m_buffer[i]);
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH
