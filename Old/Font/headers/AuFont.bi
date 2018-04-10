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

declare function printFont(PX as integer,PY as integer,TEXT as string,FONTCOLOR as uinteger,TARGET as any ptr=0) as integer
declare function SetFont(FontName as string,FontSize as integer) as integer
declare function printOutlineFont(PX as integer,PY as integer,TEXT as string,COR as integer,BORDER as integer=0,BORDERSZ as integer=1, TARGET as any ptr ptr=0) as integer

dim shared as uinteger ALPHA(65)
dim shared as CharData MYFONT(255)
dim shared as integer INTFONTSZ,INTFONTID
dim shared as hfont CHARFONT
dim shared as hdc CHARDC

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