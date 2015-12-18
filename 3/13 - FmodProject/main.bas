#define fbc data/*.o
dim shared as ulong Future_wav_sz
asm push [Future_wav_size] 
asm pop [Future_wav_sz] 
dim shared as any ptr Future_wav_ptr 
asm mov dword ptr [Future_wav_ptr], offset Future_wav 



#include "MysoftFmod.bi"

'FSOUND_Init(mixrate , maxsoftchannels, flags)
'FSOUND_Init(44100, 16, 0)
FSOUND_Init(44100, 16, FSOUND_INIT_ACCURATEVULEVELS)

'MySample = FSOUND_Sample_Load( slot, filename, mode, offset, length)
'FSOUND_16BITS or FSOUND_STEREO or FSOUND_SIGNED
dim as FSOUND_SAMPLE MySound
'MySound = FSOUND_Sample_Load(FSOUND_FREE,Future_wav_ptr,FSOUND_NORMAL or FSOUND_LOOP_OFF or FSOUND_LOADMEMORY,0 ,Future_wav_sz)
MySound = FSOUND_Sample_Load(FSOUND_FREE,"data/beat1.mp3",FSOUND_NORMAL or FSOUND_LOOP_OFF,0 ,0)

'iChannel = FSOUND_PlaySound(ChannelNumber, Sample)
'iChannel = FSOUND_PlaySound(FSOUND_FREE, MySound)
VAR iChannel = FSOUND_PlaySound(FSOUND_FREE, MySound)

print MySound
print iChannel

'FSOUND_IsPlaying(iChannel)
while FSOUND_IsPlaying(iChannel) : sleep 1,1 : wend


'-----------
'FSOUND_StopSound(iChan)
'FSOUND_SetPaused(iChannel,isPause?)   0 = Resume, 1 = Pause

'To delete a sample you loaded
'FSOUND_Sample_Free(MySound): MySound = 0