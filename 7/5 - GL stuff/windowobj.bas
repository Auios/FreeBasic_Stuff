type windowObj
    as long id
    as long wdth,hght
    as string title
    
    declare sub init(argc as long, argv as zstring ptr)
    declare sub create(wdth as long, hght as long, title as string)
end type

sub windowObj.init(argc as long, argv as zstring ptr)
    glutInit(argc, argv)
    glutInitDisplayMode(GLUT_RGB OR GLUT_DOUBLE OR GLUT_DEPTH)
end sub

sub windowObj.create(wdth as long, hght as long, title as string)
    this.wdth = wdth
    this.hght = hght
    this.title = title
    glutInitDisplayMode(GLUT_SINGLE)
    glutInitWindowSize(this.wdth, this.hght)
    this.id = glutCreateWindow(this.title)
end sub
