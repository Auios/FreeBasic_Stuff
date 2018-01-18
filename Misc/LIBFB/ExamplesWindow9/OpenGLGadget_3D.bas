#include "GL/glut.bi"
#Include "window9.bi"

' only a short 3D test

enum gadgets
  OpenGL   = 1
  TBarZoom
  '...
end enum

'sub TimerProc(byval hWin as HWND, byval uMsg as UINT, byval TimerID as UINT, byval TickCount as DWORD)
sub RenderScene
  static as single xrot=0,yrot=0,zrot=0
  dim as single zoom = 1.0+GetTrackBarPos(TBarZoom)*0.025
  glClearColor(0,0.5,0.5,1)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glLoadIdentity()
  
  gluLookAt(0,-5,-30, 0,0,0, 0,1,0)
  
  glRotatef(xRot,1,0,0)
  glRotatef(yRot,0,1,0)
  glRotatef(zRot,0,0,1)
  
  glScalef(zoom,zoom,zoom)
  glutSolidTeapot(5)
  
  OpenGLGadgetSwapBuffers(opengl)
  xRot+=1
  yRot=xRot*2
  zRot=yRot*1.5
  
end sub

var win = OpenWindow("OpenGL Gadget",100,100,640,480,WS_CLIPCHILDREN or WS_VISIBLE or WS_SYSMENU)
var cw  = WindowClientWidth (win)
var ch  = WindowClientHeight(win)

OpenGLGadget(OpenGL,10,10,cw-20,ch-50)
TrackBarGadget(TBarZoom,10,ch-35,cw-20,20,0,100)


glEnable(GL_LIGHTING)
glEnable(GL_LIGHT0)

'SetTimer(NULL,NULL,33,@TimerProc)
Do
  var event = WindowEvent()
    if event = EventClose then End
  RenderScene()
  Sleep(1)
Loop