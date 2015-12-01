'GAIScreen.bi
#include "crt.bi"
#include "fbgfx.bi"

#ifndef _GAIMINI_GAISCREEN_BI_
#define _GAIMINI_GAISCREEN_BI_

namespace GAIMini
    
    type GAIScreen
        private:
            as integer x,y
        public:
            declare constructor()
            declare sub create()
            declare sub destroy()
            declare sub clearScreen()
    end type
    
end namespace

#endif

'Result:
'0      Mouse within window
'1      Mouse outside window
'
'Buttons:
'1      Left
'2      Right
'3      Left and Right
'4      Middle
'5      Left and Middle
'6      Right and Middle
'7      Left, Right, and Middle