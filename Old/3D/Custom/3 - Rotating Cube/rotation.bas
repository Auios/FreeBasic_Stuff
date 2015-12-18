DECLARE SUB PSET3D(X AS INTEGER, Y AS INTEGER, Z AS INTEGER, XAngle AS INTEGER, YAngle AS INTEGER, ZAngle AS INTEGER, Clr AS INTEGER)

dim shared as integer scrnx,scrny
randomize timer
#include "fbgfx.bi"
using fb

scrnx = 800
scrny = 600

dim shared as integer XCENTER
dim shared as integer YCENTER
dim shared as integer ZCENTER = 750

XCENTER = scrnx/2
YCENTER = scrny/2

CONST FOV = 256
CONST PI = 3.141592654#
DIM SHARED SINTable(359) AS SINGLE '0 - 359 = 360 Degrees
DIM SHARED COSTable(359) AS SINGLE
DIM a AS INTEGER

FOR a = 0 TO 359
    SINTable(a) = SIN(a * PI / 180)  
    COSTable(a) = COS(a * PI / 180)  
NEXT

SUB PSET3D(X AS INTEGER, Y AS INTEGER, Z AS INTEGER, XAngle AS INTEGER, YAngle AS INTEGER, ZAngle AS INTEGER, Clr AS INTEGER)
    'We'll insert our rotation code here:
    DIM AS INTEGER NewX, NewY, NewZ, RotX, RotY, RotZ
    'Rotation on the X-axis:
    NewY = Y * COSTable(XAngle) - Z * SINTable(XAngle)
    NewZ = Z * COSTable(XAngle) + Y * SINTable(XAngle)
    Y = NewY
    Z = NewZ
    'Rotation on the Y-axis:
    NewZ = Z * COSTable(YAngle) - X * SINTable(YAngle)
    NewX = X * COSTable(YAngle) + Z * SINTable(YAngle)
    X = NewX
    'Rotation on the Z-axis:
    NewX = X * COSTable(ZAngle) - Y * SINTable(ZAngle)
    NewY = Y * COSTable(ZAngle) + X * SINTable(ZAngle)
    RotX = NewX
    RotY = NewY
    RotZ = NewZ
    'And we'll change the PSET3D routine to use the rotated coords:
    circle (FOV * RotX / (RotZ + ZCENTER) + XCENTER, FOV * RotY / (RotZ + ZCENTER) + YCENTER),5,Clr,,,,f 'Divide both axises by Z and move to center.
END SUB

screenres scrnx,scrny,16,2,0
DIM XCoord AS INTEGER
DIM YCoord AS INTEGER
DIM ZCoord AS INTEGER
DIM YA AS integer 'The Y Angle of rotation
dim as integer lsize = 200
dim as integer dsize = 15
dim shared as integer spd = 5
DO
    
    if multikey(sc_w) then zcenter +=spd
    if multikey(sc_s) then zcenter -=spd
    if multikey(sc_a) then xcenter -=spd
    if multikey(sc_d) then xcenter +=spd
    if multikey(sc_space) then ycenter -=spd
    if multikey(sc_lshift) then ycenter +=spd
    
    SCREENLOCK
    CLS
    
    ya+=1
    
    FOR XCoord = -lsize TO lsize STEP dsize
        FOR ZCoord = -lsize TO lsize STEP dsize
            FOR YCoord = -lsize TO lsize STEP dsize
                if zcenter > 0 then PSET3D XCoord, YCoord, ZCoord, ya, YA, ya, RGB(255*rnd, 255*rnd, 255*rnd) 'A white point
                if xcoord = dsize * 5 then PSET3D XCoord, YCoord, ZCoord, ya, YA, ya, RGB(255, 0, 0) 'A white point
                draw string(5,5),"" & ya
            NEXT
        NEXT
    NEXT
    SCREENUNLOCK
    sleep 1
LOOP UNTIL MULTIKEY(1)

screen 0

end 0