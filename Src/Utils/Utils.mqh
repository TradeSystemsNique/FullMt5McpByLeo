//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_UTILS_UTILS_MQH
#define FULLMT5MCPBYLEO_SRC_UTILS_UTILS_MQH


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
//| CMcpFuncGetTime - Obtiene diferentes tipos de tiempo             |
//+------------------------------------------------------------------+
class CMcpFuncGetTime : public CMcpFunction
 {
public:
                     CMcpFuncGetTime(void);
                    ~CMcpFuncGetTime(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMcpFuncGetTime::CMcpFuncGetTime(void) : CMcpFunction(0, false, "get_time")
 {
 }

//+------------------------------------------------------------------+
//| Run - Retorna el tiempo solicitado en múltiples formatos         |
//+------------------------------------------------------------------+
void CMcpFuncGetTime::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder; // confimamos que usamos el mismo.. este es el que usamos
  const int8_t type = int8_t(CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_TYPE_TIME>(param["type"].ToString(), WRONG_VALUE));

//---
  datetime time = 0;
  switch(type)
   {
    case MCPFUNC_TIME_GMT:
      time = TimeGMT();
      break;
    case MCPFUNC_TIME_CURRENT:
      time = TimeCurrent();
      break;
    case MCPFUNC_TIME_LOCAL:
      time = TimeLocal();
      break;
    case MCPFUNC_TIME_SERVER:
      time = TimeTradeServer();
      break;
    default:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid type = %s", EnumToString(ENUM_MCPFUNC_TYPE_TIME(type))));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").ValSWV(TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS));
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }


//+------------------------------------------------------------------+
//| CMcpFuncGetErrDescription - Obtiene descripción de errores       |
//+------------------------------------------------------------------+
class CMcpFuncGetErrDescription : public CMcpFunction
 {
public:
                     CMcpFuncGetErrDescription(void);
                    ~CMcpFuncGetErrDescription(void);

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMcpFuncGetErrDescription::CMcpFuncGetErrDescription(void) : CMcpFunction(0, false, "get_err_description")
 {
 }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMcpFuncGetErrDescription::~CMcpFuncGetErrDescription(void)
 {
 }


//+------------------------------------------------------------------+
//| Run - Retorna descripción de error MT5                           |
//+------------------------------------------------------------------+
void CMcpFuncGetErrDescription::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int error_code = (int)param["error_code"].ToInt(-1);
  const bool include_code = param["include_code"].ToBool(true);

//---
  string err = "";

//---
  CMt5ErrorDesc::GetError(err, error_code, include_code);

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").ValS(err);
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| account_info                                                     |
//+------------------------------------------------------------------+
class CMcpFuncAccountInfo : public CMcpFunction
 {
public:
                     CMcpFuncAccountInfo() : CMcpFunction(0, false, "account_info") {}
                    ~CMcpFuncAccountInfo(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncAccountInfo::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int8_t mode = (int8_t)param["mode"].ToInt(0);

//---
  switch(mode)
   {
    //--- DOUBLE
    case 0:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(AccountInfoDouble(CEnumRegBasis::GetValNoRef<ENUM_ACCOUNT_INFO_DOUBLE>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    //--- INTEGER
    case 1:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val((long)AccountInfoInteger(CEnumRegBasis::GetValNoRef<ENUM_ACCOUNT_INFO_INTEGER>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    //--- STRING
    case 2:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").ValS(AccountInfoString(CEnumRegBasis::GetValNoRef<ENUM_ACCOUNT_INFO_STRING>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    default:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %d", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }
   }
 }

//+------------------------------------------------------------------+
//| terminal_info                                                    |
//+------------------------------------------------------------------+
class CMcpFuncTerminalInfo : public CMcpFunction
 {
public:
                     CMcpFuncTerminalInfo() : CMcpFunction(0, false, "terminal_info") {}
                    ~CMcpFuncTerminalInfo(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncTerminalInfo::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int8_t mode = (int8_t)param["mode"].ToInt(0);

//---
  switch(mode)
   {
    //--- DOUBLE
    case 0:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(TerminalInfoDouble(CEnumRegBasis::GetValNoRef<ENUM_TERMINAL_INFO_DOUBLE>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    //--- INTEGER
    case 1:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val((long)TerminalInfoInteger(CEnumRegBasis::GetValNoRef<ENUM_TERMINAL_INFO_INTEGER>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    //--- STRING
    case 2:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").ValS(TerminalInfoString(CEnumRegBasis::GetValNoRef<ENUM_TERMINAL_INFO_STRING>(param["property"].ToString(""), WRONG_VALUE)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }

    default:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %d", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }
   }
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_UTILS_UTILS_MQH
