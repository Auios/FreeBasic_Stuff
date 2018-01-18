#Include "window9.bi"
' only a short test

enum gadgets
  opengl = 1
  '...
end enum

sub TimerProc()
  var w = GadgetWidth(opengl)
  var h = GadGetHeight(opengl)
  'glClearColor(rnd,rnd,rnd,0)
  'glClear(GL_COLOR_BUFFER_BIT)
  
  glBegin(GL_POINTS)
    for i as integer = 1 to 1000
      glColor3f(rnd,rnd,rnd)
      glVertex2i(rnd*w,rnd*h)
    next
  glEnd()
  OpenGLGadgetSwapBuffers(opengl)
end sub

var win = OpenWindow("OpenGL Gadget",100,100,640,480,WS_CLIPCHILDREN or WS_VISIBLE or WS_SYSMENU)
OpenGLGadget(opengl,10,10,WindowClientWidth(win)-20,WindowClientHeight(win)-20,24,0)

Do
  var event = WindowEvent()
  if event = EventClose then End
  sleep(10)
  TimerProc
Loop

