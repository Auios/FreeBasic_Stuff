#include "N3xtD.bi"

' Dimes
Dim app As any Ptr
Dim Quit As Integer
Dim shared as integer gravity = -20

'----------------------------------------------------------
' open n3xt-D screen
dim as integer scrnx = 800, scrny = 600
app = _CreateGraphics3D(scrnx, scrny)
If app=NULL Then
  End
End If

_AmbientLight(&hffcccbbb)
Dim sky as EntityNode = _CreateSkybox( _LoadTexture("media/up.jpg"),_LoadTexture("media/dn.jpg"),_LoadTexture("media/lf.jpg"),_LoadTexture("media/rt.jpg"),_LoadTexture("media/ft.jpg"),_LoadTexture("media/bk.jpg"))

' Set World Attributes
_SetWorldSize(-2000, -2000, -2000, 2000, 2000, 2000)
_GravityForce(0, gravity, 0)

' set the curent folder
_ChangeWorkingDirectory("media")
'----------------------------------------- 
' Load the Bedroom
dim obj as Mesh = _LoadMesh("bedroomfull.b3d")
  dim bedroom as EntityNode = _CreateEntityNode(obj)
  _PositionNode(bedroom, 5,6,0)
  _CreateBody(bedroom,COMPLEX_PRIMITIVE_SURFACE,false)
  
' Load the floor
Dim floormesh as Mesh = _CreateCubeMesh(1.0)
Dim floor as EntityNode = _CreateEntityNode(floormesh)
  _LoadTextureNode(floor, "TTgrass01.jpg")
  _PositionNode(floor, 0, -60, 0) 
  _ScaleNode(floor, 2000, 1, 2000)
  _CreateBody(floor, BOX_PRIMITIVE, false)
  
  
'-----------------------------------------
' Create first  camera
dim cam as CameraNode = _CreateCameraFPS( )
_PositionNode(cam, -15,30,-20)
_VisibleCursorControl(false)



'-----------------------------------
' Load font png
_LoadFont("courriernew.png")
dim font as IGUIFont = _GetFont()



'--------------------------
' Subs
dim shared as integer cubes = 0
Sub spawnCube(x as integer, y as integer, z as integer)
    cubes += 1
    dim plmesh as Mesh = _LoadMesh("Player.b3d")
    dim pl as EntityNode = _CreateEntityNode(plmesh)
    '_DebugModeNode(pl, DEBUG_BBOX_BUFFERS )
    _PositionNode(pl, x, y, z)
    _CreateBody(pl, BOX_PRIMITIVE, TRUE)
end Sub

' ---------------------------------------
'           Main loop
' ---------------------------------------
While Quit=0
    If _GetKeyDown(KEY_ESCAPE) then
        Quit=1
    EndIf
    
    '-----------
    ' Controls
    if _GetKeyDown(KEY_KEY_W) then
        _MoveNode(cam, 0, 0, 1, RT_QUATERNION)
    EndIf
    if _GetKeyDown(KEY_KEY_S) then
        _MoveNode(cam, 0, 0, -1, RT_QUATERNION)
    EndIf
    if _GetKeyDown(KEY_KEY_A) then
        _MoveNode(cam, -1, 0, 0, RT_QUATERNION)
    EndIf
    if _GetKeyDown(KEY_KEY_D) then
        _MoveNode(cam, 1, 0, 0, RT_QUATERNION)
    EndIf
    
    if _GetMouseEvent(MOUSE_BUTTON_LEFT) then
        spawnCube(_NodeX(cam), _NodeY(cam), _NodeZ(cam))
    EndIf
    
    if _GetKeyDown(KEY_KEY_Z) then
        gravity += 10
        _GravityForce(0, gravity, 0)
    EndIf
    if _GetKeyDown(KEY_KEY_X) then
        gravity -= 10
        _GravityForce(0, gravity, 0)
    EndIf
    
    '---------
    ' Render
    _BeginScene()
        _DrawScene()
        _DrawText(font, "gravity: "+ str(gravity), 10, 20, 0, 0)
        _DrawText(font, "Use z and x to alter the gravity",  10, 40, 0, 0)
        _DrawText(font, "Use WASD or arrow keys to move",  10, 60, 0, 0)
        _DrawText(font, "Left click to spawn cubes",  10, 80, 0, 0)
    _EndScene()
Wend
_FreeEngine()