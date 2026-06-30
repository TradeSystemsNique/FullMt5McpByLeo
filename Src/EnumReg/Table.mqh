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
#define FULLMTCPMCP_ENUMREG_TABLE_SIZE (33ULL)
#define FULLMTCPMCP_ENUMREG_BUCKET_SIZE (9ULL)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
const ulong g_fullmt5mcpbyleo_enum_reg_seeds[FULLMTCPMCP_ENUMREG_BUCKET_SIZE] =
 {
  39ULL,
  1ULL,
  25ULL,
  0ULL,
  0ULL,
  7ULL,
  0ULL,
  2ULL,
  8ULL
 };

const ulong g_fullmt5mcpbyleo_enum_reg_hashes[FULLMTCPMCP_ENUMREG_TABLE_SIZE] =
 {
  10828745894336411064ULL, // MCPFUNC_COPY_DATA_REAL_VOLUME
  5974599428686999426ULL, // MCPFUNC_CHARTIND_TOTAL
  12827297637917508675ULL, // MCPFUNC_COPY_DATA_CLOSE
  17427757786622224919ULL, // MCPFUNC_TIME_SERVER
  9833476190434708433ULL, // MCPFUNC_TIME_CURRENT
  215077165093199753ULL, // MCPFUNC_COPY_DATA_OPEN
  2893292029794393700ULL, // MCPFUNC_COPY_DATA_TIME
  17567442324659633658ULL, // MTTESTER_MODELADO_REAL_TICK
  0ULL, // invalid
  14844274323843258022ULL, // MCPFUNC_IND_ACTION_GET_PARAMETERS
  10511875710981981502ULL, // MCPFUNC_IND_ACTION_GET_HANDLES_NAMES
  0ULL, // invalid
  8390098331927205320ULL, // MCPFUNC_TIME_GMT
  11362161152782748803ULL, // MTTESTER_MODELADO_EVERY_TICK
  2701731610871698617ULL, // MTTESTER_MODELADO_ONLY_OPEN
  3889800963808835531ULL, // MCPFUNC_COPY_DATA_TICK_VOLUME
  10041657308074928943ULL, // MCPFUNC_IND_ACTION_REMOVE
  0ULL, // invalid
  6006495892572749119ULL, // MCPFUNC_TIME_LOCAL
  5123367570285313366ULL, // MTTESTER_MODELADO_OCHLM1
  11010084391123014691ULL, // MCPFUNC_IND_ACTION_TOTAL
  0ULL, // invalid
  17591324130668369116ULL, // MCPFUNC_CHARTIND_SHORT_NAME
  17063702951892128518ULL, // MCPFUNC_IND_ACTION_ADD
  18364679440755034845ULL, // MCPFUNC_COPY_DATA_HIGH
  11982730540221307105ULL, // MCPFUNC_COPY_DATA_LOW
  6852343758252543026ULL, // MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME
  11613815720067854899ULL, // MCPFUNC_IND_ACTION_CREATE
  1576385555095305006ULL, // MCPFUNC_COPY_DATA_SPREAD
  0ULL, // invalid
  15945352663594696195ULL, // MCPFUNC_CHARTIND_DELETE
  15334704554290380651ULL, // MCPFUNC_CHARTIND_ADD
  0ULL
 };

long g_fullmt5mcpbyleo_enum_reg_values[FULLMTCPMCP_ENUMREG_TABLE_SIZE] =
 {
  5, // MCPFUNC_COPY_DATA_REAL_VOLUME
  0, // MCPFUNC_CHARTIND_TOTAL
  0, // MCPFUNC_COPY_DATA_CLOSE
  3, // MCPFUNC_TIME_SERVER
  1, // MCPFUNC_TIME_CURRENT
  1, // MCPFUNC_COPY_DATA_OPEN
  6, // MCPFUNC_COPY_DATA_TIME
  4, // MTTESTER_MODELADO_REAL_TICK
  -1,
  5, // MCPFUNC_IND_ACTION_GET_PARAMETERS
  2, // MCPFUNC_IND_ACTION_GET_HANDLES_NAMES
  -1,
  0, // MCPFUNC_TIME_GMT
  0, // MTTESTER_MODELADO_EVERY_TICK
  2, // MTTESTER_MODELADO_ONLY_OPEN
  4, // MCPFUNC_COPY_DATA_TICK_VOLUME
  3, // MCPFUNC_IND_ACTION_REMOVE
  -1,
  2, // MCPFUNC_TIME_LOCAL
  1, // MTTESTER_MODELADO_OCHLM1
  1, // MCPFUNC_IND_ACTION_TOTAL
  -1,
  1, // MCPFUNC_CHARTIND_SHORT_NAME
  6, // MCPFUNC_IND_ACTION_ADD
  2, // MCPFUNC_COPY_DATA_HIGH
  3, // MCPFUNC_COPY_DATA_LOW
  4, // MCPFUNC_IND_ACTION_GET_HANDLE_BY_NAME
  0, // MCPFUNC_IND_ACTION_CREATE
  7, // MCPFUNC_COPY_DATA_SPREAD
  -1,
  3, // MCPFUNC_CHARTIND_DELETE
  2, // MCPFUNC_CHARTIND_ADD
  -1
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
//+------------------------------------------------------------------+
