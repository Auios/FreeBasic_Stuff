#include "fbgfx.bi"
#include "GL/gl.bi"
#include "GL/glu.bi"
using fb

screen 18, 32, , GFX_OPENGL or GFX_MULTISAMPLE

glViewport 0, 0, 640, 480
glMatrixMode GL_PROJECTION
glLoadIdentity
gluPerspective 45.0, 640.0/480.0, 0.1, 100.0
glMatrixMode GL_MODELVIEW
glLoadIdentity

glShadeModel GL_SMOOTH
glClearColor 0.0, 0.0, 0.0, 1.0
glClearDepth 1.0
glEnable GL_DEPTH_TEST
glDepthFunc GL_LEQUAL
glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

'====
dim rtri as single, rquad as single

do
    glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
    
    glLoadIdentity
    glTranslatef -2, 0, -6
    glRotatef rtri, 1, 1, 1
    glBegin GL_TRIANGLES
        glColor3f 0.5, 0.5, 1.0
        glVertex3f 0.0, 1.0, 0.0
        glVertex3f -1.0, -1.0, 0.0
        glVertex3f 1.0, -1.0, 0.0
    glEnd
    
    glLoadIdentity
    glTranslatef 2, 0, -7
    glRotatef rquad, 1, 1, 1
    glBegin GL_QUADS
        glColor3f 0.5, 0.5, 1.0
        glVertex3f -1.0, 1.0, 0.0
        glVertex3f 1.0, 1.0, 0.0
        glVertex3f 1.0, -1.0, 0.0
        glVertex3f -1.0, -1.0, 0.0
    glEnd
    rtri += 0.5
    rquad += 0.5
    flip
    sleep 1,1
loop until multikey(sc_escape)
sleep