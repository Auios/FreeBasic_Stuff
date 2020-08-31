#include "Clady3d.bi"

dim as integer scrnx, scrny
screenInfo(scrnx, scrny)
initEngine(0, scrnx, scrny, 32, 1)

hideMouse()

nSetBackgroundColor(128, 128, 128)
nSetAmbientLight(200, 200, 200)

nEnableVSync()
nEnableAntiAlias()

dim as nCamera camera = nCreateCameraFPS(300, 0.2)
nSetEntityPosition(camera, 0, 50, 0)
nSetCameraRange(camera, 4, 12000)


dim as nTexture texture = nLoadTexture("assets/images/blueCircle256.png")
nCreateSkyDome(texture,10000)

dim as nMesh mesh = nCreateMeshPlane(256, 1)
nSetEntityTexture(mesh, texture, 0)

while(engineRun())
    
    if(keyHit(KEY_ESCAPE)) then closeEngine()
    
    beginScene()
    
    UpdateEngine(0.01)
    
    endScene()
wend

endEngine()