#define fbc -s gui game.rc
#include "fbgfx.bi"
#include "crt.bi"
#include "vbcompat.bi"
#include "windows.bi"
#include "DrawFont.bas"

chdir exepath

type iScoreStruct
  iRandom   as ushort
  iHash     as ushort
  sNames(9) as zstring*24
  iScore(9) as integer
  iLevel(9) as short
end type
type CellStruct
  X as integer
  Y as integer
  iColor as integer
  iState as integer
  iDist  as integer
end type

dim shared as iScoreStruct ScoreTable
dim shared as CellStruct tCell(47)
dim shared as integer ColorSort(23),MustSave,iSaveHash = -1
dim shared as any ptr Balls(23),Pod1,Pod2
dim shared as string ThisExe
dim shared as short iPal(...) = { _
255,000,000 , 255,255,000 , 000,255,000 , 000,255,255 , 000,000,255 ,255,000,255, _
128,000,000 , 128,128,000 , 000,128,000 , 000,128,128 , 000,000,128 ,128,000,128, _
255,128,000 , 128,255,000 , 000,200,080 , 000,128,255 , 128,000,255 ,255,000,128, _
255,192,140 , 192,255,140 , 140,255,192 , 140,192,255 , 192,140,255 ,255,140,192 }

dim shared as integer iLevel=1,iComplete,iState,VC,iWait
dim shared as integer iScore,iScore2,iVerify
dim shared as double GameTimer
dim shared as any ptr iBackChar(40)
dim shared as single iBackX(40),iBackY(40)  

sub InitGraphics()
  dim as integer iC=0
  for CNT as integer = 32 to 32+23
    palette CNT,iPal(iC)*.8,iPal(iC+1)*.8,iPal(iC+2)*.8: iC += 3
    dim as integer PX=(CNT-32)*30
    line(PX,0)-(PX+29,799),CNT,bf
  next CNT
  
  palette   0, 000,255,000
  palette 255, 160,190,220
  palette 254, 160\4,190\4,220\4
  line(0,0)-(799,599),255,bf
  
  for CNT as integer = 0 to 23  
    Balls(CNT) = ImageCreate(28,28)
    circle balls(CNT),(14,14),13,16,,,,f
    circle balls(CNT),(14,14),10,32+CNT,,,,f  
  next CNT
  Pod1 = ImageCreate(68,68)
  Pod2 = ImageCreate(68,68)
  
  circle Pod1,(34,34),32,16,,,,f
  circle Pod1,(34,34),29,15,,,,f
  line Pod1,(33-22,34-22)-(55,56),16
  line Pod1,(34-22,34-22)-(56,56),16
  line Pod1,(35-22,34-22)-(57,56),16
  put Pod2,(0,0),Pod1,pset
  for CNT as integer = 0 to 32
    line Pod1,(33-32-CNT,35-32+CNT)-(56-CNT,58+CNT),0
    line Pod1,(32-32-CNT,35-32+CNT)-(55-CNT,58+CNT),0
    line Pod2,(35-32+CNT,33-32-CNT)-(58+CNT,56-CNT),0
    line Pod2,(36-32+CNT,33-32-CNT)-(59+CNT,56-CNT),0
  next CNT
end sub
sub DrawCapsule(X as integer,Y as integer,iColor as integer,DST as integer)   
  put(X-13,Y-13),Balls(iColor),trans
  put(X-32+DST,Y-32-DST),Pod1,trans
  put(X-32-DST,Y-32+DST),Pod2,trans
end sub
sub UpdateOrder(byref X as integer,byref Y as integer,DoReset as integer=0)
  static as integer S,VS,HV,VX,VY
  if DoReset then
    X=390 : Y=300 : S=1 : VS = 1
    HV=0 : VX=100 : VY=80
  else
    if HV=0 then        
      X += VX: VS -= 1
      if VS = 0 then HV xor= 1: VX = -VX: VS = S
    else
      Y += VY: VS -= 1
      if VS = 0 then
        HV xor= 1: VY = -VY
        S += 1: VS = S
      end if
    end if
  end if
end sub
sub SetupLevel(iLevel as integer, byref VC as integer)  
  VC = (iLevel*2)+1
  dim as integer X,Y,iX
  UpdateOrder(X,Y,1)
  for CNT as integer = 0 to 47  
    ColorSort(CNT shr 1) = 2  
    with tCell(CNT)
      if ((Y+20) mod 160) then iX = X+25 else iX = X-25
      .X = iX: .Y = Y
      .iDist = -1: .iColor = -1
    end with
    UpdateOrder(X,Y)
  next CNT  
  
  for CNT as integer = 0 to iLevel
    dim as integer iColor,iPos
    do
      iColor = int((-(iLevel+1))/6)*-6      
      iColor = int(rnd*iColor)
      
    loop until ColorSort(iColor)
    do
      iPos = int(rnd*(VC+1))
      if tCell(iPos).iColor = -1 then
        tCell(iPos).iColor = iColor
        ColorSort(iColor) -= 1
      end if
    loop while COlorSort(iColor)
  next CNT
end sub
function EncryptScores() as integer
  dim as ushort ptr CrypTemp = cast(any ptr,@ScoreTable)
  dim as ushort iHash,iCrypt = int(rnd*65536)
  *CrypTemp = iCrypt
  for CNT as integer = 2 to (sizeof(ScoreTable)\2)-1
    iHash += (CrypTemp[CNT]+CNT)
    asm rol word ptr [iHash],3
    CrypTemp[CNT] xor= iCrypt
    iCrypt += *CrypTemp
  next CNT
  CrypTemp[1] = iHash
  return iHash
end function
function DecryptScores() as integer
  dim as ushort ptr CrypTemp = cast(any ptr,@ScoreTable)
  dim as ushort iHash,iCrypt = *CrypTemp  
  for CNT as integer = 2 to (sizeof(ScoreTable)\2)-1
    CrypTemp[CNT] xor= iCrypt
    iHash += CrypTemp[CNT]+CNT
    asm rol word ptr [iHash],3
    iCrypt += *CrypTemp
  next CNT
  if CrypTemp[1] = iHash then 
    return iHash
  else
    return -1
  end if
end function
function LoadScores(ValidateOnly as integer=0) as integer
  dim as integer ScoreFile = freefile,iHash = -1
  if ValidateOnly then
    var Temp = ScoreTable
    iHash = DecryptScores()
    ScoreTable = Temp
  elseif open(ThisExe for binary access read as #ScoreFile)=0 then
    Clear ScoreTable,0,sizeof(ScoreTable)
    Get #ScoreFile,11*64,ScoreTable
    Close #ScoreFile
    var Temp = ScoreTable
    iHash = DecryptScores()
    ScoreTable = Temp
  end if
  if iHash < 0 then 
    clear ScoreTable,0,sizeof(ScoreTable)
    with ScoreTable
      .iLevel(0) = 8 : .iScore(0) = 4722 : .sNames(0) = "Z-Men"
      .iLevel(1) = 7 : .iScore(1) = 4215 : .sNames(1) = "Harvey Boom"
      .iLevel(2) = 6 : .iScore(2) = 3669 : .sNames(2) = "Mitch Swiss"
      .iLevel(3) = 6 : .iScore(3) = 3239 : .sNames(3) = "One-Peace"
      .iLevel(4) = 5 : .iScore(4) = 2888 : .sNames(4) = "Rubben10"
      .iLevel(5) = 5 : .iScore(5) = 2421 : .sNames(5) = "ColdDog"
      .iLevel(6) = 4 : .iScore(6) = 2001 : .sNames(6) = "zzSpumazz"
      .iLevel(7) = 3 : .iScore(7) = 1936 : .sNames(7) = "Ho-Ney"
      .iLevel(8) = 2 : .iScore(8) = 1345 : .sNames(8) = "YoMama"
      .iLevel(9) = 2 : .iScore(9) = 0997 : .sNames(9) = "G Was Here"
    end with      
    MustSave=1': iSaveHash = &h3F38
    iSaveHash = EncryptScores()': ScoreTable.iHash = iSaveHash
  else
    iSaveHash = iHash
  end if
  'iSaveHash = EncryptScores()  
  return iHash>=0
end function    
sub CheckScoreUpdate()
  dim as string sCmd = command$(1)
  dim as integer iCmdHash = valint(mid$(sCmd,2))  
  'if MessageBox(null,"["+sCmd+"/"+ThisExe+"] " & iCmdHash,command$(0),MB_OKCANCEL)=IDCANCEL then
  '  end
  'end if
  if "$" & iCmdHash & "$" = sCmd then
    dim as integer iHash,TempFile=freefile()   
    if open(ThisExe for binary access read as #TempFile)=0 then
      get #TempFile,11*64,ScoreTable: close #TempFile
      iHash = DecryptScores()
      if iHash >= 0 andalso iHash=iCmdHash then       
        var NewFile = left$(ThisExe,len(ThisExe)-4)
        if DeleteFile(NewFile) then
          MoveFile(ThisExe,NewFile)
        end if        
      end if
    end if
    end
  end if
end sub
function MainMenu() as integer
  
  dim as integer bpp
  screeninfo ,,bpp
  if screenptr=0 orelse bpp<>32 then
    screenres 800,600,32,,fb.GFX_NO_SWITCH or fb.GFX_HIGH_PRIORITY
    WindowTitle("MemoryGame v1.0 by Mysoft")
    dim as double TMR = timer
    if iBackChar(0)=0 then      
      dim as integer iPos
      for Y as integer = 0 to 5
        for X as integer = 0 to 5      
          iBackX(iPos) = (30+X*150)-40+rnd*80
          iBackY(iPos) = (30+Y*120)-40+rnd*80
          iBackChar(iPos) = ImageCreate(100,80,rgb(160,190,220))
          DrawFont(iBackChar(iPos),0,0,chr$(&h85+int(rnd*&h40)),"webdings",60, _
          rgb(224,224,224),rgb(160,190,220),FS_SOLID)
          iPos += 1
        next X
      next Y    
    end if
    dim as integer iSleep = 500-((timer-TMR)*1000)
    if iSleep < 16 then iSleep = 16
    sleep iSleep,1
    SetMouse 400,300
  else
    WindowTitle("MemoryGame v1.0 by Mysoft")
  end if  
  
  var sFont = "Courier New"
  dim as zstring ptr sMenu(3) = { @"Start Game",@"Instructions",@"High Scores",@"Quit" }
  dim as integer iSel = 0, iOpt = 0
  dim as any ptr pTitle = ImageCreate(800,110,rgb(160,190,220))
  dim as double TMR = timer,TMOV
  dim as integer iMX,iMY,iMB,iNX,iNY,iNB,iOX,iOY
  dim as any ptr pMenu(3),PMenuSel(3)
  
  scope
    var sText = "MemoryGame"
    dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER
    dim as uinteger iCor(...) = { _
    rgb(255,000,000),rgb(255,255,000),rgb(000,255,000),rgb(000,255,255),rgb(000,000,255), _
    rgb(255,128,000),rgb(128,255,000),rgb(000,200,080),rgb(000,128,255),rgb(255,000,128) }    
    for CNT as integer = 0 to len(sText)-1      
      var sChar = chr$(32,sText[CNT],32)
      DrawFont(pTitle,106+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,106+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,094+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,094+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)      
      DrawFont(pTitle,106+CNT*70,45,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,100+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,094+CNT*70,45,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,100+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)
      DrawFont(pTitle,100+CNT*70,45,sChar,sFont,80,iCOR(CNT),0,iStyle)      
    next CNT
    dim as uinteger ptr iPix = pTitle+sizeof(fb.image)
    for CNT as integer = 0 to (800*110)-1
      if iPix[CNT] = rgb(160,190,220) then
        iPix[CNT] = rgb(255,0,255)
      end if
    next CNT
  end scope
  
  for CNT as integer = 0 to 3
    pMenu(CNT) = ImageCreate(500,70,0)
    pMenuSel(CNT) = ImageCreate(500,70,0)
    dim as string sText = *sMenu(CNT)
    dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER    
    var pImg = pMenuSel(CNT)
    DrawFont(pImg,250+4,30,sText,sFont,50,rgb(0,192,140),0,iStyle)
    DrawFont(pImg,250,30+4,sText,sFont,50,rgb(0,192,140),0,iStyle)
    DrawFont(pImg,250-4,30,sText,sFont,50,rgb(0,192,140),0,iStyle)
    DrawFont(pImg,250,30-4,sText,sFont,50,rgb(0,192,140),0,iStyle)
    DrawFont(pImg,250,30  ,sText,sFont,50,rgb(0,000,000),0,iStyle)
    dim as ubyte ptr pBuf1 = pImg+sizeof(fb.image)
    pImg = pMenu(CNT)
    DrawFont(pImg,250,30  ,sText,sFont,50,rgb(0,000,000),0,iStyle)
    dim as ubyte ptr pBuf2 = pImg+sizeof(fb.image)
    'for CNT as integer = 0 to (500*70)-1
    'pBuf1[3] = pBuf1[2]: pBuf1[2] = 0
    'pBuf2[3] = pBuf2[2]: pBuf2[2] = 0      
    'pBuf1 += 4 : pBuf2 += 4
    'next CNT
    
  next CNT
  
  TMOV = timer
  line(0,0)-(800,600),rgb(160,190,220),bf  
  do
    
    getmouse iNX,iNY,,iNB
    if iNB <> -1 then
      iMX=iNX and (not 7) 
      iMY=iNY and (not 7)
      iMB = iNB      
    end if
    
    screenlock    
    
    for CNT as integer = 240 to 240+3*80 step 80
      line(150,CNT-30)-(650,CNT+40),rgb(160,190,220),bf
    next CNT    
    
    var iSum = (timer-TMOV)*30: TMOV = timer
    'if iSum > 4 then iSum = 4
    iSum = 1
    for CNT as integer = 0 to 31
      Put ((iBackX(CNT)-50),(iBackY(CNT)-40)),iBackChar(CNT),pset
      iBackX(CNT) -= iSum: iBackY(CNT) -= iSum
      if iBackX(CNT) < -50 then iBackX(CNT) += (800+100)
      if IBackY(CNT) < -50 then iBackY(CNT) += (600+100)
    next CNT
    
    put(-10,20),pTitle,trans
    
    iOpt = -1
    for iPos as integer = 0 to 3    
      dim as integer PX = 400,PY=240+iPos*80
      
      if iMX > 150 and iMX < 650 then        
        if iMY > (PY-30) and iMY < (PY+30) then
          iOpt = iPos
          'printf "??"
          if (iMB and 1) or iOX <> iMX or iOY <> iMY then
            iOX=iMX: iOY = iMY
            iSel = iPos
          end if
        end if
      end if
      
      if iPos = iSel then                
        put(150,PY-30),pMenuSel(iPos),alpha
      else
        put(150,PY-30),pMenu(iPos),alpha        
      end if
      
    next iPos
    
    screenunlock 
    
    if abs(timer-TMR) > 1 then
      TMR = timer
    else
      while abs(timer-TMR) < 1/20
        sleep 5,1
      wend
      TMR += 1/20
    end if    
    
    var sKey = inkey$    
    if (iMB and 1) andalso iOpt >= 0 then sKey = chr$(13)
    if len(sKey) then
      if sKey[1] = asc("H") then iSel = (iSel-1) and 3
      if sKey[1] = asc("P") then iSel = (iSel+1) and 3
      if sKey[0] = 27 or sKey[1]=asc("k") then end      
      if sKey[0] = 13 then exit do
    end if
    
  loop
  
  'for CNT as integer = 0 to ubound(iChar)
  '  if iChar(CNT) then ImageDestroy(iChar(CNT)):iChar(CNT)=0
  'next CNT
  for CNT as integer = 0 to ubound(pMenu)
    if pMenu(CNT) then ImageDestroy(pMenu(CNT)):pMenu(CNT)=0
    if pMenuSel(CNT) then ImageDestroy(pMenuSel(CNT)):pMenuSel(CNT)=0
  next CNT
  ImageDestroy(pTitle)  
  
  return iSel
  
end function
function MainGame() as integer
  screenres 800,600,8,,fb.GFX_NO_SWITCH
  InitGraphics()
  
  randomize()
  sleep 500,1
  
  iVerify = rnd*987654: iScore = 0
  iScore2 = (iScore xor (iVerify xor 12345))
  
  for iLevel = 1 to 23
    
    dim as integer iSel(1),iPos=0,iClick,iState
    dim as integer iMX,iMY,iMB,iNX,iNY,iNB
    dim as integer iBonus,iBonus2
    dim as double TMR = timer, LVL = timer
    SetupLevel(iLevel,VC): iComplete = iLevel+1
    iBonus2 = (iBonus xor (iVerify xor 54321))
    
    do     
      if (timer-GameTimer) >= 0 then exit do
      if iBonus2 <> (iBonus xor (iVerify xor 54321)) then iScore = -100235: iBonus = -99992
      if iScore2 <> (iScore xor (iVerify xor 12345)) then 
        iScore = -100235: iBonus = -99992
      else
        if iState < 3 or iScore = 0 then
          GameTimer += 1/20
        elseif iScore then
          iVerify = rnd*987654
          static as integer iWrap
          iWrap += 1
          if (iWrap and 7)=0 then iScore = iScore-1
          iScore2 = (iScore xor (iVerify xor 12345))       
          iBonus2 = (iBonus xor (iVerify xor 54321))        
        end if
      end if
      var sTMR = mid$(format$(timeserial(0,0,abs(int(timer-GameTimer))),"hh:mm:ss"),4)
      WindowTitle("Level " & iLevel & "  Score: " & iScore & "  Time: " & sTMR)
      getmouse iNX,iNY,,iNB
      if iNB <> -1 then
        iMX=iNX : iMY = iNY : iMB = INB
      end if
      
      select case iState
      case 0 'Begin of Level
        iWait=15: iState += 1
      case 1 'opening cells
        if iWait < 1 then
          for CNT as integer = 0 to VC
            tCell(CNT).iDist = -iWait
          next CNT
        end if
        iWait -= 1
        if iWait < -10 then 
          iWait=50: iState += 1
        end if
      case 2 'Closing Cells
        if iWait <= 10 then
          for CNT as integer = 0 to VC
            tCell(CNT).iDist = iWait
          next CNT
        end if
        iWait -= 1
        if iWait < 0 then 
          iState += 1
        end if
      case 3 'Waiting Click
        if iMB=1 and iClick=0 then iClick=-1
        if iMB=0 and iClick=1 then iClick=0
        if iMB=0 and iClick=-1 then iClick=1
      case 4 'Revealing Cell
        if tCell(iSel(iPos)).iDist < 10 then 
          tCell(iSel(iPos)).iDist += 2
        else
          iPos += 1: iClick = 0
          if iPos=2 then          
            iWait = 10:iPos = 0: iState += 1
          else
            iState = 3
          end if
        end if
      case 5 'Hiding Cell
        if iWait then
          dim as uinteger BlinkPal = rgb(0,0,63)
          iWait -= 1
          if tCell(iSel(0)).iColor = tCell(iSel(1)).iColor then
            BlinkPal = rgb(0,63,0): iPos = 1
          end if
          if (iWait and 1) < 1 then
            palette 15, 255,255,255
          else
            palette 15, BlinkPal
          end if
        else
          if iPos then          
            if iBonus2 <> (iBonus xor (iVerify xor 54321)) then 
              iScore = -100235: iBonus = -99992
            end if
            if iScore2 <> (iScore xor (iVerify xor 12345)) then
              iScore = -100235: iBonus = -99992
            else
              iScore += (512/(1+sqr(1+(timer-LVL))))*(1+((iBonus+(iLevel*3))/10))
              if iScore > 99999 then iScore = 99999
              iVerify = rnd*987654: iScore2 = (iScore xor (iVerify xor 12345))
              iBonus += sqr(1+(timer-LVL))
              iBonus2 = (iBonus xor (iVerify xor 54321))
            end if
            iState = 3: iPos = 0: iComplete -= 1
            if iComplete = 0 then exit do         
          else
            if tCell(iSel(0)).iDist  then 
              tCell(iSel(0)).iDist -= 2
              tCell(iSel(1)).iDist -= 2
            else
              iState = 3
              if iBonus2 <> (iBonus xor (iVerify xor 54321)) then 
                iScore = -100235: iBonus = -99992
              end if
              if iScore2 <> (iScore xor (iVerify xor 12345)) then
                iScore = -100235: iBonus = -99992
              else
                iScore *= (.9+(iLevel*.003))
                if iScore > 99999 then iScore = 99999
                iVerify = rnd*987654
                iScore2 = (iScore xor (iVerify xor 12345)) 
                iBonus = (iBonus\3)-1
                iBonus2 = (iBonus xor (iVerify xor 54321))
              end if
            end if
          end if
        end if
      end select
      
      screenlock
      line(0,0)-(800,600),255,bf
      
      for iBall as integer = 0 to VC      
        with tCell(iBall)        
          DrawCapsule(.X,.Y,.iColor,.iDist)
          if iState=3 and .iDist = 0 then          
            if iMX > .X-32 and iMX < .X+36 then
              if iMY > .Y-32 and iMY < .Y+36 then
                static as integer iXor = &h5555
                iXor = not iXor
                line(.X-32,.Y-32)-(.X+36,.Y+36),254,b,iXor
                line(.X-32,.Y-32)-(.X+36,.Y+36),0,b,iXor xor &hFFFF
                if iClick>0 then
                  iSel(iPos) = iBall: iState += 1
                end if
              end if
            end if
          end if
        end with      
      next iBall
      
      screenunlock    
      while abs(timer-TMR) < 1/20
        sleep 1,1
      wend
      TMR = timer
      
      var sKey = inkey$
      if len(sKey) then
        if sKey[1] = asc("k") then return -1
        if sKey[0] = 13 then exit do
        if sKey[0] = 27 then end
      end if
      
    loop
    
  next iLevel
  
  return 0  
  
end function
sub ShowHighScores(AfterGame as integer=0)
    
  dim as integer bpp
  screeninfo ,,bpp
  if screenptr=0 orelse bpp<>32 then
    screenres 800,600,32,,fb.GFX_NO_SWITCH or fb.GFX_HIGH_PRIORITY  
    WindowTitle("MemoryGame v1.0 by Mysoft - HighScores")
    sleep 100,1: setmouse 400,300
  end if
  
  var sFont = "Courier New"
  dim as zstring ptr sMenu(4) = { @"Name",@"   Lvl",@"Score",@"Back",@"Reset" }
  dim as integer iSel = 0, iOpt = 0
  dim as uinteger iColor
  dim as any ptr pTitle = ImageCreate(800,110,rgb(160,190,220))
  dim as double TMR = timer,TMOV
  dim as integer iMX,iMY,iMB,iNX,iNY,iNB,iOX,iOY
  dim as any ptr pMenu(4),PMenuSel(4),pScores(9)
  
  do
    
    scope
      var sText = "HighScores"
      dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER
      dim as uinteger iCor(...) = { _
      rgb(255,000,000),rgb(255,255,000),rgb(000,255,000),rgb(000,255,255),rgb(000,000,255), _
      rgb(255,128,000),rgb(128,255,000),rgb(000,200,080),rgb(000,128,255),rgb(255,000,128) }    
      for CNT as integer = 0 to len(sText)-1      
        var sChar = chr$(32,sText[CNT],32)
        DrawFont(pTitle,106+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,106+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,094+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,094+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)      
        DrawFont(pTitle,106+CNT*70,45,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,100+CNT*70,51,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,094+CNT*70,45,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,100+CNT*70,39,sChar,sFont,80,rgb(60,90,120),0,iStyle)
        DrawFont(pTitle,100+CNT*70,45,sChar,sFont,80,iCOR(CNT),0,iStyle)      
      next CNT
      dim as uinteger ptr iPix = pTitle+sizeof(fb.image)
      for CNT as integer = 0 to (800*110)-1
        if iPix[CNT] = rgb(160,190,220) then
          iPix[CNT] = rgb(255,0,255)
        end if
      next CNT
    end scope  
    
    for CNT as integer = 0 to 4
      pMenu(CNT) = ImageCreate(250,70,0)
      pMenuSel(CNT) = ImageCreate(250,70,0)
      dim as string sText = *sMenu(CNT)
      dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER    
      var pImg = pMenuSel(CNT)
      if CNT < 3 then 
        iColor = rgb(0,140,192)
      else
        iColor = rgb(0,192,140)
      end if      
      DrawFont(pImg,125+4,30,sText,sFont,50,  iColor  ,0,iStyle)
      DrawFont(pImg,125,30+4,sText,sFont,50,  iColor  ,0,iStyle)
      DrawFont(pImg,125-4,30,sText,sFont,50,  iColor  ,0,iStyle)
      DrawFont(pImg,125,30-4,sText,sFont,50,  iColor  ,0,iStyle)
      DrawFont(pImg,125,30  ,sText,sFont,50,rgb(0,0,0),0,iStyle)
      dim as ubyte ptr pBuf1 = pImg+sizeof(fb.image)
      pImg = pMenu(CNT)
      DrawFont(pImg,125,30  ,sText,sFont,50,rgb(0,0,0),0,iStyle)
      dim as ubyte ptr pBuf2 = pImg+sizeof(fb.image)
      'for CNT as integer = 0 to (500*70)-1
      'pBuf1[3] = pBuf1[2]: pBuf1[2] = 0
      'pBuf2[3] = pBuf2[2]: pBuf2[2] = 0      
      'pBuf1 += 4 : pBuf2 += 4
      'next CNT
    next CNT
        
    if AfterGame then
      if iScore2 <> (iScore xor (iVerify xor 12345)) then exit do  
      if iScore < 0 or iScore > 99999 then exit do
    end if
    
    LoadScores(1)  
    var TempScore = ScoreTable
    DecryptScores()    
    swap TempScore,ScoreTable
    
    if AfterGame then    
      with TempScore
        if iScore>.iScore(9) then        
          .iScore(9) = iScore: .iLevel(9) = iLevel: 
          .sNames(9) = string$(14,"$")        
          for iSel = 9 to 1 step -1
            if .iScore(iSel-1) > .iScore(iSel) then exit for          
            swap .sNames(iSel-1),.sNames(iSel)
            swap .iLevel(iSel-1),.iLevel(iSel)
            swap .iScore(iSel-1),.iScore(iSel)
          next iSel
        else
          exit do
        end if
      end with
    else
      iSel = -1
    end if
    
    for CNT as integer = 0 to 9
      pScores(CNT) = ImageCreate(800,40,0)
      dim as integer PY = 200+CNT*32
      dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER 
      dim as uinteger iColor = rgb((CNT and 1)*32,(1-(CNT and 1))*32,0)          
      dim as string sScore,sNum        
      sScore = str$(TempScore.iScore(CNT))
      sScore = string$(5-len(sScore),32)+sScore
      sNum = (CNT+1) & ". " : sNum = string$(4-len(sNum),32)+sNum
      sNum += left$(TempScore.sNames(CNT),14)
      for REP as integer = 0 to 7
        if CNT <> iSel then      
          DrawFont(pScores(CNT),40,16-15,sNum,sFont,25,iColor,0,iStyle-FS_CENTER)
        end if
        if CNT = iSel then iColor = rgb((iSel and 1)*64,(1-(iSel and 1))*64,0)
        var sLevel = str$(TempScore.iLevel(CNT)): sScore = left$(sScore,5)
        DrawFont(pScores(CNT),455,16,sLevel,sFont,25,iColor,0,iStyle)
        DrawFont(pScores(CNT),645,16,sScore,sFont,25,iColor,0,iStyle) 
      next REP
    next CNT  
    ScoreTable=TempScore
    EncryptScores()
    
    TMOV = timer
    line(0,0)-(800,600),rgb(160,190,220),bf  
    dim as string sNewName
    
    do
      
      getmouse iNX,iNY,,iNB
      if iNB <> -1 then
        iMX=iNX and (not 7) 
        iMY=iNY and (not 7)
        iMB = iNB      
      end if
      
      screenlock    
      
      'line(20,140-30)-(779,140+30),rgb(160,190,220),bf
      'line(580,530)-(790,590),rgb(160,190,220),bf
      line(0,100)-(799,599),rgb(160,190,220),bf
      
      var iSum = (timer-TMOV)*30: TMOV = timer
      'if iSum > 4 then iSum = 4
      iSum = 1
      for CNT as integer = 0 to 31
        Put ((iBackX(CNT)-50),(iBackY(CNT)-40)),iBackChar(CNT),pset
        iBackX(CNT) -= iSum: iBackY(CNT) -= iSum
        if iBackX(CNT) < -50 then iBackX(CNT) += (800+100)
        if IBackY(CNT) < -50 then iBackY(CNT) += (600+100)
      next CNT
      
      put(-10,5),pTitle,trans    
      
      for iPos as integer = 0 to 2  
        dim as integer PX = 20+iPos*250,PY=140 '+iPos*80
        put(PX,PY-30),pMenuSel(iPos),alpha
      next iPos
      
      scope
        dim as integer PX = 580, PY = 560, iPos = 3      
        iOpt = -1
        if iMX > 580 and iMX < 790 then
          if iMY > (PY-30) and iMY < (PY+30) then
            iOpt = iPos
          end if
        end if
        if iPos = iOpt then                
          put(PX,PY-30),pMenuSel(iPos),alpha
        else
          put(PX,PY-30),pMenu(iPos),alpha        
        end if
      end scope    
      
      for CNT as integer = 0 to 9
        dim as integer PY = 200+CNT*32      
        if CNT = iSel then
          dim as string sScore,sNum 
          dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER 
          dim as uinteger iColor = rgb(200,32,64)
          sScore = str$(TempScore.iScore(CNT))
          sScore = string$(5-len(sScore),32)+sScore
          sNum = (CNT+1) & ". " : sNum = string$(4-len(sNum),32)+sNum        
          var iCur = chr$(31+((timer*4) and 1))
          var sLevel = str$(TempScore.iLevel(CNT)): sScore = left$(sScore,5)
          DrawFont(,40,PY-15,sNum+sNewName+iCur,sFont,25,iColor,0,iStyle-FS_CENTER)        
          DrawFont(,455,PY,sLevel,sFont,25,iColor,0,iStyle)
          DrawFont(,645,PY,sScore,sFont,25,iColor,0,iStyle)      
        else
          put(0,PY-16),pScores(CNT),alpha
        end if     
      next CNT    
      
      screenunlock 
      
      if abs(timer-TMR) > 1 then
        TMR = timer
      else
        while abs(timer-TMR) < 1/20
          sleep 5,1
        wend
        TMR += 1/20
      end if    
      
      var sKey = inkey$
      if (iMB and 1) andalso iOpt>=0 then sKey = chr$(13)
      if len(sKey) then
        if iSel >= 0 then
          if     sKey[0] = 8 then
            if len(sNewName) then cptr(uinteger ptr,@sNewName)[1] -= 1
          elseif sKey[0] = 13 then
            if len(sNewName) then 
              dim as string sNum 
              dim as integer iStyle = FS_BOLD or FS_BLUR or FS_CENTER 
              dim as uinteger iColor = rgb((iSel and 1)*64,(1-(iSel and 1))*64,0)
              sNum = (iSel+1) & ". " : sNum = string$(4-len(sNum),32)+sNum
              for REP as integer = 0 to 7            
                DrawFont(pScores(iSel),40,16-15,sNum+sNewName, _
                sFont,25,iColor,0,iStyle-FS_CENTER)
              next REP
              TempScore.sNames(iSel) = sNewName
              swap TempScore,ScoreTable
              iSaveHash = EncryptScores()
              iSel = -1: MustSave = 1
            end if
          elseif sKey[0] = 27 or sKey[1]=asc("k") then 
            exit do,do
          elseif sKey[0] < 128 and len(sKey)=1 then
            if len(sNewName) < 14 then sNewName += sKey          
          end if
        else        
          if sKey[0] = 27 or sKey[1]=asc("k") then exit do,do
          if sKey[0] = 13 then exit do,do
        end if
      end if
      
    loop
    
  loop until pTitle
  
  for CNT as integer = 0 to ubound(pScores)
    if pScores(CNT) then ImageDestroy(pScores(CNT)):pScores(CNT)=0
  next CNT
  for CNT as integer = 0 to ubound(pMenu)
    if pMenu(CNT) then ImageDestroy(pMenu(CNT)):pMenu(CNT)=0
    if pMenuSel(CNT) then ImageDestroy(pMenuSel(CNT)):pMenuSel(CNT)=0
  next CNT
  ImageDestroy(pTitle)
  
  
end sub
' ******************************************************************
' ******************************************************************

scope
  if findwindow(null,"MemoryGame v1.0 by Mysoft - Error!") then end
  ThisExe = command$(0)
  CheckScoreUpdate()
  if OpenEvent(SYNCHRONIZE,false,"$$MysoftMemoryGame$$") then    
    MessageBox(null,"A instance of MemoryGame is already running...", _
    "MemoryGame v1.0 by Mysoft - Error!",MB_ICONSTOP or MB_SYSTEMMODAL)
    end
  else
    CreateEvent(null,null,null,"$$MysoftMemoryGame$$")
  end if
  LoadScores()
  var sNewFile = ThisExe+".exe"
  dim as integer iCheck = freefile()
  if Open(sNewFile for binary access read as #iCheck)=0 then    
    close #iCheck: kill sNewFile
  end if  
  screencontrol(fb.Set_Driver_Name,"GDI")
end scope

do
  select case MainMenu()
  case 0 'Start Game
    GameTimer = timer+(5*60)-(1/20)
    MainGame()
    ShowHighScores(1)
  case 1 'Instructions
    '
  case 2 'HighScores
    ShowHighScores()
  case 3 'Quit
    exit do
  end select
loop

if MustSave then
  if iSaveHash < 0 then
    iSaveHash = EncryptScores()
  end if  
  var sNewFile = ThisExe+".exe"
  CopyFile(ThisExe,sNewFile,False)    
  if open(sNewFile for binary as #1)=0 then  
    put #1,11*64,ScoreTable
    close #1    
    run sNewFile,"$" & iSaveHash & "$"
  end if
end if
