//+------------------------------------------------------------------+
//|                                                       Objects.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_GRAPHICS_OBJECTS_MQH
#define FULLMT5MCPBYLEO_SRC_GRAPHICS_OBJECTS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
//+------------------------------------------------------------------+
//| object_create                                                    |
//+------------------------------------------------------------------+
class CMcpFuncObjectCreate  : public CMcpFunction
 {
public:
                     CMcpFuncObjectCreate(void) : CMcpFunction(0, false, "object_create") {}
                    ~CMcpFuncObjectCreate(void) {}
  //---
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectCreate::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  const uint8_t mode = (uint8_t)param["mode"].ToInt(0);
  switch(mode)
   {
    //---
    case  0: // time1,price1,time2,price2,time3,price3 (chanel\elipse\triangle)
     {
      if(!ObjectCreate(param["chart_id"].ToInt(0), param["object_name"].ToString(""),
                       CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), WRONG_VALUE), int(param["sub_window"].ToInt(0)),
                       StringToTime(param["time1"].ToString("0")), param["price1"].ToDouble(0.00), StringToTime(param["time2"].ToString("0")), param["price2"].ToDouble(0.00),
                       StringToTime(param["time3"].ToString("0")), param["price3"].ToDouble(0.00)
                      ))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_create failed, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    //---
    case  1: // time1,price1,time2,price2 (rectangle|fibbo|)
     {
      if(!ObjectCreate(param["chart_id"].ToInt(0), param["object_name"].ToString(""),
                       CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), WRONG_VALUE), int(param["sub_window"].ToInt(0)),
                       StringToTime(param["time1"].ToString("0")), param["price1"].ToDouble(0.00), StringToTime(param["time2"].ToString("0")), param["price2"].ToDouble(0.00)))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_create failed, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    //---
    case 2: // time1,price1 (arrow\buttom|vline|hline)
     {
      if(!ObjectCreate(param["chart_id"].ToInt(0), param["object_name"].ToString(""),
                       CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), WRONG_VALUE), int(param["sub_window"].ToInt(0)),
                       StringToTime(param["time1"].ToString("0")), param["price1"].ToDouble(0.00)))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_create failed, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    //---
    case 3: // RectLabel\Buttom\Edit (va sin nada se setea con ObjectSetInteger.)
     {
      if(!ObjectCreate(param["chart_id"].ToInt(0), param["object_name"].ToString(""),
                       CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), WRONG_VALUE), int(param["sub_window"].ToInt(0)),
                       0, 0.00))
       {
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(false);
        m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_create failed, last mt5 error = %d", ::GetLastError()));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
        return;
       }
      break;
     }

    //---
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("result").ValSWV("Type of mode to create the invalid object");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Val(true);
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
//| object_delete                                                    |
//+------------------------------------------------------------------+
class CMcpFuncObjectDelete : public CMcpFunction
 {
public:
                     CMcpFuncObjectDelete() : CMcpFunction(0, false, "object_delete") {}
                    ~CMcpFuncObjectDelete(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectDelete::Run(CJsonNode & param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();

//---
  if(!ObjectDelete(param["chart_id"].ToInt(0), param["object_name"].ToString("")))
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_delete failed, last mt5 error = %d", ::GetLastError()));
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
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncObjectSetGet : public CMcpFunction
 {
public:
                     CMcpFuncObjectSetGet(void) : CMcpFunction(0, false, "object_set_get") {}
                    ~CMcpFuncObjectSetGet(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
void CMcpFuncObjectSetGet::Run(CJsonNode & param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  const int mode = (int)param["mode"].ToInt(-1);
  switch(mode)
   {
    case MCPFUNC_SETGET_DOUBLE:
     {
      ::ResetLastError();
      const ENUM_OBJECT_PROPERTY_DOUBLE property = CEnumRegBasis::GetValNoRef<ENUM_OBJECT_PROPERTY_DOUBLE>(param["property"].ToString(""), OBJPROP_PRICE);

      //---
      if(param.HasKey("value"))
       {
        // SET mode
        ::ResetLastError();
        const bool result = ObjectSetDouble(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0), param["value"].ToDouble(0.0));
        if(!result)
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_set_double failed, last mt5 error = %d", ::GetLastError()));
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
      else
       {
        // GET mode
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(ObjectGetDouble(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    case MCPFUNC_SETGET_INTEGER:
     {
      ::ResetLastError();
      const ENUM_OBJECT_PROPERTY_INTEGER property = CEnumRegBasis::GetValNoRef<ENUM_OBJECT_PROPERTY_INTEGER>(param["property"].ToString(""), OBJPROP_COLOR);

      //---
      if(param.HasKey("value"))
       {
        // SET mode
        ::ResetLastError();
        const bool result = ObjectSetInteger(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0), param["value"].ToInt(0));
        if(!result)
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_set_integer failed, last mt5 error = %d", ::GetLastError()));
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
      else
       {
        // GET mode
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").Val(ObjectGetInteger(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    case MCPFUNC_SETGET_STRING:
     {
      ::ResetLastError();
      const ENUM_OBJECT_PROPERTY_STRING property = CEnumRegBasis::GetValNoRef<ENUM_OBJECT_PROPERTY_STRING>(param["property"].ToString(""), OBJPROP_NAME);

      //---
      if(param.HasKey("value"))
       {
        // SET mode
        ::ResetLastError();
        const bool result = ObjectSetString(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0), param["value"].ToString(""));
        if(!result)
         {
          m_shared_builder.PutChar('"');
          m_shared_builder.Obj();
          m_shared_builder.KeyWV("ok").Val(false);
          m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_set_string failed, last mt5 error = %d", ::GetLastError()));
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
      else
       {
        // GET mode
        m_shared_builder.PutChar('"');
        m_shared_builder.Obj();
        m_shared_builder.KeyWV("ok").Val(true);
        m_shared_builder.KeyWV("result").ValS(ObjectGetString(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
        m_shared_builder.EndObj();
        m_shared_builder.PutChar('"');
       }
      break;
     }
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("result").ValSWV("Invalid mode");
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      break;
   }
 }

//+------------------------------------------------------------------+
//| object_list                                                      |
//+------------------------------------------------------------------+
class CMcpFuncObjectList : public CMcpFunction
 {
public:
                     CMcpFuncObjectList() : CMcpFunction(0, false, "object_list") {}
                    ~CMcpFuncObjectList(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectList::Run(CJsonNode & param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();

//---
  const long chart_id = param["chart_id"].ToInt(0);
  const int sub_window = (int)param["sub_window"].ToInt(-1);
  const int type = int(CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), -1));

//---
  const int total = ObjectsTotal(chart_id, sub_window, type);

  if(total < 0)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("object_list failed, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  for(int i = 0; i < total; i++)
   {
    m_shared_builder.ValS(ObjectName(chart_id, i, sub_window));
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_GRAPHICS_OBJECTS_MQH

//+------------------------------------------------------------------+
