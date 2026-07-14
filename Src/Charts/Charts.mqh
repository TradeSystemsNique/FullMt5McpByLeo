//+------------------------------------------------------------------+
//|                                                       Charts.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_CHARTS_CHARTS_MQH
#define FULLMT5MCPBYLEO_SRC_CHARTS_CHARTS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

namespace TSN
{
//+------------------------------------------------------------------+
//| chart_list                                                       |
//+------------------------------------------------------------------+
class CMcpFuncChartList : public CMcpFunction
 {
public:
                     CMcpFuncChartList() : CMcpFunction(0, false, "chart_list") {}
                    ~CMcpFuncChartList(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartList::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  long currChart, prevChart = ChartFirst();
  int i = 0, limit = CHARTS_MAX;

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();

//---
  if(prevChart >= 0)
   {
    m_shared_builder.Val(prevChart);
    while(i < limit)
     {
      currChart = ChartNext(prevChart);
      if(currChart < 0)
        break;
      m_shared_builder.Val(currChart);
      prevChart = currChart;
      i++;
     }
   }

  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| chart_open                                                       |
//+------------------------------------------------------------------+
class CMcpFuncChartOpen : public CMcpFunction
 {
public:
                     CMcpFuncChartOpen() : CMcpFunction(0, false, "chart_open") {}
                    ~CMcpFuncChartOpen(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartOpen::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();

//---
  const long chart_id = ::ChartOpen(param["symbol"].ToString(_Symbol), CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period));

//---
  if(chart_id == 0)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("chart_open failed, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Val(chart_id);
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| chart_close                                                      |
//+------------------------------------------------------------------+
class CMcpFuncChartClose : public CMcpFunction
 {
public:
                     CMcpFuncChartClose() : CMcpFunction(0, false, "chart_close") {}
                    ~CMcpFuncChartClose(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartClose::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const bool result = ChartClose((long)param["chart_id"].ToInt(-1));

//---
  if(!result)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("chart_close failed, last mt5 error = %d", ::GetLastError()));
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
//| chart_get_set                                                    |
//+------------------------------------------------------------------+
class CMcpFuncChartSetGet  : public CMcpFunction
 {
public:
                     CMcpFuncChartSetGet(void) : CMcpFunction(0, false, "chart_get_set") {}
                    ~CMcpFuncChartSetGet(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncChartSetGet::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int mode = (int)param["mode"].ToInt(-1);
  const long chart_id = param["chart_id"].ToInt(0);
  switch(mode)
   {
    case MCPFUNC_SETGET_DOUBLE:
     {
      if(param.HasKey("value"))
       {
        if(ChartSetDouble(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToDouble(0.00)))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").Val(true);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error set chart double, last mt5 err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      else
       {
        double v;
        if(ChartGetDouble(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), (int)param["sub_window"].ToInt(0), v))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").Val(v);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error chart get double, last err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      break;
     }
    case MCPFUNC_SETGET_INTEGER:
     {
      if(param.HasKey("value"))
       {
        if(ChartSetInteger(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToInt(0)))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").Val(true);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error set chart double, last mt5 err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      else
       {
        long v = 0;
        if(ChartGetInteger(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), (int)param["sub_window"].ToInt(0), v))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").Val(v);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error chart get integer, last err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      break;
     }
    case MCPFUNC_SETGET_STRING:
     {
      if(param.HasKey("value"))
       {
        if(ChartSetString(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToString()))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").Val(true);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error set chart string, last mt5 err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      else
       {
        string v;
        if(ChartGetString(chart_id, CEnumRegBasis::GetValNoRef<ENUM_CHART_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), v))
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(true);
          m_shared_builder.KeyWV("result").ValS(v);
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
        else
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("Error chart get string, last err = %d", ::GetLastError()));
          m_shared_builder.EndObj();
          m_shared_builder.PutChar('"');
         }
       }
      break;
     }
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV("Error, invalid mode");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
   }
 }

//+------------------------------------------------------------------+
//| chart_navigate                                                   |
//+------------------------------------------------------------------+
class CMcpFuncChartNavigate  : public CMcpFunction
 {
public:
                     CMcpFuncChartNavigate(void) : CMcpFunction(0, false, "chart_navigate") {}
                    ~CMcpFuncChartNavigate(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
void CMcpFuncChartNavigate::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  if(ChartNavigate(param["chart_id"].ToInt(0),
                   CEnumRegBasis::GetValNoRef<ENUM_CHART_POSITION>(param["loacation"].ToString(), WRONG_VALUE), int(param["bars_to_navigate"].ToInt(0))))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").Val(true);
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
  else
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("result").ValSWV(StringFormat("Eror navigate chart, last MQL5 Error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
 }

//+------------------------------------------------------------------+
//| chart_indicator                                                  |
//+------------------------------------------------------------------+
class CMcpFuncChartInd : public CMcpFunction
 {
public:
                     CMcpFuncChartInd(void)  : CMcpFunction(0, false, "chart_indicator") {}
                    ~CMcpFuncChartInd(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncChartInd::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const ENUM_MCPFUNC_CHARTIND_DEF mode = CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_CHARTIND_DEF>(param["mode"].ToString(""), WRONG_VALUE);
  const long chart_id = param["chart_id"].ToInt(0);
  const int subwin = (int)param["sub_window"].ToInt(0);
//Print(param.ComplexToString());

//---
  switch(mode)
   {
    case  MCPFUNC_CHARTIND_TOTAL:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(ChartIndicatorsTotal(chart_id, subwin));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }
    case  MCPFUNC_CHARTIND_SHORT_NAME:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").ValS(ChartIndicatorName(chart_id, subwin, (int)param["index"].ToInt(0)));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }
    case  MCPFUNC_CHARTIND_ADD:
     {
      ::ResetLastError();
      const int handle = (int)param["indicator_handle"].ToInt(-1);
      if(ChartIndicatorAdd(chart_id, subwin, handle))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValSWV("okey");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      else
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValSWV(StringFormat("Last MQL5 Error = %d, Handle = %d", ::GetLastError(), handle));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    case  MCPFUNC_CHARTIND_DELETE:
     {
      ::ResetLastError();
      if(ChartIndicatorDelete(chart_id, subwin, param["indicator_shortname"].ToString("")))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValSWV("okey");
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      else
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValSWV(StringFormat("Last MQL5 Error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV("Error, invalid mode mode.. ");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
   }
 }

//+------------------------------------------------------------------+
//| chart_redraw                                                     |
//+------------------------------------------------------------------+
class CMcpFuncChartRedraw : public CMcpFunction
 {
public:
                     CMcpFuncChartRedraw() : CMcpFunction(0, false, "chart_redraw") {}
                    ~CMcpFuncChartRedraw(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartRedraw::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
//---
  ChartRedraw(param["chart_id"].ToInt(0));
//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").ValSWV("okey");
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncChartGetSymbolOrPeriod : public CMcpFunction
 {
public:
                     CMcpFuncChartGetSymbolOrPeriod(void) : CMcpFunction(0, false, "chart_get_symbol_or_period") {}
                    ~CMcpFuncChartGetSymbolOrPeriod(void) {}
  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartGetSymbolOrPeriod::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int8_t mode = (int8_t)param["mode"].ToInt(-1);
  const long chart_id = param["chart_id"].ToInt(0);

  switch(mode)
   {
    case 0:
     {
      ::ResetLastError();
      const ENUM_TIMEFRAMES tf = ChartPeriod(chart_id);
      //Print(EnumToString(tf));
      if(tf == 0)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValSWV(StringFormat("Error in ChartPeriod, last mql5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      else
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValSWV(EnumToString(tf));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    case 1:
     {
      ::ResetLastError();
      const string simbolo = ChartSymbol(chart_id);
      if(simbolo == "")
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValSWV(StringFormat("Error in ChartPeriod, last mql5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      else
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(simbolo);
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %d, use 0=get timeframe, 1=get symbol", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
   }
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncChartSrenshot : public CMcpFunction
 {
public:
                     CMcpFuncChartSrenshot(void) : CMcpFunction(0, false, "chart_screenshot") {}
                    ~CMcpFuncChartSrenshot(void) {}
  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartSrenshot::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const string fn = param["file_name"].ToString();
  const long chart_id = param["chart_id"].ToInt(0);
  ::ResetLastError();
  if(!ChartScreenShot(chart_id, fn, (int)param["width"].ToInt(ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS)),
                      (int)param["height"].ToInt(ChartGetInteger(chart_id, CHART_HEIGHT_IN_PIXELS)), ALIGN_CENTER))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("Failed call ChartScreenShot, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }


//---
  if(param["as_image_file"].ToBool(false))
   {
    if(param["common_flag"].ToBool(true))
     {
      if(!FileMove(fn, 0, fn, FILE_COMMON | FILE_REWRITE))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("Failed call FileMove, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Obj();
      m_shared_builder.KeyWV("full_path").ValSNoRef(TERMINAL_MT5_COMMON_PATH + "\\Files\\" + fn);
      m_shared_builder.EndObj();
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
     }
    else
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Obj();
      m_shared_builder.KeyWV("full_path").ValSNoRef(TERMINAL_MT5_ROOT + "Files\\" + fn);
      m_shared_builder.EndObj();
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
     }
   }
  else
   {
    uchar bytes[];
    FileLoad(fn, bytes);
    uchar key[];
    uchar b64[];
    const int t = CryptEncode(CRYPT_BASE64, bytes, key, b64);
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(true);
    m_shared_builder.KeyWV("result").ValSWV(CharArrayToString(b64, 0, t));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
   }
 }
}


//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_CHARTS_CHARTS_MQH
