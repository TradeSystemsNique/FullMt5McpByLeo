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
//| Include                                                          |
//+------------------------------------------------------------------+
#include <TSN\\ExtraCodes\\MTTester.mqh>
#include <TSN\\ExtraCodes\\TST.mqh>

#include <TSN\\MQLArticles\\Utils\\EnumReg.mqh>
#include <TSN\\MQLArticles\\Utils\\ErrDescription.mqh>

#include <TSN\\ExtraCodes\\RunnerProtDef.mqh>

//---
#include <TSN\\Mcp\\Main.mqh>
#include <TSN\\ExtraCodes\\Expert.mqh>
#include <TSN\\ExtraCodes\\Func.mqh>
#include <TSN\\MQLArticles\\RM\\LoteSizeCalc.mqh>

//--- TBP ID
#include <TSN\\ConfigIdTbp.mqh>
#include <TSN\\MQLArticles\\Utils\\DictT.mqh>

#include "..\\EnumReg\\Main.mqh"

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
#define MCPFUNC_SETGET_DOUBLE  0
#define MCPFUNC_SETGET_INTEGER 1
#define MCPFUNC_SETGET_STRING  2

//---
enum ENUM_MCPFUNC_CHARTIND_DEF
 {
  MCPFUNC_CHARTIND_TOTAL,
  MCPFUNC_CHARTIND_SHORT_NAME,
  MCPFUNC_CHARTIND_ADD,
  MCPFUNC_CHARTIND_DELETE
 };

//---
enum ENUM_MCPFUNC_IND_ACTION
 {
  MCPFUNC_IND_ACTION_CREATE,
  MCPFUNC_IND_ACTION_TOTAL,
  MCPFUNC_IND_ACTION_GET_HANDLES_NAMES,
  MCPFUNC_IND_ACTION_REMOVE,
  MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME,
  MCPFUNC_IND_ACTION_GET_PARAMETERS,
  MCPFUNC_IND_ACTION_ADD
 };

//---
enum ENUM_MCPFUNC_TYPE_TIME
 {
  MCPFUNC_TIME_GMT = 0, // Hora GMT (Greenwich Mean Time)
  MCPFUNC_TIME_CURRENT = 1,  // Hora actual del symbolo (TimeCurrent)
  MCPFUNC_TIME_LOCAL = 2,  // Hora local de la máquina
  MCPFUNC_TIME_SERVER = 3   // Hora del servidor (Trader Server Time)
 };

//---
#endif // FULLMT5MCPBYLEO_SRC_DEF_DEF_MQH 
