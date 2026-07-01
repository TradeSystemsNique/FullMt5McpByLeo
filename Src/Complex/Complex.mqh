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
  void               Run(CJsonNode& param, string& res) override final;
 };
//+------------------------------------------------------------------+
void CMcpFunctionRunBacktest::Run(CJsonNode &param, string &res)
 {
//---
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
    res = StringFormat("{\"ok\":false,\"error\":\"Error write data in file[%s], last mt5 error = %d\"}", fn, ::GetLastError());
    return;
   }

  task.Save(fh);
  FileClose(fh);

//---
  ::ResetLastError();
  if(!::EventChartCustom(m_chart_id_runner, DEFMTTESTER_E_ON_TASK, m_current_chart_id, DEFMTTESTER_TO_DBL_ON_TASK(true), fn))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"Error to send event to run backtest, last err = %d, Ask the user if they have the Runner.ex5 bot running in their terminal, since this bot launches the tester itself; it only gives the command\"}",
                       ::GetLastError());
   }
  else
   {
    res = "{\"ok\":true,\"result\":\"Execution command sent to Runner.ex5, this should launch the MT5 strategy tester\"}";
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
  const long chart_id = OpenChartAndDevoler(ChartID(), param["symbol"].ToString(_Symbol), CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), int(param["ms_espera"].ToInt(750)));
  if(chart_id == -1)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"Error open chart, last mt5 err = %d\"}", ::GetLastError());
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncTesterRep : public CMcpFunction
 {
private:
  SINGLETESTERCACHE  m_tst;
  CJsonBuilder       m_builder;
  bool               m_cached;

public:
                     CMcpFuncTesterRep(void) : CMcpFunction(0, false, "tester_reports") {}
                    ~CMcpFuncTesterRep(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncTesterRep::Run(CJsonNode& param, string& res)
 {
// En caso no se haya caechado esto se ginora ahora en caso si este checado reivsamos si hay qeu forzar el load
  if(m_cached && param["forze_reload"].ToBool(false))
    m_cached = false;

// Solo recargamos si no esta cacheado..
  if(!m_cached)
   {
    uchar data[];
    if(!MTTESTER::GetLastTstCache(data))
     {
      res = "{\"ok\":false,\"error\":\"Error getting last tester cache\"}";
      return;
     }
    if(!m_tst.Load(data))
     {
      res = "{\"ok\":false,\"error\":\"Error loading tester cache\"}";
      return;
     }
    m_cached = true;
   }

  const ENUM_MCPFUNC_TESTER_GET mode = CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_TESTER_GET>(
                                         param["mode"].ToString(""), WRONG_VALUE);
  m_builder.Clear();
  switch(mode)
   {
    case MCPFUNC_TESTER_GET_SUMMARY:
     {
      m_builder.Obj();
      m_builder.Key("ok").Val(true);
      m_builder.Key("result").Obj();

      //--- Header
      m_builder.Key("tst_file_name").ValSNoRef(m_tst.Header.name[]);
      m_builder.Key("expert_name").ValSNoRef(m_tst.Header.expert_name[]);
      m_builder.Key("expert_path").ValSNoRef(m_tst.Header.expert_path[]);
      m_builder.Key("server").ValSNoRef(m_tst.Header.server[]);
      m_builder.Key("version").Val((int)m_tst.Header.version);
      m_builder.Key("copyright").ValSNoRef(m_tst.Header.copyright[]);
      m_builder.Key("msc_execution_time").Val((int)m_tst.Header.msc_last);
      m_builder.Key("symbol").ValSNoRef(m_tst.Header.symbol[]);

      // --- ExpTradeSummarySingle ---
      m_builder.Key("bars").Val(m_tst.Summary.bars);
      m_builder.Key("ticks").Val(m_tst.Summary.ticks);
      m_builder.Key("symbol").ValSNoRef(m_tst.Summary.symbol[]);
      m_builder.Key("initial_deposit").Val(m_tst.Summary.initial_deposit);
      m_builder.Key("withdrawal").Val(m_tst.Summary.withdrawal);
      m_builder.Key("profit").Val(m_tst.Summary.profit);
      m_builder.Key("grossprofit").Val(m_tst.Summary.grossprofit);
      m_builder.Key("grossloss").Val(m_tst.Summary.grossloss);
      m_builder.Key("maxprofit").Val(m_tst.Summary.maxprofit);
      m_builder.Key("minprofit").Val(m_tst.Summary.minprofit);
      m_builder.Key("conprofitmax").Val(m_tst.Summary.conprofitmax);
      m_builder.Key("maxconprofit").Val(m_tst.Summary.maxconprofit);
      m_builder.Key("conlossmax").Val(m_tst.Summary.conlossmax);
      m_builder.Key("maxconloss").Val(m_tst.Summary.maxconloss);
      m_builder.Key("balance_min").Val(m_tst.Summary.balance_min);
      m_builder.Key("maxdrawdown").Val(m_tst.Summary.maxdrawdown);
      m_builder.Key("drawdownpercent").Val(m_tst.Summary.drawdownpercent);
      m_builder.Key("reldrawdown").Val(m_tst.Summary.reldrawdown);
      m_builder.Key("reldrawdownpercent").Val(m_tst.Summary.reldrawdownpercent);
      m_builder.Key("equity_min").Val(m_tst.Summary.equity_min);
      m_builder.Key("maxdrawdown_e").Val(m_tst.Summary.maxdrawdown_e);
      m_builder.Key("drawdownpercent_e").Val(m_tst.Summary.drawdownpercent_e);
      m_builder.Key("reldrawdown_e").Val(m_tst.Summary.reldrawdown_e);
      m_builder.Key("reldrawdownpercnt_e").Val(m_tst.Summary.reldrawdownpercnt_e);
      m_builder.Key("expected_payoff").Val(m_tst.Summary.expected_payoff);
      m_builder.Key("profit_factor").Val(m_tst.Summary.profit_factor);
      m_builder.Key("recovery_factor").Val(m_tst.Summary.recovery_factor);
      m_builder.Key("sharpe_ratio").Val(m_tst.Summary.sharpe_ratio);
      m_builder.Key("margin_level").Val(m_tst.Summary.margin_level);
      m_builder.Key("custom_fitness").Val(m_tst.Summary.custom_fitness);
      m_builder.Key("deals").Val(m_tst.Summary.deals);
      m_builder.Key("trades").Val(m_tst.Summary.trades);
      m_builder.Key("profittrades").Val(m_tst.Summary.profittrades);
      m_builder.Key("losstrades").Val(m_tst.Summary.losstrades);
      m_builder.Key("shorttrades").Val(m_tst.Summary.shorttrades);
      m_builder.Key("longtrades").Val(m_tst.Summary.longtrades);
      m_builder.Key("winshorttrades").Val(m_tst.Summary.winshorttrades);
      m_builder.Key("winlongtrades").Val(m_tst.Summary.winlongtrades);
      m_builder.Key("conprofitmax_trades").Val(m_tst.Summary.conprofitmax_trades);
      m_builder.Key("maxconprofit_trades").Val(m_tst.Summary.maxconprofit_trades);
      m_builder.Key("conlossmax_trades").Val(m_tst.Summary.conlossmax_trades);
      m_builder.Key("maxconloss_trades").Val(m_tst.Summary.maxconloss_trades);
      m_builder.Key("avgconwinners").Val(m_tst.Summary.avgconwinners);
      m_builder.Key("avgconloosers").Val(m_tst.Summary.avgconloosers);

      // --- ExpTradeSummaryExt ---
      m_builder.Key("ghpr").Val(m_tst.Summary.ghpr);
      m_builder.Key("ghprpercent").Val(m_tst.Summary.ghprpercent);
      m_builder.Key("ahpr").Val(m_tst.Summary.ahpr);
      m_builder.Key("ahprpercent").Val(m_tst.Summary.ahprpercent);
      m_builder.Key("zscore").Val(m_tst.Summary.zscore);
      m_builder.Key("zscorepercent").Val(m_tst.Summary.zscorepercent);
      m_builder.Key("lrcorr").Val(m_tst.Summary.lrcorr);
      m_builder.Key("lrstderror").Val(m_tst.Summary.lrstderror);
      m_builder.Key("symbols").Val((int)m_tst.Summary.symbols);
      m_builder.Key("corr_prf_mfe").Val(m_tst.Summary.corr_prf_mfe);
      m_builder.Key("corr_prf_mae").Val(m_tst.Summary.corr_prf_mae);
      m_builder.Key("corr_mfe_mae").Val(m_tst.Summary.corr_mfe_mae);
      m_builder.Key("mfe_a").Val(m_tst.Summary.mfe_a);
      m_builder.Key("mfe_b").Val(m_tst.Summary.mfe_b);
      m_builder.Key("mae_a").Val(m_tst.Summary.mae_a);
      m_builder.Key("mae_b").Val(m_tst.Summary.mae_b);
      m_builder.Key("holding_time_min").Val((long)m_tst.Summary.holding_time_min);
      m_builder.Key("holding_time_max").Val((long)m_tst.Summary.holding_time_max);
      m_builder.Key("holding_time_avr").Val((long)m_tst.Summary.holding_time_avr);
      m_builder.Key("in_commission").Val(m_tst.Summary.in_commission);

      //--- Tiempo



      // --- Arrays de distribucion ---
      m_builder.Key("in_per_hours").Arr();
      for(int i = 0; i < 24; i++)
        m_builder.Val((int)m_tst.Summary.in_per_hours[i]);
      m_builder.EndArr();

      m_builder.Key("in_per_week_days").Arr();
      for(int i = 0; i < 7; i++)
        m_builder.Val((int)m_tst.Summary.in_per_week_days[i]);
      m_builder.EndArr();

      m_builder.Key("in_per_months").Arr();
      for(int i = 0; i < 12; i++)
        m_builder.Val((int)m_tst.Summary.in_per_months[i]);
      m_builder.EndArr();

      m_builder.Key("out_per_hours").Arr();
      for(int i = 0; i < 24; i++)
       {
        m_builder.Arr();
        m_builder.Val(m_tst.Summary.out_per_hours[i][0]);
        m_builder.Val(m_tst.Summary.out_per_hours[i][1]);
        m_builder.EndArr();
       }
      m_builder.EndArr();

      m_builder.Key("out_per_week_days").Arr();
      for(int i = 0; i < 7; i++)
       {
        m_builder.Arr();
        m_builder.Val(m_tst.Summary.out_per_week_days[i][0]);
        m_builder.Val(m_tst.Summary.out_per_week_days[i][1]);
        m_builder.EndArr();
       }
      m_builder.EndArr();

      m_builder.Key("out_per_months").Arr();
      for(int i = 0; i < 12; i++)
       {
        m_builder.Arr();
        m_builder.Val(m_tst.Summary.out_per_months[i][0]);
        m_builder.Val(m_tst.Summary.out_per_months[i][1]);
        m_builder.EndArr();
       }
      m_builder.EndArr();

      m_builder.EndObj();
      m_builder.EndObj();
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
        m_builder.Obj();
        m_builder.Key("ok").Val(true);
        m_builder.Key("result").Arr();
        for(int i = s; i < t; i++)
         {
          m_builder.Val(balance[i]);
         }
        m_builder.EndArr().EndObj();
       }
      else
       {
        m_builder.Obj();
        m_builder.Key("ok").Val(false);
        m_builder.Key("result").ValS("Failure to obtain balance history.");
        m_builder.EndObj();
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
        m_builder.Obj();
        m_builder.Key("ok").Val(true);
        m_builder.Key("result").Arr();
        for(int i = s; i < t; i++)
         {
          m_builder.Val(eq[i]);
         }
        m_builder.EndArr().EndObj();
       }
      else
       {
        m_builder.Obj();
        m_builder.Key("ok").Val(false);
        m_builder.Key("result").ValS("Failure to obtain equity history.");
        m_builder.EndObj();
       }
      break;
     }

    case MCPFUNC_TESTER_GET_DEALS_HISTORY:
     {

      const int s = (int)param["start"].ToInt(0);
      const int t = fmin((int)param["count"].ToInt(1), ArraySize(m_tst.Deals));

      m_builder.Obj();
      m_builder.Key("ok").Val(true);
      m_builder.Key("result").Arr();
      for(int i = s; i < t; i++)
       {
        m_builder.Obj();
        m_builder.Key("deal").Val((long)m_tst.Deals[i].deal);
        m_builder.Key("order").Val((long)m_tst.Deals[i].order);
        m_builder.Key("position_id").Val((long)m_tst.Deals[i].position_id);
        m_builder.Key("time").Val((long)m_tst.Deals[i].time_create);
        m_builder.Key("symbol").Val((int)m_tst.Deals[i].symbol[]);
        m_builder.Key("action").Val((int)m_tst.Deals[i].action);
        m_builder.Key("entry").Val((int)m_tst.Deals[i].entry);
        m_builder.Key("price_open").Val(m_tst.Deals[i].price_open);
        m_builder.Key("price_close").Val(m_tst.Deals[i].price_close);
        m_builder.Key("sl").Val(m_tst.Deals[i].sl);
        m_builder.Key("tp").Val(m_tst.Deals[i].tp);
        m_builder.Key("volume").Val((double)m_tst.Deals[i].volume / (m_tst.Deals[i].contract_size > 0 ? m_tst.Deals[i].contract_size * 1000 : 1e8));
        m_builder.Key("profit").Val(m_tst.Deals[i].profit);
        m_builder.Key("commission").Val(m_tst.Deals[i].commission);
        m_builder.Key("storage").Val(m_tst.Deals[i].storage);
        m_builder.Key("comment").ValSNoRef(m_tst.Deals[i].comment[]);
        m_builder.EndObj();
       }
      m_builder.EndArr().EndObj();
      break;
     }

    default:
     {
      m_builder.Obj();
      m_builder.Key("ok").Val(false);
      m_builder.Key("result").ValS("Invalid mode");
      m_builder.EndObj();
      break;
     }
   }
  res = m_builder.Build();
 }
} // namespace TSN

#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_COMPLEX_MQH
