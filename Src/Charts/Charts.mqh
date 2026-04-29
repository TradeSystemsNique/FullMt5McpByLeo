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

//+------------------------------------------------------------------+
//| chart_list                                                       |
//+------------------------------------------------------------------+
class CMcpFuncChartList : public CMcpFunction
 {
public:
                     CMcpFuncChartList() : CMcpFunction(0, false, "chart_list") {}
                    ~CMcpFuncChartList(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartList::Run(CJsonNode& param, string& res)
 {
//---
  long currChart, prevChart = ChartFirst();
  int i = 0, limit = CHARTS_MAX;
//---
  res = "{\"ok\":true,\"result\":[";
//---
  if(prevChart >= 0)
   {
    res += StringFormat("%I64d", prevChart);
    while(i < limit)
     {
      currChart = ChartNext(prevChart);
      if(currChart < 0)
        break;
      res += StringFormat(",%I64d", currChart);
      prevChart = currChart;
      i++;
     }
   }

  res += "]}";
 }

//+------------------------------------------------------------------+
//| chart_open                                                       |
//+------------------------------------------------------------------+
class CMcpFuncChartOpen : public CMcpFunction
 {
public:
                     CMcpFuncChartOpen() : CMcpFunction(0, false, "chart_open") {}
                    ~CMcpFuncChartOpen(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartOpen::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();

//---
  const long chart_id = ::ChartOpen(param["symbol"].ToString(_Symbol), CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period));

//---
  if(chart_id == 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"chart_open failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%I64d}", chart_id);
 }

//+------------------------------------------------------------------+
//| chart_close                                                      |
//+------------------------------------------------------------------+
class CMcpFuncChartClose : public CMcpFunction
 {
public:
                     CMcpFuncChartClose() : CMcpFunction(0, false, "chart_close") {}
                    ~CMcpFuncChartClose(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartClose::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const bool result = ChartClose((long)param["chart_id"].ToInt(-1));

//---
  if(!result)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"chart_close failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }
  res = "{\"ok\":true,\"result\":true}";
 }

//+------------------------------------------------------------------+
//| chart_integer                                                    |
//+------------------------------------------------------------------+
class CMcpFuncChartInteger : public CMcpFunction
 {
public:
                     CMcpFuncChartInteger() : CMcpFunction(0, false, "chart_integer") {}
                    ~CMcpFuncChartInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();

//---
  if(param.HasKey("value"))
   {
    if(ChartSetInteger(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToInt()))
     {
      res = "{\"ok\":true,\"result\":true}";
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error set chart double, last mt5 err = %d\"}", ::GetLastError());
     }
   }
  else
   {
    long v = 0;
    if(ChartGetInteger(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_INTEGER>(param["property"].ToString(""), WRONG_VALUE), (int)param["sub_window"].ToInt(0), v))
     {
      res = StringFormat("{\"ok\":true,\"result\":%I64d}", v);
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error chart get integer, last err = %d\"}", ::GetLastError());
     }
   }
 }

//+------------------------------------------------------------------+
//| chart_double                                                     |
//+------------------------------------------------------------------+
class CMcpFuncChartDouble : public CMcpFunction
 {
public:
                     CMcpFuncChartDouble() : CMcpFunction(0, false, "chart_double") {}
                    ~CMcpFuncChartDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();

//---
  if(param.HasKey("value"))
   {
    if(ChartSetDouble(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToDouble()))
     {
      res = "{\"ok\":true,\"result\":true}";
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error set chart double, last mt5 err = %d\"}", ::GetLastError());
     }
   }
  else
   {
    double v;
    if(ChartGetDouble(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_DOUBLE>(param["property"].ToString(""), WRONG_VALUE), (int)param["sub_window"].ToInt(0), v))
     {
      res = StringFormat("{\"ok\":true,\"result\":%.8f}", v);
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error chart get double, last err = %d\"}", ::GetLastError());
     }
   }
//---
 }


//+------------------------------------------------------------------+
//| chart_string                                                     |
//+------------------------------------------------------------------+
class CMcpFuncChartString : public CMcpFunction
 {
public:
                     CMcpFuncChartString() : CMcpFunction(0, false, "chart_string") {}
                    ~CMcpFuncChartString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();

//---
  if(param.HasKey("value"))
   {
    if(ChartSetString(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), param["value"].ToString()))
     {
      res = "{\"ok\":true,\"result\":true}";
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error set chart string, last mt5 err = %d\"}", ::GetLastError());
     }
   }
  else
   {
    string v;
    if(ChartGetString(param["chart_id"].ToInt(0), CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_STRING>(param["property"].ToString(""), WRONG_VALUE), v))
     {
      res = "{\"ok\":true,\"result\":\"" + v + "\"}";
     }
    else
     {
      res = StringFormat("{\"ok\":false,\"error\":\"Error chart get string, last err = %d\"}", ::GetLastError());
     }
   }
//---
 }

//+------------------------------------------------------------------+
//| chart_redraw                                                     |
//+------------------------------------------------------------------+
class CMcpFuncChartRedraw : public CMcpFunction
 {
public:
                     CMcpFuncChartRedraw() : CMcpFunction(0, false, "chart_redraw") {}
                    ~CMcpFuncChartRedraw(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartRedraw::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
//---
  ChartRedraw(param["chart_id"].ToInt(0));
//---
  res = "{\"ok\":true,\"result\":\"okey\"}";
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_CHARTS_CHARTS_MQH
