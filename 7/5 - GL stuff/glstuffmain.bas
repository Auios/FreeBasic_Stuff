#include "gl/glut.bi"
#include "windowObj.bas"

randomize(timer())

sub clearScreen()
    glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT)
end sub

sub drawPoint(x as single, y as single, size as single)
    glColor3f(1*rnd(),1*rnd(),1*rnd())
    glPointSize(size)
    glBegin(GL_POINTS)
        glVertex2i(x, y)
    glEnd()
end sub

sub drawSquare(x as single, y as single, size as single)
    
end sub

'-------------------------------------------------------------------------------

sub getInput cdecl(key as ubyte, mx as integer, my as integer)
    dim as integer modifier = glutGetModifiers()
    
    select case key
    case 27
        end 0
    case asc("f")
        
        'wnd.destroy()
    end select
end sub

sub render cdecl()
    'clearScreen()
    'glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluOrtho2D(0.0, 800.0, 0.0, 600.0)
    drawPoint()
    glutSwapBuffers()
end sub

sub idle cdecl()
    glutPostRedisplay()
    glFlush()
end sub

'-------------------------------------------------------------------------------

dim shared as windowObj wnd
wnd.init(__FB_ARGC__, *__FB_ARGV__)
wnd.create(800,600,"Test")

glutKeyboardFunc(@getInput)
glutDisplayFunc(@render)
glutIdleFunc(@idle)

glutMainLoop()







