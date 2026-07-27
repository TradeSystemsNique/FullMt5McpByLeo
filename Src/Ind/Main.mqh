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
                     CHashMapFast(string, long)  m_indicators;
  double             m_buffer[];

public:
                     CMcpFuncInd(void) : CMcpFunction(0, false, "indicator_manage") { ArraySetAsSeries(m_buffer, true); }
                    ~CMcpFuncInd(void)
   {
    long meta[];
    const int t = m_indicators.GetValues(meta, 0);
    for(int i = 0; i < t; i++)
     {
      IndicatorRelease(int(meta[i] & MCPFUNCIND_MASK_HANDLE));
     }
   }

  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncInd::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const ENUM_MCPFUNC_IND_ACTION mode = CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_IND_ACTION>(param["mode"].ToString(""), WRONG_VALUE);;
  switch(mode)
   {
    case MCPFUNC_IND_ACTION_CREATE:
     {
      const string name = param["indicator_alias_name"].ToString("");
      if(m_indicators.Contains(name))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias '%s' is register in dict", name));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
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

      //---
      if(t > 0)
       {
        CJsonIteratorArray it = parametros.BeginArr();
        int k = 0;

        //---
        while(it.IsValid())
         {
          CJsonNode parametro = it.Val();
          if(!parametro["value"].ToMqlParam(params[k], parametro["data_type"].ToString("TYPE_STRING")))
           {
            m_shared_builder.PutChar('"');
            m_shared_builder.Obj();
            m_shared_builder.KeyWV("ok").Val(false);
            m_shared_builder.KeyWV("result").ValSWV(StringFormat("Failed convert param = %d to mql param", k));
            m_shared_builder.EndObj();
            m_shared_builder.PutChar('"');
            return;
           }

          //---
          k++;
          it.Next();
         }
       }

      ::ResetLastError();
      const int handle = IndicatorCreate(symbol, tf, type, t, params);
      if(handle == INVALID_HANDLE)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        if(type == IND_CUSTOM)
         {
          m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias '%s' cannot created, last mql5 error = %d, Since it is custom, verify that the first parameter contains the path of the indicator for its relative loading to the folder. Indicators\\\\",
                                                name, ::GetLastError()));
         }
        else
         {
          m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias '%s' cannot created, last mql5 error = %d",
                                                name, ::GetLastError()));
         }
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      else
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator %s successfully created, with handle = %d", name, handle));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        long meta = long(handle) | long(type) << 32;
        m_indicators.Add(name, meta);
       }
      break;
     }

    case MCPFUNC_IND_ACTION_TOTAL:
     {
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(m_indicators.Count());
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    case MCPFUNC_IND_ACTION_GET_HANDLES_NAMES:
     {
      long metas[];
      string names[];
      const int c = m_indicators.CopyTo(names, metas);
      if(c < 1)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Arr();
        m_shared_builder.EndArr();
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Arr();
      for(int i = 0; i < c; i++)
       {
        m_shared_builder.Obj();
        m_shared_builder.Key(names[i]).Val(int(metas[i] & MCPFUNCIND_MASK_HANDLE));
        m_shared_builder.EndObj();
       }

      //---
      m_shared_builder.EndArr();
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    case MCPFUNC_IND_ACTION_REMOVE:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s, It does not exist in the dict",
                                              name));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      if(!m_indicators.Remove(name))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s and handle = %d, failed to removed from dict",
                                              name, handle));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      ::ResetLastError();
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      if(IndicatorRelease(handle))
       {
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s and handle = %d, removed from dict and released",
                                              name, handle));
       }
      else
       {
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s and handle = %d, removed from dict but IndicatorRelease failed, last mistake in MT5 = %d"
                                              ,  name, handle, ::GetLastError()));
       }
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    case MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s, It does not exist in the dict",
                                              name));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Val(handle);
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }

    case MCPFUNC_IND_ACTION_GET_PARAMETERS:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s, It does not exist in the dict",
                                              name));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
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
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Error get parameters of = %s, last mql5 error = %d", name, ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok");
      m_shared_builder.Val(true);
      m_shared_builder.KeyWV("result");
      m_shared_builder.Arr();

      //---
      for(int k = 0; k < t; k++)
       {
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("data_type");
        m_shared_builder.ValSWV(EnumToString(params[k].type));
        m_shared_builder.KeyWV("value");

        //---
        switch(params[k].type)
         {
          case TYPE_BOOL:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_CHAR:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_UCHAR:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_SHORT:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_USHORT:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_COLOR:
            m_shared_builder.ValSNoRefWV(string(color(params[k].integer_value)));
            break;
          case TYPE_INT:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_UINT:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_DATETIME:
            m_shared_builder.ValSNoRefWV(string(datetime(params[k].integer_value)));
            break;
          case TYPE_LONG:
          case TYPE_ULONG:
            m_shared_builder.Val(params[k].integer_value);
            break;
          case TYPE_FLOAT:
            m_shared_builder.Val(params[k].double_value);
            break;
          case TYPE_DOUBLE:
            m_shared_builder.Val(params[k].double_value);
            break;
          case TYPE_STRING:
            m_shared_builder.ValS(params[k].string_value);
            break;
          default:
            m_shared_builder.ValS(params[k].string_value);
            break;
         }
        m_shared_builder.EndObj();
       }

      //---
      m_shared_builder.EndArr();
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
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
          // Nota: en el código original este mensaje se calculaba pero luego
          // siempre era sobrescrito por el resultado final de éxito (no había return).
          // Se preserva ese comportamiento (posible bug preexistente) tal cual.
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
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s and handle = %d, added to dict",
                                            name, handle));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
     }
    case MCPFUNC_IND_ACTION_COPYBUFFER:
     {
      const string name = param["indicator_alias_name"].ToString("");
      long meta;
      if(!m_indicators.TryGet(name, meta))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s, It does not exist in the dict",
                                              name));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      const int handle = int(meta & MCPFUNCIND_MASK_HANDLE);

      //---
      ::ResetLastError();
      const int t = CopyBuffer(handle, (int)param["buffer_num"].ToInt(0),
                               (int)param["start_pos"].ToInt(0), (int)param["count"].ToInt(1), m_buffer);
      if(t == -1)
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("result").ValS(StringFormat("Indicator with alias = %s, Failed in copy buffer, last mt5 err = %d",
                                              name, ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }

      //---
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(true);
      m_shared_builder.KeyWV("result").Arr();
      for(int i = 0; i < t; i++)
       {
        m_shared_builder.Val(m_buffer[i]);
       }
      m_shared_builder.EndArr();
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
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
}
#endif // FULLMT5MCPBYLEO_SRC_IND_MAIN_MQH
//+------------------------------------------------------------------+
