//+------------------------------------------------------------------+
//|                                                          def.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                                            https://www.mql5.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/"
#property strict

#include <TSN\\MQLArticles\\Utils\\EnumRec.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// Incluimos enums donde estan todo..
#include "..\\..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MQLARTICLES_ENUMREC_REG(MCPFUNC_TIME_GMT)
MQLARTICLES_ENUMREC_REG(MCPFUNC_TIME_CURRENT)
MQLARTICLES_ENUMREC_REG(MCPFUNC_TIME_LOCAL)
MQLARTICLES_ENUMREC_REG(MCPFUNC_TIME_SERVER)

//---
MQLARTICLES_ENUMREC_REG(MTTESTER_MODELADO_EVERY_TICK)
MQLARTICLES_ENUMREC_REG(MTTESTER_MODELADO_OCHLM1)
MQLARTICLES_ENUMREC_REG(MTTESTER_MODELADO_ONLY_OPEN)
MQLARTICLES_ENUMREC_REG(MTTESTER_MODELADO_REAL_TICK)

//---
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_CLOSE)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_OPEN)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_HIGH)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_LOW)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_TICK_VOLUME)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_REAL_VOLUME)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_TIME)
MQLARTICLES_ENUMREC_REG(MCPFUNC_COPY_DATA_SPREAD)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_CREATE)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_TOTAL)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_GET_HANDLES_NAMES)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_REMOVE)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_GET_PARAMETERS)
MQLARTICLES_ENUMREC_REG(MCPFUNC_IND_ACTION_ADD)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MQLARTICLES_ENUMREC_REG(MCPFUNC_CHARTIND_TOTAL)
MQLARTICLES_ENUMREC_REG(MCPFUNC_CHARTIND_SHORT_NAME)
MQLARTICLES_ENUMREC_REG(MCPFUNC_CHARTIND_ADD)
MQLARTICLES_ENUMREC_REG(MCPFUNC_CHARTIND_DELETE)

//+------------------------------------------------------------------+
