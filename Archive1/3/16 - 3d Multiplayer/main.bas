'Version 

randomize 0
#include "clady3d.bi"
#include "vbcompat.bi"
#include "fbgfx.bi"
using fb

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

HideMouse()

sub controller()
    if Keyhit(key_Escape) then CloseEngine()
    
    nWorldMousePick(nGetMouseX(),nGetMouseY(),MouseDown(MOUSE_LEFT))
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
    
    EndScene()
Wend

EndEngine()