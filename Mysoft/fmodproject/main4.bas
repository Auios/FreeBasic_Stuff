#define fbc -s console

#include "MysoftFmod.bi"
#include "windows.bi"
#include "crt.bi"
#include "fbgfx.bi"

dim shared as string FOLDER,FILENAME

const Fmodfreq = 44100 'Working Frequency of fmod
const MaxFreq  = 5512  'Maximum Actual Sound Frequency to quantize (max FmodFreq/2)
const BarSz = 3       'Size of Bar in chars
const VoidSz = BarSz\3 'Size of spaces between bars in chars
' Limit on 512 array for the selected MaxFreq
' Since array goes from 1hz to Niquist of FmodFreq (i.e. FmodFreq/2)
const FFTLimit = (((MaxFreq*2)*512)/Fmodfreq)-1 
' Number of bars on screen (Calculated automatically for 80 columns)
const VuLevels = int(80\(BarSz+VoidSz))-1

' Play a single file repeating or... all files in a folder
' (if FOLDER is set it overrides FILENAME)
FILENAME = "data/beat1.mp3"
FOLDER = "data\" 'exepath()

FSOUND_Init( Fmodfreq , 16 , FSOUND_INIT_ACCURATEVULEVELS )

' Enabling internal FFT unit so Spectrum(VU) will work
var pFFT = FSOUND_DSP_GetFFTUnit()
FSOUND_DSP_SetActive(pFFT, 1)
' Get pointer to array of FLOATS (512) for the spectrum range
' Each float is the amplitude 0 to 1 spread in frequencies from 1 to (FmodFreq/2)
var pfVU = FSOUND_DSP_GetSpectrum()

dim as integer iMaxLVL(VuLevels),iLastLVL(VuLevels)
dim as integer iOldTopLVL(VuLevels),iTopLVL(VuLevels),iTopCnt(VuLevels)
dim as string sBar = string(BarSz,"#"),sBlank=space(BarSz),sClip=string(BarSz,"_")
dim as double TMR = timer
dim as integer iLoop = FSOUND_LOOP_NORMAL

' Set Screen Size and draw a horizontal line of minimum Bar Sz
' To Prevent the bars from showing nothing until they are used
width 80,25: locate 24,1: color 8+1
for CNT as integer = 0 to VuLevels
  iLastLVL(CNT) = 20
  print sBar+space(VoidSz);
next CNT

' Check if FOLDER exists and add a "/" in case one isnt present
' So that it will work for enumeration + loading of each music
if len(FOLDER) then 
  if FOLDER[len(FOLDER)-1] <> asc("\") then
    if FOLDER[len(FOLDER)-1] <> asc("/") then
      FOLDER += "/"
    end if
  end if
  FILENAME = dir$(FOLDER+"*.mp3") 'Get First MP3 of FOLDER
  iLoop = FSOUND_LOOP_OFF 'And Disable looping
end if

while len(FILENAME)

  ' Update console title bar with newest filename
  SetConsoleTitle("VuTest: '"+FILENAME+"'")
  
  ' Load Song... Get it's duration and Start playing it
  var MyMusic = FSOUND_Stream_Open(FOLDER+FILENAME,iLoop,0,0)
  var iDuration = FSOUND_Stream_GetLengthMs(MyMusic)  
  var iChan = FSOUND_Stream_Play(FSOUND_FREE,MyMusic)
    
  do ' ==== Loop while the music is playing ====
    
    dim as single fVU(VuLevels),iVU(VuLevels) 'Arrays with AMPLITUDE level for each BAR
    dim as single fADJ=VuLevels/sqr(FFTLimit) 'Multiplier so that MaxFreq scales to Vu BARS
    dim as integer iPrevLevel=0,iSkipGap=0,iFreq=0
    for iFreq = 0 to 511 'VuLevels
      var iNum = int((sqr(iFreq)*fADJ))-iSkipGap 'More importance to low freqs
      ' Skipping GAP in the bars
      if (iNum-iPrevLevel) > 1 then 'Found a GAP!
        iSkipGap += (iNum-iPrevLevel)-1      'Number of gap BARS to skip
        iNum -= ((iNum-iPrevLevel)-1) 
      end if
      iPrevLevel = iNum 'Keep Last Index for GAP check
      'Im Grabbing the biggest AMP level for the freq range
      'Since the levels scale exponentially (remember one octave is double freq of previous one)
      if pfVU[iFreq] > fVU(iNum) then fVU(iNum) = pfVU[iFreq] 
      'Setting Divisor to 1 (reserved for different scalings)
      'Like for example if you SUM/AVERAGE amplitudes on the range
      iVU(iNum) = 1  
      'Fill Gaps in bar with scaled averages between them
      if iNum >= VuLevels then exit for 'exits when all Levels are filled
    next iFreq  
    
    ' Show the current position that the music is playing
    var iMS = FSOUND_Stream_GetTime(MyMusic)
    var iMinute = iMS\(1000*60) mod 60
    var iSecond = (iMS\1000) mod 60
    var iMili   = (iMS\10) mod 100
    locate 1,1,0: color 15
    printf "%02i:%02i.%02i (%i%%) ",iMinute,iSecond,iMili,(iMS*100)\iDuration
    printf "[1hz to %1.1fkhz]   ", ((Fmodfreq\2)*iFreq)/512000
    
    ' === Showing Bar Levels ===
    for CNT as integer = 0 to VuLevels      
      ' calculate bar verticel size 0 to 20... but can have
      ' overheard that will be clipped later (good to represent low amps)
      var iLVL = int(((fVU(CNT)/iVU(CNT))^0.75)*(20))
      ' The level is increased or decreased since previous frame?
      if iLVL >= iMaxLVL(CNT) then 'increased
        if iLVL >= iTopLVL(CNT) then
          iTopLVL(CNT) = iif(iLVL<=19,iLVL,19)+1
          iTopCnt(CNT) = 30 '1.5 second showing top
        end if
        iMaxLVL(CNT) = (iLVL) 'just set it to new level
      else 'decreased
        ' smoothly decrease bar size (1 char + (2/3 avg))
        if iMaxLVL(CNT) > 0 then           
          iMaxLVL(CNT) = ((iMaxLVL(CNT)-1)*2+(iLVL))/3
        end if
      end if      
      
      scope 'Draw Top Level
        if iTopCnt(CNT) then iTopCnt(CNT) -= 1
        if iTopCnt(CNT)=0 and iTopLvl(CNT)>0 then iTopLvl(CNT) -= 1
        if iTopLvl(CNT)<>iOldTopLvl(CNT) then
          var iX=1+(CNT*(BarSz+VoidSz))
          color 8
          if iTopLvl(CNT) < iOldTopLvl(CNT) then
            locate 24-iOldTopLvl(CNT),iX: print sBlank;
          end if
          if iTopLvl(CNT) > 1 then Locate 24-iTopLvl(CNT),iX: print sClip;
          iOldTopLvl(CNT) = iTopLvl(CNT)
        end if
      end scope      
      
      ' Only Draws something if bar size changes
      if iLastLVL(CNT) <> iMaxLVL(CNT) then      
        var iX=1+(CNT*(BarSz+VoidSz))   'Horizontal Position of the bar
        var iSzY = iMaxLVL(CNT)         'Size of the bar (vertical chars)
        var iMinY = iLastLVL(CNT)       'Previous Size
        if iSzY >= 20 then iSzy = 19    'maximum 20 (0 to 19) units
        if iMinY >= 20 then iMiny = 19  'maximum 20 (0 to 19) units
        iLastLVL(CNT) = iMaxLVL(CNT)    'store previous AMP level
        ' draws chars if size increased
        for iY as integer = iMinY to iSzy 
          'color is 9/10/12
          locate 24-iY,iX: color 8+(1 shl (iY/8)):print sBar;
        next iY
        ' clear chars if previous size was bigger than current
        for iY as integer = (24-iSzy)-1 to (24-iMinY) step -1
          locate iY,iX: print sBlank;
        next iY    
      end if    
    next CNT  
    
    ' Keep the update framerate to 20 FPS              
    ' Changing framerate affects "smooth drop" of bars 
    if abs(timer-TMR) > 1 then 'Program Frozed for a little?
      TMR = timer 'Then avoid excessed updates
    else
      'Waits until 1/20 second passed (since last time)
      while abs(timer-TMR) < 1/20 
        sleep 1,1
      wend
      'So marks that 1/20 seconds passed
      'So if the sleep waited more than it should
      'Next time it will waits less to compensate
      TMR += 1/20 
    end if
    
    var sKey = inkey$
    if len(sKey) then 'A Key was pressed?
      select case sKey[0] 'Which Key?
      case 27   'ESCAPE exits program
       exit while
      case 13   'ENTER pause/resume music
        FSOUND_SetPaused( iChan , FSOUND_GetPaused(iChan)=0 )
      case else 'Any other key advanced to next music
        exit do
      end select
    end if
    
      
  loop until FSOUND_IsPlaying(iChan)=0
  
  ' Stop Current Music and free it's stream
  FSOUND_Stream_Stop(MyMusic)
  FSOUND_Stream_Close(MyMusic)
  
  ' Gets next music on a folder (if any)
  FILENAME = dir$()
  
wend