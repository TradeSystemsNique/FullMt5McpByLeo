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
//| CMcpFuncGetTime - Obtiene diferentes tipos de tiempo             |
//+------------------------------------------------------------------+
class CMcpFuncGetTime : public CMcpFunction
 {
public:
                     CMcpFuncGetTime(void);
                    ~CMcpFuncGetTime(void) {}

  void               Run(CJsonNode& param, string& res) override final;
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
void CMcpFuncGetTime::Run(CJsonNode& param, string& res)
 {
//---
  const int8_t type = int8_t(CEnumReg::GetValueNoRef<ENUM_MCPFUNC_TYPE_TIME>(param["type"].ToString(), WRONG_VALUE));

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
      res = StringFormat("{\"ok\":false,\"error\":\"Invalid time type = %s\"}", type);
      return;
   }

//---
  res = StringFormat(
          "{\"ok\":true,\"result\":\"%s\"}",
          TimeToString(time, TIME_DATE | TIME_MINUTES | TIME_SECONDS)
        );
 }


//+------------------------------------------------------------------+
//| CMcpFuncGetErrDescription - Obtiene descripción de errores       |
//+------------------------------------------------------------------+
class CMcpFuncGetErrDescription : public CMcpFunction
 {
public:
                     CMcpFuncGetErrDescription(void);
                    ~CMcpFuncGetErrDescription(void);

  void               Run(CJsonNode& param, string& res) override final;
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
void CMcpFuncGetErrDescription::Run(CJsonNode& param, string& res)
 {
//---
  const int error_code = (int)param["error_code"].ToInt(-1);
  const bool include_code = param["include_code"].ToBool(true);

//---
  string err = "";

//---
  CMt5ErrorDesc::GetError(err, error_code, include_code);

//---
  res = "{\"ok\":true,\"result\":\"" + err + "\"}";
 }
//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_UTILS_UTILS_MQH
