'SDL OpenGL Rotations code
'Relsoft 2004
'Rel.Betterwebber.com

'This is the code to Rotate, Translate(move) and scale a 3d polyhedron(Cube)
'
'All new codes are remaked with  'NEW!!!!
'Tips:

DEFINT A - Z

const PI = 3.141593                     'PI for rotation
const SCR_WIDTH = 640                   'Width of the screen
const SCR_HEIGHT = 480                  'height of the screen
const BITSPP = 32                       '32 bits per pixel format

option explicit                         'Force declaration

'$include: "\sdl\sdl.bi"                'sdl function and constants declaration
'$include: "\gl\gl.bi"                  'OpenGL funks and consts
'$include: "\gl\glu.bi"                 'GL standard utility lib


'Declarations
DECLARE SUB Init_GL_SDL(SDLscreen as SDL_Surface ptr)
Declare Sub SDL_GetEvents(EscapeVal as Integer)
Declare Sub draw_scene()
Declare Sub Draw_Cube()


'*******************************************************************************************
'Main code
'*******************************************************************************************
	dim vpage as SDL_Surface ptr            'The screen we want to draw to
    dim Finished as integer                 'Quit or not?

    Init_GL_SDL vpage                       'init GL SDL stuff

    Finished = 0                            'set finished to false
	do
	    SDL_GetEvents(Finished)             'handle events
        draw_scene                          'Draw something
		SDL_GL_SwapBuffers                  'Flip to screen
		SDL_PumpEvents                      'force an event queue update(input, etc)
	loop until Finished

	SDL_Quit                                'quit SDL

    end



'*******************************************************************************************
'SUBS/FUNKS
'*******************************************************************************************

'*******************************************************************************************
'Initializes GL+SDL
'Params: SDLscreen pointer to GL/SDL context to draw to
SUB Init_GL_SDL(SDLscreen as SDL_Surface ptr)

    dim Result as unsigned integer      'checker value for SDL initialization
	dim SDL_flags as integer            'Flags for SDL screen

    'OpenGL params for gluerspective
	dim FOVy as double            'Feild of view angle in Y
	dim Aspect as double          'Aspect of screen
	dim znear as double           'z-near clip distance
	dim zfar as double            'z-far clip distance


    'Let's set up our sdl flags variable

    SDL_flags = SDL_HWSURFACE                   'use Hardware surface
    SDL_flags = SDL_flags or SDL_DOUBLEBUF      'doublebuffer to prevent flicker
    SDL_flags = SDL_flags or SDL_OPENGL         'activate OpenGL
    'SDL_flags = SDL_flags or SDL_FULLSCREEN     'FullScreen(REM for windowed)

    'Init everything for SDL(video,audio, key, joy, etc)
	result = SDL_Init(SDL_INIT_EVERYTHING)
	if result <> 0 then                     'error?
  		end 1                               'then quit
	end if

    'Set 640*480*32
    'SCR_WIDTH/HEIGHT/BITSPP are CONSTANTS declared at the main module
	SDLscreen = SDL_SetVideoMode(SCR_WIDTH, SCR_HEIGHT, BITSPP, SDL_flags)
	if SDLscreen = 0 then
		SDL_Quit
		end 1
	end if

	SDL_WM_SetCaption "Sdl/GL Rotating cube", ""       'Make caption if windowed

    'Set OpenGL ViewPort to screen dimensions
	glViewport 0, 0, SCR_WIDTH, SCR_HEIGHT

	'Set current Mode to projection(ie: 3d)
	glMatrixMode GL_PROJECTION

    'Load identity matrix to projection matrix
	glLoadIdentity

    'Set gluPerspective params
    FOVy = 80/2                                     '45 deg fovy
    Aspect = SCR_WIDTH / SCR_HEIGHT                 'aspect = x/y
    znear = 1                                       'Near clip
    zfar = 200                                      'far clip

    'use glu Perspective to set our 3d frustum dimension up
	gluPerspective FOVy, aspect, znear, zfar

    'Modelview mode
    'ie. Matrix that does things to anything we draw
    'as in lines, points, tris, etc.
	glMatrixMode GL_MODELVIEW
	'load identity(clean) matrix to modelview
	glLoadIdentity

	glShadeModel GL_SMOOTH                 'set shading to smooth(try GL_FLAT)
	glClearColor 0.0, 0.0, 0.0, 0.0        'set Clear color to BLACK
	glClearDepth 1.0                       'Set Depth buffer to 1(z-Buffer)
	glEnable GL_DEPTH_TEST                 'Enable Depth Testing so that our z-buffer works

	'compare each incoming pixel z value with the z value present in the depth buffer
	'LEQUAL means than pixel is drawn if the incoming z value is less than
    'or equal to the stored z value
	glDepthFunc GL_LEQUAL

    'have one or more material parameters track the current color
    'Material is your 3d model
	glEnable GL_COLOR_MATERIAL

	'Tell openGL that we want the best possible perspective transform
	glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

END SUB


'*******************************************************************************************
'Check for events from SDL
'Params: Escapeval is a byref integer that allows us to
'       quit out mainloop and quit the proggie

Sub SDL_GetEvents(EscapeVal as Integer)
  'SDL event is type in the SDL inc directory
  dim event as SDL_Event

        'poll events
		while( SDL_PollEvent ( @event ) )
			select case event.type
				case SDL_KEYDOWN:               'if a key is pressed quit proggie
				    EscapeVal = -1
				case SDL_MOUSEBUTTONDOWN:
			end select
		wend
End Sub

'*******************************************************************************************
'Draw to our open GL screen

Sub draw_scene()

    static theta as integer     'Rotation degrees
    dim xtrans   as single      'xtranslation
    dim ytrans   as single      'ytranslation
    dim ztrans   as single      'ztranslation
    dim scalefactor as single   'Scaling factor


    'clear the screen
    'GL_COLOR_BUFFER_BIT = to black(remember glClearColor?)
    'GL_DEPTH_BUFFER_BIT set depth buffer to 1 (remember glClearDepth?)
    glClear  GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT

    'Push matrix to the matrix stack so that we start fresh
    glPushMatrix

    'Reset the matrix to identity
    glLoadIdentity

    'Our translation factor
    'Try to change these arguments
    xtrans = 0.0
    ytrans = 0.0
    ztrans = -10
    glTranslatef xtrans, ytrans, ztrans

    'Our scale factor
    Scalefactor = 1.0


    'glScalef scalefactor, scalefactor, scalefactor
    'Scales our modelview matrix 3x in the x, y, z axes
    'try to change its arguments to different values
    glScalef scalefactor, scalefactor, scalefactor


    'glRotatef angle, x, y, z  rotates your model
    'angle = Specifies the angle of rotation, in degrees
    'x, y, z = Specify the x, y, and z coordinates of a vector
    'So to rotate your 3d object theta degrees in the x axis you would write:
    'we will meke use of some other values for x,y ans z coords in later tutes

    glRotatef theta, 1, 0, 0        'angle, x axis = 1, all other axis are zero
    glRotatef theta, 0, 1, 0        'rotate in the y axis
    glRotatef theta, 0, 0, 1        'rotate in the z axis

    Draw_Cube

    glPopMatrix
    Theta = theta + 1
    'Force completion of drawing
    glFlush
end sub


'*******************************************************************************************
'Draw's our a normalized cube. Taken andmodified from NeHe's tutorials(Im lazy so what? ;*))
'NEW!!!!!!
Sub Draw_Cube()

        'NEW!!!!
        'A call to glBegin GL_QUADS does not mean that you could only draw one quad
        'per glBegin.  To speed up your drawing, it's better to call one glBegin GL_QUADS
        'since it would just draw a quad after every 4 vertex passed.
        'GL_POINTS would draw every one vertex passed, and so on.
        glBegin GL_QUADS
    		' Front Face
    		glColor3f   1.0,  0.0,  0.0      'Color of first quad = RED
    		glVertex3f -1.0, -1.0,  1.0      'the following 4 vertices would make
    		glVertex3f  1.0, -1.0,  1.0      'a quad(4 sided polygon)
    		glVertex3f  1.0,  1.0,  1.0      '
    		glVertex3f -1.0,  1.0,  1.0      '
    		'Back Face
    		glColor3f   0.7,  0.0,  0.5
    		glVertex3f -1.0, -1.0, -1.0
    		glVertex3f -1.0,  1.0, -1.0
    		glVertex3f  1.0,  1.0, -1.0
    		glVertex3f  1.0, -1.0, -1.0
    		'Top Face
    		glColor3f   0.0,  1.0,  0.7
    		glVertex3f -1.0,  1.0, -1.0
    		glVertex3f -1.0,  1.0,  1.0
    		glVertex3f  1.0,  1.0,  1.0
    		glVertex3f  1.0,  1.0, -1.0
    		'Bottom Face
    		glColor3f   0.0,  0.0,  1.0
    		glVertex3f -1.0, -1.0, -1.0
    		glVertex3f  1.0, -1.0, -1.0
    		glVertex3f  1.0, -1.0,  1.0
    		glVertex3f -1.0, -1.0,  1.0
    		'Right face
    		glColor3f   0.0,  1.0,  0.0
    		glVertex3f  1.0, -1.0, -1.0
    		glVertex3f  1.0,  1.0, -1.0
    		glVertex3f  1.0,  1.0,  1.0
    		glVertex3f  1.0, -1.0,  1.0
    		'Left Face
    		glColor3f   0.9,  1.0,  1.0
    		glVertex3f -1.0, -1.0, -1.0
    		glVertex3f -1.0, -1.0,  1.0
    		glVertex3f -1.0,  1.0,  1.0
    		glVertex3f -1.0,  1.0, -1.0
    	glEnd

End Sub



