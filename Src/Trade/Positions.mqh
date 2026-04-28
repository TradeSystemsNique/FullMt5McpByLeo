//+------------------------------------------------------------------+
//|                                                      Positions.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
#define FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//| position_get_total                                               |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetTotal : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetTotal() : CMcpFunction(0, false, "position_get_total") {}
                    ~CMcpFuncPositionGetTotal(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetTotal::Run(CJsonNode& param, string& res)
 {
  const uint total = PositionsTotal();
  res = StringFormat("{\"ok\":true,\"result\":%d}", total);
 }

//+------------------------------------------------------------------+
//| position_get_ticket                                              |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetTicket : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetTicket() : CMcpFunction(0, false, "position_get_ticket") {}
                    ~CMcpFuncPositionGetTicket(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetTicket::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const int index = (int)param["index"].ToInt(0);
  const ulong ticket = PositionGetTicket(index);

  if(ticket == 0)
   {
    res = StringFormat("{\"ok\":false,\"error\":\"invalid_index, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

  res = StringFormat("{\"ok\":true,\"result\":%lu}", ticket);
 }

//+------------------------------------------------------------------+
//| position_get_double                                              |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetDouble : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetDouble() : CMcpFunction(0, false, "position_get_double") {}
                    ~CMcpFuncPositionGetDouble(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetDouble::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_POSITION_PROPERTY_DOUBLE property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_DOUBLE>(property_str, POSITION_VOLUME);
  const double value = PositionGetDouble(property);
  res = StringFormat("{\"ok\":true,\"result\":%.8f}", value);
 }

//+------------------------------------------------------------------+
//| position_get_integer                                             |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetInteger : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetInteger() : CMcpFunction(0, false, "position_get_integer") {}
                    ~CMcpFuncPositionGetInteger(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetInteger::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_POSITION_PROPERTY_INTEGER property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_INTEGER>(property_str, POSITION_TICKET);
  const long value = PositionGetInteger(property);
  res = StringFormat("{\"ok\":true,\"result\":%ld}", value);
 }

//+------------------------------------------------------------------+
//| position_get_string                                              |
//+------------------------------------------------------------------+
class CMcpFuncPositionGetString : public CMcpFunction
 {
public:
                     CMcpFuncPositionGetString() : CMcpFunction(0, false, "position_get_string") {}
                    ~CMcpFuncPositionGetString(void) {}

  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncPositionGetString::Run(CJsonNode& param, string& res)
 {
  ::ResetLastError();
  const ulong ticket = param["ticket"].ToInt(0);
  const string property_str = param["property"].ToString("");

//---
  if(!PositionSelectByTicket(ticket))
   {
    res = StringFormat("{\"ok\":false,\"error\":\"position_not_found, last mt5 error = %d\"}", ::GetLastError());
    return;
   }

//---
  const ENUM_POSITION_PROPERTY_STRING property = CEnumReg::GetValueNoRef<ENUM_POSITION_PROPERTY_STRING>(property_str, POSITION_SYMBOL);
  const string value = PositionGetString(property);
  res = StringFormat("{\"ok\":true,\"result\":\"%s\"}", value);
 }

//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_TRADE_POSITIONS_MQH
