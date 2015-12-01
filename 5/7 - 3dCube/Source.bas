#lang "fblite"

DEFINT A-Z 'defines all unmarked variables as integers

TYPE PointType 'defines user defined type PointType

x AS INTEGER 'X coordinate

Y AS INTEGER 'Y coordinate

z AS INTEGER 'Z coordinate

END TYPE 'end definition of type PointType

TYPE LineType 'defines user defined type LineType

C1 AS INTEGER 'number of the first point of a line

C2 AS INTEGER 'number of the second point of a line

CLR AS INTEGER 'color of the line

END TYPE 'end definition of type LineType

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INFO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SCREEN 0, 0, 0, 0 'set to screen mode 0

WIDTH 80, 25'set height to 25 and width to 80 c

CLS 'clear the screen

COLOR 15 'print in color 15

PRINT "WIRE3DUO.BAS by Matt Bross, 1997" 'print the text in quotes

PRINT

COLOR 7

PRINT "3D WIREFRAME ANIMATION FOR THE QBASIC LANGUAGE"

PRINT "USE FREELY AS LONG AS I RECIEVE CREDIT DUE"

PRINT

COLOR 15

PRINT "--------CONTROLS--------"

COLOR 7

PRINT " 0 - reset rotation"

PRINT " 5 - stop rotation"

PRINT " S - reset location"

PRINT " A - stop translation"

PRINT "2, 8 - rotate around x axis"

PRINT "4, 6 - rotate around y axis"

PRINT "-, + - rotate around z axis"

PRINT CHR$(24); ", "; CHR$(25); " - translate vertically"

PRINT CHR$(27); ", "; CHR$(26); " - translate horizontally"

PRINT "Z, X - translate depthwise"

PRINT " Esc - exit"

COLOR 15

PRINT "----CASE INSENSITIVE----"

PRINT

PRINT "LOADING 0%"

'------------------------------>BEGIN INIT<-----------------------------

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%

'make fast lookup variables for calling values (e.g. if x = 1 is used

'often,x = 1, is slower than one = 1: x = one)

ZERO = 0: ONE = 1: THREESIXD = 360

intMAX = 32767: intMIN = -32768

bitsX10 = 1024

A$ = "A": S$ = "S": z$ = "Z": x$ = "X"

ZERO$ = "0": TWO$ = "2": FOUR$ = "4": FIVE$ = "5": SIX$ = "6"

EIGHT$ = "8"

PLUS$ = "+": MINUS$ = "-": EQUALS$ = "="

UP$ = CHR$(0) + "H": down$ = CHR$(0) + "P"

LEFT2$ = CHR$(0) + "K": RIGHT2$ = CHR$(0) + "M"

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%SCREEN VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = 300: SD = 60 'distance and perspective

MaxSpin = 20: MaxSpeed = 2 'max. translate and rotate

ScnMode = 7: m = 1: b = 0 'screen mode and pages

IF ScnMode <> 7 AND ScnMode <> 9 THEN ScnMode = 7

IF ScnMode = 7 THEN DX = 160: DY = 100 'center of screen mode 7

IF ScnMode = 9 THEN DX = 320: DY = 175 'center of screen mode 9

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MAKE TABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DIM SINx(360) AS LONG 'initialize array for sines

DIM COSx(360) AS LONG 'initialize array for cosines

FOR i = 0 TO THREESIXD 'loop 360 times

'Create sine and cosine tables of all degrees 0 to 360 in radians and

'scale by 1024 or 10 bits and store as a 4-byte integer. The numbers

'will be scaled down again in the main loop. This is called fixed point

'math and is faster that floating point, or math with a decimal.

SINx(i) = SIN(i * (22 / 7) / 180) * bitsX10

COSx(i) = COS(i * (22 / 7) / 180) * bitsX10

IF i MOD 40 = 0 THEN LOCATE 22, 9: PRINT STR$(i \ 4) + "%"

NEXT

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD POINTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RESTORE PointData 'Set pointer to read from label PointData.

READ MaxPoints 'Reads MaxPoints from appended data.

DIM points(1 TO MaxPoints) AS PointType 'points at start

DIM ScnPnts(1 TO MaxPoints) AS PointType 'points after rotation

DIM SX(1 TO MaxPoints), SY(1 TO MaxPoints) 'points drawn to screen

FOR i = 1 TO MaxPoints: READ points(i).x, points(i).Y, points(i).z: NEXT

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LOAD LINES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RESTORE LineData 'Set pointer to read from label LineData.

READ MaxLines 'Reads MaxLines from appended data.

DIM l(1 TO MaxLines) AS LineType 'line data

DIM OLX1(1 TO MaxLines), OLY1(1 TO MaxLines) 'old line data

DIM OLX2(1 TO MaxLines), OLY2(1 TO MaxLines)

FOR i = 1 TO MaxLines: READ l(i).C1, l(i).C2, l(i).CLR: NEXT

'-------------------------------->END INIT<-----------------------------

LOCATE 22, 9: PRINT "100%"

PRINT "Press a Key"

DO: LOOP UNTIL INKEY$ <> "" 'Do a loop until a key is pressed.

SCREEN ScnMode, 0, 0, 0 'set screen mode ScnMode

'----------------------------->BEGIN MAIN LOOP<-------------------------

DO

'*********************************GET KEY*******************************

K$ = UCASE$(INKEY$) 'get the upper case equivalent of input from the

'keyboard

SELECT CASE K$ 'select which case the string variable k$ is

CASE ZERO$

R1 = ZERO: R2 = ZERO: R3 = ZERO 'stop rotation and reset it

D1 = ZERO: D2 = ZERO: D3 = ZERO

CASE FIVE$

D1 = ZERO: D2 = ZERO: D3 = ZERO 'stop rotation

CASE A$

MX = ZERO: MY = ZERO: MZ = ZERO 'stop translation

CASE S$

MX = ZERO: MY = ZERO: MZ = ZERO 'stop translation and reset it

MMX = ZERO: MMY = ZERO: MMZ = ZERO

CASE TWO$

D1 = D1 - ONE 'rotate counter-clockwise around the x axis

CASE EIGHT$

D1 = D1 + ONE 'rotate clockwise around the x axis

CASE FOUR$

D2 = D2 - ONE 'rotate counter-clockwise around the y axis

CASE SIX$

D2 = D2 + ONE 'rotate clockwise around the y axis

CASE PLUS$, EQUALS$

D3 = D3 - ONE 'rotate clockwise around z axis

CASE MINUS$

D3 = D3 + ONE 'rotate counter-clockwise around the z axis

CASE UP$

MY = MY + ONE 'translate positively along the y axis

CASE down$

MY = MY - ONE 'translate negatively along the y axis

CASE LEFT2$

MX = MX + ONE 'translate positively along the x axis

CASE RIGHT2$

MX = MX - ONE 'translate negatively along the x axis

CASE z$

MZ = MZ + ONE 'translate positively along the z axis

CASE x$

MZ = MZ - ONE 'translate negatively along the z axis

CASE CHR$(27)

GOTO ShutDown 'end program

END SELECT

'*********************************ROTATION******************************

'keep sines and cosines in limits of the arrays

R1 = (R1 + D1) MOD THREESIXD

R2 = (R2 + D2) MOD THREESIXD

R3 = (R3 + D3) MOD THREESIXD

IF R1 < ZERO THEN R1 = THREESIXD + R1

IF R2 < ZERO THEN R2 = THREESIXD + R2

IF R3 < ZERO THEN R3 = THREESIXD + R3

'********************************TRANSLATION****************************

MMX = MMX + MX: MMY = MMY + MY: MMZ = MMZ + MZ

'keep variables within limits of integers

IF MMX > intMAX THEN MMX = intMAX

IF MMY > intMAX THEN MMX = intMAX

IF MMZ > intMAX THEN MMZ = intMAX

IF MMX < intMIN THEN MMX = intMIN

IF MMY < intMIN THEN MMX = intMIN

IF MMZ < intMIN THEN MMZ = intMIN

'******************************ROTATE POINTS****************************

S1& = SINx(R1): S2& = SINx(R2): S3& = SINx(R3)

C1& = COSx(R1): C2& = COSx(R2): C3& = COSx(R3)

FOR i = 1 TO MaxPoints

'Rotate points around the y axis.

TEMPX = (points(i).x * C2& - points(i).z * S2&) \ bitsX10

TEMPZ = (points(i).x * S2& + points(i).z * C2&) \ bitsX10

'Rotate points around the x axis.

ScnPnts(i).z = (TEMPZ * C1& - points(i).Y * S1&) \ bitsX10

TEMPY = (TEMPZ * S1& + points(i).Y * C1&) \ bitsX10

'Rotate points around the z axis.

ScnPnts(i).x = (TEMPX * C3& + TEMPY * S3&) \ bitsX10

ScnPnts(i).Y = (TEMPY * C3& - TEMPX * S3&) \ bitsX10

'*****************************CONVERT 3D TO 2D**************************

TEMPZ = ScnPnts(i).z + MMZ - SD

IF TEMPZ < ZERO THEN 'calculate points visible to the viewer

SX(i) = (ScnPnts(i).x + MMX) * D \ TEMPZ + DX

SY(i) = (ScnPnts(i).Y + MMY) * D \ TEMPZ + DY

END IF

NEXT

'******************************DRAW POLYGONS****************************

FOR i = 1 TO MaxLines

coord1 = l(i).C1: coord2 = l(i).C2

'erase old line

LINE (OLX1(i), OLY1(i))-(OLX2(i), OLY2(i)), 0

'get new points

OLX1(i) = SX(coord1): OLY1(i) = SY(coord1)

OLX2(i) = SX(coord2): OLY2(i) = SY(coord2)

'Draw line from (SX1, SY1) to (SX2, SY2) in color CLR

LINE (SX(coord1), SY(coord1))-(SX(coord2), SY(coord2)), l(i).CLR

NEXT

'******************************FRAME COUNTER****************************

F = F + 1

IF TIMER >= T# THEN

T# = TIMER + 1

FPS = F

LOCATE 1, 1

PRINT FPS: F = 0

END IF

'wait for vertical retrace, the electron beam to finish scanning the

'monitor

WAIT &H3DA, 8

LOOP

'----------------------------->END MAIN LOOP<---------------------------

ShutDown:

SCREEN 0, 0, 0, 0: WIDTH 80, 25: CLS

PRINT "Final Location of Points"

PRINT " X", " Y", " Z": PRINT STRING$(31, "-")

FOR i = 1 TO MaxPoints: PRINT ScnPnts(i).x, ScnPnts(i).Y, ScnPnts(i).z:

NEXT

PRINT : PRINT "Free space": PRINT " String Array Stack": PRINT

STRING$(21, "-")

PRINT FRE(); FRE(-1); FRE(-2): END

PointData:

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CUBE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'number of points

DATA 8

'Location of points (x, y, z)

DATA -10, 10,-10, -10,-10,-10, -10, 10, 10, -10,-10, 10

DATA 10, 10, 10, 10,-10, 10, 10, 10,-10, 10,-10,-10

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PYRAMID%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DATA 5

DATA 0, 10, 0, 0, 0,-10, 10, 0, 0, 0, 0, 10

DATA -10, 0, 0

LineData:

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CUBE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'number of lines

DATA 12

'The points above can be numbered, the first data statement is 1. The

'points listed make lines from point 1 to point 2 in color 3.

DATA 1,2, 2, 1,3, 2, 3,4, 2, 2,4, 2, 1,7, 1, 3,5, 1, 5,7, 1

DATA 5,6, 1, 7,8, 1, 6,8, 1, 4,6, 1, 2,8, 1

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PYRAMID%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DATA 8

DATA 1,2, 1, 1,3, 1, 1,4, 1, 1,5, 1, 2,3, 1, 3,4, 1, 4,5, 1

DATA 2,5, 1