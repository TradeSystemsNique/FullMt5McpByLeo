//+------------------------------------------------------------------+
//|                                                          Run.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_COMPLEX_COMPLEX_MQH
#define FULLMT5MCPBYLEO_SRC_COMPLEX_COMPLEX_MQH


//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFunctionRunBacktest : public CMcpFunction
 {
private:
  long               m_chart_id_runner;
  const long         m_current_chart_id;
public:
                     CMcpFunctionRunBacktest(void) : CMcpFunction(0, false, "execute_backtest"), m_current_chart_id(ChartID()) { m_chart_id_runner = DEFMTTesterGetChartId(); }
                    ~CMcpFunctionRunBacktest(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionRunBacktest::Run(CJsonNode &param, string &res)
 {
//---
  static MTTesterTask task;
  task.symbol = param["symbol"].ToString("");
  task.set_file = param["set_file_name"].ToString("");
  task.expert_path = param["expert_path"].ToString("");
  task.chart_id_from = m_current_chart_id;
  task.start_date = StringToTime(param["start_date"].ToString("0"));
  task.end_date = StringToTime(param["end_date"].ToString("0"));
  task.timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  task.leverage = (uint16_t)param["leverage"].ToInt(0);
  task.visual_mode = param["visual_mode"].ToBool(false);
  task.modelado = int8_t(CEnumReg::GetValueNoRef<ENUM_MTTESTER_MODELADO_MODE>(param["modelado"].ToString(), WRONG_VALUE)); // usar el que viene por defecto

//---
  const bool common = param["file_in_common"].ToBool(true);
  const string fn = param["data_file_name"].ToString();
  const int fh = FileOpen(fn, FILE_WRITE | FILE_TXT | (common ? FILE_COMMON : 0));
  FileWrite(fh, task.ToString());
  FileClose(fh);


//---
  ::ResetLastError();
  if(!::EventChartCustom(m_chart_id_runner, DEFMTTESTER_E_ON_TASK, m_current_chart_id, DEFMTTESTER_TO_DBL_ON_TASK(true), fn))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"Error to send event to run backtest, last err = %d\"}", ::GetLastError());
   }
  else
   {
    res = "{\"ok\":true,\"result\":\"Backtest sent to MT5 Tester\"}";
   }
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFunctionRunEA : public CMcpFunction
 {
public:
                     CMcpFunctionRunEA(void) : CMcpFunction(0, false, "run_ea") {}
                    ~CMcpFunctionRunEA(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };

/*
{
 "symbol" : "XAUUSD",
 "timeframe" : "PERIOD_M1",
 "ms_espera" : 1500,
 "expert_path" : "Experts\\MiEA.ex5",
 "run_flags" : "DLL|AutoTrading"
 "params" : [
  {
   "data_type" : "TYPE_STRING",
   "value" : "10.0"
  }
 ]
}
*/
//+------------------------------------------------------------------+
void CMcpFunctionRunEA::Run(CJsonNode &param, string &res)
 {
  ::ResetLastError();
  const long chart_id = OpenChartAndDevoler(ChartID(), param["symbol"].ToString(_Symbol), CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), int(param["ms_espera"].ToInt(750)));
  if(chart_id == -1)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"Error open chart, last mt5 err = %d\"}", ::GetLastError());
   }

//---
  const int t = param["params"].Size();

//---
  MqlParam exp_param[];
  ArrayResize(exp_param, t + 1);
  exp_param[0].type = TYPE_STRING;
  exp_param[0].string_value = param["expert_path"].ToString();

//---
  CJsonIterator it = param["params"].begin();
  int k = 1;
  while(it.IsValid())
   {
    //---
    CJsonNode parametro = it.Val();
    exp_param[k].type = CEnumReg::GetValueNoRef<ENUM_DATATYPE>(parametro["data_type"].ToString(), TYPE_STRING);

    //---
    switch(exp_param[k].type)
     {
      case TYPE_BOOL:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_CHAR:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_UCHAR:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_SHORT:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_USHORT:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_COLOR:
        exp_param[k].integer_value = long(color(parametro["value"].ToString("")));
        break;
      case TYPE_INT:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_UINT:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_DATETIME:
        exp_param[k].integer_value = long(datetime(parametro["value"].ToString("0")));
        break;
      case TYPE_LONG:
      case TYPE_ULONG:
        exp_param[k].integer_value = parametro["value"].ToInt();
        break;
      case TYPE_FLOAT:
        exp_param[k].double_value = parametro["value"].ToDouble();
        break;
      case TYPE_DOUBLE:
        exp_param[k].double_value = parametro["value"].ToDouble();
        break;
      case TYPE_STRING:
        exp_param[k].string_value = parametro["value"].ToString("");
        break;
      default:
        exp_param[k].string_value = parametro["value"].ToString("");
        break;
     }
    k++;
    //---
    it.Next();
   }

//---
  if(!EXPERT::Run(chart_id, exp_param, EXPERT::FlagsPermisosStrToFlags(param["run_flags"].ToString(), '|')))
   {
    res = "{\"ok\":false,\"error\":\"Error run EA, view logs..\"}";
   }
  else
   {
    res = StringFormat("{\"ok\":true,\"result\":\"EA successfully launched on chart with chart id = %I64d\"}", chart_id);
   }
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFunctionCompile : public CMcpFunction
 {
public:
                     CMcpFunctionCompile(void): CMcpFunction(0, false, "compile_mql5") {}
                    ~CMcpFunctionCompile(void) {}
  //  instruction = [avx, avx2, avx512]
  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionCompile::Run(CJsonNode &param, string &res)
 {
  string out_log_path = "";
  if(!CompileFileWithLogFile(param["full_path_code"].ToString(""), out_log_path, (int)param["timeout_ms"].ToInt(60000), param["instruction"].ToString(""), param["optimize"].ToBool(true)))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"Error compile file, view experts logs, and compile log file = %s\"}", out_log_path);
   }
  else
   {
    res = StringFormat("{\"ok\":true,\"result\":\"Success compiling file, log file=(%s)\"}", out_log_path);
   }
 }

#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_COMPLEX_MQH