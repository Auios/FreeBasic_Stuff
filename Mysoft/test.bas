'#define fbc -s console

#include "Fmod.bi"
#include "windows.bi"
#include "crt.bi"
#include "fbgfx.bi"

dim shared as string FOLDER,FILENAME

#define UseTopLimit

const Fmodfreq = 44100 'Working Frequency of fmod
const MaxFreq  = 8000  'Maximum Actual Sound Frequency to quantize (max FmodFreq/2)
const BarSz = 1        'Size of Bar in chars
const VoidSz = BarSz\3 'Size of spaces between bars in chars
' Limit on 512 array for the selected MaxFreq
' Since array goes from 1hz to Niquist of FmodFreq (i.e. FmodFreq/2)
const FFTLimit = (((MaxFreq*2)*512)/Fmodfreq)-1 
' Number of bars on screen (Calculated automatically for 80 columns)
const VuLevels = int(80\(BarSz+VoidSz))-1

'FSOUND_SetOutput(FSOUND_OUTPUT_WINMM) 'Use mmsystem
FSOUND_Init( Fmodfreq , 16 , FSOUND_INIT_ACCURATEVULEVELS )

' Select Input Device ...
scope
  var iNum = FSOUND_Record_GetNumDrivers()-1    
  for CNT as integer = 0 to iNum-1
    print CNT,*FSOUND_Record_GetDriverName(CNT)
  next CNT  
  print "Which Device? 0-" & iNum-1 & "? ";
  do
    var sKey = inkey
    if len(sKey) then
      select case sKey[0]
      case 27: stop
      case 48 to 47+iNum
        FSOUND_Record_SetDriver(sKey[0]-48)
        cls: exit do
      end select
    end if
    sleep 50,1
  loop  
end scope

' Enabling internal FFT unit so Spectrum(VU) will work
var pFFT = FSOUND_DSP_GetFFTUnit()
FSOUND_DSP_SetActive(pFFT, 1)
' Get pointer to array of FLOATS (512) for the spectrum range
' Each float is the amplitude 0 to 1 spread in frequencies from 1 to (FmodFreq/2)
var pfVU = FSOUND_DSP_GetSpectrum()

' Deactivate sound output... so it will not echo the sound
FSOUND_DSP_SetActive(FSOUND_DSP_GetClipAndCopyUnit(),0)

#ifdef UseTopLimit
dim as integer iOldTopLVL(VuLevels),iTopLVL(VuLevels),iTopCnt(VuLevels)
#endif
dim as integer iMaxLVL(VuLevels),iLastLVL(VuLevels)
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

' Update console title bar with newest filename
SetConsoleTitle("VuTest: 'Capturing...'")

' Record Input (50ms buffer*2)
var iSize = cint(FmodFreq*(50/1000)),iChan=0,iLast=0
var RecSample = FSOUND_Sample_Alloc(FSOUND_FREE,iSize*2,FSOUND_NORMAL or FSOUND_LOOP_NORMAL,FmodFreq,255,128,255)
FSOUND_Record_StartSample(RecSample,true)

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
    
  ' Show Frequency that the VU is operating
  locate 1,1,0: color 15  
  printf "[1hz to %1.1fkhz]   ", ((Fmodfreq\2)*iFreq)/512000
  
  ' === Showing Bar Levels ===
  for CNT as integer = 0 to VuLevels      
    ' calculate bar verticel size 0 to 20... but can have
    ' overheard that will be clipped later (good to represent low amps)
    var iLVL = int(((fVU(CNT)/iVU(CNT))^0.75)*(20))
    ' The level is increased or decreased since previous frame?
    if iLVL >= iMaxLVL(CNT) then 'increased
      #ifdef UseTopLimit
      if iLVL >= iTopLVL(CNT) then
        iTopLVL(CNT) = iif(iLVL<=19,iLVL,19)+1
        iTopCnt(CNT) = 30 '1.5 second showing top
      end if
      #endif
      iMaxLVL(CNT) = (iLVL) 'just set it to new level
    else 'decreased
      ' smoothly decrease bar size (1 char + (2/3 avg))
      if iMaxLVL(CNT) > 0 then           
        iMaxLVL(CNT) = ((iMaxLVL(CNT)-1)*2+(iLVL))/3
      end if
    end if      
    
    #ifdef UseTopLimit
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
    #endif
    
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
      
      ' While we wait for next frame we check sample buffers
      if (FSOUND_Record_GetPosition()\iSize)<>iLast then
        static iOnce as integer
        if iOnce=0 then 'Start playing recorded sound
          iOnce=1
          iChan = FSOUND_PlaySound(FSOUND_FREE,RecSample)          
        end if
        iLast xor= 1 'Just to keep track of buffer sides
      end if
      
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
     exit do    
    end select
  end if  
    
loop
  
FSOUND_StopSound(iChan)
