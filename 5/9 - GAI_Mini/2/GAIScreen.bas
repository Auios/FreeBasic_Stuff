'GAIScreen.bas

#include "GAIScreen.bi"

namespace GAIMini
    
    constructor GAIScreen()
        with this
            screeninfo .x,.y
        end with
    end constructor
    
    sub GAIScreen.create()
        with this
            screenres .x,.y,32,1,fb.GFX_SHAPED_WINDOW or fb.GFX_HIGH_PRIORITY
        end with
    end sub
    
    sub GAIScreen.destroy()
        screen 0
    end sub
    
    sub GAIScreen.clearScreen()
        with this
            line(0,0)-(.x-1,.y-1),rgb(255,0,255),bf
        end with
    end sub
    
end namespace
