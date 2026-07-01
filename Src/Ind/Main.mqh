//+------------------------------------------------------------------+
//|                                                         Main.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                                            https://www.mql5.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_IND_MAIN_MQH
#define FULLMT5MCPBYLEO_SRC_IND_MAIN_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{

#define MCPFUNCIND_MASK_HANDLE (0xFFFFFFFF)

//+------------------------------------------------------------------+
//| indicator_manage                                                 |
//+------------------------------------------------------------------+
class CMcpFuncInd : public CMcpFunction
 {
private:
  CDictSValue<long>  m_indicators;
  CJsonBuilder       m_builder;
  double             m_buffer[];

public:
                     CMcpFuncInd(void) : CMcpFunction(0, false, "indicator_manage") { ArraySetAsSeries(m_buffer, true); }
                    ~CMcpFuncInd(void)
   {
    long meta[];
    string keys[];
    const int t = m_indicators.GetValues(meta, keys);
    for(int i = 0; i < t; i++)
     {
      IndicatorRelease(int(meta[i] & MCPFUNCIND_MASK_HANDLE));
     }
   }

  //---
  void               Run(CJsonNode& param, string& res) override final;
 };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncInd::Run(CJsonNode &param, string &res)
 {
  const ENUM_MCPFUNC_IND_ACTION mode = CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_IND_ACTION>(param["mode"].ToString(""), WRONG_VALUE);;
  switch(mode)
   {
    case MCPFUNC_IND_ACTION_CREATE:
     {
      const string name = param["indicator_alias_name"].ToString("");
      if(m_indicators.Contains(name))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias '%s' is register in dict\"}", name);
        return;
       }

      const ENUM_INDICATOR type = CEnumRegBasis::GetValNoRef<ENUM_INDICATOR>(param["ind_type"].ToString(""), WRONG_VALUE);
      const string symbol = param["symbol"].ToString(_Symbol);
      const ENUM_TIMEFRAMES tf = CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period);

      //---
      MqlParam params[];
      CJsonNode parametros =  param["params"];
      const int t = parametros.Size();
      ArrayResize(params, t);
      CJsonIteratorArray it = parametros.BeginArr();
      int k = 0;

      //---
      while(it.IsValid())
       {
        CJsonNode parametro = it.Val();
        params[k].type = CEnumRegBasis::GetValNoRef<ENUM_DATATYPE>(parametro["data_type"].ToString(), TYPE_STRING);

        //---
        switch(params[k].type)
         {
          case TYPE_BOOL:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_CHAR:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_UCHAR:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_SHORT:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_USHORT:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_COLOR:
            params[k].integer_value = long(color(parametro["value"].ToString("")));
            break;
          case TYPE_INT:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_UINT:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_DATETIME:
            params[k].integer_value = long(datetime(parametro["value"].ToString("0")));
            break;
          case TYPE_LONG:
          case TYPE_ULONG:
            params[k].integer_value = parametro["value"].ToInt(0);
            break;
          case TYPE_FLOAT:
            params[k].double_value = parametro["value"].ToDouble(0.00);
            break;
          case TYPE_DOUBLE:
            params[k].double_value = parametro["value"].ToDouble(0.00);
            break;
          case TYPE_STRING:
            params[k].string_value = parametro["value"].ToString("");
            break;
          default:
            params[k].string_value = parametro["value"].ToString("");
            break;
         }
        k++;
        it.Next();
       }

      ::ResetLastError();
      const int handle = IndicatorCreate(symbol, tf, type, t, params);
      if(handle == INVALID_HANDLE)
       {
        if(type == IND_CUSTOM)
         {
          res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias '%s' cannot created, last mql5 error = %d, Since it is custom, verify that the first parameter contains the path of the indicator for its relative loading to the folder. Indicators\\\\\"}",
                             name, ::GetLastError());
         }
        else
         {
          res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias '%s' cannot created, last mql5 error = %d\"}",
                             name, ::GetLastError());
         }
       }
      else
       {
        res = StringFormat("{\"ok\":true,\"result\":\"Indicator %s successfully created, with handle = %d\"}", name, handle);
        long meta = long(handle) | long(type) << 32;
        m_indicators.Add(name, meta);
       }
      break;
     }

    case MCPFUNC_IND_ACTION_TOTAL:
     {
      res = "{\"ok\":true,\"result\":" + string(m_indicators.Count()) +  "}";
      break;
     }

    case MCPFUNC_IND_ACTION_GET_HANDLES_NAMES:
     {
      long metas[];
      string names[];
      const int c = m_indicators.GetValues(metas, names);
      if(c < 1)
       {
        res = "{\"ok\":true,\"result\":[]}";
        return;
       }

      //---
      res = "{\"ok\":true,\"result\":[";
      for(int i = 0; i < c; i++)
       {
        res += "{";
        res += "\"" + names[i] + "\":";
        res += string(int(metas[i] & MCPFUNCIND_MASK_HANDLE));
        res += "}";
       }

      //---
      res += "]}";
      break;
     }

    case MCPFUNC_IND_ACTION_REMOVE:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s, It does not exist in the dict\"}",
                           name);
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      if(m_indicators.Remove(name))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s and handle = %d, failed to removed from dict\"}",
                           name, handle);
        return;
       }

      ::ResetLastError();
      if(IndicatorRelease(handle))
       {
        res = StringFormat("{\"ok\":true,\"result\":\"Indicator with alias = %s and handle = %d, removed from dict and released\"}",
                           name, handle);
       }
      else
       {
        res = StringFormat("{\"ok\":true,\"result\":\"Indicator with alias = %s and handle = %d, removed from dict but IndicatorRelease failed, last mistake in MT5 = %d\"}"
                           ,  name, handle, ::GetLastError());
       }
      break;
     }

    case MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s, It does not exist in the dict\"}",
                           name);
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      res = "{\"ok\":true,\"result\":" + string(handle) +  "}";
      break;
     }

    case MCPFUNC_IND_ACTION_GET_PARAMETERS:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s, It does not exist in the dict\"}",
                           name);
        return;
       }

      //---
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);


      //---
      MqlParam params[];
      ENUM_INDICATOR type;
      ::ResetLastError();
      const int t = IndicatorParameters(handle, type, params);
      if(t == -1)
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Error get parameters of = %s, last mql5 error = %d\"}", name, ::GetLastError());
        return;
       }

      //---
      m_builder.Clear();
      m_builder.Obj();
      m_builder.Key("ok");
      m_builder.Val(true);
      m_builder.Key("result");
      m_builder.Arr();

      //---
      for(int k = 0; k < t; k++)
       {
        m_builder.Obj();
        m_builder.Key("data_type");
        m_builder.ValSNoRef(EnumToString(params[k].type));
        m_builder.Key("value");

        //---
        switch(params[k].type)
         {
          case TYPE_BOOL:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_CHAR:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_UCHAR:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_SHORT:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_USHORT:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_COLOR:
            m_builder.ValSNoRef(string(color(params[k].integer_value)));
            break;
          case TYPE_INT:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_UINT:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_DATETIME:
            m_builder.ValSNoRef(string(datetime(params[k].integer_value)));
            break;
          case TYPE_LONG:
          case TYPE_ULONG:
            m_builder.Val(params[k].integer_value);
            break;
          case TYPE_FLOAT:
            m_builder.Val(params[k].double_value);
            break;
          case TYPE_DOUBLE:
            m_builder.Val(params[k].double_value);
            break;
          case TYPE_STRING:
            m_builder.ValS(params[k].string_value);
            break;
          default:
            m_builder.ValS(params[k].string_value);
            break;
         }
        m_builder.EndObj();
       }

      //---
      m_builder.EndArr().EndObj();
      res = m_builder.Build();
      break;
     }

    case MCPFUNC_IND_ACTION_ADD:
     {
      const int handle = (int)param["indicator_handle"].ToInt(-1);
      const ENUM_INDICATOR type = CEnumRegBasis::GetValNoRef<ENUM_INDICATOR>(param["ind_type"].ToString(""), WRONG_VALUE);
      const string name = param["indicator_alias_name"].ToString("");
      const bool re = param["forze_add"].ToBool(false);

      //---
      if(m_indicators.Contains(name))
       {
        if(!re)
         {
          res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias '%s' is register in dict, use forze_add=true, If you want to replace it\"}",
                             name);
         }
        else
         {
          m_indicators.Remove(name);
         }
       }

      //---
      long meta = long(handle) | long(type) << 32;
      m_indicators.Add(name, meta);

      //---
      res = StringFormat("{\"ok\":true,\"result\":\"Indicator with alias = %s and handle = %d, added to dict\"}",
                         name, handle);
      break;
     }
    case MCPFUNC_IND_ACTION_COPYBUFFER:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s, It does not exist in the dict\"}",
                           name);
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      //---
      ::ResetLastError();
      const int t = CopyBuffer(handle, (int)param["buffer_num"].ToInt(0),
                               (int)param["start_pos"].ToInt(0), (int)param["count"].ToInt(1), m_buffer);
      if(t == -1)
       {
        res = StringFormat("{\"ok\":false,\"result\":\"Indicator with alias = %s, Failed in copy buffer, last mt5 err = %d\"}",
                           name, ::GetLastError());
        return;
       }

      //---
      res = "{\"ok\":true,\"result\":[";
      const int last = t - 1;
      for(int i = 0; i < last; i++)
       {
        res += string(m_buffer[i]) + ",";
       }
      res += string(m_buffer[last]) + "]}";
      break;
     }
    default:
      res = "{\"ok\":false,\"error\":\"Error, invalid mode\"}";
      break;
   }
 }
//+------------------------------------------------------------------+
}
#endif // FULLMT5MCPBYLEO_SRC_IND_MAIN_MQH
//+------------------------------------------------------------------+
