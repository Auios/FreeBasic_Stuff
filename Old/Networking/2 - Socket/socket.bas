#include "win/winsock2.bi"

' Winsock specific calls.
DECLARE SUB Winsock_Close ()
DECLARE SUB Winsock_Start ()

DIM SHARED as string DummyStringA, WinsockVersion


' Custom string routines.
DIM SHARED as string Key, InsertKey                ' Keyboard input stuff for later on.

' 640 x 480 
SCREEN 18, 8, 2

DO ' ======= MAIN LOOP

  ' Keyboard
  Key = INKEY                                                    ' Grab our key from keyboard.
  IF Key = CHR(255) + CHR(82) THEN InsertKey = InsertKey' XOR 1   ' Toggle insert key state.

LOOP UNTIL Key = CHR(27) OR Key = CHR(255) + "k"  ' == END OF MAIN LOOP

SUB Winsock_Close

' Winsock's shut down routine that cleans up everything associated with Winsock.
WSACleanUp
END

END SUB

SUB Winsock_Start

' Winsock's data structure has to be used to retrieve our version info.
DIM MakeOurWSAData AS WSAdata

' Fire up Winsock! We're requesting v2.0
IF WSAStartup(MAKEWORD(2, 0), @MakeOurWSAData) THEN
  SELECT CASE WSAGetLastError
    CASE WSASYSNOTREADY
      PRINT "Underlying Network subsystem is not ready."
    CASE WSAVERNOTSUPPORTED
      PRINT "The requested version is not supported."
    CASE WSAEINPROGRESS
      PRINT "A blocking Windows Sockets 1.1 operation is in progress."
    CASE WSAEPROCLIM
      PRINT "Winsock's usage has reached its limits by other programs."
    CASE WSAEFAULT
      PRINT "The second parameter is not a valid WSAData type."
    CASE ELSE
      PRINT "Unknown error. Error code (if any): ", WSAGetLastError
    END SELECT
  SLEEP
  END 
END IF

/'
  Even though we know that 2.0 (or higher) is supported, we will go ahead and check
  the highest version you have available. You may now use the returned values from
  MakeOurWSAData to pull up the highest available version of Winsock.
'/

dim as string ourversionmajor,ourversionminor,winsockversion

OurVersionMajor = LTRIM(STR(MakeOurWSAData.wHighVersion AND 255))
OurVersionMinor = LTRIM(STR(MakeOurWSAData.wHighVersion SHR 8))
WinsockVersion = "v" + OurVersionMajor + "." + OurVersionMinor

END SUB