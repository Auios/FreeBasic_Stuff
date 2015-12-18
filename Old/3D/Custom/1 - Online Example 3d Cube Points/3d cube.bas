#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny,xcen,ycen,zcen,fov
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1
'screenres 640,460,16

xcen=scrnx/2
ycen=scrny/2
zcen=256
fov=zcen

dim as uinteger white=rgb(255,255,255)
dim as integer x,y,z

DECLARE FUNCTION CalcX(X AS INTEGER, Z AS INTEGER) AS INTEGER
DECLARE FUNCTION CalcY(Y AS INTEGER, Z AS INTEGER) AS INTEGER

FUNCTION CalcX(X AS INTEGER, Z AS INTEGER) AS INTEGER
RETURN(FOV * X / (Z + ZCEN) + XCEN) 
END FUNCTION

FUNCTION CalcY(Y AS INTEGER, Z AS INTEGER) AS INTEGER
RETURN(FOV * Y / (Z + ZCEN) + YCEN)
END FUNCTION

DIM CubeXPoints(8) AS INTEGER 'We have eight X coords for our 8 points.
DIM CubeYPoints(8) AS INTEGER 'We have eight Y coords for our 8 points.
DIM CubeZPoints(8) AS INTEGER 'We have eight Z coords for our 8 points.

TYPE Point3D
    X AS INTEGER
    Y AS INTEGER
    Z AS INTEGER
END TYPE

DIM CubePoints(8) AS Point3D
DIM AS INTEGER X1, Y1, Z1, PntNum

FOR X1 = -50 TO 50 STEP 100
    FOR Z1 = -50 TO 50 STEP 100
        FOR Y1 = -50 TO 50 STEP 100
            PntNum = PntNum + 1
            CubePoints(PntNum).X =  X
            CubePoints(PntNum).Y = Y 
            CubePoints(PntNum).Z = Z 
        NEXT
    NEXT
NEXT

DO
    SCREENLOCK
    CLS
    FOR X = -50 TO 50 STEP 10
        FOR Z = -50 TO 50 STEP 10
            FOR Y = -50 TO 50 STEP 10
                PSET (CalcX(X, Z), CalcY(Y, Z)), RGB(255, 255, 255) 'We are now using PSET, but we are using our new CalcX, and CalcY vars.
            NEXT
        NEXT
    NEXT
    SCREENUNLOCK
LOOP UNTIL MULTIKEY(1)