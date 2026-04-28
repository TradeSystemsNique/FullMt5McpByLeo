//+------------------------------------------------------------------+
//|                                                          Def.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_DEF_DEF_MQH
#define FULLMT5MCPBYLEO_SRC_DEF_DEF_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//--- Position
#define MQLARTICLES_ENUMREG_ENUM_POSITION_PROPERTY_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_POSITION_PROPERTY_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_POSITION_PROPERTY_STRING

//--- Order
#define MQLARTICLES_ENUMREG_ENUM_ORDER_PROPERTY_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_ORDER_PROPERTY_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_ORDER_PROPERTY_STRING

//--- Deal
#define MQLARTICLES_ENUMREG_ENUM_DEAL_PROPERTY_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_DEAL_PROPERTY_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_DEAL_PROPERTY_STRING

//--- Object
#define MQLARTICLES_ENUMREG_ENUM_OBJECT_PROPERTY_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_OBJECT_PROPERTY_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_OBJECT_PROPERTY_STRING

//--- Symbol
#define MQLARTICLES_ENUMREG_ENUM_SYMBOL_INFO_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_SYMBOL_INFO_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_SYMBOL_INFO_STRING

//--- Chart
#define MQLARTICLES_ENUMREG_ENUM_CHART_PROPERTY_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_CHART_PROPERTY_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_CHART_PROPERTY_STRING

//--- Type order time
#define MQLARTICLES_ENUMREG_ENUM_ORDER_TYPE_TIME
#define MQLARTICLES_ENUMREG_ENUM_OBJECT

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <TSN\\ExtraCodes\\RunnerProtDef.mqh>
#include <TSN\\MQLArticles\\Utils\\EnumReg.mqh>
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_EVERY_TICK)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_OCHLM1)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_ONLY_OPEN)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_REAL_TICK)
 
//---
#include <TSN\\Mcp\\Main.mqh>
#include <Trade\\Trade.mqh>
#include <TSN\\ExtraCodes\\Expert.mqh>
#include <TSN\\ExtraCodes\\Func.mqh>


//---
#endif // FULLMT5MCPBYLEO_SRC_DEF_DEF_MQH 