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
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
//+------------------------------------------------------------------+
//| symbols_total                                                    |
//+------------------------------------------------------------------+
class CMcpFuncSymbolsTotal : public CMcpFunction
 {
public:
                     CMcpFuncSymbolsTotal() : CMcpFunction(0, false, "symbols_total") {}
                    ~CMcpFuncSymbolsTotal(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolsTotal::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int total = SymbolsTotal(param["only_selected_in_market_watch"].ToBool(false));
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Val(total);
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| symbol_select                                                    |
//+------------------------------------------------------------------+
class CMcpFuncSymbolSelect : public CMcpFunction
 {
public:
                     CMcpFuncSymbolSelect() : CMcpFunction(0, false, "symbol_select") {}
                    ~CMcpFuncSymbolSelect(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolSelect::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const bool result = SymbolSelect(param["symbol"].ToString(_Symbol), param["select"].ToBool(true) != 0);

//---
  if(!result)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("symbol_select failed, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Val(true);
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| symbol_info_double                                               |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfo : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfo() : CMcpFunction(0, false, "symbol_info") {}
                    ~CMcpFuncSymbolInfo(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfo::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const string symbol = param["symbol"].ToString(_Symbol);
  const int8_t mode = (int8_t)param["mode"].ToInt(0);

//---
  switch(mode)
   {
    case  0: // DBL
     {
      double value;
      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      if(SymbolInfoDouble(symbol, CEnumRegBasis::GetValNoRef<ENUM_SYMBOL_INFO_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), value))
       {
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(value);
       }
      else
       {
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error call SymbolInfoDouble, mt5 last err = %d", ::GetLastError()));
       }
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    case 1: // INTEGER
     {
      long value;
      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      if(SymbolInfoInteger(symbol, CEnumRegBasis::GetValNoRef<ENUM_SYMBOL_INFO_INTEGER>(param["property"].ToString(""), WRONG_VALUE), value))
       {
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(value);
       }
      else
       {
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Eror call symbolinfointeger, mt5 last err = %d", ::GetLastError()));
       }
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }
    case 2: // STRING
     {
      string value;
      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      if(SymbolInfoString(symbol, CEnumRegBasis::GetValNoRef<ENUM_SYMBOL_INFO_STRING>(param["property"].ToString(""), WRONG_VALUE),  value))
       {
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(value);
       }
      else
       {
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error call SymbolInfoString, mt5 last err = %d", ::GetLastError()));
       }
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
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncSymbolInfoSession : public CMcpFunction
 {
public:
                     CMcpFuncSymbolInfoSession(void) : CMcpFunction(0, false, "symbol_info_session") {}
                    ~CMcpFuncSymbolInfoSession(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncSymbolInfoSession::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const int8_t mode = (int8_t)param["mode"].ToInt(0);
  datetime to, from;
  switch(mode)
   {
    case  0:
     {
      if(!SymbolInfoSessionTrade(param["symbol"].ToString(), CEnumRegBasis::GetValNoRef<ENUM_DAY_OF_WEEK>(param["day_of_week"].ToString(""), WRONG_VALUE), uint(param["session_index"].ToInt(0)), from, to))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error call SymbolInfoSessionTrade, mt5 last err = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    case 1:
     {
      if(!SymbolInfoSessionQuote(param["symbol"].ToString(), CEnumRegBasis::GetValNoRef<ENUM_DAY_OF_WEEK>(param["day_of_week"].ToString(""), WRONG_VALUE), uint(param["session_index"].ToInt(0)), from, to))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error call SymbolInfoSessionQuote, mt5 last err = %d", ::GetLastError()));
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
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Obj();
  m_shared_builder.KeyWV("date_from").ValSWV(TimeToString(from, TIME_DATE | TIME_MINUTES | TIME_SECONDS));
  m_shared_builder.KeyWV("date_to").ValSWV(TimeToString(to, TIME_DATE | TIME_MINUTES | TIME_SECONDS));
  m_shared_builder.EndObj();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }




//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_DATA_SYMBOL_MQH
