//+-------------------------------------------------------------------+
//| Include generado por la herramienta PerfectHash SimPHash          |
//| Esta heramienta forma parte del ecositema TSN                     |
//| Repositorio: https://forge.mql5.io/nique_372/SimPHash             |
//+-------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza"
#property link "https://www.mql5.com/"
#property strict


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <TSN/Tables/AllHashes.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define FULLMTCPMCP_ENUMREG_TABLE_SIZE (19ULL)
#define FULLMTCPMCP_ENUMREG_BUCKET_SIZE (5ULL)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
const ulong g_fullmt5mcpbyleo_enum_reg_seeds[FULLMTCPMCP_ENUMREG_BUCKET_SIZE] = 
{
0ULL,
67ULL,
1ULL,
2ULL,
3ULL
};

const ulong g_fullmt5mcpbyleo_enum_reg_hashes[FULLMTCPMCP_ENUMREG_TABLE_SIZE] = 
{
12827297637917508675ULL, // MCPFUNC_COPY_DATA_CLOSE
9833476190434708433ULL, // MCPFUNC_TIME_CURRENT
0ULL, // invalid
8390098331927205320ULL, // MCPFUNC_TIME_GMT
2893292029794393700ULL, // MCPFUNC_COPY_DATA_TIME
0ULL, // invalid
2701731610871698617ULL, // MTTESTER_MODELADO_ONLY_OPEN
0ULL, // invalid
6006495892572749119ULL, // MCPFUNC_TIME_LOCAL
10828745894336411064ULL, // MCPFUNC_COPY_DATA_REAL_VOLUME
3889800963808835531ULL, // MCPFUNC_COPY_DATA_TICK_VOLUME
5123367570285313366ULL, // MTTESTER_MODELADO_OCHLM1
18364679440755034845ULL, // MCPFUNC_COPY_DATA_HIGH
17427757786622224919ULL, // MCPFUNC_TIME_SERVER
215077165093199753ULL, // MCPFUNC_COPY_DATA_OPEN
1576385555095305006ULL, // MCPFUNC_COPY_DATA_SPREAD
17567442324659633658ULL, // MTTESTER_MODELADO_REAL_TICK
11982730540221307105ULL, // MCPFUNC_COPY_DATA_LOW
11362161152782748803ULL
};

 long g_fullmt5mcpbyleo_enum_reg_values[FULLMTCPMCP_ENUMREG_TABLE_SIZE] = 
{
0, // MCPFUNC_COPY_DATA_CLOSE
1, // MCPFUNC_TIME_CURRENT
-1,
0, // MCPFUNC_TIME_GMT
6, // MCPFUNC_COPY_DATA_TIME
-1,
2, // MTTESTER_MODELADO_ONLY_OPEN
-1,
2, // MCPFUNC_TIME_LOCAL
5, // MCPFUNC_COPY_DATA_REAL_VOLUME
4, // MCPFUNC_COPY_DATA_TICK_VOLUME
1, // MTTESTER_MODELADO_OCHLM1
2, // MCPFUNC_COPY_DATA_HIGH
3, // MCPFUNC_TIME_SERVER
1, // MCPFUNC_COPY_DATA_OPEN
7, // MCPFUNC_COPY_DATA_SPREAD
4, // MTTESTER_MODELADO_REAL_TICK
3, // MCPFUNC_COPY_DATA_LOW
0 // MTTESTER_MODELADO_EVERY_TICK
};

/*
long TempHashCustom(const string& key)
{
//---
  const int len = StringLen(key);
  ulong key_hash = 14695981039346656037ULL;
  FNV1a_64_AsM_Str(key, len, key_hash, 1099511628211ULL)

  const int seed_index = int(key_hash % FULLMTCPMCP_ENUMREG_BUCKET_SIZE);
//---
  ulong h = key_hash + g_fullmt5mcpbyleo_enum_reg_seeds[seed_index] * 0x9e3779b97f4a7c15;
  h = (h ^ (h >> 30)) * 0xbf58476d1ce4e5b9;
  h = (h ^ (h >> 27)) * 0x94d049bb133111eb;
  h ^= (h >> 31);

 const int fi = int(h % FULLMTCPMCP_ENUMREG_TABLE_SIZE);
  return g_fullmt5mcpbyleo_enum_reg_hashes[fi] == key_hash ? g_fullmt5mcpbyleo_enum_reg_values[fi] : -1;
}
*/
}
