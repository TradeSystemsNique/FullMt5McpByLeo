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
  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectCreate::Run(CJsonNode &param, string &res)
 {
//---
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
        res = StringFormat("{\"ok\":false,\"error\":\"object_create failed, last mt5 error = %d\"}", ::GetLastError());
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
        res = StringFormat("{\"ok\":false,\"error\":\"object_create failed, last mt5 error = %d\"}", ::GetLastError());
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
        res = StringFormat("{\"ok\":false,\"error\":\"object_create failed, last mt5 error = %d\"}", ::GetLastError());
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
        res = StringFormat("{\"ok\":false,\"error\":\"object_create failed, last mt5 error = %d\"}", ::GetLastError());
        return;
       }
      break;
     }

    //---
    default:
      res = "{\"ok\":false,\"result\":\"Type of mode to create the invalid object\"}";
      return;
   }

//---
  res = "{\"ok\":true,\"result\":true}";
 }

//+------------------------------------------------------------------+
//| object_delete                                                    |
//+------------------------------------------------------------------+
class CMcpFuncObjectDelete : public CMcpFunction
 {
public:
                     CMcpFuncObjectDelete() : CMcpFunction(0, false, "object_delete") {}
                    ~CMcpFuncObjectDelete(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectDelete::Run(CJsonNode & param, string & res)
 {
  ::ResetLastError();

//---
  if(!ObjectDelete(param["chart_id"].ToInt(0), param["object_name"].ToString("")))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"object_delete failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = "{\"ok\":true,\"result\":true}";
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncObjectSetGet : public CMcpFunction
 {
public:
                     CMcpFuncObjectSetGet(void) : CMcpFunction(0, false, "object_set_get") {}
                    ~CMcpFuncObjectSetGet(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };


//+------------------------------------------------------------------+
void CMcpFuncObjectSetGet::Run(CJsonNode & param, string & res)
 {
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
          res = StringFormat("{\"ok\":false,\"error\":\"object_set_double failed, last mt5 error = %d\"}", ::GetLastError());
          return;
         }
        res = "{\"ok\":true,\"result\":true}";
       }
      else
       {
        // GET mode
        res = StringFormat("{\"ok\":true,\"result\":%.8f}", ObjectGetDouble(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
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
          res = StringFormat("{\"ok\":false,\"error\":\"object_set_integer failed, last mt5 error = %d\"}", ::GetLastError());
          return;
         }
        res = "{\"ok\":true,\"result\":true}";
       }
      else
       {
        // GET mode
        res = StringFormat("{\"ok\":true,\"result\":%I64d}", ObjectGetInteger(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
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
          res = StringFormat("{\"ok\":false,\"error\":\"object_set_string failed, last mt5 error = %d\"}", ::GetLastError());
          return;
         }
        res = "{\"ok\":true,\"result\":true}";
       }
      else
       {
        // GET mode
        res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", ObjectGetString(param["chart_id"].ToInt(0), param["object_name"].ToString(""), property, (int)param["prop_modifier"].ToInt(0)));
       }
      break;
     }
    default:
      res = "{\"ok\":false,\"result\":\"Invalid mode\"}";
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

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncObjectList::Run(CJsonNode & param, string & res)
 {
  ::ResetLastError();

//---
  const long chart_id = param["chart_id"].ToInt(0);
  const int sub_window = (int)param["sub_window"].ToInt(-1);
  const int type = int(CEnumRegBasis::GetValNoRef<ENUM_OBJECT>(param["object_type"].ToString(), -1));

//---
  const int total = ObjectsTotal(chart_id, sub_window, type);

  if(total < 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"object_list failed, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  res = "{\"ok\":true,\"result\":[";
  for(int i = 0; i < total; i++)
   {
    if(i == total - 1)
      res += "\"" + ObjectName(chart_id, i, sub_window) + "\"";
    else
      res +=  "\"" + ObjectName(chart_id, i, sub_window) + "\",";
   }
  res += "]}";
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_GRAPHICS_OBJECTS_MQH

//+------------------------------------------------------------------+
