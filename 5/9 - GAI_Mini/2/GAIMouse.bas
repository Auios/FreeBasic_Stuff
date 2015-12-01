'GAIMouse.bas

#include "crt.bi"
#include "GAIMouse.bi"

namespace GAIMini
    
    sub GAIMouse.dump()
        with this
            printf(!"MOUSE.DUMP()\n")
            printf(!"Result: %i\nX: %i,Y: %i\ndX: %i,Y: %i\nWheel: %i\nButton: %i\nClip: %i\n",.result,.x,.y,.wheel,.button,.clip)
        end with
    end sub
    
    sub GAIMouse.watch()
        with this
            .result = getMouse(.x,.y,.wheel,.button,.clip)
        end with
    end sub
    
    function GAIMouse.changed() as byte
        dim as byte result = 0
        with this
            if .oldResult <> .result or .oldX <> .x or .oldY <> .y or .oldWheel <> .wheel or .oldButton <> .button or .oldClip <> .clip then
                result = 1
                .oldResult = .result
                .oldX = .x
                .oldY = .y
                .oldWheel = .wheel
                .oldButton = .button
                .oldClip = .clip
            end if
        end with
        return result
    end function
    
    sub GAIMouse.hold()
        if isHolding = 0 then
            isHolding = 1
            ox = x
            oy = y
        end if
        dx = x-ox
        dy = y-oy
    end sub
    
    sub GAIMouse.release()
        isHolding = 0
    end sub
    
end namespace
