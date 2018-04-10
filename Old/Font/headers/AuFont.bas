#include "AuFont.bi"

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

function printFont(PX as integer,PY as integer,TEXT as string,FONTCOLOR as uinteger,TARGET as any ptr=0) as integer
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
function printOutlineFont(PX as integer,PY as integer,TEXT as string,COR as integer,BORDER as integer=0,BORDERSZ as integer=1, TARGET as any ptr ptr=0) as integer
    printFont(PX-BORDERSZ,PY-BORDERSZ,TEXT,BORDER,TARGET)
    printFont(PX+BORDERSZ,PY-BORDERSZ,TEXT,BORDER,TARGET)
    printFont(PX-BORDERSZ,PY+BORDERSZ,TEXT,BORDER,TARGET)
    printFont(PX+BORDERSZ,PY+BORDERSZ,TEXT,BORDER,TARGET)
    printFont(PX-BORDERSZ,PY,TEXT,BORDER,TARGET)
    printFont(PX+BORDERSZ,PY,TEXT,BORDER,TARGET)
    printFont(PX,PY-BORDERSZ,TEXT,BORDER,TARGET)
    printFont(PX,PY+BORDERSZ,TEXT,BORDER,TARGET)
    return printFont(PX,PY,TEXT,COR,TARGET)
end function

