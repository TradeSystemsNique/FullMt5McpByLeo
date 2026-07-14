//+------------------------------------------------------------------+
//|                                                     MarketData.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                          https://www.mql5.com/es/users/nique_372 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/es/users/nique_372"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH
#define FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH

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
//| CMcpFuncCopyTicks                                                |
//+------------------------------------------------------------------+
class CMcpFuncCopyTicks : public CMcpFunction
 {
private:
  MqlTick            m_ticks[];

public:
                     CMcpFuncCopyTicks(void);
                    ~CMcpFuncCopyTicks(void);

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMcpFuncCopyTicks::CMcpFuncCopyTicks(void) : CMcpFunction(0, false, "copy_ticks")
 {
  ArraySetAsSeries(m_ticks, true);
 }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMcpFuncCopyTicks::~CMcpFuncCopyTicks(void)
 {
 }

/*
{
 "symbol" : "XAUUSD",
 "count" : 10,
 "flags" : "COPY_TICKS_ALL",
 "from" : 0
}

  COPY_TICKS_ALL   = 0,  // Obtener todos los ticks
  COPY_TICKS_BID   = 1,  // Obtener los ticks donde cambió el precio Bid
  COPY_TICKS_ASK   = 2,  // Obtener los ticks donde cambió el precio Ask
  COPY_TICKS_LAST  = 4,  // Obtener los ticks donde cambió el precio Last
  COPY_TICKS_TRADE = 8,  // Obtener los ticks con volumen de transacción (Last)
  COPY_TICKS_BUY   = 16, // Obtener los ticks de compra
  COPY_TICKS_SELL  = 32  // Obtener los ticks de venta
*/

//+------------------------------------------------------------------+
//| Run - Copia ticks del símbolo especificado                       |
//+------------------------------------------------------------------+
void CMcpFuncCopyTicks::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();

//---
  const string symbol = param["symbol"].ToString(_Symbol);
  const uint count = (uint)param["count"].ToInt(10);
  const ulong from = (ulong)param["from"].ToInt((long(TimeCurrent()) * 1000) - (10 * 1000));
  const uint flags = uint(param["flags"].ToInt(COPY_TICKS_ALL));

//---
// Validar que se copiaron los ticks correctamente
  const int copied = CopyTicks(symbol, m_ticks, flags, from, count);
  if(copied != count)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("CopyTicks failed, last mt5 error = %d", ::GetLastError()));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  const int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

//---
  for(int i = 0; i < copied; i++)
   {
    // Construir objeto MqlTick en JSON
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("time").ValSWV(TimeToString(m_ticks[i].time, TIME_DATE | TIME_SECONDS | TIME_MINUTES));
    m_shared_builder.KeyWV("bid").Val(m_ticks[i].bid);
    m_shared_builder.KeyWV("ask").Val(m_ticks[i].ask);
    m_shared_builder.KeyWV("last").Val(m_ticks[i].last);
    m_shared_builder.KeyWV("volume").Val((long)m_ticks[i].volume);
    m_shared_builder.KeyWV("time_msc").Val(m_ticks[i].time_msc);
    m_shared_builder.KeyWV("flags").Val((long)m_ticks[i].flags);
    m_shared_builder.KeyWV("volume_real").Val(m_ticks[i].volume_real);
    m_shared_builder.EndObj();
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMcpFuncBarShift : public CMcpFunction
 {
public:
                     CMcpFuncBarShift(void) : CMcpFunction(0, false, "i_bar_shift") {}
                    ~CMcpFuncBarShift(void) {}
  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncBarShift::Run(CJsonNode &param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Val(iBarShift(param["symbol"].ToString(_Symbol), CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period),
                     StringToTime(param["time"].ToString("0")), param["exact"].ToBool(false)));
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }
 


//+------------------------------------------------------------------+
//| copy_rates                                                       |
//+------------------------------------------------------------------+
class CMcpFuncCopyData : public CMcpFunction
 {
protected:
  double             m_buffer_d[];
  long               m_buffer_l[];
  datetime           m_buffer_dt[];
  int                m_buffer_i[];

public:
                     CMcpFuncCopyData() : CMcpFunction(0, false, "copy_data")
   {
    ArraySetAsSeries(m_buffer_d, true);
    ArraySetAsSeries(m_buffer_l, true);
    ArraySetAsSeries(m_buffer_i, true);
    ArraySetAsSeries(m_buffer_dt, true);
   }
                    ~CMcpFuncCopyData(void) {}

  void               Run(CJsonNode& param, CJsonBuilderStr* &out) override final;
 };

/*
{
 "symbol" : "XAUUSD",
 "count" : 10,
 "timeframe" "PERIOD_M1",
 "start" : 0,
 "mode" : "COPY_CLOSE"
}

  MCPFUNC_COPY_DATA_CLOSE = 0,
  MCPFUNC_COPY_DATA_OPEN = 1,
  MCPFUNC_COPY_DATA_HIGH = 2,
  MCPFUNC_COPY_DATA_LOW = 3,
  MCPFUNC_COPY_DATA_TICK_VOLUME = 4,
  MCPFUNC_COPY_DATA_REAL_VOLUME = 5,
  MCPFUNC_COPY_DATA_TIME = 6,
  MCPFUNC_COPY_DATA_SPREAD = 7
*/


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMcpFuncCopyData::Run(CJsonNode& param, CJsonBuilderStr* &out)
 {
//---
  out = m_shared_builder;
  ::ResetLastError();
  uint8_t t = 0;
  const int start = (int)param["start"].ToInt(0);
  const int count = (int)param["count"].ToInt(0);
  const uint8_t mode  = uint8_t(CEnumRegFullMt5Mcp::GetValNoRef<ENUM_MCPFUNC_COPY_DATA>(param["mode"].ToString(), 0));
  const string symbol = param["symbol"].ToString(_Symbol);

// t = [0=double,1=long,2=datetime:string]
//---
  int copied = -1;
  switch(mode)
   {
    case  MCPFUNC_COPY_DATA_CLOSE:
     {
      copied = CopyClose(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_d);
      break;
     }
    case  MCPFUNC_COPY_DATA_OPEN:
     {
      copied = CopyOpen(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_d);
      break;
     }
    case  MCPFUNC_COPY_DATA_HIGH:
     {
      copied = CopyHigh(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_d);
      break;
     }
    case  MCPFUNC_COPY_DATA_LOW:
     {
      copied = CopyLow(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_d);
      break;
     }
    case  MCPFUNC_COPY_DATA_TICK_VOLUME:
     {
      t = 1;
      copied = CopyTickVolume(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_l);
      break;
     }
    case  MCPFUNC_COPY_DATA_REAL_VOLUME:
     {
      t = 1;
      copied = CopyRealVolume(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_l);
      break;
     }
    case MCPFUNC_COPY_DATA_TIME:
     {
      t = 2;
      copied = CopyTime(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_dt);
      break;
     }
    case MCPFUNC_COPY_DATA_SPREAD:
     {
      t = 3;
      copied = CopySpread(symbol, CEnumRegBasis::GetValNoRef<ENUM_TIMEFRAMES>(param["timeframe"].ToString(), _Period), start, count, m_buffer_i);
      break;
     }

    //---
    default:
      m_shared_builder.PutChar('"');
      m_shared_builder.Obj();
      m_shared_builder.KeyWV("ok").Val(false);
      m_shared_builder.KeyWV("error").ValSWV(StringFormat("Invalid mode = %u", mode));
      m_shared_builder.EndObj();
      m_shared_builder.PutChar('"');
      return;
   }

//---
  if(copied != count)
   {
    m_shared_builder.PutChar('"');
    m_shared_builder.Obj();
    m_shared_builder.KeyWV("ok").Val(false);
    m_shared_builder.KeyWV("error").ValSWV(StringFormat("copy_data failed, last mt5 error = %d, [start = %d, count = %d]", ::GetLastError(), start, count));
    m_shared_builder.EndObj();
    m_shared_builder.PutChar('"');
    return;
   }

//---
  m_shared_builder.PutChar('"');
  m_shared_builder.Obj();
  m_shared_builder.KeyWV("ok").Val(true);
  m_shared_builder.KeyWV("result").Arr();
  switch(t)
   {
    //---
    case 0: // dbl
     {
      for(int i = 0; i < copied; i++)
       {
        m_shared_builder.Val(m_buffer_d[i]);
       }
      break;
     }

    //---
    case 1: // long
     {
      for(int i = 0; i < copied; i++)
       {
        m_shared_builder.Val(m_buffer_l[i]);
       }
      break;
     }

    //---
    case 2: // date
     {
      for(int i = 0; i < copied; i++)
       {
        m_shared_builder.ValSWV(TimeToString(m_buffer_dt[i]));
       }
      break;
     }

    //---
    case  3: // int
     {
      for(int i = 0; i < copied; i++)
       {
        m_shared_builder.Val(m_buffer_i[i]);
       }
      break;
     }
   }
  m_shared_builder.EndArr();
  m_shared_builder.EndObj();
  m_shared_builder.PutChar('"');
 }

//+------------------------------------------------------------------+
} // namespace TSN
#endif // FULLMT5MCPBYLEO_SRC_DATA_MARKETDATA_MQH

//+------------------------------------------------------------------+
