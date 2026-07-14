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
namespace TSN
{
class CMcpFunctionRunBacktest : public CMcpFunction
 {
private:
  long               m_chart_id_runner;
  const long         m_current_chart_id;
public:
                     CMcpFunctionRunBacktest(void) : CMcpFunction(0, false, "run_mt5_tester"),
                     m_current_chart_id(ChartID()), m_chart_id_runner(0)
   {
    m_chart_id_runner = DEFMTTesterGetChartId();
   }
                    ~CMcpFunctionRunBacktest(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionRunBacktest::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  if(m_chart_id_runner == 0)
   {
    m_chart_id_runner = DEFMTTesterGetChartId();
   }

//---
  static MTTesterTask task;
  task.symbol = param["symbol"].ToString("");
  task.set_file = param["set_file_name"].ToString("");
  task.expert_path = param["expert_path"].ToString("");
  task.chart_id_from = m_current_chart_id; // Viene de aqui.. (auqneu igual no recibiremos el evento..)
  task.start_date = StringToTime(param["start_date"].ToString("0"));
  task.end_date = StringToTime(param["end_date"].ToString("0"));
  task.timeframe = CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);
  task.leverage = (uint16_t)param["leverage"].ToInt(0);
  task.visual_mode = param["visual_mode"].ToBool(false);
  task.modelado = CEnumRegFullMt5Mcp::GetValNoRef<int8_t>(param["modelado"].ToString(),
                  -1); // usar el que viene por defecto..
  task.opt_mode = CEnumRegFullMt5Mcp::GetValNoRef<int8_t>(param["opt_mode"].ToString(),
                  -1); // usar el que viene por defecto..
  task.criterio_opt = CEnumRegFullMt5Mcp::GetValNoRef<int8_t>(param["optimization_criterion"].ToString(),
                      -1); // usar el que viene por defecto..
  task.forward_mode = CEnumRegFullMt5Mcp::GetValNoRef<int8_t>(param["forward_mode"].ToString(),
                      -1); // usar el que viene por defecto..
  task.delay_ms = (int)param["delay_ms"].ToInt(-2); // usar el que viene por defecto
  task.forward_date = (datetime)param["forward_date"].ToInt(0);

//---
  const bool common = param["file_in_common"].ToBool(true);
  const string fn = param["data_file_name"].ToString("tester_instruction.bin");
  ::ResetLastError();
  const int fh = FileOpen(fn, FILE_WRITE | FILE_BIN | (common ? FILE_COMMON : 0));
  if(fh == INVALID_HANDLE)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error write data in file[%s], last mt5 error = %d", fn, ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

  task.Save(fh);
  FileClose(fh);

//---
  ::ResetLastError();
  if(!::EventChartCustom(m_chart_id_runner, DEFMTTESTER_E_ON_TASK, m_current_chart_id, DEFMTTESTER_TO_DBL_ON_TASK(true), fn))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error to send event to run backtest, last err = %d, Ask the user if they have the Runner.ex5 bot running in their terminal, since this bot launches the tester itself; it only gives the command",
                       ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
  else
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValSWV("Execution command sent to Runner.ex5, this should launch the MT5 strategy tester");
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
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
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
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
void CMcpFunctionRunEA::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const long chart_id = OpenChartAndDevoler(ChartID(), param["symbol"].ToString(_Symbol), CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), int(param["ms_espera"].ToInt(750)));
  if(chart_id == -1)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error open chart, last mt5 err = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  const int t = param["params"].Size();

//---
  MqlParam exp_param[];
  ArrayResize(exp_param, t + 1);
  exp_param[0].type = TYPE_STRING;
  exp_param[0].string_value = param["expert_path"].ToString();

//---
  if(t > 0)
   {
    CJsonIteratorArray it = param["params"].BeginArr();
    int k = 1;
    while(it.IsValid())
     {
      //---
      CJsonNode parametro = it.Val();
      exp_param[k].type = CEnumRegBasis::GetValNoRef<ENUM_DATATYPE>(parametro["data_type"].ToString(), TYPE_STRING);

      //---
      switch(exp_param[k].type)
       {
        case TYPE_BOOL:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_CHAR:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_UCHAR:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_SHORT:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_USHORT:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_COLOR:
          exp_param[k].integer_value = long(color(parametro["value"].ToString("")));
          break;
        case TYPE_INT:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_UINT:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_DATETIME:
          exp_param[k].integer_value = long(datetime(parametro["value"].ToString("0")));
          break;
        case TYPE_LONG:
        case TYPE_ULONG:
          exp_param[k].integer_value = parametro["value"].ToInt(0);
          break;
        case TYPE_FLOAT:
          exp_param[k].double_value = parametro["value"].ToDouble(0.00);
          break;
        case TYPE_DOUBLE:
          exp_param[k].double_value = parametro["value"].ToDouble(0.00);
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
   }

//---
  if(!EXPERT::Run(chart_id, exp_param, EXPERT::FlagsPermisosStrToFlags(param["run_flags"].ToString(), '|')))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV("Error run EA, view logs..");
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
  else
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValSWV(StringFormat("EA successfully launched on chart with chart id = %I64d", chart_id));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
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
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionCompile::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  string out_log_path = "";
  if(!CompileFileWithLogFile(param["full_path_code"].ToString(""), out_log_path, (int)param["timeout_ms"].ToInt(60000), param["instruction"].ToString(""), param["optimize"].ToBool(true)))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValS(StringFormat("Error compile file, view experts logs, and compile log file = %s", out_log_path));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
  else
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValS(StringFormat("Success compiling file, log file=(%s)", out_log_path));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncTesterRep : public CMcpFunction
 {
private:
  SINGLETESTERCACHE  m_tst;
  bool               m_cached;

public:
                     CMcpFuncTesterRep(void) : CMcpFunction(0, false, "tester_reports") {}
                    ~CMcpFuncTesterRep(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncTesterRep::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
// En caso no se haya caechado esto se ginora ahora en caso si este checado reivsamos si hay qeu forzar el load
  if(m_cached && param["forze_reload"].ToBool(false))
    m_cached = false;

// Solo recargamos si no esta cacheado..
  if(!m_cached)
   {
    uchar data[];
    if(!MTTESTER::GetLastTstCache(data))
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV("Error getting last tester cache");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }
    if(!m_tst.Load(data))
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV("Error loading tester cache");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
     }
    m_cached = true;
   }

  const ENUM_MCPFUNC_TESTER_GET mode = CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_TESTER_GET>(
                                         param["mode"].ToString(""), WRONG_VALUE);
  m_shared_builder.PutChar('"');
  switch(mode)
   {
    case MCPFUNC_TESTER_GET_SUMMARY:
     {
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Obj();

      //--- Header
      m_shared_builder.KeyWV("tst_file_name").ValSNoRef(m_tst.Header.name[]);
      m_shared_builder.KeyWV("expert_name").ValSNoRef(m_tst.Header.expert_name[]);
      m_shared_builder.KeyWV("expert_path").ValSNoRef(m_tst.Header.expert_path[]);
      m_shared_builder.KeyWV("server").ValSNoRef(m_tst.Header.server[]);
      m_shared_builder.KeyWV("version").Val((int)m_tst.Header.version);
      m_shared_builder.KeyWV("copyright").ValSNoRef(m_tst.Header.copyright[]);
      m_shared_builder.KeyWV("msc_execution_time").Val((int)m_tst.Header.msc_last);
      m_shared_builder.KeyWV("symbol").ValSNoRef(m_tst.Header.symbol[]);

      // --- ExpTradeSummarySingle ---
      m_shared_builder.KeyWV("bars").Val(m_tst.Summary.bars);
      m_shared_builder.KeyWV("ticks").Val(m_tst.Summary.ticks);
      m_shared_builder.KeyWV("symbol").ValSNoRef(m_tst.Summary.symbol[]);
      m_shared_builder.KeyWV("initial_deposit").Val(m_tst.Summary.initial_deposit);
      m_shared_builder.KeyWV("withdrawal").Val(m_tst.Summary.withdrawal);
      m_shared_builder.KeyWV("profit").Val(m_tst.Summary.profit);
      m_shared_builder.KeyWV("grossprofit").Val(m_tst.Summary.grossprofit);
      m_shared_builder.KeyWV("grossloss").Val(m_tst.Summary.grossloss);
      m_shared_builder.KeyWV("maxprofit").Val(m_tst.Summary.maxprofit);
      m_shared_builder.KeyWV("minprofit").Val(m_tst.Summary.minprofit);
      m_shared_builder.KeyWV("conprofitmax").Val(m_tst.Summary.conprofitmax);
      m_shared_builder.KeyWV("maxconprofit").Val(m_tst.Summary.maxconprofit);
      m_shared_builder.KeyWV("conlossmax").Val(m_tst.Summary.conlossmax);
      m_shared_builder.KeyWV("maxconloss").Val(m_tst.Summary.maxconloss);
      m_shared_builder.KeyWV("balance_min").Val(m_tst.Summary.balance_min);
      m_shared_builder.KeyWV("maxdrawdown").Val(m_tst.Summary.maxdrawdown);
      m_shared_builder.KeyWV("drawdownpercent").Val(m_tst.Summary.drawdownpercent);
      m_shared_builder.KeyWV("reldrawdown").Val(m_tst.Summary.reldrawdown);
      m_shared_builder.KeyWV("reldrawdownpercent").Val(m_tst.Summary.reldrawdownpercent);
      m_shared_builder.KeyWV("equity_min").Val(m_tst.Summary.equity_min);
      m_shared_builder.KeyWV("maxdrawdown_e").Val(m_tst.Summary.maxdrawdown_e);
      m_shared_builder.KeyWV("drawdownpercent_e").Val(m_tst.Summary.drawdownpercent_e);
      m_shared_builder.KeyWV("reldrawdown_e").Val(m_tst.Summary.reldrawdown_e);
      m_shared_builder.KeyWV("reldrawdownpercnt_e").Val(m_tst.Summary.reldrawdownpercnt_e);
      m_shared_builder.KeyWV("expected_payoff").Val(m_tst.Summary.expected_payoff);
      m_shared_builder.KeyWV("profit_factor").Val(m_tst.Summary.profit_factor);
      m_shared_builder.KeyWV("recovery_factor").Val(m_tst.Summary.recovery_factor);
      m_shared_builder.KeyWV("sharpe_ratio").Val(m_tst.Summary.sharpe_ratio);
      m_shared_builder.KeyWV("margin_level").Val(m_tst.Summary.margin_level);
      m_shared_builder.KeyWV("custom_fitness").Val(m_tst.Summary.custom_fitness);
      m_shared_builder.KeyWV("deals").Val(m_tst.Summary.deals);
      m_shared_builder.KeyWV("trades").Val(m_tst.Summary.trades);
      m_shared_builder.KeyWV("profittrades").Val(m_tst.Summary.profittrades);
      m_shared_builder.KeyWV("losstrades").Val(m_tst.Summary.losstrades);
      m_shared_builder.KeyWV("shorttrades").Val(m_tst.Summary.shorttrades);
      m_shared_builder.KeyWV("longtrades").Val(m_tst.Summary.longtrades);
      m_shared_builder.KeyWV("winshorttrades").Val(m_tst.Summary.winshorttrades);
      m_shared_builder.KeyWV("winlongtrades").Val(m_tst.Summary.winlongtrades);
      m_shared_builder.KeyWV("conprofitmax_trades").Val(m_tst.Summary.conprofitmax_trades);
      m_shared_builder.KeyWV("maxconprofit_trades").Val(m_tst.Summary.maxconprofit_trades);
      m_shared_builder.KeyWV("conlossmax_trades").Val(m_tst.Summary.conlossmax_trades);
      m_shared_builder.KeyWV("maxconloss_trades").Val(m_tst.Summary.maxconloss_trades);
      m_shared_builder.KeyWV("avgconwinners").Val(m_tst.Summary.avgconwinners);
      m_shared_builder.KeyWV("avgconloosers").Val(m_tst.Summary.avgconloosers);

      // --- ExpTradeSummaryExt ---
      m_shared_builder.KeyWV("ghpr").Val(m_tst.Summary.ghpr);
      m_shared_builder.KeyWV("ghprpercent").Val(m_tst.Summary.ghprpercent);
      m_shared_builder.KeyWV("ahpr").Val(m_tst.Summary.ahpr);
      m_shared_builder.KeyWV("ahprpercent").Val(m_tst.Summary.ahprpercent);
      m_shared_builder.KeyWV("zscore").Val(m_tst.Summary.zscore);
      m_shared_builder.KeyWV("zscorepercent").Val(m_tst.Summary.zscorepercent);
      m_shared_builder.KeyWV("lrcorr").Val(m_tst.Summary.lrcorr);
      m_shared_builder.KeyWV("lrstderror").Val(m_tst.Summary.lrstderror);
      m_shared_builder.KeyWV("symbols").Val((int)m_tst.Summary.symbols);
      m_shared_builder.KeyWV("corr_prf_mfe").Val(m_tst.Summary.corr_prf_mfe);
      m_shared_builder.KeyWV("corr_prf_mae").Val(m_tst.Summary.corr_prf_mae);
      m_shared_builder.KeyWV("corr_mfe_mae").Val(m_tst.Summary.corr_mfe_mae);
      m_shared_builder.KeyWV("mfe_a").Val(m_tst.Summary.mfe_a);
      m_shared_builder.KeyWV("mfe_b").Val(m_tst.Summary.mfe_b);
      m_shared_builder.KeyWV("mae_a").Val(m_tst.Summary.mae_a);
      m_shared_builder.KeyWV("mae_b").Val(m_tst.Summary.mae_b);
      m_shared_builder.KeyWV("holding_time_min").Val((long)m_tst.Summary.holding_time_min);
      m_shared_builder.KeyWV("holding_time_max").Val((long)m_tst.Summary.holding_time_max);
      m_shared_builder.KeyWV("holding_time_avr").Val((long)m_tst.Summary.holding_time_avr);
      m_shared_builder.KeyWV("in_commission").Val(m_tst.Summary.in_commission);

      //--- Tiempo



      // --- Arrays de distribucion ---
      m_shared_builder.KeyWV("in_per_hours").Arr();
      for(int i = 0; i < 24; i++)
        m_shared_builder.Val((int)m_tst.Summary.in_per_hours[i]);
      m_shared_builder.EndArr();

      m_shared_builder.KeyWV("in_per_week_days").Arr();
      for(int i = 0; i < 7; i++)
        m_shared_builder.Val((int)m_tst.Summary.in_per_week_days[i]);
      m_shared_builder.EndArr();

      m_shared_builder.KeyWV("in_per_months").Arr();
      for(int i = 0; i < 12; i++)
        m_shared_builder.Val((int)m_tst.Summary.in_per_months[i]);
      m_shared_builder.EndArr();

      m_shared_builder.KeyWV("out_per_hours").Arr();
      for(int i = 0; i < 24; i++)
       {
        m_shared_builder.Arr();
        m_shared_builder.Val(m_tst.Summary.out_per_hours[i][0]);
        m_shared_builder.Val(m_tst.Summary.out_per_hours[i][1]);
        m_shared_builder.EndArr();
       }
      m_shared_builder.EndArr();

      m_shared_builder.KeyWV("out_per_week_days").Arr();
      for(int i = 0; i < 7; i++)
       {
        m_shared_builder.Arr();
        m_shared_builder.Val(m_tst.Summary.out_per_week_days[i][0]);
        m_shared_builder.Val(m_tst.Summary.out_per_week_days[i][1]);
        m_shared_builder.EndArr();
       }
      m_shared_builder.EndArr();

      m_shared_builder.KeyWV("out_per_months").Arr();
      for(int i = 0; i < 12; i++)
       {
        m_shared_builder.Arr();
        m_shared_builder.Val(m_tst.Summary.out_per_months[i][0]);
        m_shared_builder.Val(m_tst.Summary.out_per_months[i][1]);
        m_shared_builder.EndArr();
       }
      m_shared_builder.EndArr();

      m_shared_builder.EndObj();
      m_shared_builder.EndObj();
      break;
     }

    case MCPFUNC_TESTER_GET_BALANCE_HISTORY:
     {
      double balance[];
      const int s = (int)param["start"].ToInt(0);
      const int k = m_tst.GetBalance(balance, param["date_start"].ToInt(0),
                                     param["date_end"].ToInt(0),
                                     param["incluyed_deposit"].ToBool(true));
      const int t = fmin((int)param["count"].ToInt(1), k);

      if(t != -1)
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Arr();
        for(int i = s; i < t; i++)
         {
          m_shared_builder.Val(balance[i]);
         }
        m_shared_builder.EndArr().EndObj();
       }
      else
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS("Failure to obtain balance history.");
        m_shared_builder.EndObj();
       }
      break;
     }

    case MCPFUNC_TESTER_GET_EQUITY_HISTORY:
     {
      double eq[];
      const int s = (int)param["start"].ToInt(0);
      const int k = m_tst.GetEquity(eq, param["date_start"].ToInt(0),
                                    param["date_end"].ToInt(0),
                                    param["incluyed_deposit"].ToBool(true));
      const int t = fmin((int)param["count"].ToInt(1), k);

      if(t != -1)
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Arr();
        for(int i = s; i < t; i++)
         {
          m_shared_builder.Val(eq[i]);
         }
        m_shared_builder.EndArr().EndObj();
       }
      else
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS("Failure to obtain equity history.");
        m_shared_builder.EndObj();
       }
      break;
     }

    case MCPFUNC_TESTER_GET_DEALS_HISTORY:
     {

      const int s = (int)param["start"].ToInt(0);
      const int t = fmin((int)param["count"].ToInt(1), ArraySize(m_tst.Deals));

      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Arr();
      for(int i = s; i < t; i++)
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("deal").Val((long)m_tst.Deals[i].deal);
        m_shared_builder.KeyWV("order").Val((long)m_tst.Deals[i].order);
        m_shared_builder.KeyWV("position_id").Val((long)m_tst.Deals[i].position_id);
        m_shared_builder.KeyWV("time").Val((long)m_tst.Deals[i].time_create);
        m_shared_builder.KeyWV("symbol").Val((int)m_tst.Deals[i].symbol[]);
        m_shared_builder.KeyWV("action").Val((int)m_tst.Deals[i].action);
        m_shared_builder.KeyWV("entry").Val((int)m_tst.Deals[i].entry);
        m_shared_builder.KeyWV("price_open").Val(m_tst.Deals[i].price_open);
        m_shared_builder.KeyWV("price_close").Val(m_tst.Deals[i].price_close);
        m_shared_builder.KeyWV("sl").Val(m_tst.Deals[i].sl);
        m_shared_builder.KeyWV("tp").Val(m_tst.Deals[i].tp);
        m_shared_builder.KeyWV("volume").Val((double)m_tst.Deals[i].volume / (m_tst.Deals[i].contract_size > 0 ? m_tst.Deals[i].contract_size * 1000 : 1e8));
        m_shared_builder.KeyWV("profit").Val(m_tst.Deals[i].profit);
        m_shared_builder.KeyWV("commission").Val(m_tst.Deals[i].commission);
        m_shared_builder.KeyWV("storage").Val(m_tst.Deals[i].storage);
        m_shared_builder.KeyWV("comment").ValSNoRef(m_tst.Deals[i].comment[]);
        m_shared_builder.EndObj();
       }
      m_shared_builder.EndArr().EndObj();
      break;
     }

    default:
     {
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("result").ValS("Invalid mode");
      m_shared_builder.EndObj();
      break;
     }
   }
  m_shared_builder.PutChar('"');
 }
} // namespace TSN

#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_COMPLEX_MQH
