'GAIMouse.bi

#ifndef _GAIMINI_GAIMOUSE_BI_
#define _GAIMINI_GAIMOUSE_BI_

namespace GAIMINI
    
    type GAIMouse
        private:
            as integer Oldx,Oldy,Oldwheel,Oldbutton,Oldclip,Oldresult
            as byte isHolding
        public:
            as integer x,y,wheel,button,clip,result
            as integer dx,dy,ox,oy
            
            declare sub dump()
            declare sub watch()
            declare function changed() as byte
            declare sub hold()
            declare sub release()
    end type
    
end namespace

#endif