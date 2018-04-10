#define fbc -s gui -dll -Wl Torque.o
#include "windows.bi"
#include "win\psapi.bi"

#include "torque.bi"

function init() as bool export
    if(torque_init() = 0) then return false
    dim as long FBVariable = 52
    
    Printf("Hello world!!!!!!!!!!!!")
    ConsoleVariableInt("FBVariable",@FBVariable)
    
    return true
end function

CreateThread(NULL, 0, cast(LPTHREAD_START_ROUTINE,@init), NULL, 0, NULL)