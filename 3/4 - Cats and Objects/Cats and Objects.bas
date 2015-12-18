Print "--Controls:"
print "WASD         - Movement"
print "Left Click   - Drag Stuff"
print "Right Click  - Spawn Current Entity"
print "--Entitys:"
print "1.           - Spheres"
print "2.           - Cubes"
print "3.           - Bigger Cubes"
print "4.           - Vehicle"
print "5.           - Tires"
print "6.           - Huge Fucking Glitch Platform Thing"
print "7.           - Un-Textured Chair"
print
print "Got it? Press any key to continue..."
sleep
print
print
print " ----- "

#include "clady3d.bi"
randomize timer

dim shared as nCamera Camera
dim shared as nFont font1

dim shared as integer scrnx,scrny,gravity
scrnx = 800
scrny = 600
gravity = -20

nEnablevSync()
nEnableAntiAlias()

InitEngine(0,scrnx,scrny,32,0)
nSetbackgroundcolor(128,128,128)
nSetambientlight(250,250,250)
nSetWorldGravity(0,gravity,0)
nSetWorldSize(30000,30000,30000)
nSetPhysicQuality(Q_LINEAR)
nSetFog(96,96,96,.0001)


Camera = nCreateCameraFPS(100,.25)
nSetEntityPosition(camera,2500,500,2500)
nSetCameraRange(camera,0.1,12000)

font1=nLoadFont("media/font/courier.xml")
nSetFont(font1)

dim as nTexture skytex01 = nLoadTexture("media/images/FullskiesOvercast0036_1_S.jpg")
nCreateSkyDome(Skytex01,10000)'Creates the sky

dim shared as nTexture texcolormap
texcolormap = nLoadTexture("media/terrain/colormap.jpg")
dim shared as nTexture texdetail
texdetail = nLoadTexture("media/terrain/detail.jpg")
dim shared as ntexture Tex01
Tex01 = nLoadTexture("media/images/Wood.jpg")
dim shared as ntexture Tex02
Tex02 = nLoadTexture("media/images/Wall.jpg")
Dim shared as nSound sound01
sound01 = nLoadSound("media/sounds/cat.wav")
nSetSoundType(sound01,1)

dim shared as nTerrain terrain
terrain = nLoadTerrain("media/terrain/mappy32.bmp",4,4,17)
nSetEntityType(terrain,4)
'nSetEntityPosition(terrain,0,0,0)
nSetMeshScale(terrain,10,4,10)
nSetEntityTexture(terrain,texcolormap,0)
nSetEntityTexture(terrain,texdetail,1)
nSetScaleTerrainTexture(terrain,1,256)

dim shared as uinteger ptr bodyterrain
bodyterrain = nCreateBodyTerrain(terrain,5)

dim shared as nMaterial TerrainMaterial
nSetMaterialType(terrain,0,4)
nSetBodyMaterial(BodyTerrain,TerrainMaterial)

'nSetCollisions(terrain,camera,3,20,20,20,0,-10,0)


sub CreateObject(tl as integer)
    dim As S camx = nGetEntityX(camera)
    dim As S camy = nGetEntityY(camera)
    dim As S camz = nGetEntityZ(camera)
    
    dim As S tarx = nGetCameraTargetX(camera)
    dim As S tary = nGetCameraTargetY(camera)+10
    dim As S tarz = nGetCameraTargetZ(camera)
    
    dim as nMesh mesh
    dim as nBody body
    
    
    select case tl
    case 1
        mesh = nCreateMeshSphere(16)
        nSetMeshScale(mesh,15,15,15)
        body = nCreateBodySphere(15,15,15,15)
        nSetEntityTexture(mesh,Tex02,0)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    case 2
        mesh = nCreateMeshcube()
        nSetMeshScale(mesh,25,25,25)
        body = nCreateBodyCube(25,25,25,15)
        nSetEntityTexture(mesh,Tex01,0)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    case 3
        mesh = nLoadMesh("media/shapes/cube.3ds")
        nSetMeshScale(mesh,20,20,20)
        body = nCreateBodyHull(mesh,15)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    case 4
        mesh = nLoadMesh("media/shapes/impreza1.3ds")
        nSetMeshScale(mesh,5,5,5)
        body = nCreateBodyHull(mesh,300)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
'        nSetBodyMaterialSoftness(body,bodyterrain,1)
    case 5
        mesh = nLoadMesh("media/shapes/tire1.3ds")
        nSetMeshScale(mesh,7,7,7)
        body = nCreateBodyHull(mesh,15)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    case 6
        mesh = nLoadMesh("media/shapes/platform.3ds")
        nSetMeshScale(mesh,15,15,15)
        body = nCreateBodyHull(mesh,1500)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    case 7
        mesh = nLoadMesh("media/shapes/chair.3ds")
        nSetMeshScale(mesh,15,15,15)
        body = nCreateBodyHull(mesh,1500)
        nSetBodyMaterialFriction(body,bodyterrain,100,80)
    end select
    
    nSetEntityParent(body,mesh)
    
    
    nSetEntityPosition(body,camx,camy,camz)
    
'    nSetEntityPosition(body,tarx,tary,tarz)
    nSetLinearVelocity(body,camx,camy,camz,tarx,tary,tarz,20)
    nPlaySound(sound01)
end sub

Hidemouse()

dim shared as integer isCrouch,tool = 1

sub controller()
    if Keyhit(key_Escape) then CloseEngine()
    
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))
    If Mousedown(MOUSE_RIGHT) Then CreateObject(tool)
    
'    if keydown(key_lshift) then isCrouch = 1
    
    if keyhit(key_1) then tool = 1
    if keyhit(key_2) then tool = 2
    if keyhit(key_3) then tool = 3
    if keyhit(key_4) then tool = 4
    if keyhit(key_5) then tool = 5
    if keyhit(key_6) then tool = 6
    if keyhit(key_7) then tool = 7
'    if keyhit(key_8) then tool = 8
'    if keyhit(key_9) then tool = 9
end sub

While(EngineRun)
    BeginScene()
    
    controller()
    UpdateEngine(1)
    
    nSetTransparency2D(255)
    nSetColors2D(255,255,255)
    nDrawOval2D(nGetMouseX,nGetMouseY,3)
    nDrawFontText(25,150,"X: "+str$(nGetEntityX(camera)),0,0)
    nDrawFontText(25,160,"Y: "+str$(nGetEntityY(camera)),0,0)
    nDrawFontText(25,170,"Z: "+str$(nGetEntityZ(camera)),0,0)
    nDrawFontText(25,190,"Tool: "+str$(tool),0,0)
    
    if tool = 4 then nDrawFontText(scrnx/2,scrny/2,"BETTER VEHICLE PHYSICS THAN BLOCKLAND!",0,0)
    if tool = 4 then nDrawFontText(scrnx/2,scrny/2+10,"BETTER VEHICLE PHYSICS THAN BLOCKLAND!",0,0)
    if tool = 4 then nDrawFontText(scrnx/2,scrny/2+20,"BETTER VEHICLE PHYSICS THAN BLOCKLAND!",0,0)
    if tool = 4 then nDrawFontText(scrnx/2,scrny/2+30,"BETTER VEHICLE PHYSICS THAN BLOCKLAND!",0,0)
    
    EndScene()
Wend

EndEngine()