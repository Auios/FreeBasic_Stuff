#include "windows.bi"

#define Quit sleep:system

dim as hwnd hProcessWindow = findwindow("notepad",null)
dim as dword lProcID,lThreadID_Remote
dim as handle hProcHandle,hThread_Remote
dim as any ptr pzDLL_Remote
dim as any ptr pfLoadLibrary_Remote

if hProcessWindow=0 then 
  print "Failed to find window...":Quit
end if
GetWindowThreadProcessId(hProcessWindow,@lProcID) 'this gets the PID of the process on lProcID and return PID of thread

'now we OPEN the process, that we want to inject, with the required permissions
hProcHandle = OpenProcess(PROCESS_ALL_ACCESS,false,lProcID)
if hProcHandle=0 then
  print "Failed to Open Process...":Quit
end if

'to able to inject a DLL we first must allocate space on the REMOTE process for a string that will contain
'the full path of the .DLL, so let's assume the .DLL is on the same path as the injector...
var sDLL = exepath+"\messagebox.dll"
if len(dir(sDLL))=0 then
  print "dll.dll not found...":Quit
end if
pzDLL_Remote = VirtualAllocEx(hProcHandle,null,len(sDLL)+1,MEM_COMMIT,PAGE_READWRITE)
if pzDLL_Remote = 0 then
  print "Failed to allocate remote memory...":Quit
end if

'now we must copy our DLL path to the remote process...
dim as dword lWriteSz = 0
WriteProcessMemory(hProcHandle,pzDLL_remote,strptr(sDLL),len(sDLL)+1,@lWriteSz)
if lWriteSz <> len(sDLL)+1 then
  print "Failed to write to remote process...":Quit
end if

'now we must get an address where to start execution on the remote process
'before we get ready to Create the Remote Thread, so there's a nice tiny
'function that works very well for this... LoadLibrary(pzDllFile) that
'is a kernel32.dll function so it will exist at SAME address on the remote process
'as it does on this process... so let's get the address to it
var hKernel = GetModuleHandle("kernel32.dll")
pfLoadLibrary_Remote = GetProcAddress(hKernel,"LoadLibraryA") ' "LoadLibrary Ansi"
if hKernel = 0 or pfLoadLibrary_Remote=0 then
  print "Failed to get address for LoadLibraryA":Quit
end if

'now we're ready to inject into the process, so let's do it
hThread_Remote = CreateRemoteThread(hProcHandle,0,0,pfLoadLibrary_Remote,pzDLL_Remote,0,@lThreadID_Remote)
if hThread_Remote = 0 then
  print "Failed to Create Remote Thread":Quit
end if

'and now we just wait for the thread to finish, meaning that the .DLL is done injecting
'it's worth noting that if your DLL has code on it's main (i.e. outside a function)
'this will not return until the main return, so ideally the remote Loaded DLL
'should create a thread for itself, to allow this to return and... to let everything else settle.
'also this is kinda important to allow the DLL to be unloaded later...
if WaitForSingleObject(hThread_Remote,16384)<>0 then ' (16384 = ~16 seconds timeout)
  print "Oops, something went wrong..."
else
  print "Remote DLL injection completed."
end if

'some clean up... that was missing
CloseHandle(hThread_Remote)
VirtualFreeEx(hProcHandle,pzDLL_Remote,0,MEM_RELEASE)

sleep

'Questions on lines...
'46
'62

