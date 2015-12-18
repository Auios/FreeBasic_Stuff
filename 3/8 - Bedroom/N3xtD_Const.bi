



'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Rendering Device Types
Enum DEVICE_TYPES 'DEVICE_TYPES
    EDT_NULL = 0            ' a NULL device With no display
    EDT_SOFTWARE            ' Irrlichts Default software renderer
    EDT_SOFTWARE2           ' An improved quality software renderer
    EDT_DIRECT3D8           ' not use, obselet
    EDT_DIRECT3D9           ' hardware accelerated DirectX 9 renderer
    EDT_OPENGL              ' hardware accelerated OpenGL renderer
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' An Enum for all types of automatic culling for built-in scene nodes. 
  #define EAC_OFF  0
  #define EAC_BOX  1
  #define EAC_FRUSTUM_BOX  2
  #define EAC_FRUSTUM_SPHERE   4 ' not used
  #define EAC_OCC_QUERY 8
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
'	shadows type
#define SHADOW_VOLUME_TYPE				 1
#define SHADOW_INDOOR_SOFTSHADOW_TYPE	 2
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
'	shadows filter type
#define EFT_NONE 0
#define EFT_4PCF 1
#define EFT_8PCF 2
#define EFT_12PCF 3
#define EFT_16PCF 4
#define EFT_COUNT 5
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*



'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' BUFFER_TYPE
Enum BUFFER_TYPE
  EBT_NONE = 0
  EBT_VERTEX
  EBT_INDEX
  EBT_VERTEX_AND_INDEX
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Vertex type
Enum VERTEX_TYPE
EVT_STANDART = 0
EVT_2TCOORDS
EVT_TANGENTS
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*



'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MOUSE Type Event
Enum MOUSE_EVENT 'MOUSE_EVENT
    MOUSE_BUTTON_NULL = 0             
    MOUSE_BUTTON_LEFT
    MOUSE_BUTTON_RIGHT
    MOUSE_BUTTON_MIDDLE
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
'Enum For key actions. Used For example in the fps Camera.  
Enum  KEY_ACTION     
EKA_MOVE_FORWARD =0 
EKA_MOVE_BACKWARD   
EKA_STRAFE_LEFT   
EKA_STRAFE_RIGHT  
EKA_JUMP_UP
EKA_CROUCH
EKA_COUNT  
EKA_FORCE_32BIT = &h7fffffff
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enum KEY_CODE ' EKEY_CODE
KEY_LBUTTON          = &h01  ' Left mouse button  
KEY_RBUTTON          = &h02  ' Right mouse button  
KEY_CANCEL           = &h03  ' Control-Break processing  
KEY_MBUTTON          = &h04  ' Middle mouse button (three-button mouse)  
KEY_XBUTTON1         = &h05  ' Windows 2000/XP: X1 mouse button 
KEY_XBUTTON2         = &h06  ' Windows 2000/XP: X2 mouse button 
KEY_BACK             = &h08  ' BACKSPACE key  
KEY_TAB              = &h09  ' TAB key  
KEY_CLEAR            = &h0C  ' CLEAR key  
KEY_RETURN           = &h0D  ' ENTER key  
KEY_SHIFT            = &h10  ' SHIFT key  
KEY_CONTROL          = &h11  ' CTRL key  
KEY_MENU             = &h12  ' ALT key  
KEY_PAUSE            = &h13  ' PAUSE key  
KEY_CAPITAL          = &h14  ' CAPS LOCK key  
KEY_KANA             = &h15  ' IME Kana mode 
KEY_HANGUEL          = &h15  ' IME Hanguel mode (maintained For compatibility use KEY_HANGUL) 
KEY_HANGUL           = &h15  ' IME Hangul mode 
KEY_JUNJA            = &h17  ' IME Junja mode 
KEY_FINAL            = &h18  ' IME final mode 
KEY_HANJA            = &h19  ' IME Hanja mode 
KEY_KANJI            = &h19  ' IME Kanji mode 
KEY_ESCAPE           = &h1B  ' ESC key  
KEY_CONVERT          = &h1C  ' IME convert 
KEY_NONCONVERT       = &h1D  ' IME nonconvert 
KEY_ACCEPT           = &h1E  ' IME accept 
KEY_MODECHANGE       = &h1F  ' IME mode change request 
KEY_SPACE            = &h20  ' SPACEBAR  
KEY_PRIOR            = &h21  ' PAGE UP key  
KEY_NEXT             = &h22  ' PAGE DOWN key  
KEY_END              = &h23  ' End key  
KEY_HOME             = &h24  ' HOME key  
KEY_ARROW_LEFT       = &h25  ' LEFT ARROW key  
KEY_ARROW_UP         = &h26  ' UP ARROW key  
KEY_ARROW_RIGHT      = &h27  ' RIGHT ARROW key  
KEY_ARROW_DOWN       = &h28  ' DOWN ARROW key  
KEY_SELECT           = &h29  ' Select key  
KEY_PRINT            = &h2A  ' PRINT key
KEY_EXECUT           = &h2B  ' EXECUTE key  
KEY_SNAPSHOT         = &h2C  ' PRINT SCREEN key  
KEY_INSERT           = &h2D  ' INS key  
KEY_DELETE           = &h2E  ' DEL key  
KEY_HELP             = &h2F  ' HELP key  
KEY_KEY_0            = &h30  ' 0 key  
KEY_KEY_1            = &h31  ' 1 key  
KEY_KEY_2            = &h32  ' 2 key  
KEY_KEY_3            = &h33  ' 3 key  
KEY_KEY_4            = &h34  ' 4 key  
KEY_KEY_5            = &h35  ' 5 key  
KEY_KEY_6            = &h36  ' 6 key  
KEY_KEY_7            = &h37  ' 7 key  
KEY_KEY_8            = &h38  ' 8 key  
KEY_KEY_9            = &h39  ' 9 key  
KEY_KEY_A            = &h41  ' A key  
KEY_KEY_B            = &h42  ' B key  
KEY_KEY_C            = &h43  ' C key  
KEY_KEY_D            = &h44  ' D key  
KEY_KEY_E            = &h45  ' E key  
KEY_KEY_F            = &h46  ' F key  
KEY_KEY_G            = &h47  ' G key  
KEY_KEY_H            = &h48  ' H key  
KEY_KEY_I            = &h49  ' I key  
KEY_KEY_J            = &h4A  ' J key  
KEY_KEY_K            = &h4B  ' K key  
KEY_KEY_L            = &h4C  ' L key  
KEY_KEY_M            = &h4D  ' M key  
KEY_KEY_N            = &h4E  ' N key  
KEY_KEY_O            = &h4F  ' O key  
KEY_KEY_P            = &h50  ' P key  
KEY_KEY_Q            = &h51  ' Q key  
KEY_KEY_R            = &h52  ' R key  
KEY_KEY_S            = &h53  ' S key  
KEY_KEY_T            = &h54  ' T key  
KEY_KEY_U            = &h55  ' U key  
KEY_KEY_V            = &h56  ' V key  
KEY_KEY_W            = &h57  ' W key  
KEY_KEY_X            = &h58  ' X key  
KEY_KEY_Y            = &h59  ' Y key  
KEY_KEY_Z            = &h5A  ' Z key  
KEY_LWIN             = &h5B  ' Left Windows key (Microsoft® Natural® keyboard)  
KEY_RWIN             = &h5C  ' Right Windows key (Natural keyboard)  
KEY_APPS             = &h5D  ' Applications key (Natural keyboard)  
KEY_SLEEP            = &h5F  ' Computer Sleep key 
KEY_NUMPAD0          = &h60  ' Numeric keypad 0 key  
KEY_NUMPAD1          = &h61  ' Numeric keypad 1 key  
KEY_NUMPAD2          = &h62  ' Numeric keypad 2 key  
KEY_NUMPAD3          = &h63  ' Numeric keypad 3 key  
KEY_NUMPAD4          = &h64  ' Numeric keypad 4 key  
KEY_NUMPAD5          = &h65  ' Numeric keypad 5 key  
KEY_NUMPAD6          = &h66  ' Numeric keypad 6 key  
KEY_NUMPAD7          = &h67  ' Numeric keypad 7 key  
KEY_NUMPAD8          = &h68  ' Numeric keypad 8 key  
KEY_NUMPAD9          = &h69  ' Numeric keypad 9 key  
KEY_MULTIPLY         = &h6A  ' Multiply key  
KEY_ADD              = &h6B  ' Add key  
KEY_SEPARATOR        = &h6C  ' Separator key  
KEY_SUBTRACT         = &h6D  ' Subtract key  
KEY_DECIMAL          = &h6E  ' Decimal key  
KEY_DIVIDE           = &h6F  ' Divide key  
KEY_F1               = &h70  ' F1 key  
KEY_F2               = &h71  ' F2 key  
KEY_F3               = &h72  ' F3 key  
KEY_F4               = &h73  ' F4 key  
KEY_F5               = &h74  ' F5 key  
KEY_F6               = &h75  ' F6 key  
KEY_F7               = &h76  ' F7 key  
KEY_F8               = &h77  ' F8 key  
KEY_F9               = &h78  ' F9 key  
KEY_F10              = &h79  ' F10 key  
KEY_F11              = &h7A  ' F11 key  
KEY_F12              = &h7B  ' F12 key  
KEY_F13              = &h7C  ' F13 key  
KEY_F14              = &h7D  ' F14 key  
KEY_F15              = &h7E  ' F15 key  
KEY_F16              = &h7F  ' F16 key  
KEY_F17              = &h80  ' F17 key  
KEY_F18              = &h81  ' F18 key  
KEY_F19              = &h82  ' F19 key  
KEY_F20              = &h83  ' F20 key  
KEY_F21              = &h84  ' F21 key  
KEY_F22              = &h85  ' F22 key  
KEY_F23              = &h86  ' F23 key  
KEY_F24              = &h87  ' F24 key  
KEY_NUMLOCK          = &h90  ' NUM LOCK key  
KEY_SCROLL           = &h91  ' SCROLL LOCK key  
KEY_LSHIFT           = &hA0  ' Left SHIFT key 
KEY_RSHIFT           = &hA1  ' Right SHIFT key 
KEY_LCONTROL         = &hA2  ' Left CONTROL key 
KEY_RCONTROL         = &hA3  ' Right CONTROL key 
KEY_LMENU            = &hA4  ' Left MENU key 
KEY_RMENU            = &hA5  ' Right MENU key 
KEY_PLUS             = &hBB  ' Plus Key   (+)
KEY_COMMA            = &hBC  ' Comma Key  (,)
KEY_MINUS            = &hBD  ' Minus Key  (-)
KEY_PERIOD           = &hBE  ' Period Key (.)
KEY_ATTN             = &hF6  ' Attn key 
KEY_CRSEL            = &hF7  ' CrSel key 
KEY_EXSEL            = &hF8  ' ExSel key 
KEY_EREOF            = &hF9  ' Erase EOF key 
KEY_PLAY             = &hFA  ' Play key 
KEY_ZOOM             = &hFB  ' Zoom key 
KEY_PA1              = &hFD  ' PA1 key 
KEY_OEM_CLEAR        = &hFE   ' Clear key 

KEY_KEY_CODES_COUNT  = &hFF ' this is Not a key, but the amount of keycodes there are.
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' type of node
#define ESNT_CUBE                 1700951395'('c','u','b','e'),
#define ESNT_SPHERE               1919447155'('s','p','h','r'),
#define ESNT_TEXT                 1954047348'('t','e','x','t'),
#define ESNT_WATER_SURFACE        1920229751'('w','a','t','r'), 
#define ESNT_TERRAIN              1920099700'('t','e','r','r'),
#define ESNT_SKY_BOX              1601792883'('s','k','y','_'),
#define ESNT_SHADOW_VOLUME        2003069043'('s','h','d','w'),
#define ESNT_OCT_TREE             1953784687'('o','c','t','t'),
#define ESNT_MESH                 1752393069'('m','e','s','h'),
#define ESNT_LIGHT                1952999276'('l','g','h','t'),
#define ESNT_EMPTY                2037673317'('e','m','t','y'),
#define ESNT_DUMMY_TRANSFORMATION 2037214564'('d','m','m','y'),
#define ESNT_CAMERA               1601003875'('c','a','m','_'),
#define ESNT_BILLBOARD            1819044194'('b','i','l','l'),
#define ESNT_ANIMATED_MESH        1752395105'('a','m','s','h'),
#define ESNT_PARTICLE_SYSTEM      1818457200'('p','t','c','l'),
#define ESNT_MD3_SCENE_NODE       1597203565'('m','d','3','_'),
#define ESNT_UNKNOWN              1852534389'('u','n','k','n'),
#define ESNT_ANY                  1601793633'('a','n','y','_')
#define ESNT_CONE                 1701736291'('c','o','n','e'),
#define ESNT_CYLINDER             1600944483'('c','y','l','_'),
#define ESNT_CONSTRUCT            1936617315'('c','o','n','s')
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' type picking 
#define ENT_PICKBOX				&h00000000
#define ENT_PICKFACE				&h01
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Hardware Mapping type
Enum HARDMAPPING
EHM_NEVER  = 0   'Don't load in hardware.  
EHM_STATIC       'Rarely changed.  
EHM_DYNAMIC      'Sometimes changed.  
EHM_STREAM       'Always changed.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' 
Enum EJUOR_TYTPE 
EJUOR_NONE = 0  'do nothing  
EJUOR_READ      'get joints positions from the mesh (For attached nodes, etc)  
EJUOR_CONTROL   'control joint positions in the mesh (eg. ragdolls, Or set the animation from animateJoints() )  
EJUOR_COUNT     'count of all available interpolation modes  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' text alignment
Enum TEXT_ALIGN
EGUIA_UPPERLEFT=0  'Aligned To parent's top or left side (default).  
EGUIA_LOWERRIGHT  'Aligned To parent's bottom or right side.  
EGUIA_CENTER  'Aligned To the center of parent.  
EGUIA_SCALE  'Stretched To fit parent.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' 
Enum MOUSE_BUTTON
EGBS_BUTTON_UP=0  'The button is Not pressed.  
EGBS_BUTTON_DOWN  'The button is currently pressed down.  
EGBS_BUTTON_MOUSE_OVER  'The mouse cursor is over the button.  
EGBS_BUTTON_MOUSE_OFF  'The mouse cursor is Not over the button.  
EGBS_BUTTON_FOCUSED  'The button has the focus.  
EGBS_BUTTON_NOT_FOCUSED  'The button doesn't have the focus.  
EGBS_COUNT  'Not used, counts the number of enumerated items  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' type of node object
#define ENT_CUBE                 &h01
#define ENT_SPHERE               &h02
#define ENT_TEXT                 &h03
#define ENT_CONE                 &h04
#define ENT_CYLINDER             &h05
#define ENT_WATER_SURFACE        &h07
#define ENT_MESH                 &h08
#define ENT_EMPTY                &h09
#define ENT_BILLBOARD            &h0A
#define ENT_PARTICLE_SYSTEM      &h0B
#define ENT_MD3_SCENE_NODE       &h0F
#define ENT_TERRAIN              &h10
#define ENT_SKY_BOX              &h20
#define ENT_SHADOW_VOLUME        &h30
#define ENT_OCT_TREE             &h50
#define ENT_LIGHT                &h60
#define ENT_CAMERA               &h70
#define ENT_ANIMATED_MESH        &h80
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' debug mode type
#define DEBUG_OFF                 0 'No Debug Data ( Default )<br>  
#define DEBUG_BBOX                1 'Show Bounding Boxes of SceneNode<br>  
#define DEBUG_NORMALS             2 'Show Vertex Normals<br>  
#define DEBUG_SKELETON            4 'Shows Skeleton/Tags<br>  
#define DEBUG_MESH_WIRE_OVERLAY   8 'Overlays Mesh Wireframe<br>  
#define DEBUG_HALF_TRANSPARENCY   16'Temporary use transparency Material Type<br>  
#define DEBUG_BBOX_BUFFERS        32'Show Bounding Boxes of all MeshBuffers<br>
#define DEBUG_BBOX_ALL            33'EDS_BBOX | EDS_BBOX_BUFFERS<br>  
#define DEBUG_FULL                &hffffffff' Show all Debug infos.  
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MATERIAL flag
#define EMF_WIREFRAME             1
#define EMF_POINTCLOUD            2 
#define EMF_GOURAUD_SHADING       4
#define EMF_LIGHTING              8
#define EMF_ZBUFFER               &h10
#define EMF_ZWRITE_ENABLE         &h20
#define EMF_BACK_FACE_CULLING     &h40
#define EMF_FRONT_FACE_CULLING    &h80
#define EMF_BILINEAR_FILTER       &h100
#define EMF_TRILINEAR_FILTER      &h200
#define EMF_ANISOTROPIC_FILTER    &h400
#define EMF_FOG_ENABLE            &h800
#define EMF_NORMALIZE_NORMALS     &h1000
#define EMF_TEXTURE_WRAP          &h2000
#define EMF_ANTI_ALIASING         &h4000
#define EMF_COLOR_MASK            &h8000
#define EMF_COLOR_MATERIAL        &h10000
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' fog type
Enum FOG_TYPE
EFT_FOG_EXP   = 0
EFT_FOG_LINEAR   
EFT_FOG_EXP2   
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' TEXTURE CLAMP
#define ETC_REPEAT  0
#define ETC_CLAMP 1
#define ETC_CLAMP_TO_EDGE 2
#define ETC_CLAMP_TO_BORDER 3
#define ETC_MIRROR 4
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MATERIAL TYPES
#define EMT_SOLID                                  0
#define EMT_SOLID_2_LAYER                          1
#define EMT_LIGHTMAP                               2
#define EMT_LIGHTMAP_ADD                           3
#define EMT_LIGHTMAP_M2                            4
#define EMT_LIGHTMAP_M4                            5
#define EMT_LIGHTMAP_LIGHTING                      6
#define EMT_LIGHTMAP_LIGHTING_M2                   7
#define EMT_LIGHTMAP_LIGHTING_M4                   8
#define EMT_DETAIL_MAP                             9
#define EMT_SPHERE_MAP                             10
#define EMT_REFLECTION_2_LAYER                     11
#define EMT_TRANSPARENT_ADD_COLOR                  12
#define EMT_TRANSPARENT_ALPHA_CHANNEL              13
#define EMT_TRANSPARENT_ALPHA_CHANNEL_REF          14
#define EMT_TRANSPARENT_VERTEX_ALPHA               15
#define EMT_TRANSPARENT_REFLECTION_2_LAYER         16
#define EMT_NORMAL_MAP_SOLID                       17
#define EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR       18
#define EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA    19
#define EMT_PARALLAX_MAP_SOLID                     20
#define EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR     21
#define EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA  22
#define EMT_ONETEXTURE_BLEND                       23
#define EMT_FORCE_32BIT                            &h7fffffff
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MATERIAL COLOR TYPES
#define ECM_NONE  0
#define ECM_DIFFUSE  1
#define ECM_AMBIENT  2
#define ECM_EMISSIVE  3
#define ECM_SPECULAR  4
#define ECM_DIFFUSE_AND_AMBIENT  5
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MATERIAL COLOR MASK TYPES
#define ECP_NONE 0
#define ECP_ALPHA 1
#define ECP_RED 2
#define ECP_GREEN 4
#define ECP_BLUE 8
#define ECP_RGB 14
#define ECP_ALL 15
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' light types
#define ELT_POINT         0 
#define ELT_SPOT          1 
#define ELT_DIRECTIONAL   2 
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' light types
#define ECF_A1R5G5B5  0
#define ECF_R5G6B5    1
#define ECF_R8G8B8    2
#define ECF_A8R8G8B8  3
#define ECF_R16F  4
#define ECF_G16R16F  5
#define ECF_A16B16G16R16F  6
#define ECF_R32F  7
#define ECF_G32R32F  8
#define ECF_A32B32G32R32F  9
#define ECF_UNKNOWN  10
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
'Compiletarget for Pixel-Shader
Enum PIXELSHADER_VERSION
EPST_PS_1_1  = 0 
EPST_PS_1_2   
EPST_PS_1_3   
EPST_PS_1_4   
EPST_PS_2_0   
EPST_PS_2_a   
EPST_PS_2_b   
EPST_PS_3_0  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
'Compiletarget for Vertex-Shader
Enum VERTEXSHADER_VERSION
EVST_VS_1_1  = 0 
EVST_VS_2_0   
EVST_VS_2_a   
EVST_VS_3_0  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enum MATRIX_TYPE
ETS_VIEW  =0   'View transformation.  
ETS_WORLD      'World transformation.  
ETS_PROJECTION 'Projection transformation.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enum APP_FLAG
EGDC_3D_DARK_SHADOW=0  'Dark shadow For three-dimensional display elements.  
EGDC_3D_SHADOW  'Shadow color For three-dimensional display elements (For edges facing away from the light source).  
EGDC_3D_FACE  'Face color For three-dimensional display elements And For dialog box backgrounds.  
EGDC_3D_HIGH_LIGHT  'Highlight color For three-dimensional display elements (For edges facing the light source.).  
EGDC_3D_LIGHT  'Light color For three-dimensional display elements (For edges facing the light source.).  
EGDC_ACTIVE_BORDER  'Active window border.  
EGDC_ACTIVE_CAPTION  'Active window title bar text.  
EGDC_APP_WORKSPACE  'Background color of multiple document Interface (MDI) applications.  
EGDC_BUTTON_TEXT  'Text on a button.  
EGDC_GRAY_TEXT  'Grayed (disabled) text.  
EGDC_HIGH_LIGHT  'tem(s) selected in a control.  
EGDC_HIGH_LIGHT_TEXT  'Text of item(s) selected in a control.  
EGDC_INACTIVE_BORDER  'Inactive window border.  
EGDC_INACTIVE_CAPTION  'Inactive window caption.  
EGDC_TOOLTIP  'Tool tip text color.  
EGDC_TOOLTIP_BACKGROUND  'Tool tip background color.  
EGDC_SCROLLBAR  'Scrollbar gray area.  
EGDC_WINDOW  'Window background.  
EGDC_WINDOW_SYMBOL  'Window symbols like on close buttons, scroll bars And check boxes.  
EGDC_ICON  'Icons in a list Or tree.  
EGDC_ICON_HIGH_LIGHT  'Selected icons in a list Or tree.  
EGDC_COUNT  'this value is Not used, it only specifies the amount of Default colors available.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' type of FONT
Enum FONT_TYPE
EGDF_DEFAULT=0  'For Static text, edit boxes, lists And most other places.  
EGDF_BUTTON  'Font For buttons.  
EGDF_WINDOW  'Font For window title bars.  
EGDF_MENU  'Font For menu items.  
EGDF_TOOLTIP  'Font For tooltips.  
EGDF_COUNT  'this value is Not used, it only specifies the amount of Default fonts available.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*




'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' type of GUI
Enum GUI_TYPE
EGUIET_BUTTON =0     ' A button (IGUIButton).  
EGUIET_CHECK_BOX     'A check Box (IGUICheckBox).  
EGUIET_COMBO_BOX     'A combo Box (IGUIComboBox).  
EGUIET_CONTEXT_MENU  'A context menu (IGUIContextMenu).  
EGUIET_MENU          ' A menu (IGUIMenu).  
EGUIET_EDIT_BOX      'An edit Box (IGUIEditBox).  
EGUIET_FILE_OPEN_DIALOG  'A file open dialog (IGUIFileOpenDialog).  
EGUIET_COLOR_SELECT_DIALOG  'A color Select open dialog (IGUIColorSelectDialog).  
EGUIET_IN_OUT_FADER  'A in/out fader (IGUIInOutFader).  
EGUIET_IMAGE         'An image (IGUIImage).  
EGUIET_LIST_BOX      'A List Box (IGUIListBox).  
EGUIET_MESH_VIEWER   'A mesh viewer (IGUIMeshViewer).  
EGUIET_MESSAGE_BOX   'A message Box (IGUIWindow).  
EGUIET_MODAL_SCREEN  'A modal screen.  
EGUIET_SCROLL_BAR    'A scroll bar (IGUIScrollBar).  
EGUIET_SPIN_BOX      'A spin Box (IGUISpinBox).  
EGUIET_STATIC_TEXT   'A Static text (IGUIStaticText).  
EGUIET_TAB           'A tab (IGUITab).  
EGUIET_TAB_CONTROL   'A tab control.  
EGUIET_TABLE         'A Table.  
EGUIET_TOOL_BAR      'A tool bar (IGUIToolBar).  
EGUIET_TREE_VIEW     'A Tree View.  
EGUIET_WINDOW        'A window.  
EGUIET_COUNT         'Not an element, amount of elements in there.  
EGUIET_ELEMENT       'Unknown type.  
EGUIET_FORCE_32_BIT  'This enum is never used, it only forces the compiler To compile this Enum To 32 bit.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enum BUTTON_FLAG
EGEIT_BUTTON_PANE_STANDARD = 0
EGEIT_BUTTON_PANE_PRESSED
EGEIT_SUNKEN_PANE_FLAT
EGEIT_SUNKEN_PANE_SUNKEN
EGEIT_WINDOW_BACKGROUND
EGEIT_WINDOW_BACKGROUND_TITLEBAR
EGEIT_MENU_PANE
EGEIT_TOOLBAR
EGEIT_TAB_BUTTON
EGEIT_TAB_BODY
EGEIT_COUNT
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enum GUI_EVENT_TYPE 'enum EGUI_EVENT_TYPE
EGET_ELEMENT_FOCUS_LOST = 0  '0 A gui element has lost its focus. GUIEvent.Caller is losing the focus To GUIEvent.Element. If the event is absorbed then the focus will Not be changed. 
EGET_ELEMENT_FOCUSED  '1 A gui element has got the focus.If the event is absorbed then the focus will Not be changed. 
EGET_ELEMENT_HOVERED  '2 The mouse cursor hovered over a gui element.  
EGET_ELEMENT_LEFT      '3 The mouse cursor left the hovered element.  
EGET_ELEMENT_CLOSED      '4 An element would like To close. Windows And context menus use This event when they would like To close, This can be cancelled by absorbing the event. 

EGET_BUTTON_CLICKED    '5 A button was clicked.  
EGET_SCROLL_BAR_CHANGED  '6 A scrollbar has changed its position.  
EGET_CHECKBOX_CHANGED    '7 A checkbox has changed its check state.  
EGET_LISTBOX_CHANGED     '8 A new item in a listbox was seleted.  
EGET_LISTBOX_SELECTED_AGAIN '9 An item in the listbox was selected, which was already selected.  
EGET_DIRECTORY_SELECTED   ' 10 directory has been selected in the file dialog.  
EGET_FILE_SELECTED       '11 A file has been selected in the file dialog.  
EGET_FILE_CHOOSE_DIALOG_CANCELLED  '12 A file open dialog has been closed without choosing a file.  
EGET_MESSAGEBOX_YES        '13 'Yes' was clicked on a messagebox  
EGET_MESSAGEBOX_NO         '14 'No' was clicked on a messagebox  
EGET_MESSAGEBOX_OK         '15 'OK' was clicked on a messagebox  
EGET_MESSAGEBOX_CANCEL     '16 'Cancel' was clicked on a messagebox  
EGET_EDITBOX_ENTER         '17 In an editbox was pressed 'ENTER'.  
EGET_EDITBOX_CHANGED         ' 18
EGET_EDITBOX_MARKING_CHANGED ' 19
EGET_TAB_CHANGED           '20 The tab was changed in an tab control.  
EGET_MENU_ITEM_SELECTED    '21 A menu item was selected in a (context) menu.  
EGET_COMBO_BOX_CHANGED     '22 The selection in a combo box has been changed.  
EGET_SPINBOX_CHANGED       '23 The value of a spin box has changed.  
EGET_TABLE_CHANGED         '24 A table has changed.  
EGET_TABLE_HEADER_CHANGED  '25   
EGET_TABLE_SELECTED_AGAIN  '26
EGET_TREEVIEW_NODE_DESELECT'27 A tree view node lost selection. See IGUITreeView::getLastEventNode().  
EGET_TREEVIEW_NODE_SELECT  '28 A tree view node was selected. See IGUITreeView::getLastEventNode().  
EGET_TREEVIEW_NODE_EXPAND  '29 A tree view node was expanded. See IGUITreeView::getLastEventNode().  
EGET_TREEVIEW_NODE_COLLAPS '30 A tree view node was collapsed. See IGUITreeView::getLastEventNode().  
EGET_COUNT 

End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Enum for listbox colors. 
Enum LISTBOX_AD
EGUI_LBC_TEXT=0  'Color of text.  
EGUI_LBC_TEXT_HIGHLIGHT  'Color of selected text.  
EGUI_LBC_ICON  'Color of icon.  
EGUI_LBC_ICON_HIGHLIGHT  'Color of selected icon.  
EGUI_LBC_COUNT  'Not used, just counts the number of available colors.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' for messagebox flag.  
#define EMBF_OK  1 'Flag For the ok button.  
#define EMBF_CANCEL 2  'Flag For the cancel button.  
#define EMBF_YES 4 'Flag For the yes button.  
#define EMBF_NO 8 'Flag For the no button.  
#define EMBF_FORCE_32BIT &h7fffffff  'This value is Not used. It only forces This Enum To compile in 32 bit.  
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Enum . 
Enum BOX_ORDER
EGOM_NONE  = 0 'No element ordering.  
EGOM_ASCENDING  'Elements are ordered from the smallest To the largest.  
EGOM_DESCENDING  'Elements are ordered from the largest To the smallest.  
EGOM_COUNT  'This value is Not used, it only specifies the amount of Default ordering types available.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Enum   EGUI_COLUMN_ORDERING 
Enum GUI_COLUMN_ORDERING
EGCO_NONE = 0 'Do Not use ordering.  
EGCO_CUSTOM  'Send a EGET_TABLE_HEADER_CHANGED message when a column header is clicked.  
EGCO_ASCENDING  'Sort it ascending by it's ascii value like: a,b,c,...  
EGCO_DESCENDING  'Sort it descending by it's ascii value like: z,x,y,...  
EGCO_FLIP_ASCENDING_DESCENDING  'Sort it ascending on first click, descending on Next, etc.  
EGCO_COUNT  'Not used As mode, only To get maximum value For this enum.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' EGUI_TABLE_DRAW_FLAGS, which influence the layout. 
#define EGTDF_ROWS   1 
#define EGTDF_COLUMNS   2 
#define EGTDF_ACTIVE_ROW  4  
#define EGTDF_COUNT   0
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' MD2 Animation sequences
Enum MD2_ANIM_SEQUENCES 'IRR_MD2_ANIM_SEQUENCES
EMAT_STAND = 0
EMAT_RUN
EMAT_ATTACK
EMAT_PAIN_A
EMAT_PAIN_B
EMAT_PAIN_C
EMAT_JUMP
EMAT_FLIP
EMAT_SALUTE
EMAT_FALLBACK
EMAT_WAVE
EMAT_POINT
EMAT_CROUCH_STAND
EMAT_CROUCH_WALK
EMAT_CROUCH_ATTACK
EMAT_CROUCH_PAIN
EMAT_CROUCH_DEATH
EMAT_DEATH_FALLBACK
EMAT_DEATH_FALLFORWARD
EMAT_DEATH_FALLBACKSLOW
EMAT_BOOM
EMAT_COUNT  'Not an animation, but amount of animation types.  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Particle definitions
#define NO_EMITTER      0
#define DEFAULT_EMITTER 1
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' GUI Interface definitions
#define GUI_NO_BORDER   0
#define GUI_BORDER      1
#define GUI_NO_WRAP     0
#define GUI_WRAP        1
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Type of emitter particles
Enum EMITTER_PARTICLE
EPET_POINT   = 0 
EPET_ANIMATED_MESH   
EPET_BOX   
EPET_CYLINDER   
EPET_MESH   
EPET_RING   
EPET_SPHERE   
EPET_COUNT  
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' 
#define ETCF_ALWAYS_16_BIT   1
#define ETCF_ALWAYS_32_BIT   2
#define ETCF_OPTIMIZED_FOR_QUALITY  4
#define ETCF_OPTIMIZED_FOR_SPEED    8
#define ETCF_CREATE_MIP_MAPS  16
#define ETCF_NO_ALPHA_CHANNEL  32
#define ETCF_ALLOW_NON_POWER_2  64 'Allow the Driver To use Non-Power-2-Textures. 
#define ETCF_FORCE_32_BIT_DO_NOT_USE  &h7ffffff
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Enum for querying features of the video driver. 
Enum VIDEO_FEATURES
EVDF_RENDER_TO_TARGET = 0  'Is driver able To render To a surface?  
EVDF_HARDWARE_TL           'Is hardeware transform And lighting supported?  
EVDF_MULTITEXTURE          'Are multiple textures per material possible?  
EVDF_BILINEAR_FILTER       'Is driver able To render With a bilinear filter applied?  
EVDF_MIP_MAP               'Can the driver handle mip maps?  
EVDF_MIP_MAP_AUTO_UPDATE   'Can the driver update mip maps automatically?  
EVDF_STENCIL_BUFFER        'Are stencilbuffers switched on And does the device support stencil buffers?  
EVDF_VERTEX_SHADER_1_1     'Is Vertex Shader 1.1 supported?  
EVDF_VERTEX_SHADER_2_0     'Is Vertex Shader 2.0 supported?  
EVDF_VERTEX_SHADER_3_0     'Is Vertex Shader 3.0 supported?  
EVDF_PIXEL_SHADER_1_1      'Is Pixel Shader 1.1 supported?  
EVDF_PIXEL_SHADER_1_2      'Is Pixel Shader 1.2 supported?  
EVDF_PIXEL_SHADER_1_3      'Is Pixel Shader 1.3 supported?  
EVDF_PIXEL_SHADER_1_4      'Is Pixel Shader 1.4 supported?  
EVDF_PIXEL_SHADER_2_0      'Is Pixel Shader 2.0 supported?  
EVDF_PIXEL_SHADER_3_0      'Is Pixel Shader 3.0 supported?  
EVDF_ARB_VERTEX_PROGRAM_1  'Are ARB vertex programs v1.0 supported?  
EVDF_ARB_FRAGMENT_PROGRAM_1'Are ARB fragment programs v1.0 supported?  
EVDF_ARB_GLSL            'Is GLSL supported?  
EVDF_HLSL                'Is HLSL supported?  
EVDF_TEXTURE_NSQUARE     'Are non-square textures supported?  
EVDF_TEXTURE_NPOT        'Are non-power-of-two textures supported?  
EVDF_FRAMEBUFFER_OBJECT  'Are framebuffer objects supported?  
EVDF_VERTEX_BUFFER_OBJECT'Are vertex buffer objects supported?  
EVDF_ALPHA_TO_COVERAGE   'Supports Alpha To Coverage.  
EVDF_COLOR_MASK          'Supports Color masks (disabling color planes in output).  
EVDF_COUNT               'Only used For counting the elements of this enum. 
End Enum 
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' collide and physic
#define BOX_PRIMITIVE				1
#define CONE_PRIMITIVE				2
#define SPHERE_PRIMITIVE			3
#define CYLINDER_PRIMITIVE			4
#define CAPSULE_PRIMITIVE			5
#define CHAMFER_CYLINDER_PRIMITIVE	6
#define HULL_PRIMITIVE				7
#define HULL_PRIMITIVE_SURFACE  8
#define COMPLEX_PRIMITIVE_SURFACE  9
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' collide terrain type
#define HEIGHTFIELD_METHOD			0
#define VERTICES_METHOD				1
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' E_EFFECT_TYPE
Enum EFFECT_TYPE
EET_ANISO = 0
EET_MRWIGGLE
EET_GOOCH
EET_PHONG
EET_BRDF
EET_COUNT
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' '	shadows mode
Enum SHADOW_MODE
ESM_RECEIVE = 0
ESM_CAST
ESM_BOTH
ESM_EXCLUDE
ESM_COUNT
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' response type with collide node
Enum COLLIDE_RESPONSE
RESP_NONE=0
RESP_STOP
RESP_SLIDE
RESP_SLIDEXZ
RESP_SLIDEYZ
RESP_SLIDEXY
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' Axis joystick
Enum JOY_AXIS
AXIS_X = 0' e.g. analog stick 1 left To right
AXIS_Y		 ' e.g. analog stick 1 top To bottom
AXIS_Z		 ' e.g. throttle, Or analog 2 stick 2 left To right
AXIS_R		 ' e.g. rudder, Or analog 2 stick 2 top To bottom
AXIS_U
AXIS_V
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*



'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
Enum PARTICLE_FLAG1
PARAM_RED  =0        'The red component of the Particle 
PARAM_GREEN          'The green component of the Particle 
PARAM_BLUE           'The blue component of the Particle 
PARAM_ALPHA          'The alpha component of the Particle 
PARAM_SIZE           'The size of the Particle 
PARAM_MASS           'The mass of the Particle 
PARAM_ANGLE          'The angle of the texture of the Particle 
PARAM_TEXTURE_INDEX  'the index of texture of the Particle 
PARAM_ROTATION_SPEED 'the rotation speed of the particle (must be used With a rotator modifier) 
PARAM_CUSTOM_0       'Reserved For a user custom parameter. This is Not used by SPARK 
PARAM_CUSTOM_1       'Reserved For a user custom parameter. This is Not used by SPARK 
PARAM_CUSTOM_2       'Reserved For a user custom parameter. This is Not used by SPARK 
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
#define FLAG_NONE 0                'the flag bit For no parameter 
#define FLAG_RED  %1             'the flag bit For PARAM_RED 
#define FLAG_GREEN %10           'the flag bit For PARAM_GREEN 
#define FLAG_BLUE  %100            'the flag bit For PARAM_BLUE 
#define FLAG_ALPHA %1000          'the flag bit For PARAM_ALPHA 
#define FLAG_SIZE  %10000          'the flag bit For PARAM_SIZE 
#define FLAG_MASS  %100000          'the flag bit For PARAM_MASS 
#define FLAG_ANGLE %1000000          'the flag bit For PARAM_ANGLE 
#define FLAG_TEXTURE_INDEX %10000000  'the flag bit For PARAM_TEXTURE_INDEX 
#define FLAG_ROTATION_SPEED %100000000  'the flag bit For PARAM_ROTATION_SPEED 
#define FLAG_CUSTOM_0      %1000000000  'the flag bit For PARAM_CUSTOM_0 
#define FLAG_CUSTOM_1      %10000000000  'the flag bit For PARAM_CUSTOM_1 
#define FLAG_CUSTOM_2      %100000000000  'the flag bit For PARAM_CUSTOM_2 
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
#define ALWAYS %1            'No trigger, a Particle is always modified 
#define INSIDE_ZONE %10      'Trigger defining a Particle inside the Zone 
#define OUTSIDE_ZONE %100    'Trigger defining a Particle outside the Zone 
#define INTERSECT_ZONE %1000 'Trigger defining a Particle intersecting the Zone (in any direction) 
#define ENTER_ZONE %10000    'Trigger defining a Particle entering the Zone 
#define EXIT_ZONE %100000    'Trigger defining a Particle exiting the Zone 
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
Enum PARTICLE_FLAG2
BLENDING_NONE=0  'No blending is applied. The particles will appeared As opaque 
BLENDING_ADD=1  'The additive blending is useful To render particles that supposed To emit light (fire, magic spells...) 
BLENDING_ALPHA=2  'The alpha blending is useful To render transparent particles 
End Enum
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
#define ALPHA_TEST 1  'The alpha test. Enabling it is useful when rendering fully opaque particles With fully transparent zones (a texture of ball For instance) 
#define DEPTH_TEST 2  'The depth test. Disabling it is useful when rendering particles With additive blending without having To sort them. Note that disabling the depth test will disable the depth write As well. 
#define DEPTH_WRITE 4  'The depth write. Disabling it is useful when rendering particles With additive blending without having To sort them. Particles are still culled With the Zbuffer (when behind a wall For instance) 
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' particle Flag
#define TEXTURE_NONE 0
#define TEXTURE_2D 1
#define TEXTURE_3D 2
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  


'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  
' Flag for EMT_ONETEXTURE_BLEND, ( BlendFactor ) BlendFunc = source * sourceFactor + dest * destFactor
#define EBF_ZERO	 0		            '//!< src & dest	(0, 0, 0, 0)
#define EBF_ONE 1			            '//!< src & dest	(1, 1, 1, 1)
#define EBF_DST_COLOR 2 			      '//!< src	(destR, destG, destB, destA)
#define EBF_ONE_MINUS_DST_COLOR 3 	'//!< src	(1-destR, 1-destG, 1-destB, 1-destA)
#define EBF_SRC_COLOR 4			      '//!< dest	(srcR, srcG, srcB, srcA)
#define EBF_ONE_MINUS_SRC_COLOR 5 	'//!< dest	(1-srcR, 1-srcG, 1-srcB, 1-srcA)
#define EBF_SRC_ALPHA 6			      '//!< src & dest	(srcA, srcA, srcA, srcA)
#define EBF_ONE_MINUS_SRC_ALPHA 7	'//!< src & dest	(1-srcA, 1-srcA, 1-srcA, 1-srcA)
#define EBF_DST_ALPHA 8			      '//!< src & dest	(destA, destA, destA, destA)
#define EBF_ONE_MINUS_DST_ALPHA 9	'//!< src & dest	(1-destA, 1-destA, 1-destA, 1-destA)
#define EBF_SRC_ALPHA_SATURATE 10	'//!< src	(min(srcA, 1-destA), idem, ...)
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  
'	//! MaterialTypeParam: e.g. DirectX: D3DTOP_MODULATE, D3DTOP_MODULATE2X, D3DTOP_MODULATE4X
#define EMFN_MODULATE_1X	 1
#define EMFN_MODULATE_2X	 2
#define EMFN_MODULATE_4X	 4
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  
'	 Source of the alpha value To take
' This is currently only supported in EMT_ONETEXTURE_BLEND. You can use an
'	Or'ed combination of values. Alpha values are modulated (multiplicated). */
'	enum E_ALPHA_SOURCE
#define EAS_NONE 0         '//! Use no alpha, somewhat redundant With other settings
#define EAS_VERTEX_COLOR 1 '//! Use vertex color alpha
#define EAS_TEXTURE 2      '//! Use texture alpha channel
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' terrain Quality
#define TQ_LOW 4
#define TQ_MEDIUM 2
#define TQ_HIGHT 1
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
' terrain teraforming
#define TH_UP 0
#define TH_ABSOLUTE 1
#define TH_DOWN 2
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*  

'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 
'E_TERRAIN_PATCH_SIZE
';//! patch size of 9, at most, use 4 levels of detail With this patch size.
#define ETPS_9  9
'		//! patch size of 17, at most, use 5 levels of detail With this patch size.
#define ETPS_17  17
'		//! patch size of 33, at most, use 6 levels of detail With this patch size.
#define ETPS_33  33
'		//! patch size of 65, at most, use 7 levels of detail With this patch size.
#define ETPS_65  65
'		//! patch size of 129, at most, use 8 levels of detail With this patch size.
#define ETPS_129  129
'*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 


#define RT_QUATERNION 1

#Define NULL 0
#Define TRUE 1
#Define FALSE 0
 