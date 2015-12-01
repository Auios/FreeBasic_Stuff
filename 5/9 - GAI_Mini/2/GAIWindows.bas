'GAIWindows.bas

#include "GAIMouse.bi"
#include "GAIWindows.bi"

namespace GAIMini
    
    constructor GAIWindow
        with this
            .titleBarSpace = 16
            .resizeBarSpace = 16
            .x = 100 'Position
            .y = 100
            .w = 800 'Size
            .h = 600
            .title = "GAIMini Application"
        end with
    end constructor
    
    sub GAIWindow.render()
        line(x,y)-(x+w,y+h),rgb(200,200,200),bf                                   'Background
        line(x,y+titleBarSpace)-(x+w,y+titleBarSpace),rgb(100,100,100)             'Bar line
        line(x+w-resizeBarSpace,y+h)-(x+w,y+h-resizeBarSpace),rgb(100,100,100)      'Large resize line
        line(x+w-resizeBarSpace/2,y+h)-(x+w,y+h-resizeBarSpace/2),rgb(100,100,100)  'Small resize line
        line(x,y)-(x+w,y+h),rgb(100,100,100),b                                    'Border
        draw string(x+8,y+titleBarSpace/2-3),title,rgb(50,50,50)                       'Title Text
    end sub
    
    sub GAIWindow.setSize(w as integer,h as integer)
        with this
            .w = w
            .h = h
        end with
    end sub
    
    sub GAIWindow.setPosition(x as integer,y as integer)
        with this
            .x = x
            .y = y
        end with
    end sub
    
    sub GAIWindow.setTitle(title as string)
        with this
            .title = title
        end with
    end sub
    
    function GAIWindow.mouseOnTitleBar(ms as gaiMouse) as byte
        dim as byte result = 0
        if ms.x >= this.x andalso ms.x <= this.x+this.w andalso ms.y >= this.y andalso ms.y <= this.y+titleBarSpace then
            result = 1
        end if
        return result
    end function
    
    function GAIWindow.mouseOnResizeBar(ms as gaiMouse) as byte
        dim as byte result = 0
        if ms.x >= this.x+w-resizeBarSpace andalso ms.x <= this.x+w andalso ms.y >= this.y+h-resizeBarSpace andalso ms.y <= this.y+h then
            return 1
        end if
        return result
    end function
    
end namespace
