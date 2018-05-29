'SDL OpenGL Triangles code
'Relsoft 2004
'Rel.Betterwebber.com

'This is the code to draw your first triangle and more
'All new codes are remaked with  'NEW!!!!
'Tips:
'1. Try to pass different values to glTranslatef, glVertex3f and glcolor3f
'2. Also try to change the gluPerspective parameters to see some wacky projection

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

	SDL_WM_SetCaption "Sdl Triangles", ""       'Make caption if windowed

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
'       quit out mainloop and qui the proggie

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
    'clear the screen
    'GL_COLOR_BUFFER_BIT = to black(remember glClearColor?)
    'GL_DEPTH_BUFFER_BIT set depth buffer to 1 (remember glClearDepth?)
    glClear  GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT

    'NEW!!!! Push matrix to the matrix stack so that we start fresh
    glPushMatrix

    'NEW!!!! Reset the matrix to identity
    glLoadIdentity

    'NEW!!!!
    'Move our current position (origin) to (0,0,-10)
    'x = 0
    'y = 0
    'z = -10
    'Remember that GL is Right_handed so negative(-) z values go into the screen
    'or away from you
    glTranslatef 0.0, 0.0, -10.0

    'Draw our geometry

    'NEW!!!!
    'Begin drawing of triangle
    'When GL_TRIANGLES is passed to glBegin it uses 3 vertices to make a triangle
    'Try GL_QUADS and pass 4 points
    'GL_POINT needs 1 vertex
    'Guess what GL_LINES require?

    'NEW!!!!
    'glColor sets the current drawing color to the RGB values
    'Say glColor3f 0,0,1
    'Makes a blue intense color
    '3f means that it needs 3 parameters in "floating" point format(single in FB)

    'NEW!!!!
    'glVertex would define a point having x,y,z coords
    'so glVertex3f 0.0, -1.0, 0.0
    'would move(plot) a vertex from the origin 0 x-units, -1 y-units and 0 z-units
    'BTW, all positions are relative from the last glTranslate call so:
    'this glVertex3f 0.0, -1.0, 0.0 call would plot it's coords at (0,-1,-10)
    ' since we called glTranslate with this coord (0,0,-10)
    glBegin GL_TRIANGLES
                'NEW!!!! Color of first vertex
                glColor3f  1.0, 0.0, 0.0
                'NEW!!!! coords of first vert
                glVertex3f 0.0, -1.0, 0.0

                '2nd vert
                glColor3f  0.0, 1.0, 0.0
                glVertex3f -1.0, 0.0, 0.0

                '3dr vert
                glColor3f  0.0, 0.0, 1.0
                glVertex3f 1.0, 0.0, 0.0
    glEnd  'NEW!!!! End triangle drawing


    'NEW!!!! Restore last matrix used
    glPopMatrix
    'Force completion of drawing
    glFlush
end sub


