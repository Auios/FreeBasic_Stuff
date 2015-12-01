' *******************************************************************
' wrap N3xtD for FreeBasic
'
' thank you very much for Jepalza help for the part FreeBasic.
'
' *******************************************************************
#inclib "N3XTD"

#Include "N3xtD_Const.bi"
#Include "N3xtD_Type.bi"
#Include "N3xtD_Physic.bi"

Extern "c"

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- Global application v2.0
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare sub _SetAntiAlias alias "_SetAntiAlias"(ByVal value As integer= 0)
 declare Sub _SetInputEvent alias "_SetInputEvent"(ByVal value As integer = 0)
 declare Sub _InitEngine alias "_InitEngine"()
 declare Function _CreateScreen alias "_CreateScreen"(ByVal dType As integer, ByVal dwWidth as integer, ByVal dwHeight as integer, ByVal VSync As Ubyte= 1, ByVal Depth as Integer=32, ByVal fullscreen As Ubyte= 0, ByVal stencil As UByte= 1)as any Ptr
 declare Function _CreateEngineGadget alias "_CreateEngineGadget"(ByVal hWnd as integer, ByVal dType as integer, ByVal dwWidth as integer, ByVal dwHeight as Integer, ByVal VSync As Ubyte= 1, ByVal stencil As UByte= 0)as any Ptr
 declare Sub _FreeEngine alias "_FreeEngine"()
 declare Function _BeginScene alias "_BeginScene"( ByVal red As Ubyte=0,  ByVal green As Ubyte=0,  ByVal blue As Ubyte =0, ByVal Alpha As Ubyte=255, ByVal backbuffer As Ubyte= 1,  ByVal zbuffer As UByte= 1) As Integer
 declare Function _DrawScene alias "_DrawScene"() As Integer
 declare Sub _DrawGUI alias "_DrawGUI"()
 declare Sub _EndScene alias "_EndScene"()
 declare Sub _SendLog alias "_SendLog"(ByVal logtext As zstring ptr)
 declare Sub _LogFile alias "_LogFile"(ByVal flag as Integer= 1)
 declare Function _FPS alias "_FPS"() As Integer
 declare Function _PrimitiveCountDrawn alias "_PrimitiveCountDrawn"() As Integer
 declare Function _RenderTarget alias "_RenderTarget"(ByVal target As NTexture , ByVal clearBackBuffer As Ubyte= 1,  clearZBuffe As UByte= 1,  ByVal ccolor as Integer=0) As Integer
 declare Sub _SetViewPort alias "_SetViewPort"( ByVal x as integer,  ByVal y as integer,  ByVal dx as integer,  ByVal dy as Integer )
 declare Sub _TextureCreation alias "_TextureCreation"( ByVal flag as Integer, ByVal enabled As UByte )
 declare Function _ClipPlane alias "_ClipPlane"(ByVal index as Integer, ByVal iplane As iPLANE, ByVal enable As UByte= 1) As Integer
 declare Sub _EnableClipPlane alias "_EnableClipPlane"(ByVal index as Integer,  ByVal enable As UByte= 1)
 declare Sub _GetProjectionTransform alias "_GetProjectionTransform"(ByVal mat As any Ptr)
 declare Sub _GetViewTransform alias "_GetViewTransform"(ByVal mat As any Ptr)
 declare Sub _GetWorldTransform alias "_GetWorldTransform"(ByVal mat As any Ptr)
 declare Sub _QueryFeature alias "_QueryFeature"( ByVal feature as Integer )
 declare Sub _RegisterNodeForRendering alias "_RegisterNodeForRendering"( ByVal node As EntityNode , ByVal pass as Integer )
 declare Sub _Fog alias "_Fog"(ByVal  ccolor as integer=&h00ffffff, ByVal FogType as integer= EFT_FOG_LINEAR,  ByVal start as single=50.0, ByVal FEnd as single=100.0,  ByVal density as Single=0.01,  ByVal pixelFog As Ubyte= 0,  ByVal rangeFog As UByte= 0)
 declare Sub _DistanceLOD alias "_DistanceLOD"(  ByVal d0 as single,  ByVal d1 as single,  ByVal d2 as single,  ByVal d3 as single,  ByVal d4 as single,  ByVal d5 as single)
 declare Function _CreateSceneManager alias "_CreateSceneManager"() As any Ptr
 declare Function _CurentSceneManager alias "_CurentSceneManager"(ByVal scenemanager As Any Ptr) as any Ptr
 declare Sub _DrawSceneManager alias "_DrawSceneManager"(ByVal smgr0 As any Ptr)
 Declare Sub _GetWorldViewProjection(ByVal world As Any Ptr, ByVal mat As Any ptr)


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- NODE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateEntityNode alias "_CreateEntityNode" (ByVal mmesh As Mesh, ByVal x As Single=0,  ByVal y As Single=0,  ByVal z As Single=0, ByVal parent As EntityNode =NULL) As EntityNode'; Return *EntityNode
 declare Function _CreateDebugEntity alias "_CreateDebugEntity"(ByVal mmesh As Mesh, ByVal guru As EntityNode ) As EntityNode ' Return *EntityNode
 declare Function _CreatePopNodes alias "_CreatePopNodes"(ByVal mmesh As Mesh, ByVal parent As EntityNode =NULL) As EntityNode ' Return *EntityNode
 declare Sub _PositionNode alias "_PositionNode"(ByVal node As EntityNode ,  ByVal x As single,  ByVal y As single,  ByVal z As Single)
 declare Sub _XNode alias "_XNode"(ByVal node As EntityNode ,  ByVal x As Single)
 declare Sub _YNode alias "_YNode"(ByVal node As EntityNode ,  ByVal y As Single)
 declare Sub _ZNode alias "_ZNode"(ByVal node As EntityNode ,  ByVal z As Single)
 declare Sub _RotateNode alias "_RotateNode"(ByVal node As EntityNode , ByVal x As single,  ByVal y As single,  ByVal z As Single)
 declare Sub _ScaleNode alias "_ScaleNode"(ByVal node As EntityNode , ByVal x As single,  ByVal y As single,  ByVal z As Single)
 declare Sub _TurnNode alias "_TurnNode"(ByVal node As EntityNode , ByVal x As single,  ByVal y As single,  ByVal z As Single, ByVal typeRotation As Integer=0)
 declare Sub _TranslateNode alias "_TranslateNode"(ByVal node As EntityNode , ByVal x As single,  ByVal y As single,  ByVal z As Single)
 declare Sub _MoveNode alias "_MoveNode"(ByVal node As EntityNode , ByVal x As single,  ByVal y As single,  ByVal z As Single, ByVal response As Integer=RESP_NONE)
 declare Sub _AddChildNode alias "_AddChildNode"(ByVal node As EntityNode , ByVal child As EntityNode )
 declare Function _CloneNode alias "_CloneNode"(ByVal node As EntityNode , ByVal parent As EntityNode =NULL)  As EntityNode ' Return *EntityNode
 declare Sub _NodePosition alias "_NodePosition"(ByVal node As EntityNode ,byval vect As any Ptr)
 declare Sub _NodePositionP alias "_NodePositionP"(ByVal node As EntityNode ,byval vect As any Ptr)
 declare Sub _NodeRotation alias "_NodeRotation"(ByVal node As EntityNode ,byval vect As any Ptr)
 declare Function _NodeRoll alias "_NodeRoll"(ByVal node As EntityNode ) As single
 declare Function _NodePitch alias "_NodePitch"(ByVal node As EntityNode ) As Single
 declare Function _NodeYaw alias "_NodeYaw"(ByVal node As EntityNode ) As Single
 declare Sub _NodeAbsoluteRotation alias "_NodeAbsoluteRotation"(ByVal node As EntityNode , ByVal vect As any Ptr)
 declare Sub _NodeScale alias "_NodeScale"(ByVal node As EntityNode , ByVal vect As any Ptr)
 declare Function _NodeX alias "_NodeX"(ByVal node As EntityNode ) As Single
 declare Function _NodeY alias "_NodeY"(ByVal node As EntityNode ) As Single
 declare Function _NodeZ alias "_NodeZ"(ByVal node As EntityNode ) As Single
 declare Sub _NodeTransformation alias "_NodeTransformation"(ByVal node As EntityNode , ByVal mat As any Ptr)
 declare Function _NodeChildren alias "_NodeChildren"(ByVal node As EntityNode , ByVal num As Integer=0) As integer' Return *EntityNode
 declare Function _NodeFindChildren alias "_NodeFindChildren"(ByVal node As EntityNode , ByVal child As EntityNode ) As Integer '; Return bool
 declare Function _NodeNumChildren alias "_NodeNumChildren"(ByVal node As EntityNode ) As Integer
 declare Function _NodeNumMaterial alias "_NodeNumMaterial"(ByVal node As EntityNode ) As Integer
 declare Function _NodeMaterial alias "_NodeMaterial"(ByVal node As EntityNode ,  ByVal num As Integer=0) As NMaterial
 declare Sub _MaterialNode alias "_MaterialNode"(ByVal node As EntityNode , ByVal mat As NMaterial, ByVal num As Integer=0)
 declare Function _NodeParent alias "_NodeParent"(ByVal node As EntityNode ) As Integer
 declare Sub _NodeBoundingBox alias "_NodeBoundingBox"(ByVal node As EntityNode ,  box As any Ptr)
 declare Sub _NodeTransformedBoundingBox alias "_NodeTransformedBoundingBox"(ByVal node As EntityNode ,  ByVal box As any Ptr)
 declare Function _NodeType alias "_NodeType"(ByVal node As EntityNode ) As integer
 declare Function _NodeVisible alias "_NodeVisible"(ByVal node As EntityNode ) As Integer
 declare Function _NodeName alias "_NodeName"(ByVal node As EntityNode ) As Integer
 declare Function _NodeNametype alias "_NodeNametype"(node As EntityNode )As Integer
 declare Sub _VisibleNode alias "_VisibleNode"(ByVal node As EntityNode ,  ByVal flag As UByte=TRUE)
 declare Function _NodeBoxIsVisible alias "_NodeBoxIsVisible"(ByVal node As EntityNode , ByVal cam As CameraNode) As Integer
 declare Sub _FreeNode alias "_FreeNode"(ByVal node As EntityNode )
 declare Sub _FreeAllChildrenNode alias "_FreeAllChildrenNode"(ByVal node As EntityNode )
 declare Sub _FreeChildrenNode alias "_FreeChildrenNode"(ByVal node As EntityNode , ByVal child As EntityNode )
 declare Sub _RenderNode alias "_RenderNode"(ByVal node As EntityNode )
 declare Sub _DebugModeNode alias "_DebugModeNode"(ByVal node As EntityNode ,  ByVal state As Integer)
 declare Sub _MaterialFlagNode alias "_MaterialFlagNode"(ByVal node As EntityNode ,  ByVal Flag As Integer,  ByVal newvalue As UByte=TRUE)
 declare Sub _MaterialTextureNode alias "_MaterialTextureNode"(ByVal node As EntityNode , ByVal texture As NTexture , ByVal Layer As Integer=0)
 declare Sub _ParentNode alias "_ParentNode"(ByVal node As EntityNode , ByVal parent As EntityNode )
 declare Sub _UpdateAbsolutePositionNode alias "_UpdateAbsolutePositionNode"(ByVal node As EntityNode )
 declare Sub _MaterialColorNode alias "_MaterialColorNode"(ByVal node As EntityNode , ByVal COLOR_MATERIALtype As Integer=ECM_NONE) 
 declare Sub _MaskColorNode alias "_MaskColorNode"(ByVal node As EntityNode , ByVal COLOR_PLANEtype As Integer=ECP_NONE) 
 declare Sub _SpecularColorNode alias "_SpecularColorNode"(ByVal node As EntityNode , ByVal  vColor As Integer)
 declare Sub _AmbientColorNode alias "_AmbientColorNode"(ByVal node As EntityNode , ByVal vColor As Integer)
 declare Sub _DiffuseColorNode alias "_DiffuseColorNode"(ByVal node As EntityNode , ByVal vColor As Integer)
 declare Sub _EmissiveColorNode alias "_EmissiveColorNode"(ByVal node As EntityNode , ByVal vColor As Integer)
 declare Sub _ShininessColorNode alias "_ShininessColorNode"(ByVal node As EntityNode , shin As Single=20.0)
 declare Sub _GlobalColorNode alias "_GlobalColorNode"(ByVal node As EntityNode , ByVal vColor As Integer)
 declare Function _LoadTextureNode alias "_LoadTextureNode"(ByVal node As EntityNode , ByVal filename As zstring ptr, ByVal numMat As integer=0,  ByVal layer As Integer=0) As NTexture' Return NTexture*  
 declare Function _ProjectedX alias "_ProjectedX"(ByVal node As EntityNode , ByVal camera As CameraNode=NULL) As Integer
 declare Function _ProjectedY alias "_ProjectedY"(ByVal node As EntityNode , ByVal camera As CameraNode=NULL) As Integer
 declare Sub _MaterialTypeNode alias "_MaterialTypeNode"(ByVal node As EntityNode ,  ByVal TType As Integer )
 declare Sub _PointNode alias "_PointNode"(ByVal node As EntityNode , ByVal target As EntityNode ,  ByVal roll As Single=0)
 declare Sub _PointTargetNode alias "_PointTargetNode"(ByVal node As EntityNode , ByVal px As single=0, ByVal py As single=0, ByVal pz As single=0,  ByVal roll As single=0)
 declare Sub _AutomaticCullingNode alias "_AutomaticCullingNode"(ByVal state As Integer=EAC_BOX  )
 declare Function _NodeRootScene alias "_root"()As EntityNode
 declare Sub _NodeDirection alias "_NodeDirection"(ByVal node As EntityNode , ByVal vect As any ptr)
 declare Sub _PickingNode alias "_PickingNode"(ByVal node As EntityNode ,  ByVal pickFlag As Integer=TRUE)
 declare Sub _GetNodeWorldViewProjection(ByVal node As EntityNode, ByVal mat As Any Ptr)
 declare sub _ModeCullingNode(ByVal node As EntityNode,  ByVal mode As Integer =EAC_FRUSTUM_BOX)
 declare sub _UserDataNode(ByVal node As EntityNode,  ByVal userdata As Any Ptr)
 declare Function _NodeUserData(ByVal node As EntityNode) As Any ptr

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- Object Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _LoadMesh (ByVal filename As zstring Ptr, ByVal hardmapping as Integer=EHM_STATIC)As Mesh ' Return *Mesh
 declare Function _LoadAnimatedMesh alias "_LoadAnimatedMesh" (ByVal filename As zstring ptr)As AnimatedMesh ' Return *AnimatedMesh
 declare Function _CreateCubeMesh alias "_CreateCubeMesh"(ByVal ssize as Single=1.0)As Mesh' Return *Mesh
 declare Function _CreateSphereMesh alias "_CreateSphereMesh"(ByVal radius as Single=1.0, ByVal polyCount as Integer=16)As Mesh' Return *Mesh
 declare Function _CreateCylinderMesh alias "_CreateCylinderMesh"(ByVal radius as single, ByVal length as single, ByVal col as integer=&hffffffff, ByVal tesselation as Integer=8, ByVal closeTop As UByte= True, ByVal oblique as Single=0)As Mesh' Return *Mesh
 declare Function _CreateConeMesh alias "_CreateConeMesh"(ByVal radius as single, ByVal length as single, ByVal colTop as integer=&hffffffff, ByVal closeBottom as integer=&hffffffff, ByVal tesselation as Integer=8,  ByVal oblique as Single=0)As Mesh' Return *Mesh
 declare Function _CreateArrowMesh alias "_CreateArrowMesh"(ByVal tesselationCylinder as integer=4,ByVal 	tesselationCone as integer=8,	ByVal height as single=1.0,	ByVal cylinderHeight as single=0.6,	ByVal width0 as single=0.05,	ByVal width1 as Single=0.3,	ByVal vtxColor0 as integer = &hffffffff, ByVal vtxColor1 as Integer = &hffffffff)As Mesh'Return *Mesh
 declare Function _CreateHillPlaneMesh alias "_CreateHillPlaneMesh"(ByVal tileSizeW as single=10.0,ByVal tileSizeH as single=10.0, ByVal tileCountW as integer=10,ByVal tileCountH as Integer=10,ByVal material As NMaterial= NULL,ByVal hillHeight as single=0,	ByVal countHillsW as single=0, ByVal countHillsH as single=0,textureRepeatCountW as single=1,ByVal textureRepeatCountH as Single=1)As Mesh'Return *Mesh
 declare Function _CreatePlaneMesh alias "_CreatePlaneMesh"(ByVal  tileSizeW as single=8.0,ByVal  tileSizeH as single=8.0,ByVal  tileCountW as integer=8, ByVal tileCountH as Integer=8,ByVal material As NMaterial= NULL,ByVal textureRepeatCountW as single=1, ByVal textureRepeatCountH as Single=1)As Mesh'Return *Mesh
 declare Function _CreateSpriteMesh alias "_CreateSpriteMesh"(ByVal  size as single=1.0, ByVal  cColor as integer=&hffffffff)As Mesh' Return *Mesh
 declare Sub _FreeMesh alias "_FreeMesh"(ByVal mmesh As Mesh)
 declare Sub _FreeLoadedMesh alias "_FreeLoadedMesh"(ByVal mmesh As Mesh)
 declare Function _CreateAxisMesh alias "_CreateAxisMesh"(ByVal radius as single=0.15, ByVal polyCount as Single=1.0)As Mesh
 declare Function _CreateLightMesh alias "_CreateLightMesh"(ByVal radius as Single=1.0)As Mesh


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- CAMERA Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateCamera Alias "_CreateCamera"(ByVal parent As EntityNode=NULL) As CameraNode
 declare Sub _CameraTarget Alias "_CameraTarget"(ByVal cam As CameraNode, ByVal res As Any Ptr)
 declare Sub _TargetCamera Alias "_TargetCamera"(ByVal cam As CameraNode, ByVal  x As single, ByVal  y As Single, ByVal  z As Single)
 declare Sub _TargetAndRotationCamera Alias "_TargetAndRotationCamera"(ByVal cam As CameraNode, ByVal flag As UByte=TRUE)
 declare Function _CameraAspectRatio Alias "_CameraAspectRatio"(ByVal cam As CameraNode ) As single
 declare Function _CameraFarValue Alias "_CameraFarValue"(ByVal cam As CameraNode ) As Single
 declare Function _CameraNearValue Alias "_CameraNearValue"(ByVal cam As CameraNode ) As Single
 declare Function _CameraFOV Alias "_CameraFOV"(ByVal cam As CameraNode ) As Single
 declare Sub _CameraProjectionMatrix Alias "_CameraProjectionMatrix"(ByVal cam As CameraNode, ByVal mat As Any Ptr)
 declare Sub _CameraUpVector Alias "_CameraUpVector"(ByVal cam As CameraNode, ByVal vect As Any Ptr )
 declare Sub _CameraViewMatrix Alias "_CameraViewMatrix"(ByVal cam As CameraNode, ByVal mat As Any Ptr)
 declare Sub _AspectRatioCamera Alias "_AspectRatioCamera"(ByVal cam As CameraNode, ByVal aspect As Single)
 declare Sub _FarValueCamera Alias "_FarValueCamera"(ByVal cam As CameraNode, ByVal  farv As Single)
 declare Sub _FOVCamera Alias "_FOVCamera"(ByVal cam As CameraNode, ByVal  fov As Single)
 declare Sub _NearValueCamera Alias "_NearValueCamera"(ByVal cam As CameraNode, ByVal  nearv As Single)
 declare Sub _UpVectorCamera Alias "_UpVectorCamera"(ByVal cam As CameraNode, ByVal   x As Single, ByVal  y As Single, ByVal  z As Single)
 declare Sub _CameraBoxInside Alias "_CameraBoxInside"(ByVal cam As CameraNode, ByVal box As Any Ptr)
 declare Sub _ActiveCamera Alias "_ActiveCamera"(ByVal cam As CameraNode)
 declare Function _CameraActive Alias "_CameraActive"() As Integer
 declare Sub _ProjectionMatrixCamera Alias "_ProjectionMatrixCamera"(ByVal cam As CameraNode, ByVal  projection As Any Ptr, ByVal  isOrthogonal As UByte=FALSE)
 declare Function _CreateCameraFPS( ByVal rotateSpeed As Single=80.0,  ByVal moveSpeed As Single=0.1, ByVal jumpSpeed As single=1.0, ByVal keyMapArray As Any Ptr=Null, ByVal keyMapSize As Integer=0, ByVal noVerticalMovement As UByte=False, ByVal invertMouseY As UByte=False, ByVal parent As EntityNode=NULL) As CameraNode
 declare Function _CreateCameraMaya(ByVal rotateSpeed As Single=100.0,  ByVal zoomSpeed As Single=400.0,  ByVal translationSpeed As Single=400.0,  ByVal parent As EntityNode=NULL) As CameraNode' Return *CameraNode
 Declare Function _CreateCameraFree Alias "_CreateCameraFree"(ByVal parent As EntityNode=NULL) As CameraNode

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- COLLIDE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _OverPickCamera Alias "_OverPickCamera"(ByVal camera As CameraNode) As Integer
 declare Function _PickCamera Alias "_PickCamera"(ByVal camera As CameraNode,ByVal mx as integer,ByVal my as integer, ByVal pickType as Integer=ENT_PICKBOX, ByVal distance As Single=5000.0 )As EntityNode
 declare Function _CollisionPoint Alias "_CollisionPoint"(ByVal sx as single, ByVal sy as single,ByVal sz as single, ByVal ex as single, ByVal ey as single, ByVal ez as Single, ByVal mmesh As EntityNode) As Integer
 declare Function _CollisionPointNode Alias "_CollisionPointNode"(ByVal sx as single, ByVal sy as single, ByVal sz as single, ByVal ex as single, ByVal ey as single, ByVal ez as Single, ByVal pickType as Integer=ENT_PICKBOX)As EntityNode
 declare Sub _PickedPosition Alias "_PickedPosition"(ByVal pPos As any Ptr)
 declare Sub _PickedNormal Alias "_PickedNormal"(ByVal norm As Any Ptr)
 declare Sub _Pickedtriangle Alias "_Pickedtriangle"(ByVal triangles As Any Ptr)
 
 declare Function _CreateCollisionResponseAnimator(ByVal world As Mesh, ByVal Node As EntityNode, ByVal elRadiusX as single, ByVal elRadiusY as single, ByVal elRadiusZ as single, ByVal elTransX as single=0, ByVal elTransY as single=0, ByVal elTransZ as single=0, ByVal gravityPerSecondX as single=0, ByVal gravityPerSecondY as single=-10, ByVal gravityPerSecondZ as single=0, ByVal slidingValue as Single=0.0005) As NAnimatorCollisionResponse
 declare Sub _AddCollisionResponseNode(ByVal node As EntityNode, byval anim as NAnimatorCollisionResponse)
 declare Sub _CollisionResponseEllipsoidRadius(byval anim as NAnimatorCollisionResponse, ByVal radius as any Ptr)
 declare Sub _CollisionResponseEllipsoidTranslation(byval anim as NAnimatorCollisionResponse, ByVal Translation as any Ptr)
 declare Sub _CollisionResponseGravity(byval anim as NAnimatorCollisionResponse, ByVal gravity as any ptr)
 declare Function _CollisionResponseFalling(byval anim as NAnimatorCollisionResponse)As Integer
 declare Sub _JumpCollisionResponse(byval anim as NAnimatorCollisionResponse,  ByVal jumpSpeed as Single)
 declare Sub _EllipsoidRadiusCollisionResponse(byval anim as NAnimatorCollisionResponse,  ByVal x as single,  ByVal y as single,  ByVal z as Single)
 declare Sub _EllipsoidTranslationCollisionResponse(byval anim as NAnimatorCollisionResponse,  ByVal x as single,  ByVal y as single,  ByVal z as Single)
 declare Sub _GravityCollisionResponse(byval anim as NAnimatorCollisionResponse,  ByVal x as single,  ByVal y as single,  ByVal z as Single)
	
	
	
	
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- TIMER  Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _GetTime Alias "_GetTime"() As Integer
 declare Function _GetRealTime Alias "_GetRealTime"() As Integer
 declare Function _GetSpeed Alias "_GetSpeed"() As Single
 declare Function _IsStopped Alias "_IsStopped"()As Integer
 declare Sub _SetSpeed Alias "_SetSpeed"( ByVal speed as Single =1.0)
 declare Sub _SetTime Alias "_SetTime"( ByVal tt as Integer )
 declare Sub _StartTime Alias "_StartTime"()
 declare Sub _StoptTime Alias "_StoptTime"()
 declare Sub _TickTime Alias "_TickTime"()
	
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- MESH Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _FlipSurfacesMesh Alias "_FlipSurfacesMesh"(ByVal mmesh as Mesh)
 declare Sub _RecalculateNormalsMesh Alias "_RecalculateNormalsMesh"(ByVal mmesh as Mesh, ByVal smooth As UByte= False, ByVal angleWeighted As UByte= False)
 declare Function _CreateMeshCopy Alias "_CreateMeshCopy"(ByVal mmesh as Mesh)As Mesh ' Return *Mesh
 declare Sub _MakePlanarTextureMappingMesh Alias "_MakePlanarTextureMappingMesh"(ByVal mmesh as Mesh, ByVal resolution as Single=0.001)
 declare Sub _RecalculateTangentsMesh Alias "_RecalculateTangentsMesh"(ByVal mmesh as Mesh, ByVal recalculateNormals As UByte= False, ByVal smooth As UByte= False, ByVal angleWeighted As UByte= False)
 declare Function _CreateMeshWithTangents  Alias "_CreateMeshWithTangents"(ByVal mmesh as Mesh, ByVal recalculateNormals As UByte= False, ByVal smooth As UByte= False, ByVal angleWeighted As UByte= False, ByVal recalculateTangents As UByte= True)As Mesh' Return *Mesh
 declare Function _CreateMeshWith2TCoords Alias "_CreateMeshWith2TCoords"(ByVal mmesh as Mesh)As Mesh'; Return *Mesh
 declare Function _CreateMeshWith1TCoords  Alias "_CreateMeshWith1TCoords"(ByVal mmesh as Mesh)As Mesh' Return *Mesh
 declare Function _CreateMeshWelded  Alias "_CreateMeshWelded"(ByVal mmesh as Mesh, ByVal tolerance as Single)As Mesh' Return *Mesh
 declare Function _MeshPolyCount  Alias "_MeshPolyCount"(ByVal mmesh as Mesh)As Mesh
 declare Function _AnimatedMeshPolyCount Alias "_AnimatedMeshPolyCount" (ByVal amesh As AnimatedMesh)As Integer
' mesh manipulation
 declare Function _CreateEmptyMesh Alias "_CreateEmptyMesh" (ByVal Type_vertex As Integer= EVT_STANDART) As Mesh' Return *Mesh
 declare Function _AddEmptyMeshBuffer Alias "_AddEmptyMeshBuffer"(ByVal mmesh as Mesh, ByVal type_vertex  as Integer= EVT_STANDART)As integer
 declare Function _AddFaceMesh (ByVal mmesh as Mesh, ByVal num_buffer  as Integer,  ByVal i1 as short, ByVal i2 as short, ByVal i3 as Short)As Integer
 declare Function _AddVertexMesh Alias "_AddVertexMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal posx as single, ByVal posy as single, ByVal posz as single,ByVal nx as single=0, ByVal ny as single=0, ByVal nz as single=0, ByVal col  as Integer=&hffffffff, ByVal uvx1 as single=0, ByVal uvy1 as single=0, ByVal uvx2 as single=0,  ByVal uvy2 as Single=0)As Integer
 declare Sub _VertexMesh Alias "_VertexMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal posx as single, ByVal posy as single, ByVal posz as single, ByVal nx as single, ByVal ny as single, ByVal nz as single, ByVal col  as Integer, ByVal uvx1 as single=0, ByVal uvy1 as single=0, ByVal uvx2 as single=0,  ByVal uvy2 as Single=0)
 declare Sub _FaceMesh Alias "_FaceMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer,  ByVal num  as Integer, ByVal  i1 as short,  ByVal i2 as short, ByVal  i3 as Short)
 declare Sub _VertexPositionMesh Alias "_VertexPositionMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal px as single, ByVal py as single, ByVal pz as Single)
 declare Sub _VertexNormalMesh Alias "_VertexNormalMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal nx as single, ByVal ny as single, ByVal nz as Single)
 declare Sub _VertexColorMesh Alias "_VertexColorMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as integer, ByVal col  as Integer)
 declare Sub _VertexTexCoord1Mesh Alias "_VertexTexCoord1Mesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal  u as single, ByVal  v as Single)
 declare Sub _VertexTexCoord2Mesh Alias "_VertexTexCoord2Mesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal  u as single, ByVal  v as Single)
 declare Sub _VertexTangentMesh Alias "_VertexTangentMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal tx as single, ByVal ty as single, ByVal tz as Single)
 declare Sub _VertexBinormalMesh Alias "_VertexBinormalMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal tx as single, ByVal ty as single, ByVal tz as Single)
 declare Sub _MeshVertex Alias "_MeshVertex"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer,  ByVal vert As any Ptr)
 declare Sub _MeshNormal Alias "_MeshNormal"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer,  ByVal vert As any Ptr)
 declare Function _MeshColor Alias "_MeshColor"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer)As Integer
 declare Sub _MeshTexCoord1 Alias "_MeshTexCoord1"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal vert as Any Ptr)
 declare Sub _MeshTexCoord2 Alias "_MeshTexCoord2"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal vert as Any Ptr)
 declare Sub _MeshTangent Alias "_MeshTangent"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal vert as Any Ptr)
 declare Sub _MeshBinormal Alias "_MeshBinormal"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal num  as Integer, ByVal vert as Any Ptr)
 declare Sub _MeshFace Alias "_MeshFace"(ByVal mmesh as Mesh, ByVal num_buffer  as integer,  ByVal num  as Integer, ByVal id as Any Ptr)
 declare Function _MeshTypeVertex  Alias "_MeshTypeVertex"(ByVal mmesh as Mesh, ByVal num_buffer  as Integer=0)As Integer
 declare Function _MeshFaceCount  Alias "_MeshFaceCount"(ByVal mmesh as Mesh, ByVal num_buffer  as Integer=0)As Integer
 declare Function _MeshVertexCount  Alias "_MeshVertexCount"(ByVal mmesh as Mesh, ByVal num_buffer  as Integer=0)As Integer
 declare Sub _HardwareMappingMesh Alias "_HardwareMappingMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer, ByVal bufferMap as integer= EHM_STATIC, ByVal bufferType  as Integer= EBT_VERTEX_AND_INDEX)
 declare Function _MeshBufferCount  Alias "_MeshBufferCount"(ByVal mmesh as Mesh)As Integer
 declare Sub _CalculBoundingBoxMesh Alias "_CalculBoundingBoxMesh"(ByVal mmesh as Mesh)
 declare Sub _BoundingBoxMesh Alias "_BoundingBoxMesh"(ByVal mmesh as Mesh,  ByVal maxx as single,  ByVal maxy as single,  ByVal maxz as single,  ByVal minx as single,  ByVal miny as single,  ByVal minz as Single)
 declare Sub _TransformMesh Alias "_TransformMesh"(ByVal mmesh as Mesh, ByVal mat as Any Ptr)
 declare Sub _ScaleMesh Alias "_ScaleMesh"(ByVal mmesh as Mesh, ByVal factorx as single, ByVal factory as single, ByVal factorz as Single)
 declare Sub _RotateMesh Alias "_RotateMesh"(ByVal mmesh as Mesh, ByVal rotx as single, ByVal roty as single, ByVal rotz as Single)
 declare Sub _TranslateMesh Alias "_TranslateMesh"(ByVal mmesh as Mesh, ByVal tx as single, ByVal ty as single, ByVal tz as Single)
 declare Sub _ScaleTCoordsMesh Alias "_ScaleTCoordsMesh"(ByVal mmesh as Mesh, ByVal factorx as single, ByVal factory as Single, ByVal layer  as Integer=0)
 declare Sub _VertexColorAlphaMesh Alias "_VertexColorAlphaMesh"(ByVal mmesh as Mesh,  ByVal aalpha  as Integer)
 declare Function _AddAreaVerticesMesh  Alias "_AddAreaVerticesMesh"(ByVal mmesh as Mesh, ByVal num_buffer  as integer , ByVal vertices  as Any Ptr, ByVal numVertices  as Integer)As Integer
 declare Function _AddAreaIndicesMesh Alias "_AddAreaIndicesMesh" (ByVal mmesh as Mesh, ByVal num_buffer  as integer , ByVal indices As any Ptr, ByVal numFaces  as Integer)As Integer
 declare Sub _ChangeColorMesh Alias "_ChangeColorMesh"(ByVal mmesh as Mesh, ByVal cColor  as Integer=&hffffffff)
 declare Sub _ChangeColorMeshBuffer Alias "_ChangeColorMeshBuffer"(ByVal mmesh as Mesh, ByVal numBuffer  as integer=0, ByVal cColor  as Integer=&hffffffff)
 declare Sub _DirtyMeshBuffer Alias "_DirtyMeshBuffer"(ByVal mmesh as Mesh, ByVal BUFFER_TYPE  as Integer= EBT_VERTEX)
 declare Sub _DrawIndexedTriangleList Alias "_DrawIndexedTriangleList"(ByVal vertices As Any Ptr, ByVal vertexCount  as integer, ByVal indexList as any Ptr,ByVal   triangleCount  as Integer)
 declare Sub _DrawIndexedTriangleList2T Alias "_DrawIndexedTriangleList2T"(ByVal vertices As Any Ptr, ByVal vertexCount  as integer, ByVal indexList As Any Ptr, ByVal  triangleCount  as Integer)
 declare Sub _DrawIndexedTriangleListTan Alias "_DrawIndexedTriangleListTan"(ByVal vertices As Any Ptr,ByVal  vertexCount  as integer, ByVal indexList As Any Ptr,  ByVal triangleCount  as Integer)
 declare Function _MeshMaterial(ByVal imesh As Mesh, ByVal num As Integer=0)As NMaterial
 declare Sub _MaterialMesh(ByVal imesh As Mesh,  ByVal material As NMaterial, ByVal num As Integer=0)
 declare Sub _MeshBoundingBox(ByVal imesh As Mesh, ByVal aabbox As Any Ptr)	
 	

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- IRRSCENE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _LoadIrrScene Alias "_LoadIrrScene"(ByVal filename As ZString ptr, ByVal userDataSerializer As any Ptr=NULL)
 declare Sub _SaveIrrScene Alias "_SaveIrrScene"(ByVal filename As ZString Ptr, ByVal userDataSerializer As any Ptr=NULL)
 declare Sub _SceneNodesFromType Alias "_SceneNodesFromType"(ByVal arr As NArray, ByVal tType As integer=ESNT_ANY, ByVal start As any Ptr=NULL)
' DPM scene
 declare Function _LoadDpmScene(ByVal filename As ZString Ptr, ByVal limb_prefix As ZString Ptr=NULL) As EntityNode


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- LOD Mesh Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateLODEntityNode Alias "_CreateLODEntityNode"(ByVal imesh As Mesh, ByVal parent As EntityNode=NULL) As EntityNode' Return *EntityNode
 declare Sub _AddMeshLODEntityNode Alias "_AddMeshLODEntityNode"( ByVal lod As EntityNode, ByVal imesh As Mesh, ByVal index As Integer=0 )


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- STATICZONE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateStaticZone Alias "_CreateStaticZone"(ByVal imesh As Mesh, ByVal parent As EntityNode=NULL) As EntityNode' Return *EntityNode
 declare Sub _SetLODStaticZoneEntityNode Alias "_SetLODStaticZoneEntityNode"( ByVal lod As EntityNode, ByVal imesh As Mesh, ByVal index As Integer=0 )
 declare Function _AddElementStaticZone Alias "_AddElementStaticZone"( ByVal lod As EntityNode,ByVal posx As single, ByVal posy As single, ByVal posz As single, ByVal rotx As single=0, ByVal roty As single=0, ByVal rotz As single=0, ByVal scx As single=1, ByVal scy As single=1, ByVal scz As Single=1)As Integer
 declare Function _DelElementStaticZone Alias "_DelElementStaticZone"( ByVal lod As EntityNode, ByVal index As Integer =1) As integer
 declare Sub _DelElementStaticZoneWithPosition Alias "_DelElementStaticZoneWithPosition"( lod As EntityNode, ByVal posx As single, ByVal posy As single, ByVal posz As Single)  

' batch zone
 declare Function _CreateBatchNode(ByVal imesh As Mesh, ByVal matType as Integer=EMT_SOLID, ByVal windEnable As Byte=FALSE, ByVal parent As EntityNode=Null) As EntityNode' Return *EntityNode
 declare Function _AddBatchElement(ByVal batch As EntityNode, ByVal posx as single, ByVal posy as single, ByVal posz as single, ByVal rotx as single=0, ByVal roty as single=0, ByVal rotz as single=0, ByVal scx as single=1, ByVal scy as single=1, ByVal scz as Single=1)As integer
 declare Sub _VisibleDistanceBatchZone(ByVal batch As EntityNode, ByVal value as Single=500.0)
 declare Sub _WindValueBatchZone(ByVal batch As EntityNode, ByVal amplitude as Single=0.15, ByVal speed as Integer=25)
 declare Sub _DelBatchElement(ByVal batch As EntityNode,   ByVal index as integer)
 declare Sub _DelBatchElementWithPosition(ByVal batch As EntityNode, ByVal posx as single, ByVal posy as single, ByVal posz as single) 
 



' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- SPRITE3D Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateSprite3D Alias "_CreateSprite3D"(ByVal mmesh As Mesh, ByVal texturename As ZString Ptr, ByVal parent As EntityNode=NULL) As SpriteSceneNode' Return SpriteSceneNode
 declare Sub _OrientationSprite3D Alias "_OrientationSprite3D"(ByVal sp As SpriteSceneNode, ByVal Orientation As integer=0)
 declare Sub _CenterSprite3D Alias "_CenterSprite3D"(ByVal sp As SpriteSceneNode,  ByVal x As single=0,  ByVal y As single=0,  ByVal z As single=0) 

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- PIVOT Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreatePivot Alias "_CreatePivot"(ByVal parent As EntityNode=NULL)As EntityNode
 	
 	
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- SKY/WATER Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateSkybox Alias "_CreateSkybox"(ByVal top As NTexture, ByVal bottom As NTexture, ByVal LLeft As NTexture, ByVal rRight As NTexture, ByVal front As NTexture, ByVal back As NTexture, ByVal parent As EntityNode=NULL) As EntityNode
 declare Function _CreateSkydome Alias "_CreateSkydome"(ByVal texture As NTexture, ByVal horiRes As Integer=16, ByVal verticalRes As integer=8, ByVal texturePercentage As Single=0.9,  ByVal spherePercentage As Single=2.0, ByVal radius As single=1000.0, ByVal parent As EntityNode=NULL) As EntityNode
'
 declare Function _CreateWater Alias "_CreateWater"(ByVal hillpnae As Mesh, ByVal waveHeight As Single=2.0,   ByVal waveSpeed As Single=300.0,   ByVal waveLength As Single=10.0, ByVal parent As EntityNode=NULL) As EntityNode
'
 declare Function _CreateWaterAR Alias "_CreateWaterAR"(ByVal surfaceTileSize As Single=25.0,  ByVal surfaceTileCount As Integer=50, ByVal SinWave As UByte=TRUE,  ByVal Refraction As UByte=TRUE, ByVal parent As EntityNode=NULL)As EntityNode
 declare Sub _DataWaterAR Alias "_DataWaterAR"(ByVal filenamenormal As ZString ptr, ByVal filenameDUDV As ZString ptr, ByVal textureMap As Single=0.05, ByVal sizeRTT As Integer=512) 
 declare Sub _ColorWaterAR Alias "_ColorWaterAR"(ByVal water As EntityNode, ByVal col As Integer=&h9966b7ff) 
 declare Sub _DirLightWaterAR Alias "_DirLightWaterAR"(ByVal water As EntityNode,  ByVal x As Single,  ByVal y As Single,  ByVal z As Single)
 declare Sub _SpeedWaterAR Alias "_SpeedWaterAR"(ByVal water As EntityNode,  ByVal speed As Single=10000.0)
 declare Sub _HeightWaterAR Alias "_HeightWaterAR"(ByVal water As EntityNode,  ByVal h As Single)
 declare Sub _ClipPlaneOffsetWaterAR Alias "_ClipPlaneOffsetWaterAR"(ByVal water As EntityNode, ByVal clip As Single=2.0)
 declare Sub _AddNodeToRenderWaterAR Alias "_AddNodeToRenderWaterAR"(ByVal water As EntityNode,  ByVal node As EntityNode)
 declare Sub _DropNodeToRenderWaterAR Alias "_DropNodeToRenderWaterAR"(ByVal water As EntityNode,  ByVal node As EntityNode)
 declare Sub _ClearNodeToRenderWaterAR Alias "_ClearNodeToRenderWaterAR"(ByVal water As EntityNode)
 declare Sub _CustumRenderWaterAR Alias "_CustumRenderWaterAR"(ByVal water As EntityNode, ByVal flag As UByte=TRUE)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- TERRAIN Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateTerrain Alias "_CreateTerrain"(ByVal HeightmapFile As ZString ptr, ByVal Quality as integer, ByVal scx as single, ByVal scy as single, ByVal scz as single, ByVal scaleSecondTexture as Single=32, ByVal smooth As UByte=TRUE,ByVal bufferType as Integer=EHM_STATIC) As TerrainNode' Return TerrainNode
 declare Function _LoadTerrain Alias "_LoadTerrain"(ByVal filename As ZString Ptr, ByVal bufferType as Integer=EHM_STATIC) As TerrainNode
 declare Sub _SaveTerrain Alias "_SaveTerrain"(ByVal terrain As TerrainNode, ByVal FileName As ZString Ptr)
 declare Sub _SplattingTerrain Alias "_SplattingTerrain"(ByVal terrain As TerrainNode, ByVal  fog as Single, ByVal  fogColor as Integer=&hffffffff)
 declare Function _TextureTerrain Alias "_TextureTerrain"(ByVal terrain As TerrainNode, ByVal NumTex as integer , ByVal FileName As ZString Ptr, ByVal tileX as integer=-1, ByVal tileY as Integer=-1) As NTexture' Return NTexture
 declare Sub _TextureTexTerrain Alias "_TextureTexTerrain"(ByVal terrain As TerrainNode, ByVal NumTex as integer, ByVal tex As NTexture, ByVal tileX as integer=-1, ByVal tileY as Integer=-1)
 declare Sub _FreeTerrain Alias "_FreeTerrain"(ByVal terrain As TerrainNode)
 declare Sub _TerrainBoundingBox Alias "_TerrainBoundingBox"(ByVal terrain As TerrainNode, ByVal box as Any Ptr)
 declare Function _TerrainHeight Alias "_TerrainHeight"(ByVal terrain As TerrainNode,  ByVal x as single, ByVal  z as Single, ByVal ttype as Integer=0) As Single
 declare Sub _FogTerrain Alias "_FogTerrain"(ByVal terrain As TerrainNode,  ByVal value as Single)
 declare Sub _FogColorTerrain Alias "_FogColorTerrain"(ByVal terrain As TerrainNode,  ByVal col as Integer)
 declare Sub _DiffusePowerTerrain Alias "_DiffusePowerTerrain"(ByVal terrain As TerrainNode, ByVal value as Single)
 declare Sub _HeightTerrain Alias "_HeightTerrain"(ByVal terrain As TerrainNode, ByVal radius as single, ByVal x as integer, ByVal y as integer,  ByVal hh as Single, ByVal tType as Integer=TH_UP)
 declare Sub _TerrainPickedPosition Alias "_TerrainPickedPosition"(ByVal terrain As TerrainNode, ByVal Pos as any Ptr)
 declare Sub _TerrainPickedNormal Alias "_TerrainPickedNormal"(ByVal terrain As TerrainNode, ByVal norm as Any Ptr)
 declare Sub _TerrainPickedtriangle Alias "_TerrainPickedtriangle"(ByVal terrain As TerrainNode, ByVal triangles as Any Ptr)
 declare Function _PickTerrain Alias "_PickTerrain"(ByVal terrain As TerrainNode)As Integer
 declare Sub _WriteTextureTerrain Alias "_WriteTextureTerrain"(ByVal terrain As TerrainNode,byval texture As NTexture, ByVal px as integer, ByVal py as integer, ByVal radius as integer, ByVal col as Integer)
 declare Function _TextureTerrainColor Alias "_TextureTerrainColor"(ByVal terrain As TerrainNode, ByVal texture As NTexture, ByVal px as integer, ByVal py as integer)As Integer
 declare Sub _ScaleDetailTextureTerrain Alias "_ScaleDetailTextureTerrain"(ByVal terrain As TerrainNode, ByVal value as Single)
 declare Sub _CoordTextureTerrain Alias "_CoordTextureTerrain"(ByVal terrain As TerrainNode,  ByVal scalemain as single=0,  ByVal scaledetail as single=0)
 
' sphere terrain
 declare Function _CreateSphereTerrain(ByVal tex0 As ZString Ptr, ByVal tex1 As ZString Ptr, ByVal tex2 As ZString Ptr, ByVal tex3 As ZString Ptr, ByVal tex4 As ZString Ptr, ByVal tex5 As ZString Ptr, ByVal ScaleHeightmap as single=1, ByVal posx as single=0, ByVal posy as single=0, ByVal posz as single=0, ByVal rotx as single=0, ByVal roty as single=0, ByVal rotz as single=0, ByVal scx as single=1, ByVal scy as single=1, ByVal scz as Single=1, ByVal col as integer=&hffffffff, ByVal maxLOD as integer=4, ByVal patchSize as Integer=ETPS_17) As TerrainSphereNode
 declare Sub _TextureSphereTerrain(ByVal terrain As TerrainSphereNode, ByVal tTop As NTexture, ByVal tFront As NTexture, ByVal tBack As NTexture, ByVal tLeft As NTexture, ByVal tRight As NTexture, ByVal tBottom As NTexture, ByVal index as Integer=0 )
 declare Sub _LoadSphereTerrainVertexColor(ByVal terrain As TerrainSphereNode, ByVal iTop As NImage, ByVal iFront As NImage, ByVal iBack As NImage, ByVal iLeft As NImage, ByVal iRight As NImage, ByVal iBottom As NImage )
 declare Sub _SphereTerrainSurfacePosition(ByVal terrain As TerrainSphereNode, ByVal face as Integer, ByVal x as single, ByVal z as single, ByVal posx as single, ByVal posy as single, ByVal posz as Single )
 declare Sub _SphereTerrainSurfacePositionAndAngle(ByVal terrain As TerrainSphereNode, ByVal face as Integer, ByVal x as single, ByVal z as single, ByVal px as single, ByVal py as single, ByVal pz as Single, ByVal rx As Any Ptr, ByVal ry As any  Ptr, ByVal rz As any Ptr )
'
 declare Function _CreateLensFlare(ByVal texture As NTexture ) As EntityNode' Return *EntityNode
 declare Function _CreateClouds(ByVal texture As NTexture, ByVal lod as integer=3, ByVal depth as integer=1, ByVal density as Integer=500 ) As EntityNode ' Return *EntityNode

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- ANIMATOR Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateFlyCircleAnimator(ByVal node as EntityNode, ByVal x as single, ByVal y as single, ByVal z as single, ByVal radius as single, ByVal speed as Single )As NSceneNodeAnimator
 declare Function _CreateFlyStraightAnimator(ByVal node as EntityNode, ByVal startx as single, ByVal starty as single, ByVal startz as single, ByVal endx as single, ByVal endy as single, ByVal endz as Single, ByVal uitime as Integer,  ByVal lLoop As UByte=False )As NSceneNodeAnimator
 declare Function _CreateRotationAnimator(ByVal node as EntityNode,  ByVal x as single,  ByVal y as single,  ByVal z as Single)As NSceneNodeAnimator
 declare Function _CreateFollowSplineAnimator(ByVal node as EntityNode, ByVal num_points as integer,	ByVal pts As any Ptr, ByVal tTime as integer,  ByVal speed as single,  ByVal tightness As single )As NSceneNodeAnimator
 declare Sub _RemoveAnimator(ByVal node as EntityNode, ByVal anim As NSceneNodeAnimator )

 
 
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- MATERIAL Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateMaterial Alias "_CreateMaterial"(Byval flag as Integer=NULL) As NMaterial' Return NMaterial
 declare Function _MaterialFlag Alias "_MaterialFlag"(Byval material as NMaterial, Byval flag as Integer) As integer
 declare Function _MaterialTexture Alias "_MaterialTexture"(Byval material as NMaterial,  Byval i as Integer=0) As NMaterial' Return NTexture*
 declare Sub _MaterialTextureMatrix Alias "_MaterialTextureMatrix"(Byval material as NMaterial,  Byval i as Integer, Byval matrix As Any Ptr) 
 declare Function _MaterialTransparent Alias "_MaterialTransparent"(Byval material as NMaterial)  As Integer
 declare Sub _FlagMaterial Alias "_FlagMaterial"(Byval material as NMaterial, Byval flag as Integer,  Byval value As UByte) 
 declare Sub _TextureMaterial Alias "_TextureMaterial"(Byval material as NMaterial,  Byval i as Integer, Byval tex As NTexture) 
 declare Sub _TextureMatrixMaterial Alias "_TextureMatrixMaterial"(Byval material as NMaterial, Byval i as Integer,  Byval matrix As any Ptr) 
 declare Function _MaterialAmbientColor Alias "_MaterialAmbientColor"(Byval material as NMaterial)  As Integer
 declare Sub _ColorMaterial Alias "_ColorMaterial"(Byval material as NMaterial,  Byval tType as Integer=ECM_NONE) 
 declare Sub _MaskColorMaterial Alias "_MaskColorMaterial"(Byval material as NMaterial, Byval COLOR_PLANEtype as Integer=ECP_NONE)
 declare Sub _AmbientColorMaterial Alias "_AmbientColorMaterial"(Byval material as NMaterial,  Byval col as Integer) 
 declare Function _MaterialDiffuseColor Alias "_MaterialDiffuseColor"(Byval material as NMaterial)  As Integer
 declare Sub _DiffuseColorMaterial Alias "_DiffuseColorMaterial"(Byval material as NMaterial,  Byval col as Integer) 
 declare Function _MaterialEmissiveColor Alias "_MaterialEmissiveColor"(Byval material as NMaterial)  As Integer
 declare Sub _EmissiveColorMaterial Alias "_EmissiveColorMaterial"(Byval material as NMaterial,  Byval col as Integer) 
 declare Function _MaterialBackfaceCulling Alias "_MaterialBackfaceCulling"(Byval material as NMaterial)  As Integer
 declare Function _MaterialFogEnable Alias "_MaterialFogEnable"(Byval material as NMaterial)  As Integer
 declare Function _MaterialFrontfaceCulling Alias "_MaterialFrontfaceCulling"(Byval material as NMaterial)  As Integer
 declare Function _MaterialGouraudShading Alias "_MaterialGouraudShading"(Byval material as NMaterial)  As Integer
 declare Function _MaterialShininess Alias "_MaterialShininess"(Byval material as NMaterial) As single
 declare Sub _ShininessMaterial Alias "_ShininessMaterial"(Byval material as NMaterial,  Byval shin as Single) 
 declare Function _MaterialSpecularColor Alias "_MaterialSpecularColor"(Byval material as NMaterial)  As Integer
 declare Sub _SpecularColorMaterial Alias "_SpecularColorMaterial"(Byval material as NMaterial,  Byval col as Integer) 
 declare Function _MaterialThickness Alias "_MaterialThickness"(Byval material as NMaterial) As single
 declare Sub _ThicknessMaterial Alias "_ThicknessMaterial"(Byval material as NMaterial, Byval thick as Single) 
 declare Sub _TypeBlendMaterial Alias "_TypeBlendMaterial"(Byval material as NMaterial, Byval src as integer, Byval dest as integer, Byval modulate as integer=EMFN_MODULATE_1X, Byval alphaSource as integer=EAS_TEXTURE) 
 declare Sub _TypeParamMaterial Alias "_TypeParamMaterial"(Byval material as NMaterial, Byval sAlpha as Single=0) 
 declare Sub _TypeParam2Material Alias "_TypeParam2Material"(Byval material as NMaterial, Byval param as Single) 
 declare Sub _TypeMaterial Alias "_TypeMaterial"(Byval material as NMaterial,  Byval tType as Integer) 
 declare Sub _SetMaterial Alias "_SetMaterial"(Byval material as NMaterial) 
 declare Sub _CopyMaterial Alias "_CopyMaterial"( Byval src as NMaterial, Byval dest As NMaterial) 
 declare Sub _TextureWrapMaterial Alias "_TextureWrapMaterial"(Byval material as NMaterial, Byval valueU as integer=0, Byval valueV as integer=0, Byval layer as Integer=0) 

 
 ' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- LIGHT Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateLight(Byval col as UInteger=&hffffffff, Byval radius as Single=20.0, Byval typeLight as Integer=ELT_POINT , Byval parent As EntityNode=NULL)As LightNode ' Return *LightNode
 declare Sub _CastShadowLight(byval lgt As LightNode, Byval flag as UByte=TRUE)
 declare Function _LightType( byval lgt As LightNode) As integer
 declare Sub _TypeLight( byval lgt As LightNode, Byval tType as Integer)
 declare Function _LightRadius( byval lgt As LightNode)As Single
 declare Sub _RadiusLight( byval lgt As LightNode,  Byval radius as Single=100)
 declare Sub _AmbientColorLight( byval lgt As LightNode, Byval col as UInteger)
 declare Function _LightAmbientColor(byval lgt As LightNode) As UInteger
 declare Sub _SpecularColorLight(byval lgt As LightNode,  col as Integer)
 declare Function _LightSpecularColor(byval lgt As LightNode) As UInteger
 declare Sub _DiffuseColorLight(byval lgt As LightNode,  Byval col as uinteger)
 declare Function _LightDiffuseColor( byval lgt As LightNode) As UInteger
 declare Sub _AttenuationLight( byval lgt As LightNode,  Byval constant as single,  Byval linear as single,  Byval quadratic as Single)
 declare Sub _LightAttenuation( byval lgt As LightNode, Byval ret as Any Ptr)
 declare Sub _LightDirection( byval lgt As LightNode, Byval ret as Any ptr)
 declare Sub _FalloffLight( byval lgt As LightNode,  Byval falloff as Single)
 declare Function _LightFalloff( byval lgt As LightNode)As Single
 declare Sub _InnerConeLight( byval lgt As LightNode,  Byval InnerCone as Single )
 declare Function _LightInnerCone( byval lgt As LightNode) As Single
 declare Sub _OuterConeLight( byval lgt As LightNode, Byval OuterCone as Single )
 declare Function _LightOuterCone( byval lgt As LightNode)As Single
 declare Sub _AmbientLight(Byval col as UInteger=&hffffffff)
 declare Function _LightAmbient() As UInteger
 declare Function _CreateVolumeLight(ByVal  tailcolor as integer=0, ByVal footcolor as integer=&h3300f090,  ByVal subdivU as integer=32, ByVal subdivV as Integer=32, ByVal parent As EntityNode=NULL ) As VolumeLightNode'Return *VolumeLightNode
 declare Sub _ParametersVolumeLight(ByVal  vlight As VolumeLightNode, ByVal tailcolor as integer=0, ByVal footcolor as integer=&h3300f090,  ByVal subdivU as integer=32,  ByVal subdivV as Integer=32)


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- TEXTURE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _TextureColorFormat(Byval tex As NTexture)  As UInteger
 declare Sub _TextureOriginalSize(Byval tex As NTexture,ByVal  wwidth as any ptr,  ByVal height as any Ptr) 
 declare Function _TexturePitch(Byval tex As NTexture)  As Integer
 declare Sub _TextureSize(Byval tex As NTexture, ByVal wWidth as any ptr, ByVal height as any ptr) 
 declare Function _TextureMipMaps(Byval tex As NTexture)  As Integer
 declare Function _TextureRenderTarget(Byval tex As NTexture)  As UInteger
 declare Function _LockTexture(Byval tex As NTexture,  ByVal readonly As UByte=FALSE) As Any ptr
 declare Sub _UnlockTexture(Byval tex As NTexture) 
 declare Sub _MipMapLevelTexture(Byval tex As NTexture) 
 declare Function _CreateRenderTargetTexture(ByVal  wwidth as integer, ByVal height as integer, ByVal fFormat as Integer=ECF_UNKNOWN) As NTexture ' Return NTexture*
 declare Function _CreateTexture(ByVal  wwidth as integer=128,  ByVal height as integer=128, ByVal  fformat as Integer=ECF_A8R8G8B8)As NTexture   ' Return NTexture*
 declare Function _CreateTextureWithImage( ByVal nName As ZString ptr, ByVal img As NImage) As NTexture  ' Return NTexture*
 declare Function _FindTexture(ByVal nname As ZString Ptr) As NTexture ' Return NTexture*
 declare Function _LoadTexture(ByVal nname As ZString Ptr) As NTexture ' Return NTexture* 
 declare Function _TextureCount() As Integer
 declare Sub _ColorKeyTexture(Byval tex As NTexture,  ByVal col as UInteger) 
 declare Sub _NormalMapTexture(Byval tex As NTexture, ByVal  ampli as single= 1.0) 
 declare Sub _FreeTexture(Byval tex As NTexture) 
 declare Sub _FlagCreationTexture( ByVal flag as Integer,  ByVal   enabled As UByte) 
 declare Function _CreateListTexture(ByVal filename As ZString Ptr,  ByVal wwidth as integer, ByVal height as Integer) As NArray
 declare Sub _SaveTexture( Byval tex As NTexture, ByVal filename As ZString Ptr,  ByVal param as Integer=0)
 declare Sub _MakeAlphaKeyTexture(Byval tex As NTexture, ByVal col as UInteger) 
 declare Sub _MakeColorKeyTexture(Byval tex As NTexture, ByVal col as UInteger) 
 
 
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- TEXTURE ANIMATOR Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateTextureAnimator(ByVal  texture As NArray,  ByVal timePerFrame as Integer, ByVal  lloop As UByte=TRUE) As NNodeAnimator' Return *INodeAnimator
 declare Sub _AddAnimatorTexture(ByVal node As EntityNode, ByVal anim As NNodeAnimator)
 declare Sub _FreeAnimatorTexture(ByVal node As EntityNode, ByVal anim As NNodeAnimator)
 declare Function _AnimatorTextureIndex(ByVal anim As NNodeAnimator) As integer
 declare Function _AnimatorTextureStartTime(ByVal anim As NNodeAnimator) As Integer
 declare Function _AnimatorTextureEndTime(ByVal anim As NNodeAnimator) As Integer
 declare Function _AnimatorTextureSize(ByVal anim As NNodeAnimator) As Integer
 declare Function _NodeAnimators(ByVal node As EntityNode,  ByVal num as Integer=0) As Integer
 declare Sub _RemoveAnimatorNode(ByVal node As EntityNode,  ByVal anim As NNodeAnimator)
 declare Sub _RemoveAnimatorsNode(ByVal node As EntityNode)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- IMAGES Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _LoadImage(ByVal  filename as zstring Ptr )As NImage
 declare Sub _FreeImage(byval img As NImage )
 declare Function _CreateSubImage(byval src As NImage,  ByVal posx as integer,  ByVal posy as integer, ByVal sizex as integer,  ByVal sizey as Integer )As NImage
 declare Function _CreateEmptyImage(ByVal  fformat as integer, ByVal sizex as integer,  ByVal sizey as Integer )As NImage
 declare Function _CreateImageFromData( ByVal fformat as integer, ByVal sizex as integer,  ByVal sizey as Integer , ByVal IData As any Ptr )As NImage
 declare Function _CreateScreenShot()As Integer
 declare Function _SaveImage(byval img As NImage, ByVal filename as zstring ptr,  ByVal param as Integer=0)As Integer
 declare Sub _CopyRecImage(byval src As NImage, ByVal target As NImage,  ByVal posx as integer,  ByVal posy as integer,  ByVal orx as integer,  ByVal ory as integer,  ByVal w as integer,  ByVal h as Integer)
 declare Sub _CopyImage(byval src As NImage, ByVal target As NImage)
 declare Sub _CopyWithAlphaImage(byval src As NImage, ByVal target As NImage, ByVal posx as integer,  ByVal posy as integer,  ByVal orx as integer,  ByVal ory as integer, ByVal  w as integer, ByVal  h as integer, ByVal Col as Integer=&hffffffff)
 declare Sub _FillImage(byval img As NImage, ByVal col as Integer)
 declare Function _ImageAlphaMask(byval img As NImage)As Integer
 declare Function _ImageBitsPerPixel(byval img As NImage)As Integer
 declare Function _ImageBytesPerPixel(byval img As NImage)As Integer
 declare Function _ImageBlueMask(byval img As NImage)As Integer
 declare Function _ImageGreenMask(byval img As NImage)As Integer
 declare Function _ImageRedMask(byval img As NImage)As Integer
 declare Function _ImageColorFormat(byval img As NImage)As Integer
 declare Sub _ImageDimension(byval img As NImage,  ByVal w As any Ptr,  ByVal h As Any Ptr)
 declare Function _ImageSize(byval img As NImage)As Integer
 declare Function _ImageSizeInPixels(byval img As NImage)As Integer
 declare Function _ImagePitch(byval img As NImage)As Integer
 declare Function _ImagePixel(byval img As NImage,  ByVal x as integer,  ByVal y as Integer)As Integer
 declare Sub _PixelImage( byval img As NImage, ByVal  x as integer,  ByVal y as integer,  ByVal col as integer=&hffffffff)
 declare Function _LockImage(byval img As NImage)As Any ptr
 declare Sub _UnlockImage(byval img As NImage) 


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- ANIMATION Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateAnimation(ByVal model As AnimatedMesh, ByVal parent As EntityNode=NULL) As AnimatedNode' Return *AnimatedNode
 declare Sub _SpeedAnimation(ByVal model As AnimatedMesh,  ByVal speed as Single )
 declare Sub _AnimateJointAnimation(ByVal model As AnimatedMesh, ByVal CalculateAbsolutePositions as UByte=True )
 declare Function _CloneAnimation(ByVal model As AnimatedMesh, ByVal parent As EntityNode=NULL)As AnimatedNode ' Return *AnimatedNode
 declare Sub _AnimationEndFrame(ByVal model As AnimatedMesh)
 declare Function _AnimationFrameNumber(ByVal model As AnimatedMesh)As single
 declare Sub _FrameLoopAnimation(ByVal model As AnimatedMesh,  ByVal Fbegin as integer=0,byval Fend as Integer=0)
 declare Function _AnimationJointCount(ByVal model As AnimatedMesh)As integer
 declare Function _AnimationJointNode(ByVal model As AnimatedMesh, ByVal jointID as Integer=0) As BoneNode ' Return *BoneNode
 declare Function _AnimationJointNodebyName(ByVal model As AnimatedMesh, ByVal nName As ZString Ptr)As Integer
 declare Function _AnimationStartFrame(ByVal model As AnimatedMesh)As Integer
 declare Sub _CurrentFrameAnimation(ByVal model As AnimatedMesh,  ByVal frame as Single)
 declare Sub _JointModeAnimation(ByVal model As AnimatedMesh, ByVal mode as Integer=EJUOR_NONE )
 declare Sub _LoopModeAnimation(ByVal model As AnimatedMesh, ByVal mode as UByte=True)
 declare Sub _RenderFromIdentityAnimation(ByVal model As AnimatedMesh,ByVal  mode as UByte=True)
 declare Sub _TransitionTimeAnimation(ByVal model As AnimatedMesh,  ByVal ttime as Single)
' Bones 
 declare Function _BoneAnimationMode(ByVal bone As BoneNode)As Integer
 declare Function _BoneIndex(ByVal bone As BoneNode)As Integer
 declare Function _BoneName(ByVal bone As BoneNode)As Any Ptr ' Return char*
 declare Sub _BoneBoundingBox(ByVal bone As BoneNode, ByVal bound as Single Ptr)
 declare Function _BoneSkinningSpace(ByVal bone As BoneNode)As integer
 declare Sub _OnAnimateBone(ByVal bone As BoneNode, ByVal timeMS as Integer)
 declare Sub _AnimationModeBone(ByVal bone As BoneNode, ByVal mode as Integer)
 declare Sub _SkinningSpaceBone(ByVal bone As BoneNode, ByVal  dSpace as Integer)
 declare Sub _UpdateAbsolutePositionOfAllChildrenBone(ByVal bone As BoneNode)
 declare Function _BonePositionHint(ByVal bone As BoneNode)As Integer
 declare Function _BoneScaleHint(ByVal bone As BoneNode)As Integer
 declare Function _BoneRotationHint(ByVal bone As BoneNode)As Integer
 declare Function _BoneAnimationParent(ByVal bone As BoneNode)As Integer
 declare Sub _PositionHintBone(ByVal bone As BoneNode,  ByVal hint as Integer=-1)
' MD2
 declare Sub _AnimationMD2(ByVal model As AnimatedMesh,  ByVal tType as Integer=EMAT_STAND )
 declare Sub _AnimationMD2byName(ByVal model As AnimatedMesh,  ByVal animationName As ZString Ptr )
 declare Function _MD2AnimationCount(ByVal model As AnimatedMesh)As Integer
 declare Function _MD2AnimationName(ByVal model As AnimatedMesh, ByVal nr as Integer=0)As Any Ptr ' Return char*
 declare Sub _MD2FrameLoopName(ByVal model As AnimatedMesh, ByVal nName as ZString Ptr,  ByVal outBegin as any Ptr, ByVal outEnd as Any Ptr, ByVal outFPS as Any Ptr)   
 declare Sub _MD2FrameLoopType(ByVal model As AnimatedMesh, ByVal tType as Integer, ByVal outBegin as any Ptr, ByVal outEnd as Any Ptr, ByVal outFPS as any Ptr)   
' MD3
 declare Sub _InterpolationShiftMD3(ByVal model As AnimatedMesh,  ByVal shift as integer,  ByVal loopMode as Integer)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- PARTICLE Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateParticleSystem(ByVal withDefaultEmitter as UByte=FALSE, ByVal parent As EntityNode=NULL )As ParticleSystemNode
 declare Function _CreateParticleBoxEmitter(ByVal part As ParticleSystemNode, ByVal dirx as single=0, ByVal diry as single=0.03, ByVal dirz as single=0, ByVal minParticlesPerSecond as integer=5, ByVal maxParticlesPerSecond as integer=10, ByVal mnStartColor as integer=&hff000000, ByVal mxStartColor as integer=&hffffffff, ByVal lifeTimeMin as integer=2000, ByVal lifeTimeMax as integer=4000, ByVal maxAngleDegrees as Integer=0, ByVal dimminx as single=5.0, ByVal dimminy as single=5.0, ByVal dimmaxx as single=5.0, ByVal dimmaxy as Single=5.0, ByVal bbox as any Ptr=NULL) As ParticleSystemNode
 declare Function _CreateParticleCylinderEmitter(ByVal part As ParticleSystemNode, ByVal centerx as single,  ByVal centery as single,  ByVal centerz as single, ByVal radius as single, ByVal normalx as single, ByVal normaly as single, ByVal normalz as single, ByVal length as single, ByVal outlineOnly as UByte=FALSE, ByVal dirx as single=0, ByVal diry as single=0.03, ByVal dirz as single=0, ByVal minParticlesPerSecond as integer=5, ByVal maxParticlesPerSecond as integer=10, ByVal minStartCol as integer=&hff000000, ByVal maxStartCol as integer=&hffffffff,ByVal lifeTimeMin as integer=2000, ByVal lifeTimeMax as integer=4000, ByVal maxAngleDegrees as Integer=0, ByVal minStartSx as single=5.0, ByVal minStartSy as single=5.0, ByVal maxStartSx as single=5.0, ByVal maxStartSy as Single=5.0) As ParticleSystemNode
 declare Function _CreateParticleSphereEmitter(ByVal part As ParticleSystemNode, ByVal centerx as single,  ByVal centery as single,  ByVal centerz as single, ByVal radius as single,  ByVal dirx as single=0, ByVal diry as single=0.03, ByVal dirz as single=0, ByVal minParticlesPerSecond as integer=5, ByVal maxParticlesPerSecond as integer=10, ByVal minStartCol as integer=&hff000000, ByVal maxStartCol as integer=&hffffffff,ByVal lifeTimeMin as integer=2000, ByVal lifeTimeMax as integer=4000, ByVal maxAngleDegrees as Integer=0, ByVal minStartSx as single=5.0, ByVal minStartSy as single=5.0, ByVal maxStartSx as single=5.0,  ByVal maxStartSy as Single=5.0) As ParticleSystemNode
 declare Function _CreateParticleMeshEmitter(ByVal part As ParticleSystemNode, ByVal mesh As Mesh, ByVal useNormalDirection as UByte=TRUE, ByVal dirx as single=0, ByVal diry as single=0.03, ByVal dirz as single=0, ByVal normalDirectionModifier as single=100.0, ByVal mbNumber as integer=-1, everyMeshVertex as UByte = FALSE, ByVal minParticlesPerSecond as integer=5, ByVal maxParticlesPerSecond as integer=10, ByVal minStartCol as integer=&hff000000, ByVal maxStartCol as integer=&hffffffff,ByVal lifeTimeMin as integer=2000, ByVal lifeTimeMax as integer=4000, ByVal maxAngleDegrees as Integer=0, ByVal minStartSx as single=5.0, ByVal minStartSy as single=5.0, ByVal maxStartSx as single=5.0,  ByVal maxStartSy as Single=5.0) 	As ParticleSystemNode																		 
																			 
 declare Sub _ScaleParticleSystem(ByVal part As ParticleSystemNode, ByVal spx as single=1.0, ByVal spy as Single=1.0)
 declare Sub _RotationParticleSystem(ByVal part As ParticleSystemNode, ByVal spx as single=5.0,  ByVal spy as single=5.0, ByVal spz as single=5.0, ByVal px as single=0, ByVal py as single=0, ByVal pz as Single=0)
 declare Sub _AttractionParticleSystem(ByVal part As ParticleSystemNode, ByVal pointx as single, ByVal pointy as single, ByVal pointz as single, ByVal speed as Single=1.0, ByVal attract as UByte=TRUE, ByVal  affectX as UByte=True,  ByVal affectY as UByte=TRUE,  ByVal affectZ as UByte=TRUE )
 declare Sub _AddEmitterParticleSystem(ByVal part As ParticleSystemNode, byval em as ParticleEmitter )
 declare Sub _FadeOutParticleSystem(ByVal part As ParticleSystemNode,  ByVal targetColor as integer=0,   ByVal timeNeededToFadeOut as Integer=1000 )
 declare Function _ParticleSystemEmitter(ByVal part As ParticleSystemNode)As Integer
 declare Sub _GlobalParticleSystem(ByVal part As ParticleSystemNode, ByVal Glob as UByte=TRUE)
 declare Sub _ParticleSizeParticleSystem(ByVal part As ParticleSystemNode, ByVal sx as single=1.0, ByVal sy as Single=1.0)
 declare Sub _GravityParticleSystem(ByVal part As ParticleSystemNode, ByVal  gx as single,  ByVal gy as single,  ByVal gz as Single, ByVal timeForceLost as integer)
' IParticle functions
 declare Sub _MinStartSizeParticle(byval em as ParticleEmitter,  ByVal dimx as single, ByVal  dimy as Single  )
 declare Sub _MaxStartSizeParticle(byval em as ParticleEmitter,  ByVal dimx as single, ByVal  dimy as Single  )
 declare Sub _ParticleDirection(byval em as ParticleEmitter,  dirx as Any Ptr, ByVal  diry as any Ptr,  ByVal dirz as any Ptr  )
 declare Function _ParticleMaxPerSecond(byval em as ParticleEmitter)As Integer
 declare Function _ParticleMinPerSecond(byval em as ParticleEmitter )As Integer
 declare Sub _DirectionParticle(byval em as ParticleEmitter,  ByVal dirx as single, ByVal diry as single, ByVal dirz as Single  )
 declare Sub _MinPerSecondParticle(byval em as ParticleEmitter,  ByVal minPPS as Integer )
 declare Sub _MaxPerSecondParticle(byval em as ParticleEmitter,  ByVal maxPPS as Integer )
 declare Function _ParticleType(byval em as ParticleEmitter )As Integer
 declare Function _ParticleMaxStartColor(byval em as ParticleEmitter)As Integer
 declare Function _ParticleMinStartColor(byval em as ParticleEmitter )As Integer
 declare Sub _ParticleMaxStartSize(byval em as ParticleEmitter,  ByVal dimx as Any Ptr,  ByVal dimy as Any Ptr)
 declare Sub _ParticleMinStartSize(byval em as ParticleEmitter,  ByVal dimx as any Ptr,  ByVal dimy as Any Ptr)
 declare Sub _MaxStartColorParticle(byval em as ParticleEmitter,  ByVal col as Integer )
 declare Sub _MinStartColorParticle(byval em as ParticleEmitter,  ByVal col as Integer )

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' FileSystem Functions v2.0
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _AddZipFileArchive(byval filename as zstring ptr)
 declare Sub _AddFolderFileArchive(byval filename as zstring Ptr,  byval ignoreCase as UByte=True,  byval  ignorePaths as UByte=True)  
 declare Sub _AddPakFileArchive(byval filename as zstring Ptr, byval ignoreCase as UByte=True, byval   ignorePaths as UByte=True)  
 declare Sub _ChangeWorkingDirectory(byval filename as zstring Ptr) 
 declare Function _CreateAndOpenFile(byval filename as zstring Ptr) As integer
 declare Function _CreateAndWriteFile(byval filename as zstring Ptr, byval aappend as UByte=False)As Integer
 declare Function _CreateFileList() As Integer 
 declare Sub _FreeFileList(byval list As NFileList)  
 declare Sub _CreateMemoryReadFile(byval memory as Any Ptr , byval lLen as Integer, byval fileName as zstring Ptr, byval deleteMemoryWhenDropped as UByte=False) 
 declare Sub _ExistFile(byval fileName As zstring ptr)  
 Declare Function _WorkingDirectory()As Any Ptr ' Return char *
' IReadFile
 declare Function _ReadFileFileName(byval rf As NReadFile)As Any Ptr ' Return char *  
 declare Function _ReadFilePos(byval rf As NReadFile)As Integer  
 declare Function _ReadFileSize(byval rf As NReadFile) As Integer 
 declare Function _ReadFileRead(byval rf As NReadFile, byval buffer as Any Ptr, byval sizeToRead as Integer)  As Integer
 declare Function _ReadFileSeek(byval rf As NReadFile, byval finalPos as Integer,  byval relativeMovement as UByte=False) As Integer
 declare Sub _CloseReadFile(byval rf As NReadFile)  
' IWriteFile
 declare Function _WriteFileName(byval wf as NWriteFile)As Any Ptr ' ; Return char *  
 declare Function _WriteFilePos(byval wf as NWriteFile) As Integer
 declare Function _WriteFileSeek(byval wf as NWriteFile, byval finalPosint As integer,  byval relativeMovement as UByte=False)As Integer 
 declare Function _WriteFileWrite(byval wf as NWriteFile, byval buffer as Any ptr, byval sizeToWrite as Integer)As Integer  
 declare Sub _CloseWriteFile(byval wf as NWriteFile)  
' IFileList
 declare Function _FileListCount(byval fl as NFileList)As Integer  
 declare Function _FileListName(byval fl as NFileList, byval index as Integer) As Any ptr 
 declare Function _FileListFullName(byval fl as NFileList, byval index as Integer) As Integer 
 declare Function _FileListisDirectory(byval fl as NFileList, byval index as Integer)As Integer  

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- 2D Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _DrawLine2D(byval sx as integer,  byval sy as integer, byval ex as integer,  byval ey as integer,  byval col as Integer=&hffffffff)
 declare Sub _DrawPolygon2D(byval sx as integer,  byval sy as integer, byval radius as Single,  byval Col as integer=&hffffffff,  byval vertexcount as Integer=10)
 declare Sub _DrawRectangle2D(byval sx as integer,  byval sy as integer, byval ex as integer,  byval ey as integer,  byval colorLUp as integer=&hffffffff,  byval colorRUp as integer=&hffffffff,  byval colorLDown as integer=&hffffffff,  byval colorRDown as Integer=&hffffffff, byval clip as any Ptr=Null)
 declare Sub _DrawRect2D(byval sx as integer,  byval sy as integer, byval ex as integer,  byval ey as integer, byval  col as Integer=&hffffffff, byval  clip As any Ptr=NULL)
 declare Sub _DrawSubRectImage2D(byval texture as NTexture ,byval destx as integer,  byval desty as integer, byval destex as integer,  byval destey as integer, byval srcx as integer, byval  srcy as integer, byval srcex as integer,  byval srcey as Integer,  byval Col As any Ptr=NULL,  byval clip As any Ptr=NULL, byval useAlphaChannelOfTexture As Any ptr=FALSE )
 declare Sub _DrawRectImage2D(byval texture as NTexture ,byval posx as integer,  byval posy as integer, byval srcx as integer,  byval srcy as integer, byval srcex as integer,  byval srcey as integer, byval  col as Integer=&hffffffff,  byval clip As any Ptr=Null, byval useAlphaChannelOfTexture As UByte=FALSE )
 declare Sub _DrawImage2D(byval texture as NTexture, byval posx as integer,byval   posy as Integer)
 declare Sub _Begin2D(byval wwidth as integer=0, byval height as Integer=0)
 declare Sub _End2D()
' sprite2D
 declare Function _CreateSprite2D(byval texturename As ZString ptr, byval ssize as Single=1.0, byval Col as Integer=&hffffffff, byval parent As Sprite2D=NULL) As Sprite2D
 declare Sub _CenterSprite2D(byval sp As Sprite2D, byval  x as single,  byval y as Single) 
 declare Sub _RenderSprite2D(byval sp As Sprite2D) 

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- PRIMITIVES 3D Functions v1.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _DrawTriangle3D(byval tri As Any Ptr, byval col as Integer=&hffffffff)
 declare Sub _DrawBox3D(byval box As any Ptr, byval Col as Integer=&hffffffff)
 declare Sub _DrawLine3D(byval startx as single,  byval starty as single,  byval startz as single,  byval endx as single,  byval endy as single, byval  endz as Single, byval Col as integer=&hffffffff)
 declare Sub _SituatePrimitive3D(byval  px as single=0,  byval py as single=0,  byval pz as single=0,  byval rx as single=0,  byval ry as single=0,  byval rz as single=0)
 declare Sub _MatrixPrimitive3D(byval  mdraw As any Ptr )


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- GUI Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _TextGUI(byval gui as IGUIElement, byval text as zstring Ptr)
 declare Sub _ToolTipTextGUI(byval gui as IGUIElement, byval text as zstring Ptr)
 declare Sub _VisibleGUI(byval gui as IGUIElement, byval flag as UByte)
 declare Sub _RelativePositionGUI(byval gui as IGUIElement, byval posx as integer, byval  posy as Integer)
 declare Sub _RelativeRectGUI(byval gui as IGUIElement,byval  posx as integer, byval  posy as integer, byval  ox as integer,  byval oy as Integer)
 declare Sub _GUIAbsoluteRect(byval gui as IGUIElement, byval posx as UByte Ptr, byval  posy as UByte Ptr,  byval ox as UByte Ptr,  byval oy as UByte Ptr)
 declare Sub _GUIAbsoluteClippingRect(byval gui as IGUIElement, byval posx as UByte Ptr,  byval posy as UByte Ptr,  byval ox as UByte Ptr,  byval oy as UByte Ptr)
 declare Function _GUIChildren(byval gui as IGUIElement,  byval num as Integer=0)As IGUIElement
 declare Sub _ChildrenGUI(byval gui as IGUIElement, byval child as IGUIElement)
 declare Function _BringToFrontGUI(byval gui as IGUIElement)as Integer
 declare Function _GUIElementFromId(byval gui as IGUIElement,  byval Id as Integer, byval searchchildren as UByte=False) As IGUIElement
 declare Function _GUIID (byval gui as IGUIElement)as Integer
 declare Function _GUIParent(byval gui as IGUIElement)As IGUIElement
 declare Function _GUIType(byval gui as IGUIElement)as Integer
 declare Function _GUIisEnabled(byval gui as IGUIElement)as Integer
 declare Function _GUIisPointInside(byval gui as IGUIElement,  byval posx as integer,  byval posy as Integer)as Integer
 declare Function _GUIVisible(byval gui as IGUIElement)as Integer
 declare Sub _MoveGUI(byval gui as IGUIElement,  byval posx as integer,  byval posy as Integer)
 declare Sub _FreeGUI(byval gui as IGUIElement)
 declare Sub _FreeChildGUI(byval gui as IGUIElement, byval child as IGUIElement)
 declare Sub _EnabledGUI(byval gui as IGUIElement,  byval enable as UByte=True)
 declare Sub _IDGUI(byval gui as IGUIElement,  byval ID as Integer=-1)
 declare Sub _MaxSizeGUI(byval gui as IGUIElement, byval posx as integer,  byval posy as Integer)
 declare Sub _MinSizeGUI(byval gui as IGUIElement, byval posx as integer,  byval posy as Integer)
 declare Function _GUIText(byval gui as IGUIElement)As Any Ptr
 declare Sub _GUIEventCallBack(byval procedureGUIEventCallBack as UByte Ptr)
 declare Function _GUIColor( byval index as Integer)as Integer
 declare Sub _ColorGUI(byval index as integer, byval col as Integer)
' @ text And font
 declare Function _AddStaticText(byval text as zstring Ptr,  byval x as integer,  byval y as integer,  byval rx as integer,  byval ry as integer, byval border as UByte=False, byval wordWrap as UByte=True, byval fillBackground as UByte=False, byval parent as IGUIElement=Null, byval id as Integer=-1)As IGUIStaticText
 declare Sub _LoadFont(byval filename as zstring Ptr, byval egui as Integer = EGDF_DEFAULT )
 declare Function _GetFont()As IGUIFont
 declare Sub _DrawText(byval font as IGUIFont, byval text as zstring Ptr,  byval x as integer,  byval y as integer,  byval rx as integer,  byval ry as integer, byval col as Integer=&hff9999ff)
 declare Sub _GUIText_EnableOverrideColor(byval text as IGUIStaticText, byval enable as UByte)
 declare Function _GUIText_OverrideColor(byval text as IGUIStaticText)as Integer
 declare Function _GUIText_OverrideFont(byval text as IGUIStaticText)As IGUIFont  ' Return IGUIFont*
 declare Function _GUIText_Height(byval text as IGUIStaticText)as Integer
 declare Function _GUIText_Width(byval text as IGUIStaticText)as Integer
 declare Sub _BackgroundColor_GUIText(byval text as IGUIStaticText, byval Col as Integer=&hffffffff)
 declare Sub _DrawBackground_GUIText(byval text as IGUIStaticText,  byval dDraw as UByte)
 declare Sub _DrawBorder_GUIText(byval text as IGUIStaticText,  byval Draw as UByte)
 declare Sub _OverrideColor_GUIText(byval text as IGUIStaticText,  byval Col as Integer=&hffffffff)
 declare Sub _OverrideFont_GUIText(byval text as IGUIStaticText, byval font as IGUIFont)
 declare Sub _Alignment_GUIText(byval text as IGUIStaticText, byval h as integer, byval v as Integer)
 declare Sub _WordWrap_GUIText(byval text as IGUIStaticText,  byval enable as UByte)
' @button
 declare Function _AddButtonGUI(byval orx as integer, byval ory as integer, byval sx as integer, byval sy as integer,  byval text as zstring ptr, byval tooltiptext as zstring Ptr=Null, byval parent as IGUIElement=Null , byval id as Integer=-1  )As IGUIButton
 declare Function _GUIButton_AlphaChannel(byval button as IGUIElement )as Integer
 declare Function _GUIButton_DrawingBorder(byval button as IGUIElement )as Integer
 declare Function _GUIButton_Pressed (byval button as IGUIElement )as Integer
 declare Function _GUIButton_PushButton(byval button as IGUIElement )as Integer
 declare Sub _DrawBorder_GUIButton(byval button as IGUIElement, byval border as UByte=True)
 declare Sub _Image_GUIButton(byval button as IGUIElement, byval image as NTexture=Null)
 declare Sub _PushButton_GUIButton(byval button as IGUIElement, byval isPushButton as UByte=False )
 declare Sub _OverrideFont_GUIButton(byval button as IGUIElement, byval font as IGUIFont  )
 declare Sub _Pressed_GUIButton(byval button as IGUIElement,  byval pressed as UByte=True  )
 declare Sub _PressedImage_GUIButton(byval button as IGUIElement,  byval image as NTexture=Null)
 declare Sub _Sprite_GUIButton(byval button as IGUIElement, byval state as integer, byval index as integer, byval Col as Integer=&hffffffff, byval Loop as UByte=False )
 declare Sub _SpriteBank_GUIButton(byval button as IGUIElement,  byval bank as IGUISpriteBank )
 declare Sub _AlphaChannel_GUIButton(byval button as IGUIElement,  byval useAlphaChannel as UByte=False )
' @ CursorControl
 declare Sub _CursorControlPosition( byval posx as UByte Ptr, byval posy as UByte Ptr)
 declare Sub _CursorControlRelativePosition( byval posx as UByte Ptr, byval posy as UByte Ptr)
 declare Function _CursorControlVisible ()as Integer
 declare Sub _PositionCursorControl( byval x as integer, byval y as Integer)
 declare Sub _ReferenceRectCursorControl( byval orx as integer, byval ory as integer, byval sx as integer, byval sy as Integer)
 declare Sub _VisibleCursorControl( byval visible as UByte=True )
 declare Function _CursorControlX()as Integer
 declare Function _CursorControlY()as Integer
' @ CheckBox
 declare Function _AddCheckBoxGUI( byval checked as UByte, byval orx as integer, byval ory as integer, byval sx as integer, byval sy as integer,  byval text as zstring Ptr, byval parent as IGUIElement=NULL , byval id as Integer=-1  )As IGUICheckBox
 declare Function _GUICheckBox_Check( byval check as IGUICheckBox )as Integer
 declare Sub _Check_GUICheckBox(byval check as IGUICheckBox , byval checked as UByte=TRUE  )
' @ EditBox
 declare Function _AddEditBox(byval text as zstring Ptr, byval x as integer,  byval y as integer,  byval rx as integer,  byval ry as integer, byval border as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1  )As IGUIEditBox
 declare Sub _EnableOverrideColor_GUIEditBox(byval gui as IGUIEditBox , byval enable as UByte)
 declare Function _GUIEditBox_Max(byval gui as IGUIEditBox)as Integer
 declare Function _GUIEditBox_AutoScrollEnabled(byval gui as IGUIEditBox)as Integer
 declare Sub _GUIEditBox_TextDimension(byval gui as IGUIEditBox, byval dimx as UByte Ptr, byval dimy as UByte Ptr)
 declare Function _GUIEditBox_MultiLineEnabled(byval gui as IGUIEditBox)as Integer
 declare Sub _AutoScroll_GUIEditBox(byval gui as IGUIEditBox, byval enable as UByte=True)
 declare Sub _DrawBorder_GUIEditBox(byval gui as IGUIEditBox, byval enable as UByte=True)
 declare Sub _Max_GUIEditBox(byval gui as IGUIEditBox, byval mm as Integer=128)
 declare Sub _Multiline_GUIEditBox(byval gui as IGUIEditBox, byval enable as UByte=True)
 declare Sub _OverrideColor_GUIEditBox(byval gui as IGUIEditBox, byval Col as Integer=&hffffffff)
 declare Sub _OverrideFont_GUIEditBox(byval gui as IGUIEditBox, byval font as IGUIFont  )
 declare Sub _TextAlignment_GUIEditBox(byval gui as IGUIEditBox, byval h as integer, byval v as Integer)
' @ GUI Image
 declare Function _AddImageGUI(byval img as NTexture, byval posx as integer, byval posy as integer, byval useAlphaChannel as UByte, byval text as zstring Ptr, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIImage
 declare Function _AddEmptyImageGUI(byval posx as integer, byval posy as integer, byval osx as integer, byval osy as integer, byval text as zstring Ptr, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIImage
 declare Function _GUIImage_AlphaChannelUsed ( byval img as IGUIImage )as Integer
 declare Function _GUIImage_ImageScaled (byval img as IGUIImage)as Integer
 declare Sub _Color_GUIImage(byval img as IGUIImage, byval Col as Integer=&hffffffff )
 declare Sub _Image_GUIImage(byval img as IGUIImage,  byval image as NTexture )
 declare Sub _Scale_GUIImage(byval img as IGUIImage, byval enable as UByte )
 declare Sub _AlphaChannel_GUIImage(byval img as IGUIImage, byval enable as UByte=True )
' @ ComboBox
 declare Function _AddComboBoxGUI( byval x as integer,  byval y as integer,  byval rx as integer,  byval ry as integer, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIComboBox
 declare Function _AddItem_GUIComboBox( byval combo as IGUIComboBox, byval text as zstring Ptr)as Integer
 declare Sub _Clear_GUIComboBox(byval combo as IGUIComboBox)
 declare Function _GUIComboBox_Item(byval combo as IGUIComboBox,  byval idx as Integer=0) As Any Ptr'char*
 declare Function _GUIComboBox_ItemCount(byval combo as IGUIComboBox)as Integer
 declare Function _GUIComboBox_Selected (byval combo as IGUIComboBox)as Integer
 declare Sub _RemoveItem_GUIComboBox(byval combo as IGUIComboBox, byval idx as Integer=0)
 declare Sub _Selected_GUIComboBox(byval combo as IGUIComboBox, byval idx as Integer=0)
 declare Sub _TextAlignment_GUIComboBox(byval combo as IGUIComboBox, byval h as integer, byval v as Integer)
' @ ContextMenu
 declare Function _AddContexMenuGUI(byval x as integer,  byval y as integer,  byval rx as integer,  byval ry as integer, byval parent as IGUIElement=Null , byval id as Integer=-1 ) As IGUIContextMenu
 declare Function _AddItem_GUIContexMenu(byval menu as IGUIContextMenu, byval text as zstring Ptr, byval commandId as Integer=-1, byval enable as UByte=True, byval hasSubMenu as UByte=False , byval checked as UByte=False ) as Integer
 declare Sub _AddSeparator_GUIContexMenu(byval menu as IGUIContextMenu)
 declare Function _GUIContexMenu_ItemCommandId(byval menu as IGUIContextMenu, byval idx as Integer=0)as Integer
 declare Function _GUIContexMenu_ItemCount(byval menu as IGUIContextMenu)as Integer
 declare Function _GUIContexMenu_ItemText(byval menu as IGUIContextMenu, byval idx as Integer=0) As Any Ptr' char*
 declare Function _GUIContexMenu_ItemSelected(byval menu as IGUIContextMenu)as Integer
 declare Function _GUIContexMenu_SubMenu(byval menu as IGUIContextMenu, byval idx as Integer=0)As IGUIContextMenu
 declare Function _GUIContexMenu_ItemChecked(byval menu as IGUIContextMenu, byval idx as Integer=0)as Integer
 declare Function _GUIContexMenu_ItemEnabled(byval menu as IGUIContextMenu, byval idx as Integer=0)as Integer
 declare Sub _RemoveAll_GUIContexMenu(byval menu as IGUIContextMenu)
 declare Sub _RemoveItem_GUIContexMenu(byval menu as IGUIContextMenu, byval idx as Integer=0)
 declare Sub _ItemChecked_GUIContexMenu(byval menu as IGUIContextMenu, byval idx as Integer=0, byval enable as UByte=True)
 declare Sub _ItemCommanId_GUIContexMenu(byval menu as IGUIContextMenu, byval idx as integer=0, byval id as Integer=-1)
 declare Sub _ItemEnabled_GUIContexMenu(byval menu as IGUIContextMenu, byval idx as Integer=0, byval enable as UByte=True)
 declare Sub _ItemText_GUIContexMenu(byval menu as IGUIContextMenu, byval idx as Integer, byval text as zstring Ptr)
' @ Sprite Bank
 declare Function _AddEmptySpriteBankGUI(byval nName as zstring Ptr)As IGUISpriteBank
 declare Sub _AddTexture_GUISpriteBank(  byval sp as IGUISpriteBank,  byval texture as NTexture  )
 declare Sub _Draw2D_GUISpriteBank( byval sp as IGUISpriteBank, byval index as integer, byval posx as integer, byval posy as integer, byval Col as integer=&hffffffff, byval starttime as integer=0,	byval cCurrentTime as Integer=0, byval lLoop as UByte=True, byval center as UByte=False, byval clipox as UByte Ptr=Null ) 
 Declare Function _GUISpriteBank_Texture(byval  sp as IGUISpriteBank, byval idx as Integer=0)As NTexture
 Declare Function _GUISpriteBank_TextureCount( byval sp as IGUISpriteBank)as Integer
 declare Sub _Texture_GUISpriteBank( byval sp as IGUISpriteBank, byval idx as Integer, byval texture as NTexture)
' @ FileOpenDialog
 declare Function _AddFileOpenDialogGUI(byval  title as zstring Ptr, byval modal as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIFileOpenDialog
 declare Function _GUIFileOpenDialog_FileName( byval dial as IGUIFileOpenDialog )As Any Ptr
' @ InOutFader
 declare Function _AddInOutFaderGUI(byval rect as UByte Ptr, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIInOutFader'; Return IGUIInOutFader*
 declare Sub _FadeIn_GUIInOutFader( byval inout as IGUIInOutFader,  byval ttime as Integer)
 declare Sub _FadeOut_GUIInOutFader(byval inout as IGUIInOutFader,byval  ttime as Integer)
 declare Function _GUIInOutFader_Color (byval inout as IGUIInOutFader)as Integer
 declare Function _GUIInOutFader_Ready(byval inout as IGUIInOutFader)as Integer
 declare Sub _Color_GUIInOutFader(byval inout as IGUIInOutFader,  byval Col as Integer=&hffffffff)
' @ ListBox
 declare Function _AddListBoxGUI( byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer,  byval drawBackground as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIListBox
 declare Sub _AddItem_GUIListBox(byval lbox as IGUIListBox, byval item as zstring Ptr, byval icon as Integer=-1)
 declare Sub _Clear_GUIListBox(byval lbox as IGUIListBox)
 declare Sub _ClearItemOverrideColor_GUIListBox(byval lbox as IGUIListBox,  byval idx as Integer)
 declare Function _GUIListBox_Icon (byval lbox as IGUIListBox,  byval idx as Integer)as Integer
 declare Function _GUIListBox_ItemCount(byval lbox as IGUIListBox)as Integer
 declare Function _GUIListBox_ItemDefaultColor(byval lbox as IGUIListBox,  byval colorType as Integer )as Integer
 declare Function _GUIListBox_ItemOverrideColor(byval lbox as IGUIListBox,  byval idx as integer,  byval colorType as Integer )as Integer
 declare Function _GUIListBox_ListItem(byval lbox as IGUIListBox,  byval idx as Integer)As Any Ptr
 declare Function _GUIListBox_Selected (byval lbox as IGUIListBox)as Integer
 declare Function _GUIListBox_HasItemOverrideColor(byval lbox as IGUIListBox,  byval idx as integer,  byval colorType as Integer )as Integer
 declare Function _InsertItem_GUIListBox (byval lbox as IGUIListBox,  byval idx as zstring ptr, byval item as zstring Ptr,  byval icon as Integer )as Integer
 declare Function _GUIListBox_AutoScrollEnabled(byval lbox as IGUIListBox)as Integer
 declare Sub _RemoveItem_GUIListBox(byval lbox as IGUIListBox,  byval idx as Integer)
 declare Sub _AutoScrollEnabled_GUIListBox(byval lbox as IGUIListBox,  byval scroll as UByte=True)
 declare Sub _Item_GUIListBox(byval lbox as IGUIListBox,  byval idx as integer, byval item as zstring Ptr,  byval icon as Integer )
 declare Sub _ItemOverrideColor_GUIListBox(byval lbox as IGUIListBox,  byval idx as integer,  byval colorType as integer,  byval Col as Integer )
 declare Sub _Selected_GUIListBox(byval lbox as IGUIListBox,  byval idx as Integer)
 declare Sub _SpriteBank_GUIListBox(byval lbox as IGUIListBox,   byval bank as IGUISpriteBank  )
 declare Sub _SwapItems_GUIListBox(byval lbox as IGUIListBox,  byval idx1 as integer,  byval idx2 as Integer)
' @ Menu
 declare Function _AddMenuGUI(byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIContextMenu
' @ messagebox
 declare Function _AddMessageBoxGUI(byval caption as zstring ptr, byval text as zstring Ptr, byval modal as UByte=True, byval flag as integer=EMBF_OK, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIWindow
 declare Function _GUIMessageBox_CloseButton( byval mb as IGUIWindow)As IGUIButton
 declare Function _GUIMessageBox_MaximizeButton(byval mb as IGUIWindow)As IGUIButton
 declare Function _GUIMessageBox_MinimizeButton(byval mb as IGUIWindow)As IGUIButton
' @ modal screen
 declare Function _AddModalScreenGUI(byval parent as IGUIElement=Null)As IGUIElement
' @ scroll bar
 declare Function _AddScrollBarGUI( byval horizontal as UByte, byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIScrollBar
 declare Function _GUIScrollBar_LargeStep ( byval sb as IGUIScrollBar)as Integer
 declare Function _GUIScrollBar_Max(byval sb as IGUIScrollBar)as Integer
 declare Function _GUIScrollBar_Pos(byval sb as IGUIScrollBar)as Integer
 declare Function _GUIScrollBar_SmallStep(byval sb as IGUIScrollBar)as Integer
 declare Sub _LargeStep_GUIScrollBar(byval sb as IGUIScrollBar,  byval value as Integer)
 declare Sub _Max_GUIScrollBar(byval sb as IGUIScrollBar,  byval value as Integer)
 declare Sub _Pos_GUIScrollBar(byval sb as IGUIScrollBar,  byval value as Integer)
 declare Sub _SmallStep_GUIScrollBar(byval sb as IGUIScrollBar,  byval value as Integer)
' @ spin box
 declare Function _AddSpinBoxGUI(byval text as zstring Ptr, byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer, byval bborder as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUISpinBox
 declare Function _GUISpinBox_EditBox( byval spb as IGUISpinBox)As IGUIEditBox
 declare Function _GUISpinBox_Max (byval spb as IGUISpinBox)as Single
 declare Function _GUISpinBox_Min (byval spb as IGUISpinBox)as Single
 declare Function _GUISpinBox_StepSize(byval spb as IGUISpinBox)as Single
 declare Function _GUISpinBox_Value(byval spb as IGUISpinBox)as Single
 declare Sub _DecimalPlaces_GUISpinBox(byval spb as IGUISpinBox, byval value as Integer)
 declare Sub _Range_GUISpinBox(byval spb as IGUISpinBox,  byval mMin as single,  byval mMax as Single)
 declare Sub _StepSize_GUISpinBox(byval spb as IGUISpinBox, byval sStep as Single)
 declare Sub _Value_GUISpinBox(byval spb as IGUISpinBox, byval value as Single)
' @ tabcontrol 
 declare Function _AddTabControlGUI(byval orx as integer,  byval ory as integer,  byval sx as integer,  sy as integer, byval fillbackground as UByte=False,	byval bborder as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUITabControl
 declare Function _AddTab_GUITabControl(byval tabc as IGUITabControl, byval caption as zstring Ptr, byval id as Integer=-1)As IGUITab
 declare Function _GUITabControl_ActiveTab (byval tabc as IGUITabControl)as Integer
 declare Function _GUITabControl_Tab(byval tabc as IGUITabControl, byval idx as Integer=-1)As IGUITab
 declare Function _GUITabControl_TabCount(byval tabc as IGUITabControl)as Integer
 declare Function _GUITabControl_TabExtraWidth(byval tabc as IGUITabControl)as Integer
 declare Function _GUITabControl_TabHeight(byval tabc as IGUITabControl)as Integer
 declare Function _GUITabControl_TabVerticalAlignment(byval tabc as IGUITabControl)as Integer
 declare Function _ActiveTab_GUITabControl(byval tabc as IGUITabControl,  byval tTab as IGUIElement )as Integer
 declare Function _ActiveTabId_GUITabControl(byval tabc as IGUITabControl, byval idx as Integer=0 )as Integer
 declare Sub _TabExtraWidth_GUITabControl(byval tabc as IGUITabControl,  byval extraWidth as Integer  )
 declare Sub _TabHeight_GUITabControl(byval tabc as IGUITabControl, byval height as Integer )
 declare Sub _TabVerticalAlignment_GUITabControl(byval tabc as IGUITabControl, byval align as Integer )
' @ tab functions
 Declare Function _AddTabGUI(byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUIElement
 declare Sub _BackgroundColor_GUITab( byval tTab as IGUITab, byval Col as Integer=&hffffffff)
 declare Function _GUITab_BackgroundColor(byval tTab as IGUITab)as Integer
 declare Function _GUITab_Number(byval tTab as IGUITab)as Integer
 declare Function _GUITab_TextColor(byval tTab as IGUITab)as Integer
 declare Function _GUITab_isDrawingBackground(byval tTab as IGUITab)as Integer
 declare Sub _DrawBackground_GUITab(byval tTab as IGUITab, byval flag as UByte=True)
 declare Sub _TextColor_GUITab(byval tTab as IGUITab,  byval col as Integer=&hffffffff)
' @ Table
 declare Function _AddTableGUI(byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer, byval drawBackground as UByte=True, byval parent as IGUIElement=Null , byval id as Integer=-1 )As IGUITable
 declare Sub _AddColumn_GUITable(byval table as IGUITable, byval caption as zstring Ptr, byval columnIndex as Integer=-1 )
 declare Sub _AddRow_GUITable(byval table as IGUITable,  byval rowIndex as Integer )
 declare Sub _Clear_GUITable(byval table as IGUITable)
 declare Sub _ClearRows_GUITable(byval table as IGUITable)
 declare Function _GUITable_ActiveColumn(byval table as IGUITable)as Integer
 declare Function _GUITable_ActiveColumnOrdering(byval table as IGUITable)as Integer
 declare Function _GUITable_CellData(byval table as IGUITable,  byval rowIndex as integer,  byval columnIndex as Integer)As Any ptr
 declare Function _GUITable_CellText(byval table as IGUITable,  byval rowIndex as integer,  byval columnIndex as Integer)  As Any Ptr 
 declare Function _GUITable_ColumnCount (byval table as IGUITable)  as Integer 
 declare Function _GUITable_DrawFlags(byval table as IGUITable)  as Integer 
 declare Function _GUITable_RowCount(byval table as IGUITable)  as Integer 
 declare Function _GUITable_Selected(byval table as IGUITable) as Integer  
 declare Function _GUITable_hasResizableColumns(byval table as IGUITable)as Integer
 declare Sub _OderRows_GUITable(byval table as IGUITable,  byval columnindex as integer=-1, byval mode as Integer=EGOM_NONE ) 
 declare Sub _RemoveColumn_GUITable(byval table as IGUITable, byval columnindex as Integer=-1)
 declare Sub _RemoveRow_GUITable(byval table as IGUITable, byval columnindex as Integer=-1)
 declare Sub _ActiveColumn_GUITable(byval table as IGUITable,  byval index as Integer,  byval doOrder as UByte=False)   
 declare Sub _CellColor_GUITable(byval table as IGUITable, byval rowindex as integer, byval columnindex as integer, byval Col as Integer=&hffffffff)
 declare Sub _CellData_GUITable(byval table as IGUITable, byval rowindex as integer, byval columnindex as Integer, byval ddata as UByte Ptr)
 declare Sub _CellText_GUITable(byval table as IGUITable, byval rowindex as integer, byval columnindex as integer, byval text as zstring Ptr, byval col as Integer=&hffffffff)
 declare Sub _ColumnOrdering_GUITable(byval table as IGUITable, byval columnindex as integer, byval mode as Integer=EGCO_NONE  ) 
 declare Sub _ColumnWidth_GUITable(byval table as IGUITable, byval columnindex as integer,  byval wwidth as Integer) 
 declare Sub _DrawFlags_GUITable(byval table as IGUITable, byval flag as Integer)
 declare Sub _ResizableColumns_GUITable(byval table as IGUITable, byval flag as UByte) 
 declare Sub _SwapRows_GUITable(byval table as IGUITable, byval rowindexA as integer, byval rowindexB as Integer) 
' @ ToolBar
 declare Function _AddToolBarGUI(byval parent as IGUIElement=Null , id as Integer=-1 )As IGUIToolBar
 declare Sub _AddButton_GUIToolBar(byval tb as IGUIToolBar, byval text as zstring ptr, byval tooltiptext as zstring Ptr, byval img as NTexture=Null, byval pressedimg as NTexture=Null, byval  isPushButton as UByte=FALSE, byval  useAlphaChannel as UByte=FALSE, byval id as Integer=-1)
' @ GUI Window
 declare Function _AddWindowGUI(byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as integer, byval text as zstring Ptr, byval modal as UByte=FALSE, byval parent as IGUIElement=NULL , byval id as Integer=-1 )As IGUIWindow
 declare Function _GUIWindow_CloseButton( byval win as IGUIWindow )As IGUIButton
 declare Function _GUIWindow_MaximizeButton( byval win as IGUIWindow )As IGUIButton
 declare Function _GUIWindow_MinimizeButton( byval win as IGUIWindow )As IGUIButton
' @ GUI Environement, To be continued....
 declare Function _SetSkinGUI( byval tType as Integer )As IGUISkin
 declare Sub _ClearGUI()
 declare Function _GUI_BuiltInFont()As IGUIFont
 declare Function _GUI_Focus()As IGUIElement
 declare Function _GUI_SpriteBank(byval filename as zstring Ptr)As IGUISpriteBank
 declare Function _GUI_VideoDriver()As Any Ptr
 declare Function _Focus_GUI(byval  element as IGUIElement )as Integer
 declare Function _GUI_HasFocus(byval  element as IGUIElement )as Integer
 declare Function _Load_GUI(byval  filename as zstring Ptr, byval parent as IGUIElement=Null )as Integer
 declare Function _Save_GUI(byval  filename as zstring Ptr, byval start as IGUIElement=Null  )as Integer
' @ Skin GUI
 declare Function _CustomSkinGUI(byval configSkinname as zstring Ptr)As IGUISkin
 declare Sub _Color_GUISkin(byval skin As IGUISkin, byval which as integer=EGDC_3D_FACE ,  byval Col as Integer=&hffffffff)
 declare Function _GUISkin_Color(byval skin As IGUISkin, byval which as Integer=EGDC_3D_FACE) as Integer
 declare Function _SkinGUI_Curent()As IGUISkin
 declare Sub _Size_GUISkin(byval skin As IGUISkin, byval which as integer,  byval size as Integer)
 declare Function _GUISkin_Size(byval skin As IGUISkin, byval which as Integer)as Integer
 declare Sub _DefaultText_GUISkin(byval skin As IGUISkin, byval which as Integer, byval text as zstring Ptr)
' @ progress bar (only with Custum Skin loaded
 declare Function _AddProgressBarGUI(byval orx as integer,  byval ory as integer,  byval sx as integer,  byval sy as Integer, byval parent As IGUIElement=NULL)As IGUIProgressBar
 declare Sub _Value_ProgressBarGUI(byval bar as IGUIProgressBar,  byval progress as Single=0.5)
 declare Function _ProgressBarGUI_Value(byval bar as IGUIProgressBar) as Single
 declare Function _GUIProgressBar_Color(byval bar as IGUIProgressBar)as Integer
 declare Sub _Color_GUIProgressBar(byval bar as IGUIProgressBar,  byval col as Integer=&hffffffff)
 declare Sub _AutomaticText_GUIProgressBar(byval bar as IGUIProgressBar,  byval fformat as zstring Ptr)
 declare Sub _EmptyColor_GUIProgressBar(byval bar as IGUIProgressBar, byval col as Integer=&hffffffff)
 declare Sub _GUIProgressBar_EmptyColor(byval bar as IGUIProgressBar)


' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- Event Input Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _GetKey () As integer
 declare Function _MouseEvent () As Integer
 declare Function _GetMouseWheel () As Integer
 declare Function _GetKeyDown (ByVal  keyCode As integer) As Integer
 declare Function _GetKeyUp (ByVal  keyCode As Integer) As Integer
 declare Function _GetMouseX () As Integer
 declare Function _GetMouseY () As Integer
 declare Function _GetDeltaMouseX (ByVal fcursoras As UByte=0) As Integer
 declare Function _GetDeltaMouseY (ByVal fcursoras As UByte=0) As Integer
 declare Function _GetMouseEvent (ByVal event As Integer) As Integer
 declare Function _GetLastKey () As Integer
 declare Sub _PositionCursor (ByVal  x As single, ByVal  y As single)
 declare Function _CursorX () As Integer
 declare Function _CursorY () As Integer
' Joystick
 declare Sub _ActivateJoysticks Alias "_ActivateJoysticks"()
 declare Function _JoysticksAxis Alias "_JoysticksAxis"(ByVal axis As Integer) As Integer
 declare Function _JoysticksButtonStates Alias "_JoysticksButtonStates"() As Integer
 declare Function _JoysticksPOV Alias "_JoysticksPOV"() As Integer
 declare Function _JoysticksJoy Alias "_JoysticksJoy"() As Integer

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'-CORE Utils Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Function _CreateArray() As NArray' Return NArray
 declare Sub _PushbackArray(byval arr As NArray,  byval el As Any Ptr) 
 declare Sub _PushfrontArray(byval arr As NArray,  byval el As Any Ptr) 
 declare Function _ArrayElement(byval arr As NArray,  byval i as Integer)As Any Ptr
 declare Function _ArraySize(byval arr As NArray) As integer
 declare Function _PoplastArray(byval arr As NArray) As Any Ptr
 declare Sub _FreeArray(byval arr As NArray) 
 declare Sub _ProjectionMatrixOrthoLH(byval w as single,  byval h as single, byval projection As Any Ptr, byval zNear as single=0.1,  byval zFar as Single=100.0)
 declare Sub _ProjectionMatrixOrthoRH(byval w as single,  byval h as single, byval projection As Any Ptr, byval zNear as single=0.1,  byval zFar as Single=100.0)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- SHADER Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _VersionShader(byval VSType as integer=EVST_VS_1_1, byval PSType as Integer=EPST_PS_1_1)
 declare Function _CreateShaderHighLevel(byval vsFileName as zstring ptr, byval EntryNameVS as zstring ptr, byval psFileName as zstring ptr, byval EntryNamePS as zstring Ptr, byval videottype as Integer, byval constantshaderFnt As Any Ptr=Null, byval materialshaderFnt As Any Ptr=Null )As Integer
 declare Sub _BasicRenderStatesMaterialServices(byval services as NMaterialServices, byval material As NMaterial, byval lastMaterial As NMaterial,   byval resetAllRenderstates As UByte  )
 declare Sub _PixelShaderConstantMaterialServices(byval services as NMaterialServices,	byval fData As Any Ptr,  byval startRegister as integer,   byval constantAmount as Integer=1  )
 declare Sub _PixelShaderConstantNMaterialServices(byval services as NMaterialServices,	byval nName as zstring Ptr,  byval fFloat As Any Ptr,   byval count as Integer)
 declare Sub _VertexShaderConstantMaterialServices(byval services as NMaterialServices,	byval fData As Any Ptr,  byval startRegister as integer,   byval constantAmount as Integer=1  )
 declare Sub _VertexShaderConstantNMaterialServices(byval services as NMaterialServices, byval nName as zstring ptr,  byval fFloat As Any Ptr,   byval count as Integer)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- SHADOW Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _SetShadowType(byval value as integer=SHADOW_VOLUME_TYPE)
' shadowVolume
 declare Function _ShadowVolumeEntity(byval node As EntityNode,  byval zfailmethod As UByte=True, byval infinity as Single=10000.0 )As ShadowVolumeNode
 declare Function _ShadowVolumeAnimation(byval anim As AnimatedNode,  byval zfailmethod As UByte=True, byval infinity as Single=10000.0 )As ShadowVolumeNode
 declare Sub _UpdateShadowVolume(byval shad As ShadowVolumeNode)
 declare Sub _ShadowVolumeColor(byval  col as Integer=&h96000000)

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- OCCLUSION Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 declare Sub _AddOcclusionQuery(byval node As EntityNode, byval mesh As Mesh)
 declare Sub _RemoveOcclusionQuery(byval node As EntityNode)
 declare Function _GetOcclusionQueriesResult(byval node As EntityNode) As Integer

' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'- MATH Functions v2.0
' ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' matrix
 declare Sub _Matrix_Add(byval matDest As Any Ptr, byval mat1 As Any Ptr, byval mat2 As Any Ptr) 
 declare Sub _Matrix_Sub(byval matdest As Any Ptr, byval mat1 As Any Ptr, byval mat2 As Any Ptr) 
 declare Sub _Matrix_Mul(byval matdest As Any Ptr, byval mat1 As Any Ptr, byval mat2 As Any Ptr)
 declare Sub _Matrix_Identity(byval matdest As Any Ptr) 
 declare Sub _Matrix_Translation(byval matdest As Any Ptr, byval vect As Any Ptr) 
 declare Sub _Matrix_Rotation(byval matdest As Any Ptr, byval vect As Any Ptr) 
 declare Sub _Matrix_Scale(byval matdest As Any Ptr, byval vect As Any Ptr) 
 declare Sub _Matrix_TransformVect(byval matdest As Any Ptr, byval vectOut As Any Ptr, byval vectIn As Any Ptr) 
 declare Sub _Matrix_Inverse(byval matdest As Any Ptr, byval mat1 As Any Ptr) 
 declare Sub _Matrix_Transposed(byval matdest As Any Ptr, byval mat As Any Ptr) 
' vectors
 declare Sub _Vector_Add(byval dest As Any Ptr, byval vect1 As Any Ptr, byval vect2 As Any Ptr) 
 declare Sub _Vector_Sub(byval dest As Any Ptr, byval vect1 As Any Ptr, byval vect2 As Any Ptr) 
 declare Sub _Vector_Mul(byval dest As Any Ptr, byval vect1 As Any Ptr, byval vect2 As Any Ptr) 
 declare Function _Vector_Length(byval vect As Any Ptr)  As Single
 declare Function _Vector_DotProduct(byval vect As Any Ptr, byval other As Any Ptr)  As Single
 declare Function _Vector_DistanceFrom(byval vect As Any Ptr, byval other As Any Ptr) As single
 declare Sub _Vector_CrossProduct(byval dest As Any Ptr, byval vect1 As Any Ptr,  byval vect2 As Any Ptr) 
 declare Sub _Vector_Normalize(byval dest As Any Ptr, byval vect As Any Ptr) 
 declare Sub _Vector_SetLength(byval dest As Any Ptr, byval vect As Any Ptr, byval length As single=1.0) 
 declare Sub _Vector_Invert(byval dest As Any Ptr, byval vect As Any Ptr)

End Extern


Function _CreateGraphics3D(wwidth As integer, height As Integer, depth As Integer  = 32, fullscreen As UByte = 0, sync As UByte = TRUE, dType As Integer = EDT_DIRECT3D9, DepthBufferFormat As UByte = TRUE) As Any Ptr
 '----------------------------------------------------------
  _InitEngine()		
  Return _CreateScreen(dType, wwidth, height, sync, depth, fullscreen, DepthBufferFormat)
 '----------------------------------------------------------
End Function

Function _Graphics3DGadget(wwidth As Integer, height As Integer, hwnd As Integer, dType As Integer = EDT_DIRECT3D9, vsync As UByte = TRUE) As Any Ptr
    _InitEngine()
    ' open n3xt-D 
    Return _CreateEngineGadget(hwnd, dType, wwidth, height, vsync, True )
End Function
