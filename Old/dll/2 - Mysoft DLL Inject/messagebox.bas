#if 0 '======================== DLL CODE =========================
  #define fbc -dll

  #include "windows.bi"

  function GetModuleFromPtr(pPtr as any ptr) as handle
    for CNT as integer = 12 to 16
      var pP = cast(ushort ptr,(cint(pPtr) shr CNT) shl CNT)
      if IsBadReadPtr(pP,2)=0 andalso *pP = cvshort("MZ") then return pP
    next CNT
  end function

  sub Main(ID as any ptr)  
    Messagebox(null,"Hello","World",MB_SYSTEMMODAL)
    FreeLibraryAndExitThread(GetModuleFromPtr(@Main),0)
  end sub

  ThreadCreate(@Main,0)
#endif
'================================================================