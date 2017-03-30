#define fbc -s gui -asm intel -gen gcc -O 1

#include "fbgfx.bi"
#Include "windows.bi"
#include "win\mmsystem.bi"
#include "crt.bi"
#include "GfxResize.bas"

const PI = 3.141592/(11025/2)
const AudioFreq = 44100, Divider = AudioFreq/11025

#include "music.bas"

type Sample as short
type StereoSample
  as sample wLeft,wRight
end type

static shared as Sample wWave(3,11025-1)

for N as integer = 0 to 11025-1    
  wWave( 0 , N ) = sin(N*PI)*16383                                              'sine
  wWave( 1 , N ) = sgn(wWave(0 , N ))*8191                                      'square
  wWave( 2 , N ) = (abs(16383-((-8191+((N*32767)\11024)) and 32767))-8191)*1.99 'triangle
  wWave( 3 , N ) = (((((N*32767)\11024)+16383) and 32767)-16383)\2              'sawtooth
next N

#ifdef GfxResize
  gfx.PreResize()
#endif
screenres 512,200,,fb.gfx_high_priority: width 512\8,200\16
#ifdef GfxResize
  gfx.Resize(1024,400)
#endif

#if 0
for iR as integer = -1 to 1
  dim as integer iOld(3)
  for N as integer = 0 to 511
    var iN = (N*11024)\511  
    for I as integer = 0 to 3
      var iNew = I*48+24+(((wWave(I,iN)*22)*iif(I=1 or I=3,2,1))\16383)      
      if N = 0 then iOld(I) = iNew
      line( N-1+iR,iOld(I) )-( N+iR, iNew ), 7+iR*8
      iOld(I) = iNew
    next I
  next N
next iR
for I as integer = 0 to 3
  line(0,I*48)-(511,I*48+48),10,b
next I
sleep
#endif

sub GetWaveOutError(iErr as integer)
  dim as wstring*4096 wErr
  waveOutGetErrorTextW( iErr , wErr , 4096 )    
  print "Failed: "+wErr    
  sleep: system
end sub
function AudioOpen( iHz as integer = 44100 , iBits as integer = 16, iChan as integer = 2 ) as HWAVEOUT
  
  dim WavFmt as WAVEFORMATEX, hResult as HWAVEOUT
  with WavFmt
    .wFormatTag       = WAVE_FORMAT_PCM
    .nSamplesPerSec   = iHz   '44.1khz
    .wBitsPerSample   = iBits '16bit
    .nChannels        = iChan 'stereo
    .nBlockAlign      = (.nChannels*.wBitsPerSample)\8  
    .nAvgBytesPerSec  = .nSamplesPerSec*.nBlockAlign
  end with  
  
  var iResu = WaveOutOpen( @hResult , WAVE_MAPPER , @WavFmt , null , null , CALLBACK_NULL )
  if iResu <> MMSYSERR_NOERROR then GetWaveOutError( iResu ) 
  
  return hResult

end function
function AudioWrite( hWave as HWAVEOUT , pzBuff as any ptr , iSz as integer ) as integer
  if hWave = null then return 0
    
  static as WAVEHDR tWaveA , tWaveB
  static as WAVEHDR ptr pWaveFront, pWaveBack
  if pWaveFront = 0 then pWaveBack = @tWaveA: pWaveFront = @tWaveB
  
  'possible wait for front buffer to finish
  with *pWaveFront
    if .lpData then
      while (.dwFlags and WHDR_PREPARED) andalso (.dwFlags and WHDR_DONE)=0
        SleepEx 1,1
      wend
      WaveOutUnprepareHeader( hWave , pWaveFront , sizeof(WAVEHDR) )
      Deallocate( .lpData ): .lpData = null
    end if
  end with  
  swap pWaveFront, pWaveBack
  
  'add new buffer
  if pzBuff andalso iSz then
    with *pWaveBack
      .lpData = allocate( iSz ) : memcpy( .lpData , pzBuff , iSz )
      .dwFlags = 0: .dwBufferLength = iSz
      WaveOutprepareHeader( hWave , pWaveBack , sizeof(WAVEHDR) )
      WaveOutWrite( hWave , pWaveBack , sizeof(WAVEHDR) )
    end with
  else
    pWaveBack->lpData = null
  end if
  
  return 1  

end function
sub AudioClose( byref hWave as HWAVEOUT )
  if hWave=0 then exit sub
  AudioWrite( hWave , 0 , 0 ): AudioWrite( hWave , 0 , 0 )
  var iResu = WaveOutClose( hWave ): hWave = null
  if iResu <> MMSYSERR_NOERROR then GetWaveOutError(iResu)
end sub

timeBeginPeriod(1)
SetPriorityClass(GetCurrentProcess(),HIGH_PRIORITY_CLASS)

var hWave = AudioOpen( AudioFreq , 16 , 2 )
cls: print AudioFreq;"hz 16bit stereo"

dim iN as integer=-1,dN as double
const BuffLen = (AudioFreq\45)*2 '(AudioFreq*BuffMS)\1000
const BuffSz = BuffLen*sizeof(StereoSample)
static shared as StereoSample lBuff(BuffLen-1)
static shared as Sample       ctBuff(3,AudioFreq\45)
dim shared as integer iOff,iTempo=0,iPat,iChans=4
dim shared as integer WavI(3),Fq(3),OldFreq(3),iTmpFreq(3),iAmp(3)
dim shared as integer iDecay=1,iWaveType=7,iTempoOff
static shared as zstring ptr pzDecay(...) = { @"No ", @"Yes" }
static shared as zstring ptr pzWave(...) = { _
  @"Sine    " , @"Square  " , @"Triangle", @"Sawtooth" , _
  @"Sin+Trig",@"Sqr+Saw ",@"ALL(0)  ",@"ALL(1)  ",@"ALL(2)  ",@"ALL(3)  "}
'if iDecay then print "Decay: enabled" else print "Decay: disabled"

function GetWaveType( N as integer ) as integer
  select case iWaveType
  case 0 to 3: return iWaveType
  case 4     : return (N*2) and 2
  case 5     : return ((N*2) and 2)+1
  case 6 to 9: return (N+(iWaveType-6)) and 3
  end select
end function
sub UpdateState()
  locate 3,1: color 7
  print "Decay: ";*pzDecay(iDecay);" - Wave: ";*pzWave(iWaveType)
  for N as integer = 0 to 3
    locate 5+N*2,23: print *pzWave( GetWaveType( N ) );
  next N
end sub
sub UpdateGraph()
  screenlock
    static as integer iCol(...) = {2,10,3,11}
    for N as integer = 0 to iChans-1
      var iN = iAmp(N)\(65536\21)    
      color iCol(N)
      locate 5+N*2,1: print string$(iN,219)+space(21-iN);
      locate 5+N*2+1,1: print string$(iN,219)+space(21-iN);
      color 7
    next N
    Color 15:locate 1,24
    print (iPat*100)\ubound(pMusic);"%  ";
    
    line(253,9)-(493,53),8,bf
    dim as integer iOld
    for N as integer = 0 to 239
      var iN = (N*((AudioFreq\45)))\240      
      var iTemp = ((((lBuff(iTempoOff+iN).wLeft)+(lBuff(iTempoOff+iN).wRight))*13)\32768)
      if abs(iTemp) > 23 then iTemp = 23*sgn(iTemp)
      var iNew = 9+22+iTemp
      if N = 0 then iOld = iNew
      line(253+N-1,iOld )-(253+N, iNew ), 15
      iOld = iNew
    next N    
    line(252,8)-(494,54),10,b
    
    for I as integer = 0 to 3
      line(252,66+I*32)-(494,94+I*32),0,bf
      dim as integer iOld, IY=64+I*32+16
      for N as integer = 0 to 240
        var iN = (N*((AudioFreq\45)))\240      
        var iTemp = (ctBuff(I,N)*13)\32768        
        var iNew = IY+iTemp : if N = 0 then iOld = iNew
        line(253+N-1,iOld )-(253+N, iNew ), 14
        iOld = iNew
      next N    
      line(252,66+I*32)-(494,94+I*32),8,b
    next I
    
  screenunlock
  
  
end sub

var pPatPtr = pMusic( iPat )
UpdateState()

while pPatPtr  
  
  for N as integer = 0 to iChans-1    
    dim as integer iType = GetWaveType(N)    
    ctBuff(N,iTempo) = ((wWave( iType , WavI(N) )*iAmp(N)) shr 15)
    if OldFreq(N) <> pPatPtr[N] then 
      iAmp(N) += Divider*128 : iTmpFreq(N) = iif(pPatPtr[N]=0,OldFreq(N),0)
      if iAmp(N) >= 65535 then
        iAmp(N) = 65535: OldFreq(N) = pPatPtr[N]
      end if
    end if        
    Fq(N) += FreqTab( iif( iTmpFreq(N) andalso iDecay , iTmpFreq(N) , pPatPtr[N] ) )
    if Fq(N) >= 32 then
      WavI(N) += (Fq(N) shr 5): Fq(N) and= 31
      if WavI(N) >= 11025 then WavI(N) -= 11025
    end if
    if iDecay then 
      if iTmpFreq(N) then
        iAmp(N) -= (44100*4)\AudioFreq 'Divider*2
      else
        iAmp(N) -= (44100*2)\AudioFreq 'Divider/1
      end if          
      if iAmp(N) < 0 then iAmp(N) = 0
    end if    
  next N
  
  iTempo += 1  
  if iTempo >= (AudioFreq\45) then    
    
    pPatPtr += iChans
    if pPatPtr[0] = &h80 then 'end of pattern
      iPat += 1: pPatPtr = pMusic(iPat)
      if pPatPtr = 0 then iPat=0:pPatPtr=pMusic(0)            
    end if
    
    #define MinMax(_V,_MI,_MA) if _V < (_MI) then _V=(_MI) else if _V > (_MA) then _V=_MA
    
    iTempoOff = iOff
    for N as integer = 0 to iTempo-1
      var iSampL = cint( (ctBuff(0,N)+ctBuff(1,N) )/1.85 )
      MinMax(iSampL,-32767,32767)      
      var iSampR = cint( (ctBuff(2,N)+ctBuff(3,N) )/1.85 )
      MinMax(iSampR,-32767,32767)      
      lBuff(iOff).wLeft = iSampL      
      lBuff(iOff).wRight = iSampR
      iOff += 1
    next N
    
    if iOff >= BuffLen then
      UpdateGraph()
      AudioWrite( hWave , @lBuff(0), BuffSz )
      iOff = 0
      do
        var sKey = inkey$
        if len(sKey)=0 then exit do        
        var iKey = cint(sKey[0])
        if iKey=255 then Ikey=-sKey[1]
        WindowTitle(iKey & " , " & asc("k"))
        select case iKey
        case asc("1") to asc("9")
          iWaveType = iKey-asc("1"): UpdateState()
        case asc("0")
          iWaveType = 9: UpdateState()
        case asc("d"),asc("D")          
          if iDecay then 
            iAmp(0)=32767:iAmp(0)=32767
            iAmp(1)=32767:iAmp(2)=32767
          end if
          iDecay xor= 1: UpdateState()
        case 27,-asc("k")          : exit while     
        end select
      loop
    end if
    
    iTempo = 0
    
  end if  
  
wend 

AudioClose(hWave)

