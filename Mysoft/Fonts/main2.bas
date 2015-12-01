#include "windows.bi"
#include "fbgfx.bi"

type CharData
  PixMap as any ptr
  FONTID as integer
  SX as integer
  SY as integer
  PY as integer
  PX as integer
  GX as integer
  GY as integer
  
end type

declare function DrwTxt(PX as integer,PY as integer,TEXT as string,FONTCOLOR as uinteger,TARGET as any ptr=0) as integer
declare function DrwTxt2(PX as integer,PY as integer,TEXT as string,FONTCOLOR as uinteger,TARGET as any ptr=0) as integer
declare function SetFont(FontName as string,FontSize as integer) as integer
declare function OutlinedText(TARGET as any ptr ptr=0,PX as integer,PY as integer,TEXT as string,COR as integer,BORDER as integer=0,BORDERSZ as integer=1) as integer

dim shared as uinteger ALPHA(65)
dim shared as CharData MYFONT(255)
dim shared as integer INTFONTSZ,INTFONTID
dim shared as hfont CHARFONT
dim shared as hdc CHARDC

dim as integer LINESZ
dim as double TMR,FPT

asm 'Setup alpha data
  lea edi,[ALPHA]
  mov eax,&h03030303
  mov ebx,&h83838383
  mov ecx,&h04040404
  add edi, 4
  0:
  mov [edi+0],eax  
  mov [edi+128],ebx
  add edi,4
  add ebx,ecx
  add eax,ecx
  jns 0b
end asm
ALPHA(1) = &h00000000ull
ALPHA(64) = &hFFFFFFFFull

screencontrol(fb.SET_DRIVER_NAME,"GDI")
screenres 640,480,32
open cons for output as #99
screenlock:screensync:screenunlock
'SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS)

LINESZ = SetFont("Times New Roman",26)
WindowTitle("Color Test")
screenlock
TMR = timer
for CNT as integer = 1 to 10000
  DrwTxt(5,10,"The newborn partner of our company is you!",rgb(255,0,0))
next CNT
print #99,"time per line: " & csng((timer-TMR)/10) & "ms"
screenunlock

dim as uinteger COR=&hBB9944,SWP
do
  screenlock    
  line(0,0)-(639,479),rgb(255,255,255),bf
  for POSY as integer = 2 to 480 step LINESZ*.75   
    DrwTxt(4,POSY,"The newborn partner of our company is you!",0)
    DrwTxt(6,POSY,"The newborn partner of our company is you!",0)
    DrwTxt(5,POSY-1,"The newborn partner of our company is you!",0)
    DrwTxt(5,POSY+1,"The newborn partner of our company is you!",0)
    DrwTxt(5,POSY,"The newborn partner of our company is you!",COR xor (rnd*&hFFFFFF))
    asm
      mov al,[SWP]
      add al,1
      mov [SWP],al      
      add byte ptr [COR],al
      rol dword ptr [COR],8
    end asm    
  next POSY
  screenunlock    
  sleep 10*(640/LINESZ),1
  if inkey$ <> "" then exit do    
loop

dim as integer FCNTA,FCNTB
LINESZ = SetFont("Comic Sans MS",40)
WindowTitle("Random Chars... Black Background!")
TMR = timer
do
  screenlock
  for CNT as integer = 0 to 4
    dim as integer PX=-30+rnd*700,PY=-30+rnd*540
    dim as string PC=chr$(32+rnd*224)
    DrwTxt(PX-1,PY,PC,0)
    DrwTxt(PX+1,PY,PC,0)
    DrwTxt(PX,PY,PC,0)
    DrwTxt(PX,PY+1,PC,0)
    DrwTxt(PX,PY,PC,rnd*&hFFFFFF)
    FCNTA += 5
  next CNT
  screenunlock
  if inkey$ <> "" then exit do    
  if (timer-TMR) > 2 then 
    if FCNTB=0 then 
      FCNTB=FCNTA
      print #99, FCNTA & " chars/call draw in 2 seconds."
    end if
    sleep 30,1  
  end if
loop

WindowTitle("Big Font Test")
dim as integer CCOR = rgba(0,255,255,0),CCHAR=251,FSIZE=300
dim as string KEY
dim as any ptr BKG = ImageCreate(640,480)
LINESZ = SetFont("Webdings",FSIZE)
setmouse 320,240
for CNT as integer = 0 to 1000
  line BKG,(rnd*640,rnd*480)-(rnd*640,rnd*480),rgb(rnd*128,rnd*128,rnd*128),bf
  circle BKG,(rnd*640,rnd*480),rnd*120,rgb(rnd*128,rnd*128,rnd*128),,,,f
next CNT
dim as double DRW,TOT,TCNT
FPT=timer
dim as integer MX,MY,NX,NY
do  
  getmouse NX,NY
  if (NX and NY) <> -1 then getmouse MX,MY
  screenlock
  if abs(timer-TMR) > 2 then
    if TMR=0 then SWP = DrwTxt(0,0,chr$(CCHAR),0)
    TMR = timer
    TCNT /= 5: TOT /= 5
    asm rol dword ptr [CCOR],8    
    WindowTitle("Big Font Test: " & CCHAR & " (arrows/escape)")        
  end if
  put(0,0),BKG,pset
  DRW = timer
  SWP = OutlinedText(,MX-(SWP/2),MY-(LINESZ/2),chr$(CCHAR),CCOR,COR and &h3F3F3F3F,-int(FSIZE\-150))
  TOT += ((timer-DRW)/9):TCNT += 1  
  locate 1,1: print csng((TOT/TCNT)*1000)  
  screenunlock
  while (timer-FPT) < 1/30
    sleep 1,1
  wend
  FPT += 1/30
  KEY = inkey$
  if KEY = chr$(255,fb.SC_UP) and FSIZE < 300 then 
    FSIZE *= 1.25:TMR=0:if FSIZE > 300 then FSIZE = 300
    LINESZ = SetFont("Webdings",FSIZE)
  elseif KEY = chr$(255,fb.SC_DOWN) and FSIZE > 30 then 
    FSIZE /= 1.25:TMR=0:if FSIZE < 30 then FSIZE=30
    LINESZ = SetFont("Webdings",FSIZE)
  elseif KEY = chr$(255,fb.SC_LEFT) then 
    CCHAR = (CCHAR-1) and 255: TMR=0
  elseif KEY = chr$(255,fb.SC_RIGHT) then 
    CCHAR = (CCHAR+1) and 255: TMR=0
  end if  
loop until KEY = chr$(27)

for CNT as integer = 10 to 190 step 8
  FPT = timer
  'Windowtitle "Loading..."
  TMR = timer
  LINESZ = SetFont("Trebuchet MS",CNT)  
  TMR = timer-TMR
  print #99, "Font size: " & CNT & " // Time to load: " & cint(TMR*1000) & "ms";
  'Windowtitle "Querying..."  
  screenlock
  line(0,0)-(639,LINESZ+32),0,bf
  TMR = timer
  for REP as integer = 1 to 100    
    SWP = DrwTxt(0,32,"Greg!",&hFFFFFF)
  next REP
  TMR = timer-TMR
  print #99," // Time to Draw: " & cint(TMR*10000) & "ns"
  for CNT as integer = 0 to 47
    line(0,CNT*10)-(639,CNT*10+9),rgb(0,0,CNT*2+32),bf
  next CNT
  DrwTxt(320-SWP/2,240-LINESZ/2,"Greg!",(&h010101*CNT)+&h404040)  
  screenunlock 
  while (timer-FPT) < 1/10
    sleep 1,1
  wend
next CNT

Windowtitle "done..."  
close #99
sleep

' -------------------------------------------------------------------------------
function SetFont(FontName as string,FontSize as integer) as integer  
  static as byte STARTED
  static as MAT2 CHARMAT = ((0, 1), (0, 0), (0, 0), (0, 1)) 
  
  dim as GlyphMetrics CHARMET    
  dim as integer FONTSZ,RESULT
  dim as integer PITCH,SHADE,BUFMAX
  dim as integer FONTHEI,FONTHEI2,TPIT    
  dim as any ptr PIXMAP
  
  if STARTED=0 then
    STARTED=1    
    CHARDC = CreateDC("DISPLAY",null,null,null)
  end if
  
  FONTSZ = -MulDiv(FontSize, GetDeviceCaps(CHARDC, LOGPIXELSY), 72)
  if CHARFONT then DeleteObject(CHARFONT):CHARFONT=0  
  CHARFONT = CreateFont(FONTSZ,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,0,0,0,0,FontName)
  selectObject(CHARDC,CHARFONT)
  
  for ICHAR as integer=0 to 255        
    GetGlyphOutline(CHARDC,ICHAR,GGO_GRAY8_BITMAP or _
    GGO_METRICS,@CHARMET,null,null,@CHARMAT)        
    with CHARMET            
      MYFONT(ICHAR).GX = .gmBlackBoxX
      MYFONT(ICHAR).GY = .gmBlackBoxY
      MYFONT(ICHAR).SX = .gmCellIncX+.gmptGlyphOrigin.X
      MYFONT(ICHAR).PY = FontSize-(.gmCellIncY+.gmptGlyphOrigin.Y)
      MYFONT(ICHAR).SY = .gmCellIncY+.gmptGlyphOrigin.Y
      MYFONT(ICHAR).PX = .gmptGlyphOrigin.X
      if MYFONT(ICHAR).SY > FONTHEI then FONTHEI = MYFONT(ICHAR).SY
      if MYFONT(ICHAR).PY < FONTHEI2 then FONTHEI2 = MYFONT(ICHAR).PY
    end with
  next ICHAR
  INTFONTSZ = FontSize  
  INTFONTID = cast(uinteger,CHARFONT)*cast(uinteger,FONTSIZE)
  return FONTHEI-FONTHEI2
end function
' -------------------------------------------------------------------------------
sub UpdateFont(ISFONT() as CharData,ICHAR as integer)  
  static as MAT2 CHARMAT = ((0, 1), (0, 0), (0, 0), (0, 1))   
  static as GlyphMetrics CHARMET    
  with ISFONT(ICHAR)
    if .FONTID = INTFONTID then exit sub
    .FONTID = INTFONTID
    dim as integer GX = .GX, GY = .GY
    dim as integer PITCH = GX
    if (PITCH and 3) then PITCH = (PITCH or 3)+1        
    dim as integer BUFMAX = (GY*PITCH)    
    if .PIXMAP then Deallocate(.PIXMAP)        
    .PIXMAP = allocate(BUFMAX+sizeof(fb.image))
    with *cptr(fb.image ptr,.PIXMAP)        
      .Width = GX
      .Height = GY
      .Bpp = 8
      .Pitch = PITCH        
    end with      
    GetGlyphOutline(CHARDC,ICHAR,GGO_GRAY8_BITMAP, _
    @CHARMET,BUFMAX,.PIXMAP+sizeof(fb.image),@CHARMAT)
    if BUFMAX=GDI_ERROR then Deallocate(.PIXMAP):.PIXMAP=0
  end with
end sub
function DrwTxt(PX as integer,PY as integer,TEXT as string,FONTCOLOR as uinteger,TARGET as any ptr=0) as integer
  dim as integer MYCHAR,RSZ,PX2,ITMP
  dim as integer WID,HEI,BPP,PITCH,DSX,DSY
  dim as any ptr TGTPTR,SRCPTR
  dim as integer SZX,SPT
  static as ulongint NOTBITS = &hFFFFFFFFFFFFFFFFull
  if TARGET = 0 then
    TGTPTR = screenptr
    screeninfo WID,HEI,,BPP,PITCH
  else
    TGTPTR = TARGET+sizeof(fb.image)
    imageinfo TARGET,WID,HEI,BPP,PITCH
  end if  
  if (PY-32) >= HEI then return 0  
  if INTFONTSZ > 105 then 'method for big fonts
    select case BPP  
    case 4 '32 bits
      for CNT as integer = 0 to len(TEXT)-1
        MYCHAR = TEXT[CNT]
        UpdateFont(MYFONT(),MYCHAR)
        with MYFONT(MYCHAR)      
          ITMP = (.SX-.PX): PX2 = PX+ITMP      
          if PX2 > 0 then
            if .PixMap then
              if PX >= WID then exit for   
              SRCPTR = .PixMap: DSX=.PX:DSY=.PY          
              asm          
                movd mm7,esp
                mov edi,[TGTPTR]         ' Target Pointer
                mov esi,[SRCPTR]         ' Source pointer
                mov ebx,[esi+offsetof(fb.image,width)]  'Source Width
                mov ecx,[esi+offsetof(fb.image,height)] 'Source height
                mov esp,[esi+offsetof(fb.image,pitch)]  'Source Pitch
                add esi,sizeof(fb.image) 'point to the imagebits
                mov eax,[PY]             ' initial position Y
                add eax,[DSY]            ' add with displacement
                jns 1f                   ' not negative? skip adjust
                neg eax                  ' change signal
                sub ecx,eax              ' subtract from source height
                jle 9f                   ' finish if totally outside target
                imul eax,esp             ' lines in source pitch
                add esi,eax              ' adjust source
                jmp 2f                   ' skip target Y adjust
                1:                    'skipping source adjust
                mov edx,ecx              ' get source height
                add edx,eax              ' posi Y + height
                sub edx,[HEI]            ' bottom of image outside target?
                jl 1f                    ' no? skip size adjust
                sub ecx,edx              ' subtract from source height
                jle 9f                   ' finish if totally outside target
                1:                    'skipping height adjust
                imul eax,[PITCH]         ' lines in target pitch
                add edi,eax              ' adjust target
                2:                    'skipping target Y adjust
                mov eax,[PX]             ' initial position X
                add eax,[DSX]            ' add with displacement
                jns 1f                   ' not negative? skip adjust
                neg eax                  ' change signal
                sub ebx,eax              ' subtract from source width
                jle 9f                   ' finish if totally outside
                lea esi,[esi+eax*1]      ' adjust source pixels to the begin
                jmp 2f                   ' skip target X adjust
                1:                    'skipping source adjust
                mov edx,ebx              ' get source width
                add edx,eax              ' posi X + width
                sub edx,[WID]            ' right of image outside target?
                jl 1f                    ' no? skip size adjust
                sub ebx,edx              ' subtract from source width
                js 9f                    ' finish if totally outside target
                1:                    'skipping width adjust
                lea edi,[edi+eax*4]      ' adjust target pixels to the begin
                2:                       ' skipping target X adjust
                movd mm1,[FONTCOLOR]     ' reading color
                movq mm3,[NOTBITS]
                movq mm5,mm1
                sub ebx,1
                punpcklbw mm1,mm1        ' converting bytes to words
                1:                       ' begin of a line
                mov edx,ebx              ' get pixels to process in a line
                2:                       ' next pixel
                movzx eax, byte ptr [esi+edx] 'reading alpha value
                cmp eax,60
                ja 4f
                cmp eax,4
                jl 3f
                'movq mm0,[ALPHA+eax*8]   ' get expanded alpha from table as words
                punpcklbw mm0,[ALPHA+eax*4]
                movd mm2,[edi+edx*4]
                movq mm4,mm0
                punpcklbw mm2,mm2
                pxor mm4,mm3
                pmulhuw mm0,mm1          ' multiply alpha x color (get high word of result)
                pmulhuw mm2,mm4          ' multiply alpha x color (get high word of result)
                paddusw mm0,mm2
                psrlw mm0,8              ' get high byte of word
                packuswb mm0,mm0         ' convert to bytes
                movd [edi+edx*4],mm0     ' save resulting pixel
                3:
                sub edx,1                ' decrement pixel count
                jns 2b                   ' continue until line is over
                add esi,esp              ' point to the next source line
                add edi,[PITCH]          ' point to the next target line
                sub ecx,1                ' there are more lines to process?
                jnz 1b                   ' yes? go process
                jmp 9f
                4:
                movd [edi+edx*4],mm5
                sub edx,1                ' decrement pixel count
                jns 2b                   ' continue until line is over
                add esi,esp              ' point to the next source line
                add edi,[PITCH]          ' point to the next target line
                sub ecx,1                ' there are more lines to process?
                jnz 1b                   ' yes? go process
                9:                     'finished blitting
                movd esp,mm7
                emms                     ' empty mmx state
              end asm
            end if
          end if
          PX = PX2: RSZ += .SX-.PX
        end with
      next CNT
      
    end select
  else                    'method for small fonts
    select case BPP  
    case 4 '32 bits
      for CNT as integer = 0 to len(TEXT)-1
        MYCHAR = TEXT[CNT]    
        UpdateFont(MYFONT(),MYCHAR)
        with MYFONT(MYCHAR)      
          ITMP = (.SX-.PX): PX2 = PX+ITMP      
          if PX2 > 0 then
            if .PixMap then
              if PX >= WID then exit for   
              SRCPTR = .PixMap: DSX=.PX:DSY=.PY          
              asm          
                movd mm7,esp
                mov edi,[TGTPTR]         ' Target Pointer
                mov esi,[SRCPTR]         ' Source pointer
                mov ebx,[esi+offsetof(fb.image,width)]  'Source Width
                mov ecx,[esi+offsetof(fb.image,height)] 'Source height
                mov esp,[esi+offsetof(fb.image,pitch)]  'Source Pitch
                add esi,sizeof(fb.image) 'point to the imagebits
                mov eax,[PY]             ' initial position Y
                add eax,[DSY]            ' add with displacement
                jns 1f                   ' not negative? skip adjust
                neg eax                  ' change signal
                sub ecx,eax              ' subtract from source height
                jle 9f                   ' finish if totally outside target
                imul eax,esp             ' lines in source pitch
                add esi,eax              ' adjust source
                jmp 2f                   ' skip target Y adjust
                1:                    'skipping source adjust
                mov edx,ecx              ' get source height
                add edx,eax              ' posi Y + height
                sub edx,[HEI]            ' bottom of image outside target?
                jl 1f                    ' no? skip size adjust
                sub ecx,edx              ' subtract from source height
                jle 9f                   ' finish if totally outside target
                1:                    'skipping height adjust
                imul eax,[PITCH]         ' lines in target pitch
                add edi,eax              ' adjust target
                2:                    'skipping target Y adjust
                mov eax,[PX]             ' initial position X
                add eax,[DSX]            ' add with displacement
                jns 1f                   ' not negative? skip adjust
                neg eax                  ' change signal
                sub ebx,eax              ' subtract from source width
                jle 9f                   ' finish if totally outside
                lea esi,[esi+eax*1]      ' adjust source pixels to the begin
                jmp 2f                   ' skip target X adjust
                1:                    'skipping source adjust
                mov edx,ebx              ' get source width
                add edx,eax              ' posi X + width
                sub edx,[WID]            ' right of image outside target?
                jl 1f                    ' no? skip size adjust
                sub ebx,edx              ' subtract from source width
                js 9f                    ' finish if totally outside target
                1:                    'skipping width adjust
                lea edi,[edi+eax*4]      ' adjust target pixels to the begin
                2:                       ' skipping target X adjust
                movd mm1,[FONTCOLOR]     ' reading color
                movq mm3,[NOTBITS]
                sub ebx,1
                punpcklbw mm1,mm1        ' converting bytes to words
                1:                       ' begin of a line
                mov edx,ebx              ' get pixels to process in a line
                2:                       ' next pixel
                movzx eax, byte ptr [esi+edx] 'reading alpha value
                'movq mm0,[ALPHA+eax*8]   ' get expanded alpha from table as words
                punpcklbw mm0,[ALPHA+eax*4]
                movd mm2,[edi+edx*4]
                movq mm4,mm0
                punpcklbw mm2,mm2
                pxor mm4,mm3
                pmulhuw mm0,mm1          ' multiply alpha x color (get high word of result)
                pmulhuw mm2,mm4          ' multiply alpha x color (get high word of result)
                paddusw mm0,mm2
                psrlw mm0,8              ' get high byte of word
                packuswb mm0,mm0         ' convert to bytes
                movd [edi+edx*4],mm0     ' save resulting pixel
                sub edx,1                ' decrement pixel count
                jns 2b                   ' continue until line is over
                add esi,esp              ' point to the next source line
                add edi,[PITCH]          ' point to the next target line
                sub ecx,1                ' there are more lines to process?
                jnz 1b                   ' yes? go process
                9:                     'finished blitting
                movd esp,mm7
                emms                     ' empty mmx state
              end asm
            end if
          end if
          PX = PX2: RSZ += .SX-.PX
        end with
      next CNT  
    end select
  end if  
  return RSZ
end function
' -------------------------------------------------------------------------------
function OutlinedText(TARGET as any ptr ptr=0,PX as integer,PY as integer,TEXT as string,COR as integer,BORDER as integer=0,BORDERSZ as integer=1) as integer  
  drwtxt(PX-BORDERSZ,PY-BORDERSZ,TEXT,BORDER,TARGET)
  drwtxt(PX+BORDERSZ,PY-BORDERSZ,TEXT,BORDER,TARGET)
  drwtxt(PX-BORDERSZ,PY+BORDERSZ,TEXT,BORDER,TARGET)
  drwtxt(PX+BORDERSZ,PY+BORDERSZ,TEXT,BORDER,TARGET)
  drwtxt(PX-BORDERSZ,PY,TEXT,BORDER,TARGET)
  drwtxt(PX+BORDERSZ,PY,TEXT,BORDER,TARGET)
  drwtxt(PX,PY-BORDERSZ,TEXT,BORDER,TARGET)
  drwtxt(PX,PY+BORDERSZ,TEXT,BORDER,TARGET)
  return drwtxt(PX,PY,TEXT,COR,TARGET)
end function