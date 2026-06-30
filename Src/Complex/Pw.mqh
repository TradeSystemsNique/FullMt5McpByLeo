//+------------------------------------------------------------------+
//|                                                           Pw.mqh |
//|                                  Copyright 2026, Niquel Mendoza. |
//|                                            https://www.mql5.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Niquel Mendoza."
#property link      "https://www.mql5.com/"
#property strict

#ifndef FULLMT5MCPBYLEO_SRC_COMPLEX_PW_MQH
#define FULLMT5MCPBYLEO_SRC_COMPLEX_PW_MQH

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "..\\Def\\Def.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
namespace TSN
{
class CMcpFuncRunCommand : public CMcpFunction
 {
private:
  int                m_mode;
  CJsonBuilder       m_builder;

public:
                     CMcpFuncRunCommand(int mode)
    :                CMcpFunction(0, false, "run_command"), m_mode(mode) {}
                    ~CMcpFuncRunCommand(void) {}
  void               Run(CJsonNode& param, string& res) override final;
 };

//+------------------------------------------------------------------+
void CMcpFuncRunCommand::Run(CJsonNode& param, string& res) override final
 {
//---
  const string command = param["run"].ToStringNoEscape("");
  const uint timeout = uint(param["timeout_segundos"].ToInt(1) * 1000);
//---
  if(command == "")
   {
    res = "{\"ok\":false,\"result\":\"Empty command\"}";
    return;
   }
  if(m_mode == 0)
   {
    res = "{\"ok\":false,\"result\":\"The user has disabled the use of this tool in the EA settings.\"}";
    return;
   }

//--- Nombre único de archivo temporal, relativo a la carpeta Files (para usarlo con funciones nativas MQL5)
  const string rel_file = "McpMt5ByLeo\\temp.txt";

//--- Asegurar que la subcarpeta exista, en el ámbito Common
  FolderCreate("McpMt5ByLeo", FILE_COMMON);

//--- Ruta absoluta real en disco: Common + \Files\ + subcarpeta + archivo
  const string abs_path = TERMINAL_MT5_COMMON_PATH + "\\Files\\" + rel_file;

//--- Borrar cualquier residuo previo antes de ejecutar
  FileDelete(rel_file, FILE_COMMON);

//--- El propio shell redirige su salida (stdout + stderr) al archivo
  string ps_args = "-NoProfile -NonInteractive";
  if(m_mode == 1)
    ps_args += " -ExecutionPolicy AllSigned";
  else
    if(m_mode == 2)
      ps_args += " -ExecutionPolicy Restricted";

  string ps_inner =
    "$out = & { " + command + " } 2>&1 | Out-String; " +
    "[System.IO.File]::WriteAllText('" + abs_path + "', $out, [System.Text.UTF8Encoding]::new($false))";
  string full_command = "powershell " + ps_args + " -Command \"" + ps_inner + "\"";

//---
  PROCESS_INFORMATION pi;
  STARTUPINFOW si;
  ZeroMemory(pi);
  ZeroMemory(si);
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE;

//---
  const int created = CreateProcessW(NULL, full_command, NULL, NULL, 0, 0x08000000, NULL, NULL, si, pi);

  if(created == 0)
   {
    res = StringFormat("{\"ok\":false,\"result\":\"Failed call CreateProcessW, last error = %u\"}", GetLastError());
    return;
   }

//--- Esperar a que el proceso termine
  const uint wait_result = WaitForSingleObject(pi.hProcess, timeout);
  if(wait_result == WAIT_TIMEOUT_VAL)
    TerminateProcess(pi.hProcess, 1);

  uint exit_code = 0;
  GetExitCodeProcess(pi.hProcess, exit_code);

  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

//--- Leer el contenido del archivo con funciones nativas de MQL5 (ámbito Common)
  uchar data[];
  const long size = FileLoad(rel_file, data, FILE_COMMON);

//--- Borrar el archivo temporal para no acumular basura
  FileDelete(rel_file, FILE_COMMON);

//---
  m_builder.Clear();
  m_builder.Obj();
  m_builder.Key("ok").Val(bool(exit_code == 0));
  m_builder.Key("result").Obj();
  m_builder.Key("exit_code").Val(int(exit_code));
  m_builder.Key("stdout").ValU(data);
  m_builder.EndObj();
  m_builder.EndObj();
  res = m_builder.Build();
 }
}
//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_PW_MQH
