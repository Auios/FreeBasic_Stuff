''=============================================================================

''

''    Easy GL2D (FB.IMAGE compatible version)

''

''    By Relminator (Richard Eric M. Lope)

''    http://rel.betterwebber.com

''   

''    FAST Pixel Perfect Collision Detection

''    Uses the sofware surface to detect collisions

''    While using the hardware to draw

''

''=============================================================================

 

#Pragma Once

 

 

 

 

 

'' include needed libs

#Include Once "fbgfx.bi"

#Include Once "gl/gl.bi"

#Include Once "gl/glu.bi"  

 

#Include Once "fbgl2d.bi"  

#Include Once "fbgl2d.bas"

 

 

'' MYSOFT'S collision detection

'' Modified the 32 bit pixel check so account for

'' the way GL2D stores sprites in alpha mode

''

Function Collide_sprites(OAX As Integer, OAY As Integer,OBJA As Any Ptr,  OBX As Integer, OBY As Integer, OBJB As Any Ptr) As Integer

  Dim As Integer COLLI,TX,TY,RESULT,IBPP

  Dim As Integer OASX,OASY,OBSX,OBSY

  Dim As Integer OAXX,OAYY,OBXX,OBYY

  Dim As Integer APIT,BPIT,XCNT,YCNT

  Dim As Any Ptr ASTRT,BSTRT,CSTRT

  OASX = CPtr(fb.image Ptr,OBJA)->Width-1

  OASY = CPtr(fb.image Ptr,OBJA)->height-1

  OBSX = CPtr(fb.image Ptr,OBJB)->Width-1

  OBSY = CPtr(fb.image Ptr,OBJB)->height-1

  OAXX = OAX+OASX:OAYY = OAY+OASY

  OBXX = OBX+OBSX:OBYY = OBY+OBSY

  APIT = CPtr(fb.image Ptr,OBJA)->PITCH

  BPIT = CPtr(fb.image Ptr,OBJB)->PITCH

  IBPP = CPtr(fb.image Ptr,OBJA)->BPP

  If IBPP = 1 Then

    IBPP = 0

  ElseIf IBPP = 2 Then

    IBPP = 1

  ElseIf IBPP = 4 Then

    IBPP = 2

  Else

    Return 0

  End If

 

  Do   

    If OAX >= OBX And OAX <= OBXX Then

      ' ********** 11 ***********

      If OAY >= OBY And OAY <= OBYY Then

        If OBXX > OAXX Then TX = OAXX Else TX = OBXX

        If OBYY > OAYY Then TY = OAYY Else TY = OBYY       

        ASTRT = OBJA + SizeOf(fb.image)

        BSTRT = OBJB + SizeOf(fb.image) + _

        ((OAX-OBX) Shl IBPP) + ((OAY-OBY)*BPIT)

        XCNT = (TX-OAX)+1:YCNT = (TY-OAY)+1

        APIT -= ((TX-OAX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((TX-OAX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 11: Exit Do

      End If

      ' ********** >12< ***********

      If OAYY >= OBY And OAYY <= OBYY Then

        If OBXX > OAXX Then TX = OAXX Else TX = OBXX       

        ASTRT = OBJA + SizeOf(fb.image) + ((OBY-OAY)*APIT)

        BSTRT = OBJB + SizeOf(fb.image) + ((OAX-OBX) Shl IBPP)

        XCNT = (TX-OAX)+1:YCNT = (OAYY-OBY)+1

        APIT -= ((TX-OAX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((TX-OAX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 12: Exit Do

      End If

      ' *********** 13 *************

      If OAY <= OBY And OAYY >= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + ((OBY-OAY)*APIT)

        BSTRT = OBJB + SizeOf(fb.image) + ((OAX-OBX) Shl IBPP)

        XCNT = (OBXX-OAX)+1:YCNT = OBSY+1

        APIT -= ((OBXX-OAX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OBXX-OAX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 13: Exit Do

      End If

    End If

   

    If OAXX >= OBX And OAXX <= OBXX Then

      ' *********** <21> *************

      If OAY >= OBY And OAY <= OBYY Then

        If OBYY > OAYY Then TY = OAYY Else TY = OBYY       

        ASTRT = OBJA + SizeOf(fb.image) + ((OBX-OAX) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image) + ((OAY-OBY)*BPIT)

        XCNT = (OAXX-OBX)+1:YCNT = (TY-OAY)+1

        APIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 21: Exit Do

      End If

      ' *********** <22> ************

      If OAYY >= OBY And OAYY <= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + _

        ((OASY-(OAYY-OBY))*APIT) + _

        ((OASX-(OAXX-OBX)) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image)

        XCNT = (OAXX-OBX)+1:YCNT = (OAYY-OBY)+1

        APIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 22: Exit Do

        ' *********** <23> ************

      End If

      If OAY <= OBY And OAYY >= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + _

        ((OBY-OAY)*APIT) + ((OBX-OAX) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image)

        XCNT = (OAXX-OBX)+1:YCNT = OBSY+1

        APIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OAXX-OBX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 23: Exit Do

      End If

    End If

   

    If OAX <= OBX And OAXX >= OBXX Then

      ' ********** <31> *************

      If OAY >= OBY And OAY <= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + ((OBX-OAX) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image)  + ((OAY-OBY)*BPIT)

        XCNT = OBSX+1:YCNT = (OBYY-OAY)+1

        APIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 31: Exit Do

      End If

      ' ********** <32> *************

      If OAYY >= OBY And OAYY <= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + _

        ((OBY-OAY)*APIT) + ((OBX-OAX) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image)

        XCNT = OBSX+1:YCNT = (OAYY-OBY)+1

        APIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 32: Exit Do

      End If

      ' ********** <33> *************

      If OAY <= OBY And OAYY >= OBYY Then

        ASTRT = OBJA + SizeOf(fb.image) + _

        ((OBY-OAY)*APIT) + ((OBX-OAX) Shl IBPP)

        BSTRT = OBJB + SizeOf(fb.image)

        XCNT = OBSX+1:YCNT = OBSY+1

        APIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)

        BPIT -= ((OBSX) Shl IBPP)+(1 Shl IBPP)       

        RESULT = 33: Exit Do

      End If

    End If

    Return 0   

  Loop

 

  If XCNT Then   

    Select Case IBPP

    Case 0

      ' ******** 8 bpp pixel check ******

      Asm     

        mov ESI,[ASTRT]

        mov EDI,[BSTRT]

        mov EAX,[APIT]

        mov EBX,[XCNT]

        mov EDX,[YCNT]     

        _CPNEXTLINE8_:

        mov ECX,EBX

        _CPNEXTPIXEL8_:

        cmp Byte Ptr [ESI],0       

        je _CPSKIPPIXEL8_

        cmp Byte Ptr [EDI],0       

        je _CPSKIPPIXEL8_

        jmp _CPENDCOLISION8_

        _CPSKIPPIXEL8_:

        inc ESI

        inc EDI

        dec ECX

        jnz _CPNEXTPIXEL8_

        Add ESI,EAX

        Add EDI,[BPIT]

        dec EDX

        jnz _CPNEXTLINE8_    

        neg dword Ptr [RESULT]

        _CPENDCOLISION8_:

      End Asm

    Case 1

      ' ******** 16 bpp pixel check ******

      Asm     

        mov ESI,[ASTRT]

        mov EDI,[BSTRT]       

        mov EBX,[XCNT]

        mov EDX,[YCNT]

        mov EAX,[APIT]

        _CPNEXTLINE16_:

        mov ECX,EBX       

        _CPNEXTPIXEL16_:       

        cmp word Ptr [ESI],0xF81F

        je _CPSKIPPIXEL16_

        cmp word Ptr [EDI],0xF81F

        je _CPSKIPPIXEL16_              

        jmp _CPENDCOLISION16_

        _CPSKIPPIXEL16_:

        Add ESI,2

        Add EDI,2

        dec ECX

        jnz _CPNEXTPIXEL16_

        Add ESI,EAX       

        Add EDI,[BPIT]

        dec EDX

        jnz _CPNEXTLINE16_    

        neg dword Ptr [RESULT]

        _CPENDCOLISION16_:

      End Asm

    Case 2

      ' ******** 32 bpp pixel check ******

      Asm     

        mov ESI,[ASTRT]

        mov EDI,[BSTRT]

        mov EBX,[XCNT]

        mov EDX,[YCNT]

        mov EAX,[APIT]

        _CPNEXTLINE32_:

        mov ECX,EBX

        _CPNEXTPIXEL32_:

        cmp dword Ptr [ESI],0x00FF00FF

        je _CPSKIPPIXEL32_

        cmp dword Ptr [EDI],0x00FF00FF

        je _CPSKIPPIXEL32_     

        jmp _CPENDCOLISION32_

        _CPSKIPPIXEL32_:     

        Add ESI,4

        Add EDI,4

        dec ECX

        jnz _CPNEXTPIXEL32_

        Add ESI,EAX

        Add EDI,[BPIT]

        dec EDX

        jnz _CPNEXTLINE32_    

        neg dword Ptr [RESULT]

        _CPENDCOLISION32_:

      End Asm   

    End Select

  End If

 

  Return RESULT

 

End Function

 

#Ifndef FALSE

Const As Integer FALSE = 0

Const As Integer TRUE = Not FALSE

#EndIf

 

Dim As Integer limit_fps = FALSE

 

Print "Limit FPS? Y/N"

 

Dim As String k = UCase(Input(1))

 

Select Case k

     Case "Y"

           limit_fps = TRUE

     Case "N"

           limit_fps = FALSE

End Select

 

Const SCR_WIDTH = 640

Const SCR_HEIGHT = 480

 

Const As Single PI = Atn(1)*4

'' set up textures

 

Dim As Single time_start = 0

Dim demosecs As Integer

demosecs = 0

 

'' initialize gl2d

gl2d.screen_init( SCR_WIDTH, SCR_HEIGHT )

 

Using FB

 

 

 

ScreenControl ( SET_WINDOW_TITLE  , "FB.IMAGE compatible Easy GL2D by Relminator" )

 

Dim As Integer frames_per_sec = 0

Dim As Integer fps = 0

 

'' UNREM Enable antialias

'  GL2D.enable_antialias()

 

 

 

If limit_fps Then

     gl2d.vsync_on()

End If

 

 

''===================== FB EXAMPLE FILE TEST ===============================================

'' Got this sprite in the CHM examples

    

     '' make a standard FB image

     Dim As Any Ptr bg = ImageCreate(SCR_WIDTH, SCR_HEIGHT, RGBA(0,0,0,255))

    

     Dim img As fb.image Ptr = ImageCreate( 32, 32, RGB(255, 0, 255), 32 )

     Circle img, (16, 16), 15, RGB(255, 255, 0),     ,     , 1, f

     Circle img, (10, 10), 3,  RGB(  0,   0, 0),     ,     , 2, f

     Circle img, (23, 10), 3,  RGB(  0,   0, 0),     ,     , 2, f

     Circle img, (16, 18), 10, RGB(  0,   0, 0), 3.14, 6.28

 

     '' load the sprite to HW (SW data still remains for whatever purposes you want)

     '' Pixel perfect collision FTW!!!

     gl2d.load_image_to_HW(Cast(gl2d.image Ptr, img))

''================= END FB EXAMPLE FILE TEST ===============================================

 

 

 

Dim As Integer xa, ya, xb, yb

 

xa = 100

ya = 100

 

xb = 200

yb = 100

 

Do

    

     frames_per_sec += 1

    

     '' clear buffer

     gl2d.clear_screen()

    

     '' normal color

     glColor4ub(255,255,255,255)

 

    

    

     glColor4ub(255,255,255,255)

    

    

    

     gl2d.set_blend_mode(GL2D.E_TRANS)

    

     gl2d.sprite(xb,yb,Cast(gl2d.image Ptr,img))

 

     gl2d.sprite(xa,ya,Cast(gl2d.image Ptr,img))

 

 

     'gl2d.box(xa,ya,xa+img->width,ya+img->height, GL2D_RGBA(255,255,255,255))

 

 

     Dim As Single timer_elapsed = (Timer - demosecs)

     time_start =  Timer

     If timer_elapsed > 1 Then

           fps = frames_per_sec/timer_elapsed

           frames_per_sec = 0

         demosecs = Timer

     End If

    

    

     '' Test print

     gl2d.set_blend_mode(GL2D.E_TRANS)   '' blended

     glColor4ub(255,255,255,255)  '' no transluceny

     gl2d.print_scale(0, 10,1.5, "Fast Pixel-Perfect Collision FPS = " + Str(fps))

    

     gl2d.print_scale(0, 25,2, "Use arrow keys to move")

    

     Dim As Integer collide = Collide_sprites( xa, ya, img, xb,yb, img) > 0

    

     gl2d.print_scale(0, 50,2, "collision = " + Str(collide))

    

    

     If MultiKey(SC_LEFT ) And xa >   0 Then xa = xa - 1

    If MultiKey(SC_RIGHT) And xa < 639 Then xa = xa + 1

    If MultiKey(SC_UP   ) And ya >   0 Then ya = ya - 1

    If MultiKey(SC_DOWN ) And ya < 479 Then ya = ya + 1

 

    Flip

   

   

     Sleep 1,1

Loop Until MultiKey( FB.SC_ESCAPE )

 

 

 

'' destroy da happy face

gl2d.destroy_image(Cast(gl2d.image Ptr,img))

gl2d.destroy()

 

 

'' Reset screen and test the sprite in

'' FBGFX mode

ScreenRes 640, 480, 32

 

Cls

 

Print "Back in FBGFX"

Put(100,100), img, Trans

 

Sleep

Sleep

 

End

 