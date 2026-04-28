//+------------------------------------------------------------------+
//|                                                        Charts.mqh |
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
  long currChart, prevChart = ChartFirst();
  int i = 0, limit = 100;

  res = "{\"ok\":true,\"result\":[";

  if(prevChart >= 0)
   {
    res += StringFormat("%ld", prevChart);
    while(i < limit)
     {
      currChart = ChartNext(prevChart);
      if(currChart < 0) break;
      res += StringFormat(",%ld", currChart);
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
  const string symbol = param["symbol"].ToString(_Symbol);
  const ENUM_TIMEFRAMES timeframe = CEnumReg::GetValueNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToInt(), _Period);

//---
  const long chart_id = ChartOpen(symbol, timeframe);

//---
  if(chart_id == 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"chart_open failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%ld}", chart_id);
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
  const long chart_id = (long)param["chart_id"].ToInt(0);

//---
  const bool result = ChartClose(chart_id);

//---
  if(!result)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"chart_close failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%s}", result ? "true" : "false");
 }

//+------------------------------------------------------------------+
//| chart_get_integer                                                |
//+------------------------------------------------------------------+
class CMcpFuncChartGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncChartGetInteger() : CMcpFunction(0, false, "chart_get_integer") {}
                    ~CMcpFuncChartGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const long chart_id = (long)param["chart_id"].ToInt(0);
  const string property_str = param["property"].ToString("");
  const int sub_window = (int)param["sub_window"].ToInt(0);

//---
  const ENUM_CHART_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_INTEGER>(property_str, CHART_SCALE);
  const long value = ChartGetInteger(chart_id, property, sub_window);

//---
  res = StringFormat("{\"ok\":true,\"result\":%ld}", value);
 }

//+------------------------------------------------------------------+
//| chart_get_double                                                 |
//+------------------------------------------------------------------+
class CMcpFuncChartGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncChartGetDouble() : CMcpFunction(0, false, "chart_get_double") {}
                    ~CMcpFuncChartGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncChartGetDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const long chart_id = param["chart_id"].ToInt(0);
  const string property_str = param["property"].ToString("");
  const int sub_window = (int)param["sub_window"].ToInt(0);

//---
  const ENUM_CHART_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_CHART_PROPERTY_DOUBLE>(property_str, CHART_SHIFT_SIZE);
  const double value = ChartGetDouble(chart_id, property, sub_window);

//---
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", value);
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
  const long chart_id = param["chart_id"].ToInt(0);

//---
  ChartRedraw(chart_id);

//---
  res = StringFormat("{\"ok\":true,\"result\":\"okey\"}");
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_CHARTS_CHARTS_MQH
