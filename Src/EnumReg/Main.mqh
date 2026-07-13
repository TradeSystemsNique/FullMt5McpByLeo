//+------------------------------------------------------------------+
//|                                                         Main.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                                            https://www.mql5.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_ENUMREG_MAIN_MQH
#define FULLMT5MCPBYLEO_SRC_ENUMREG_MAIN_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "Table.mqh"
#include <TSN\\MQLArticles\\Utils\\EnumTemplate.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
TSN_MQLARTICLES_ENUM_REG_TEM(FullMt5Mcp, g_fullmt5mcpbyleo_enum_reg_seeds, g_fullmt5mcpbyleo_enum_reg_values, g_fullmt5mcpbyleo_enum_reg_hashes, FULLMTCPMCP_ENUMREG_BUCKET_SIZE, FULLMTCPMCP_ENUMREG_TABLE_SIZE)

// Mod val..
static bool CEnumRegFullMt5Mcp::RunDinyamics(void)
 {
  return true;
 }
}
#endif // FULLMT5MCPBYLEO_SRC_ENUMREG_MAIN_MQH