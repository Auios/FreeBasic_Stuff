'GAIWindows.bi

#ifndef _GAIMINI_GAIWINDOWS_BI_
#define _GAIMINI_GAIWINDOWS_BI_

#include "GAIMouse.bi"

namespace GAIMini
    
    type GAIWindow
        private:
            as integer titleBarSpace
            as integer resizeBarSpace
'            as string printBuffer(0 to 99)
        public:
            as integer x,y,w,h
            as string title
            
            declare constructor
            declare sub create()
            declare sub render()
            declare sub setSize(w as integer,h as integer)
            declare sub setPosition(x as integer,y as integer)
            declare sub setTitle(title as string)
            declare function mouseOnTitleBar(ms as gaiMouse) as byte
            declare function mouseOnResizeBar(ms as gaiMouse) as byte
    end type
    
end namespace

#endif