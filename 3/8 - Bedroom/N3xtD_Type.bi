

Type S3DVertex
  x As Single
  y As Single
  z As Single
  nx As Single
  ny As Single
  nz As Single
  ccolor As Integer
  tu As Single
  tv As Single
End Type

Type S3DVertex2TCoords
  x  As Single
  y  As Single
  z  As Single
  nx  As Single
  ny  As Single
  nz  As Single
  ccolor As Integer
  tu1  As Single
  tv1  As Single
  tu2  As Single
  tv2  As Single
End Type

Type S3DVertexTangents
  x  As Single
  y  As Single
  z  As Single
  nx  As Single
  ny  As Single
  nz  As Single
  ccolor As Integer
  tu  As Single
  tv  As Single
  tangx  As Single
  tangy  As Single
  tangz  As Single
  binormx  As Single
  binormy  As Single 
  binormz  As Single   
End Type


Type NewtonHingeSliderUpdateDesc
	m_accel  As Single
	m_minFriction  As Single
	m_maxFriction  As Single
	m_timestep  As Single
End Type



Type Mesh As UINTEGER Ptr

Type AnimatedMesh As UINTEGER Ptr

Type EntityNode As UINTEGER Ptr

Type PivotNode As UINTEGER Ptr
  
Type CameraNode As UINTEGER Ptr
  
Type LightNode As UINTEGER Ptr
  
Type VolumeLightNode As UINTEGER Ptr
  
Type TextNode As UINTEGER Ptr
  
Type ParticleSystemNode As UINTEGER Ptr

Type ParticleEmitter As UINTEGER Ptr
      
Type BillboardNode As UINTEGER Ptr
 
Type TerrainNode As UINTEGER Ptr

Type TerrainSphereNode As UINTEGER Ptr

Type AnimatedNode As UINTEGER Ptr
  
Type BoneNod As UINTEGER Ptr
  
Type ShadowVolumeNode As UINTEGER Ptr
  
Type SpriteSceneNode As UINTEGER Ptr
  
Type Sprite2D As UINTEGER Ptr
  
Type MeshBuffer As UINTEGER Ptr

Type NSceneNodeAnimator As UINTEGER Ptr

Type NNodeAnimator As UINTEGER Ptr

Type NAnimatorCollisionResponse As UINTEGER Ptr

Type BoneNode As UINTEGER Ptr

Type NMaterial As UINTEGER Ptr

Type NTexture As UINTEGER Ptr

Type NImage As UINTEGER Ptr

Type NArray As UINTEGER Ptr

Type NMaterialServices As UINTEGER Ptr

Type NReadFile As UINTEGER Ptr

Type NWriteFile As UINTEGER Ptr

Type NFileList As UINTEGER Ptr

'-----------------------------
' GUI
Type IGUIFont As UINTEGER Ptr

Type IGUIElement As UINTEGER Ptr

    Type IGUICheckBox As UINTEGER Ptr
    
    Type IGUIButton As UINTEGER Ptr
    
    Type IGUIEditBox As UINTEGER Ptr
    
    Type IGUIImage As UINTEGER Ptr
    
    Type IGUIComboBox As UINTEGER Ptr
    
    Type IGUIContextMenu As UINTEGER Ptr
    
    Type IGUIFileOpenDialog As UINTEGER Ptr
    
    Type IGUIInOutFader As UINTEGER Ptr
    
    Type IGUIListBox As UINTEGER Ptr
    
    Type IGUIWindow As UINTEGER Ptr
    
    Type IGUIScrollBar As UINTEGER Ptr
    
    Type IGUISpinBox As UINTEGER Ptr
    
    Type IGUITab As UINTEGER Ptr
    
    Type IGUITabControl As UINTEGER Ptr
    
    Type IGUIStaticText As UINTEGER Ptr
    
    Type IGUITable As UINTEGER Ptr
    
    Type IGUIToolBar  As UINTEGER Ptr
    
    Type IGUIProgressBar As UINTEGER Ptr
  
Type IGUISkin As UINTEGER Ptr

Type CCustomGUISkin As UINTEGER Ptr

Type IGUISpriteBank As UINTEGER Ptr


' physic part
Type NBodySceneNode As UINTEGER Ptr

Type NMaterialPair As UINTEGER Ptr

Type NPMaterial As UINTEGER Ptr

Type NJoint As UINTEGER Ptr

' physic body
Type NBody As UINTEGER Ptr



Type iVECTOR2
  x  As Single
  y  As Single
End Type
Type iVECTOR3
  x  As Single
  y  As Single
  z  As Single
End Type
Type iPLANE
 		' Normal vector of the plane.
		Normal As iVECTOR3
		' Distance from origin.
		D  As Single
End Type
Type iAABBOX
		min As iVECTOR3
		max As iVECTOR3
End Type

'key event
Type SKeyMap
    Action As integer
    KeyCode As Integer
End Type