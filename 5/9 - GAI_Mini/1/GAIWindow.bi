'GAIWindow.bi
#ifndef _GAIWindow_BI_
#define _GAIWindow_BI_

namespace GAI
    type screenProp
        private:
            as integer pW,pH
        public:
            declare sub set(x as integer,y as integer)
    end type
end namespace
#endif