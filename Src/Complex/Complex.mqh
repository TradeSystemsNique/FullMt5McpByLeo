//+------------------------------------------------------------------+
//|                                                          Run.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <TSN\\ExtraCodes\\RunnerProtDef.mqh>
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
                     CMcpFunctionRunBacktest(void) {}
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
  task.timeframe = CEnumReg::GetValueNoRef(param["timeframe"], _Period);
  task.leverage = (uint16_t)param["leverage"].ToInt(0);
  task.visual_mode = param["visual_mode"].ToBool(false);
  task.modelado = int8_t(CEnumReg::GetValueNoRef<ENUM_MTTESTER_MODELADO_MODE>(param["modelado"].ToString())); // usar el que viene por defecto

//---
  const bool common = param["file_in_common"].ToBool();
  const string fn = param["data_file_name"];
  const int fh = FileOpen(fn, FILE_WRITE | FILE_TXT | (common ? FILE_COMMON));
  FileWrite(fh, task.ToString());
  FileClose(fh);


//---
  if(!::EventChartCustom(m_chart_id_runner, DEFMTTESTER_E_ON_TASK, m_current_chart_id, DEFMTTESTER_TO_DBL_ON_TASK(true), fn))
   {
    res = "";
   }
  else
   {
    res = "";
   }
 }
//+------------------------------------------------------------------+
