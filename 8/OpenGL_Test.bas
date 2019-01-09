#include "fbgfx.bi"
#include "Aulib/window.bi"
#include "GL/gl.bi"
#include "GL/glu.bi"

using fb, aulib

dim as AuWindow wnd

wnd.init(800, 600, 32, 1, GFX_OPENGL or GFX_MULTISAMPLE)
glViewport 0, 0, wnd.wdth, wnd.hght
wnd.show()

dim as boolean runApp = true

while(runApp)
    if(multikey(sc_escape)) then runApp = false
    glFlush()
    flip()
wend



sleep