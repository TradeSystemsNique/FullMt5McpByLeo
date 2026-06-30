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
  const string command = param["run"].ToString("");
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

//---
  string full_command = "powershell -NoProfile -NonInteractive";
  if(m_mode == 1)
    full_command += " -ExecutionPolicy AllSigned";
  else if(m_mode == 2)
    full_command += " -ExecutionPolicy Restricted";
  full_command += " -Command \"" + command + "\"";

//--- Pipe para capturar stdout/stderr
  SECURITY_ATTRIBUTES sa;
  ZeroMemory(sa);
  sa.nLength = sizeof(sa);
  sa.bInheritHandle = 1;
  sa.lpSecurityDescriptor = NULL;

//---
  HANDLE hReadPipe, hWritePipe;
  if(!CreatePipe(hReadPipe, hWritePipe, sa, 0))
   {
    res = "{\"ok\":false,\"result\":\"Failed to create pipe\"}";
    return;
   }

//---
  PROCESS_INFORMATION pi;
  STARTUPINFOW si;
  ZeroMemory(pi);
  ZeroMemory(si);
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE; // usa el valor correcto que tengas definido para SW_HIDE
  si.hStdOutput = hWritePipe;
  si.hStdError = hWritePipe;
  si.hStdInput = NULL;

//---
  const int created = CreateProcessW(NULL, full_command, NULL, NULL, 1, 0x08000000, NULL, NULL, si, pi);
  CloseHandle(hWritePipe); // SIEMPRE cerrar el write end en el padre, sin importar si CreateProcessW falló

//---
  if(created == 0)
   {
    CloseHandle(hReadPipe);
    res = StringFormat("{\"ok\":false,\"result\":\"Failed call CreateProcessW, last error = %u\"}", GetLastError());
    return;
   }

//---
  const uint wait_result = WaitForSingleObject(pi.hProcess, timeout);
  if(wait_result == WAIT_TIMEOUT_VAL)
    TerminateProcess(pi.hProcess, 1);

//--- Leer el output del pipe
  string output = "";
  uchar buffer[];
  ArrayResize(buffer, 4096);
  uint bytes_read = 0;
  while(ReadFile(hReadPipe, buffer, 4095, bytes_read, NULL) && bytes_read > 0)
   {
    string chunk = CharArrayToString(buffer, 0, bytes_read);
    output += chunk;
   }
  CloseHandle(hReadPipe);

//---
  uint exit_code = 0;
  GetExitCodeProcess(pi.hProcess, exit_code);

//---
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

//---
  m_builder.Obj();
  m_builder.Key("ok").Val(bool(exit_code == 0));
  m_builder.Key("result").Obj();
  m_builder.Key("exit_code").Val(int(exit_code));
  m_builder.Key("stdout").ValS(output);
  m_builder.EndObj();
  m_builder.EndObj();
  res = m_builder.Build();
 }
}
//+------------------------------------------------------------------+
#endif // FULLMT5MCPBYLEO_SRC_COMPLEX_PW_MQH
