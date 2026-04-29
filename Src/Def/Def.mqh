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


//---
#define MQLARTICLES_ENUMREG_ENUM_ORDER_TYPE
#define MQLARTICLES_ENUMREG_ENUM_DAY_OF_WEEK

//---
#define MQLARTICLES_ENUMREG_ENUM_ACCOUNT_INFO_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_ACCOUNT_INFO_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_ACCOUNT_INFO_STRING

//---
#define MQLARTICLES_ENUMREG_ENUM_TERMINAL_INFO_INTEGER
#define MQLARTICLES_ENUMREG_ENUM_TERMINAL_INFO_DOUBLE
#define MQLARTICLES_ENUMREG_ENUM_TERMINAL_INFO_STRING


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_MCPFUNC_COPY_DATA
 {
  MCPFUNC_COPY_DATA_CLOSE = 0,
  MCPFUNC_COPY_DATA_OPEN = 1,
  MCPFUNC_COPY_DATA_HIGH = 2,
  MCPFUNC_COPY_DATA_LOW = 3,
  MCPFUNC_COPY_DATA_TICK_VOLUME = 4,
  MCPFUNC_COPY_DATA_REAL_VOLUME = 5,
  MCPFUNC_COPY_DATA_TIME = 6,
  MCPFUNC_COPY_DATA_SPREAD = 7
 };

//---
enum ENUM_MCPFUNC_TYPE_TIME
 {
  MCPFUNC_TIME_GMT = 0, // Hora GMT (Greenwich Mean Time)
  MCPFUNC_TIME_CURRENT = 1,  // Hora actual del symbolo (TimeCurrent)
  MCPFUNC_TIME_LOCAL = 2,  // Hora local de la máquina
  MCPFUNC_TIME_SERVER = 3   // Hora del servidor (Trader Server Time)
 };


//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <TSN\\ExtraCodes\\RunnerProtDef.mqh>
#include <TSN\\MQLArticles\\Utils\\EnumReg.mqh>
#include <TSN\\MQLArticles\\Utils\\ErrDescription.mqh>
//---
MQLARTICLES_ENUMREG_REG(MCPFUNC_TIME_GMT)
MQLARTICLES_ENUMREG_REG(MCPFUNC_TIME_CURRENT)
MQLARTICLES_ENUMREG_REG(MCPFUNC_TIME_LOCAL)
MQLARTICLES_ENUMREG_REG(MCPFUNC_TIME_SERVER)

//---
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_EVERY_TICK)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_OCHLM1)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_ONLY_OPEN)
MQLARTICLES_ENUMREG_REG(MTTESTER_MODELADO_REAL_TICK)

//---
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_CLOSE)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_OPEN)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_HIGH)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_LOW)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_TICK_VOLUME)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_REAL_VOLUME)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_TIME)
MQLARTICLES_ENUMREG_REG(MCPFUNC_COPY_DATA_SPREAD)

//---
#include <TSN\\Mcp\\Main.mqh>
#include <TSN\\ExtraCodes\\Expert.mqh>
#include <TSN\\ExtraCodes\\Func.mqh>
#include <TSN\\MQLArticles\\RM\\LoteSizeCalc.mqh>


//---
#endif // FULLMT5MCPBYLEO_SRC_DEF_DEF_MQH 
