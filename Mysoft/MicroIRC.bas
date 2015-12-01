#define xfbc -g
#ifdef __fb_Android32__
  #include "android\freebasic.bas"  
#else
  #include "crt.bi"
  #include "fbgfx.bi"
  
  '#define Exceptions_GetFaultyLine
  '#include "MyTDT\exceptions.bas"
  'StartExceptions()
#endif

#include "wshelper.bas"
hStart()

enum CharCode
  ccCTCP      =  1
  ccBOLD      =  2
  ccCOLOR     =  3
  ccRESET     = 15
  ccREVERSE   = 22
  ccUNDERLINE = 31
end enum

enum ConnectionStatus
  csErrorRetry
  csDisconnected
  csConnect
  csConnecting
  csConnected  
end enum

const StatusWindow = 0
enum ChannelMode
  cmUnused
  cmRegular
  cmVoice
  cmHalf
  cmOperator
  cmSuper
  cmOwner
end enum

type NickStruct
  zNick as zstring*24   'Nickname             
  lChan as long         'Channels mask (3bit) 
  bCount as ubyte       'Channel count        
  Reserved(2) as ubyte  'Padding to 32 bytes  
end type
type NickIndexStruct       
  pArray as NickStruct ptr 'Array for nicks with index 
  wSize as short           'Size of array for index    
  wCount as short          'Used slots for index       
end type
type WindowStruct
  zName as zstring*32           'Window/Channel/Query Name 
  pzBuffer(255) as zstring ptr  '256 lines circular buffer 
  iFlags as short               'Window Flags (action?)    
  iBuffStart as short           'Start of the buffer       
  iBuffSize as short            'Lines on the buffer       
  iBuffScroll as short          'Negative Scroll position  
  sEdit as string               'Edit content for window   
  iCursor as short              'Cursor on edit control    
  iScroll as short              'Scroll position on edit   
end type

declare sub CheckConsoleSize(iForce as integer=0)
declare sub AddLine(iID as integer,sText as string,iColor as integer=7)
declare sub CheckKeyboardInput(iForce as integer=0)
declare sub UpdateChannelBar()

dim shared as socket SvSock
dim shared as string sNick,sChannel,sMe
dim shared SvHost as string,SvIP as ulong,SvPort as integer
dim shared as integer iWid,iHei,iOldConSz,iCurrent,iUpEdit=3
dim shared as integer iConn=csConnect,iQuitApp
dim shared as WindowStruct tWindow(31)
dim shared aNicks(255) as NickIndexStruct
dim shared as double dRetryTime

randomize()
SvHost = "irc.freenode.net":SvPort = 6667:sChannel = "##Freebasic"
sNick = "FreeTest" & int(rnd*1000):sMe = lcase$(ltrim$(sNick))

#define NickMode NickJoin
function FindNick(iIndex as integer,plNick as long ptr,byref pNick as NickStruct ptr) as integer
  #define plA plNick
  var pArray = aNicks(iIndex).pArray
  dim pTemp as NickStruct ptr
  for CNT as integer = 0 to aNicks(iIndex).wSize-1
    with *pArray
      if .zNick[0] then
        var plB = cast(long ptr,@.zNick)
        if plA[0] = plB[0] andalso plA[1] = plB[1] andalso plA[2] = plB[2] then 
          if plA[3] = plB[3] andalso plA[4] = plB[4] andalso plA[5] = plB[5] then
            pNick = pArray: return 1
          end if
        end if
      else
        if pTemp = 0 then pTemp = pArray
      end if
    end with
    pArray += 1
  next CNT
  pNick = pTemp: return 0
end function
sub NickJoin(iChannel as integer,sNick as string,iMode as integer)
  dim as zstring*32 zNick: zNick = sNick  
  var iIndex = sNick[0],plA = cast(long ptr,@zNick)  
  with aNicks(iIndex)
    if .pArray = 0 then .wSize = 8: .pArray = callocate(sizeof(NickStruct)*.wSize)
    dim as NickStruct ptr pNick = any
    if FindNick(iIndex,plA,pNick) then 'found nick on list
      with *pNick
        if (.lChan and (7 shl ((iChannel-1)*3))) then          'already on channel
          .lChan and= (not (7 shl ((iChannel-1)*3)))
          .lChan or= (iMode shl ((iChannel-1)*3)):exit sub     'updated mode 
        end if
        .lChan or= (iMode shl ((iChannel-1)*3))
        memcpy(@.zNick,@zNick,24): .bCount += 1: exit sub      'added to channel
      end with
    elseif pNick then                  'not found nick, but has free slot
      with *pNick
        .lChan or= (iMode shl ((iChannel-1)*3))
        memcpy(@.zNick,@zNick,24): .bCount += 1: exit sub      'added to channel
      end with
    else                               'need more room
      .wSize += 8: .pArray = reallocate(.pArray,sizeof(NickStruct)*.wSize)
      memset(.pArray+(.wSize-8),0,sizeof(NickStruct)*8) 'start clean
      with .pArray[.wSize-8]
        .lChan or= (iMode shl ((iChannel-1)*3))
        memcpy(@.zNick,@zNick,24): .bCount += 1: exit sub      'added to channel
      end with
    end if
  end with
end sub
function NickPart(iChannel as integer,sNick as string) as integer
  dim as zstring*32 zNick: zNick = sNick  
  var iIndex = sNick[0],plA = cast(long ptr,@zNick)  
  with aNicks(iIndex)
    if .pArray = 0 then return 0 'no nicks on this index
    dim as NickStruct ptr pNick = any
    if FindNick(iIndex,plA,pNick) then 'found nick on list
      with *pNick
        if iChannel < 0 then 
          function=.lChan:.lChan=0:.bCount = 0
          memset(@.zNick,0,24): exit function
        end if
        if (.lChan and (7 shl ((iChannel-1)*3))) then              
          .lChan and= (not (7 shl ((iChannel-1)*3))): .bCount -= 1 'parted from channel
          if .bCount=0 then memset(@.zNick,0,24): return 0         'erased nick
        end if
      end with
    end if
  end with
end function
function NickRename(sOldNick as string,sNewNick as string) as integer
  dim as zstring*32 zOldNick,zNewNick
  zOldNick=sOldNick: zNewNick = sNewNick
  var iOldIndex = sOldNick[0], iNewIndex = sNewNick[0]
  var plOld = cast(long ptr,@zOldNick)
  var plNew = cast(long ptr,@zNewNick)
  if sMe = lcase$(sOldNick) then sNick = sNewNick: sMe = lcase$(sNewNick)
  with aNicks(iOldIndex)
    if .pArray = 0 then return 0 'no nicks on this index
    dim as NickStruct ptr pOldNick = any,pNewNick = any
    if FindNick(iOldIndex,plOld,pOldNick) then 'found nick on list
      if iOldIndex = iNewIndex then 'new nick use same index
        memcpy(@(pOldNick->zNick),plNew,24): return pOldNick->lChan
      end if
      FindNick(iNewIndex,plNew,pNewNick)
      if pNewNick=0 then 'no free slots on new index
        with aNicks(iNewIndex)
          .wSize += 8: .pArray = reallocate(.pArray,sizeof(NickStruct)*.wSize)
          memset(.pArray+(.wSize-8),0,sizeof(NickStruct)*8) 'start clean
          pNewNick = .pArray+(.wSize-8)
        end with
      end if
      *pNewNick = *pOldNick
      memset(pOldNick,0,sizeof(NickStruct)) 'remove old nick 
      memcpy(@(pNewNick->zNick),plNew,24) 'create new nick
      return pNewNick->lChan
    end if
  end with
end function

function FindChan(sChan as string) as integer
  var sChanL = lcase$(sChan)',iLen=len(sChan)
  for CNT as integer = 1 to 31 '0 is status
    if lcase$(tWindow(CNT).zName) = sChanL then return CNT
  next CNT
  return 0
end function    
function ChanCreate(sNewChan as string) as integer
  var iResu = FindChan(sNewChan)
  if iResu then 
    iCurrent=iResu:CheckConsoleSize(true)
    return iResu
  end if
  var iStart = iif(sNewChan[0]=asc("#"),0,15)
  for CNT as integer = iStart+1 to iStart+15
    with tWindow(CNT)
      if .zName[0] = 0 then 'found empty slot      
        .zName = sNewChan
        for I as integer = 0 to 255
          .pzBuffer(I) = 0
        next I
        .iBuffStart=0:.iBuffSize=0:.iBuffScroll=0
        .sEdit="":.iCursor=0:.iScroll=0
        iCurrent=CNT:CheckConsoleSize(true)
        if sNewChan[0] = asc("#") then
          AddLine(CNT,"Now talking on "+sNewChan,10)
        end if
        iUpEdit=3:CheckKeyboardInput(1):return CNT
      end if
    end with
  next CNT
  return 0
end function
function ChanDestroy(sChan as string) as integer
  var iResu = FindChan(sChan)
  if iResu = 0 then return 0
  var iMask = (7 shl ((iResu-1)*3))
  for CNT as integer = 0 to 255 'Partying all nicks
    with aNicks(CNT)
      if .pArray then        
        for I as integer = 0 to .wSize-1 'all nicks on index
          if (.pArray[I].lChan and iMask) then
            .pArray[I].lChan and= (not iMask)
            .pArray[I].bCount -= 1
            if .pArray[I].bCount = 0 then
              memset(@(.pArray[I].zNick),0,24)
            end if
          end if
        next I
      end if
    end with
  next CNT
  with tWindow(iResu)
    .zName = ""
    for I as integer = 0 to 255
      if .pzBuffer(I) then deallocate(.pzBuffer(I)):.pzBuffer(I)=0
    next I  
    .iBuffStart=0:.iBuffSize=0
    .iBuffScroll=0:.sEdit=""
    .iCursor=0:.iScroll=0
  end with
  return iResu
end function

sub AddLine(iID as integer,sText as string,iColor as integer=7)
  with tWindow(iID)
    if .iBuffSize = 256 then 
      .iBuffStart = (.iBuffStart+1) and 255
    else
      .iBuffSize += 1
    end if
    var iLine = (.iBuffStart+.iBuffSize-1) and 255
    .pzBuffer(iLine) = reallocate(.pzBuffer(iLine),len(sText)+2)
    *cptr(ubyte ptr,.pzBuffer(iLine)) = iColor
    memcpy(.pzBuffer(iLine)+1,strptr(sText),len(sText)+1)    
    if iID = iCurrent then
      view print 3 to iHei-3
      locate iHei-3,iWid,0:color iColor,0
      print:print sText;
      view print 1 to iHei
    end if
    if iID <> iCurrent then
      .iFlags or= 1:UpdateChannelBar()
    end if
  end with
end sub
sub MessageSend(sMessage as string)
  if len(sMessage) then
    while hSelect(svSock,1)=0 andalso hSelectError(SvSock)=0
      sleep 10,1
    wend  
    if hSend(svSock,sMessage,len(sMessage)) <> len(sMessage) then
      for CNT as integer = 0 to 31
        if tWindow(CNT).zName[0] then AddLine(CNT,"Disconnected.",12)
      next CNT
      hClose(SvSock):SvSock=0:iConn=csErrorRetry:dRetryTime=timer-20
    end if
  end if
end sub
sub UpdateChannelBar()
  locate iHei-1,1,0
  var iPos = 1: iUpEdit = 3
  for I as integer = 0 to 31
    with tWindow(I)
      var iLen = len(.zName)+1
      if iLen>1 then
        if (iPos+iLen) >= iWid then
          color 7,1:print space$((iWid-1)-iPos);
          exit sub
        end if
        if iCurrent = I then 
          .iFlags and= (not 1):color 11,1 
        else 
          if (.iFlags and 1) then color 3,1 else color 7,1
        end if
        print " "+.zName;: iPos += iLen
      end if
    end with
  next I
  if iPos < iWid then
    print " ";:color 7,1:print space$((iWid)-iPos);
  end if
end sub
sub CheckConsoleSize(iForce as integer=0)
  with tWindow(iCurrent)
    var iConSz = width()
    if iForce orelse iConSz <> iOldCOnSz then
      iOldConSz = iConSz
      iWid=loword(iConSz):iHei=hiword(iConSz)
      color 7,0:cls: color 12,0
      locate iHei-2,1,0: print string$(iWid,"-");
      locate 2,1: print string$(iWid,"-");      
      view print 3 to iHei-3: locate iHei-3,1
      var iLine = 0,iAmount=iHei-5
      if .iBuffSize > iAmount then
        iLine = (.iBuffStart+.iBuffSize-iAmount-1) and 255
      else
        iAmount = .iBuffSize
      end if      
      for CNT as integer = 1 to iAmount
        color *cptr(ubyte ptr,.pzBuffer(iLine))
        if CNT <> iAmount then print .pzBuffer(iLine)[1] else print .pzBuffer(iLine)[1];
        iLine = (iLine+1) and 255
      next CNT
      view print 1 to iHei
      UpdateChannelBar()
    end if
  end with
end sub
function ParseCommand(sCmd as string) as string  
  var pLen = cptr(integer ptr,@sCmd)+1
  var iPosi = instr(sCmd," "),iLen = *pLen
  if iPosi then *pLen = iPosi-1
  var sCmdL = lcase$(sCmd),sParms="": *pLen = iLen
  if iPosi then sParms = trim$(mid$(sCmd,iPosi+1))
  select case sCmdL
  case "quit" : iQuitApp = 1
  case "join"  ' join a channel
    if sParms[0] <> asc("#") then return "JOIN #"+sParms+!"\r\n"
  case "j"     ' join a channel
    if sParms[0] <> asc("#") then sParms = "#"+sParms
    return "JOIN "+sParms+!"\r\n"
  case "ns"   : return "PRIVMSG NickServ :"+sParms
  case "cs"   : return "PRIVMSG ChanServ :"+sParms
  case "ms"   : return "PRIVMSG MemoServ :"+sParms
  case "bs"   : return "PRIVMSG BotServ  :"+sParms
  case "query" ' Open private conversation 
    if len(sParms) then
      if sParms[0] = asc("#") then return ""
      var iPosi = instr(sParms," ")
      if iPosi then sParms = left$(sParms,iPosi-1)
      ChanCreate(sParms)
    end if
    return ""    
  case "part"  ' Left channel (current if no parms)
    if len(sParms)=0 then
      if iCurrent=StatusWindow then return ""
      if tWindow(iCurrent).zName[0] <> asc("#") then
        ChanDestroy(tWindow(iCurrent).zName)
        iCurrent=0:CheckConsoleSize(1)
        CheckKeyboardInput(1):return ""
      end if
      return "PART "+tWindow(iCurrent).zName+!"\r\n"
    else      
      return sCmd+!"\r\n"
    end if
  case "hop"   ' Part+Join current channel
    if iPosi=0 andalso iCurrent=StatusWindow then return ""
    if iPosi=0 then sParms = tWindow(iCurrent).zName
    return "PART "+sParms+!":hopping!\r\nJOIN "+sParms+!"\r\n"
  case "me"    ' Self-Action on channel  
    if iCurrent=StatusWindow then return ""
    AddLine(iCurrent,"* "+sNick+" "+sParms,14)
    return "PRIVMSG "+tWindow(iCurrent).zName+!" :\1ACTION "+sParms+!"\1\r\n"
  end select
  return sCmd+!"\r\n"
end function  
sub CheckKeyboardInput(iForce as integer=0)
  #define Ctrl(_I_) (asc(_I_)-asc("A")+1)
  with tWindow(iCurrent)    
    ' Checking keyboard events
    do until iForce
      var sKey = inkey$
      if len(sKey)=0 then exit do
      var iKey = cint(sKey[0])
      if iKey=255 then iKey = -sKey[1]
      select case iKey
      case 32 to 254     'ascii chr = add char to edit  
        if len(.sEdit) < 256 then
          .sEdit = left$(.sEdit,.iCursor)+sKey+mid$(.sEdit,.iCursor+1)
          .iCursor += 1:iUpEdit=3
        end if
      case -fb.SC_DELETE 'delete    = delete next char  
        if .iCursor < len(.sEdit) then
          .sEdit = left$(.sEdit,.iCursor)+mid$(.sEdit,.iCursor+2)
          iUpEdit=3    
        end if
      case 8             'backspace = erase text        
        if .iCursor then
          .sEdit = left$(.sEdit,.iCursor-1)+mid$(.sEdit,.iCursor+1)
          .iCursor -= 1:iUpEdit=3    
        end if
      case 13,10         'enter     = send text         
        if len(.sEdit) then                  
          var sTemp = "":.sEdit = trim$(.sEdit)
          if len(.sEdit)=0 then continue do         
          if iKey=13 andalso .sEdit[0]=asc("/") then
            sTemp = ParseCommand(mid$(.sEdit,2))+!"\r\n"
          else
            if iConn<>csConnected then
              AddLine(iCurrent,"Not connected.",9)
              .iCursor = 0:.sEdit = "": .iScroll=0
              iUpEdit = 3: exit do
            end if
            if iCurrent=StatusWindow then
              AddLine(iCurrent,"Not on a channel/query.",9)
              .iCursor = 0:.sEdit = "": .iScroll=0
              iUpEdit = 3: exit do
            end if
            sTemp = "PRIVMSG "+.zName+" :"+.sEdit+!"\r\n"
            AddLine(iCurrent,"<"+sNick+"> "+.sEdit)
          end if
          MessageSend(sTemp)
          .iCursor = 0:.sEdit = "": .iScroll=0: iUpEdit = 3
        end if        
      case Ctrl("A")     'Ctrl+A    = prev channel      
        for CNT as integer = 1 to 31
          with tWindow((iCurrent-CNT) and 31)
            if .zName[0] then
              iCurrent = (iCurrent-CNT) and 31
              CheckConsoleSize(1):iUpEdit=3
              exit do
            end if
          end with
        next CNT
      case Ctrl("D")     'Ctrl+D    = next channel      
        for CNT as integer = 1 to 32
          with tWindow((iCurrent+CNT) and 31)
            if .zName[0] then
              iCurrent = (iCurrent+CNT) and 31
              CheckConsoleSize(1):iUpEdit=3
              exit do
            end if
          end with
        next CNT
      case -fb.SC_LEFT   'LEFT      = move cursor left  
        if .iCursor then .iCursor -= 1:iUpEdit or= 1      
      case -fb.SC_RIGHT  'RIGHT     = move cursor right 
        if .iCursor < len(.sEdit) then .iCursor += 1:iUpEdit or= 1
      case -fb.SC_HOME   'HOME      = cursor at start   
        if .iCursor then .iCursor=0:iUpEdit or= 1
      case -fb.SC_END    'END       = cursor at end     
        if .iCursor<len(.sEdit) then .iCursor = len(.sEdit):iUpEdit or= 1
      end select
    loop
  end with
  with tWindow(iCurrent)
    
    'Adjust Cursor to follow scrolling
    var iLen = len(.sEdit)
    if iLen > (iWid-2) then
      if (iLen-.iScroll) < (iWid-2) then
        .iScroll = iLen-(iWid-2)
      end if
      if .iCursor < .iScroll then 
        .iScroll = .iCursor: iUpEdit = 3
      elseif .iCursor > (.iScroll+(iWid-2)) then
        .iScroll = .iCursor-(iWid-2):iUpEdit=3
      end if
    else
      if .iScroll then .iScroll=0:iUpEdit=3
    end if
    
    'Update edit box and cursor when apply
    if iUpEdit then      
      if (iUpEdit and 2) then
        locate iHei,1,0:color 10,0: print ">";:color 7,0
        if iLen > (iWid-2) then
          print mid$(.sEdit,.iScroll+1,(iWid-2));
        else
          print .sEdit+space((iWid-iLen)-2);
        end if
      end if
      if (iUpEdit and 1) then
        locate iHei,2+.iCursor-.iScroll,1
      end if
      iUpEdit = 0
    end if
    
  end with
end sub
sub ParseCTCP(iWindow as integer,sMethod as string,sSrc as string,sTarget as string,sMsg as string)
  var iPosi = instr(sMsg," "),sCTCP=""
  if iPosi then
    sCTCP = ucase$(mid$(sMsg,2,iPosi-2))
    sMsg = mid$(sMsg,iPosi+1,len(sMsg)-(iPosi+1))
  else
    swap sCTCP,sMsg
  end if
  select case sCTCP 'CTCP without echo
  case "ACTION": AddLine(iWindow,"* "+sSrc+" "+sMsg,14)
  case else 
    AddLine(iif(sTarget[0]=asc("#"),iWindow,StatusWindow),"["+sSrc+" "+sCTCP+"]{"+sMsg+"}",4)
    select case sCTCP 'CTCP with echo
    case "PING": MessageSend(sMethod+" "+sSrc+!" :\1PING "+sMSg+!"\1\r\n")
    end select
  end select
end sub
sub ParseLine(sText as string)
  var pLen = cptr(integer ptr,@sText)+1
  var iPosi = instr(sText," "),iLen = *pLen,iRev=0
  if iPosi = 0 then Addline(StatusWindow,sText):exit sub  
  *pLen = iPosi-1
  var iPos2 = instr(sText,"!"): if iPos2 then *pLen = iPos2-1
  if sText[0] = asc(":") then *cptr(integer ptr,@sText) += 1: *pLen -= 1:iRev=1
  var sSrc = sText,sSrcL = lcase$(sSrc): *pLen = iLen
  if iRev then *cptr(integer ptr,@sText) -= 1:iRev=0
  var sMsg = mid$(sText,iPosi+iif(sText[iPosi]=asc(":"),2,1))
  select case sSrcL
  case "ping" 'Server Ping
    sMsg = "PONG :"+sMsg+!"\r\n"
    hSend(SvSock,sMsg,len(sMsg))  
  case else
    pLen = cptr(integer ptr,@sMsg)+1
    iPosi = instr(sMsg," "):iLen = *pLen
    if iPosi = 0 then AddLine(0,sMsg):exit sub    
    var iRaw = valint(sMsg)    
    select case iRaw
    case 0    'Server Action 
      *pLen = iPosi-1
      var sAct = lcase$(sMsg)
      *pLen=iLen:sMsg=mid$(sMsg,iPosi+iif(sMsg[iPosi]=asc(":"),2,1))      
      select case sAct
      case "privmsg" 'Message was sent            
        iPosi = instr(sMsg," "):iLen = *pLen
        if iPosi = 0 then AddLine(0,sMsg):exit sub
        *pLen = iPosi-1: var sTarget = sMsg, iChan = 0
        *pLen=iLen:sMsg=mid$(sMsg,iPosi+iif(sMsg[iPosi]=asc(":"),2,1))      
        if sMsg[0] = ccCTCP andalso sMsg[1] <> 0 andalso sMsg[len(sMsg)-1] = ccCTCP then
          iChan = FindChan(sTarget): ParseCTCP(iChan,"PRIVMSG",sSrc,sTarget,sMsg)
        else
          if lcase$(sTarget) = sMe then
            iChan = FindChan(sSrc)
            if iChan=0 then 
              iChan = ChanCreate(sSrc)
              CheckConsoleSize(1): CheckKeyboardInput(1)
            end if
          else            
            iChan = FindChan(sTarget)
          end if
          AddLine(iChan,"<"+sSrc+"> "+sMsg)
        end if
      case "notice" 'Notice was sent            
        iPosi = instr(sMsg," "):iLen = *pLen
        if iPosi = 0 then AddLine(0,sMsg):exit sub
        *pLen = iPosi-1: var sTarget = sMsg, iChan = 0
        *pLen=iLen:sMsg=mid$(sMsg,iPosi+iif(sMsg[iPosi]=asc(":"),2,1))      
        if sMsg[0] = ccCTCP andalso sMsg[1] <> 0 andalso sMsg[len(sMsg)-1] = ccCTCP then
          iChan = FindChan(sTarget): ParseCTCP(iChan,"NOTICE",sSrc,sTarget,sMsg)
        else
          if lcase$(sTarget) = sMe then
            iChan = FindChan(sSrc)
            if iChan=0 then 
              iChan = ChanCreate(sSrc)
              CheckConsoleSize(1): CheckKeyboardInput(1)
            end if
          else            
            iChan = FindChan(sTarget)
          end if
          AddLine(iChan,"<"+sSrc+"> "+sMsg,4)
        end if
      case "join"    'Someone joined a channel    
        if lcase$(sSrc) = sMe then 'joining a new channel
          var iChan = ChanCreate(sMsg)
          NickJoin(iChan,sSrc,cmRegular)
        else
          var iChan = FindChan(sMsg)
          NickJoin(iChan,sSrc,cmRegular)
          AddLine(iChan,sSrc+" joined "+sMsg,10)
        end if
      case "part"    'Someone left a channel      
        if lcase$(sSrc) = sMe then 'joining a new channel
          if ChanDestroy(sMsg) = iCurrent then iCurrent = 0
          CheckConsoleSize(1):CheckKeyboardInput(1)
        else
          var iChan = FindChan(sMsg)
          NickPart(iChan,sSrc)
          AddLine(iChan,sSrc+" left "+sMsg,10)
        end if     
      case "quit"    'Someone quit from a channel 
        var iMask = 7, iChan = NickPart(-1,sSrc)
        for CNT as integer = 1 to 15
          if (iChan and iMask) then AddLine(CNT,sSrc+" quit: ("+sMsg+")",9)
          iChan and= (not iMask):if iChan=0 then exit for
          iMask shl= 3
        next CNT
        iChan = FindChan(sSrc)
        if iChan then AddLine(iChan,sSrc+" quit: ("+sMsg+")",9)        
      case "nick"    'Someone changed nick        
        var iMask = 7, iChan = NickRename(sSrc,sMsg)
        for CNT as integer = 1 to 15
          if (iChan and iMask) then 
            AddLine(CNT,sSrc+" is now known as "+sMsg,10)
          end if          
          iChan and= (not iMask):if iChan=0 then exit for
          iMask shl= 3
        next CNT
        iChan = FindChan(sSrc)
        if iChan then 
          tWindow(iChan).zName = sMsg
          AddLine(iChan,sSrc+" is now known as "+sMsg,10)
          UpdateChannelBar()
        end if
      case else
        AddLine(0,"["+sAct+"]{"+sMsg+"}")
      end select
    case else 'Server Info   
      AddLine(0,sMsg)
    end select      
  end select  
end sub
sub CheckNetworkInput()
  
  static sBuff as string,pBuff as any ptr,pLen as integer ptr
  if pBuff=0 then
    sBuff = space(4096):pBuff = strptr(sBuff)
    pLen = cptr(integer ptr,@sBuff)+1: *pLen = 0
  end if  
  
  static as double dLast
  if *pLen then
    if dLast = 0 then
      dLast = timer
    elseif abs(timer-dLast) > 10 then
      AddLine(0,"{"+sBuff+"}",13)
      *pLen=0:dLast=0
    end if
  end if
  
  if hSelect(SvSock) then
    dLast = 0
    var iResu = hReceive(SvSock,pBuff+*pLen,4096-*pLen)
    if iResu > 0 then
      *pLen += iResu
      do        
        var iPosi = instr(sBuff,!"\n")        
        if iPosi then 
          var iNewLen = *pLen-(iPosi)
          *pLen = iPosi-iif(iPosi>1 andalso sBuff[iPosi-2] = asc(!"\r"),2,1)
          ParseLine(sBuff): memmove(pBuff,pBuff+iPosi,iNewLen)
          *pLen = iNewLen: continue do
        end if
        iUpEdit=1:exit sub
      loop
    end if
    AddLine(StatusWindow,"Connection Closed.",12)
    hClose(SvSock):SvSock=0:dRetryTime=timer-20
    iConn = csErrorRetry:iUpEdit=3
  end if
  
end sub

with tWindow(0)
  .zName = "Status"  
end with

do
  
  CheckConsoleSize()
  CheckKeyboardInput()
  
  select case iConn
  case csConnected  'Check received packets             
    CheckNetworkInput()
  case csConnect    'Start Connection                   
    AddLine(StatusWindow,"Connecting to '"+SvHost+":" & SvPort & "'",11)
    SvIP = hresolve(SvHost): iQuitApp = 0
    if SvIP then
      SvSock = hOpen(,true)
      hConnect(SvSock,SvIP,SvPort)
      iConn = csConnecting: continue do
    end if
    AddLine(StatusWindow,"Failed to resolve hostname.",12)
    iConn = csErrorRetry: dRetryTime = timer
  case csConnecting 'Checking if it connected or error. 
    if hSelect(SvSock,1) then 
      AddLine(StatusWindow,"Connected.",11)      
      var sTemp = !"USER MicroIRC Freebasic c :Freebasic MicroIRC\r\n" _
      !"NICK "+sNick+!"\r\n" _
      !"JOIN "+sChannel+!"\r\n"
      hSend(SvSock,sTemp,len(sTemp))
      while hSelect(SvSock,1)=0
        sleep 1,1
      wend
      iConn = csConnected: dRetryTime = 0
    elseif hSelectError(SvSock) then 
      AddLine(StatusWindow,"Failed to connect.",12)
      iConn = csErrorRetry: dRetryTime = timer
    end if
  case csErrorRetry 'Error connecting retry in seconds  
    if iQuitApp then exit do
    if dRetryTime then
      if abs(timer-dRetryTime) > 30 then
        dRetryTime=0:iConn=csConnect:iQuitApp=0
      end if
    end if
  end select
  
  sleep 30,1
loop