'SDL OpenGL Rotations code
'Relsoft 2004
'Rel.Betterwebber.com

'This is the code teaches you how to load vertices from arrays to make objects
'easy to manage
'All new codes are remaked with  'NEW!!!!
'Tips:
'1. Cube's vertices are defined in the DATA statements
'2. I just randomized the color index by using static arrays

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
    RANDOMIZE TIMER
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
'DATA
'*******************************************************************************************
'NEW!!!!!
'The cube is defined in the data statements so that it would be easy to manage
'You only have to use a for loop to draw the model

DATA -1.0, -1.0,  1.0
DATA  1.0, -1.0,  1.0
DATA  1.0,  1.0,  1.0
DATA -1.0,  1.0,  1.0

'Back Face
DATA -1.0, -1.0, -1.0
DATA -1.0,  1.0, -1.0
DATA  1.0,  1.0, -1.0
DATA  1.0, -1.0, -1.0

'Top Face
DATA -1.0,  1.0, -1.0
DATA -1.0,  1.0,  1.0
DATA  1.0,  1.0,  1.0
DATA  1.0,  1.0, -1.0

'Bottom Face
DATA -1.0, -1.0, -1.0
DATA  1.0, -1.0, -1.0
DATA  1.0, -1.0,  1.0
DATA -1.0, -1.0,  1.0

'Right face
DATA  1.0, -1.0, -1.0
DATA  1.0,  1.0, -1.0
DATA  1.0,  1.0,  1.0
DATA  1.0, -1.0,  1.0

'Left Face
DATA -1.0, -1.0, -1.0
DATA -1.0, -1.0,  1.0
DATA -1.0,  1.0,  1.0
DATA -1.0,  1.0, -1.0



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

	SDL_WM_SetCaption "Sdl/GL Rotating smooth cube", ""       'Make caption if windowed

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
    Scalefactor = 1.5


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
    glRotatef theta, 0, 1, 0        'rotate in the y axis (Try to REM this)
    glRotatef theta, 0, 0, 1        'rotate in the z axis (Try to REM this)

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
        'NEW!!!
        'loop counters
        dim i as integer, j as integer

        'NEW!!!
        'variable to check if colors and cube are already initialized
        static color_init

        'NEW!!!
        'initialize color and cube arrays
        if color_init = 0 then                          'is it initialized already?
                                                            'nope so...
            'make static arrays for cube and colors
            '(23, 2) means 23 vertices and 3 elements per vertex
            '3 because:
            'x, y, z for verts
            'r, g, b for colors
            static colors(23, 2) as GLfloat
            static cube(23, 2) as GLfloat

            'put values to each elements by looping
            for i = 0 to 23
                for j = 0 to 2
                    'Color range are from 0 to 1
                    colors(i, j) = rnd          'I'm lazy so I just randomized the colors
                    'read cubes coords from data statements
                    read cube(i,j)
                next i
            next j

            color_init = -1
        end if


        'NEW!!!!
        'Draw the cube
        glBegin GL_QUADS
    		'Draw the cube with smooth colors
   		    for i = 0 to 23
		              glColor3f   colors(i,0), colors(i,1), colors(i,2)
		              glVertex3f  cube(i,0), cube(i,1), cube(i,2)
		    next i
    	glEnd

End Sub



