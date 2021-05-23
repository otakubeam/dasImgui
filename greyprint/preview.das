options indenting = 4
options remove_unused_symbols = false

module preview

require daslib/glfw_boost
require daslib/safe_addr
require daslib/static_let

require instructions

var g_PreviewTexture : uint
var g_PreviewInstruction : Instruction?
var g_PreviewOutput : string
var g_LivePreview = true

def make_rgba_texture(width,height:int; data:void?)
    var texture : uint
    glGenTextures(1, safe_addr(texture))
    glBindTexture(GL_TEXTURE_2D, texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glTexImage2D(GL_TEXTURE_2D, 0, int(GL_RGBA), width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data)
    glBindTexture(GL_TEXTURE_2D, GL_INVALID_VALUE)
    return texture

def make_checkerboard
    var cbt : uint[16][16]
    for y in range(16)
        for x in range(16)
            cbt[y][x] = ((x^y)&1)!=0 ? 0xff404040 : 0xff808080
    return make_rgba_texture(16,16,gl_array_ptr(cbt))

def clear_preview
    g_PreviewInstruction = null
    if g_PreviewTexture != 0u
        glDeleteTextures(1, safe_addr(g_PreviewTexture))
        g_PreviewTexture = 0u

def draw_preview ( display_w, display_h : int )
    static_let <|
        var rot_cube = 0.
        var rot_tri = 0.
        var texture = 0u
    if g_PreviewTexture==0u
        g_PreviewTexture = make_checkerboard()
    static_let <|
        let vertices = [[float[]
            -0.5;  -0.5;  0.5;   0.5; -0.5;  0.5;   0.5;  0.5;  0.5; -0.5;  0.5;  0.5;
            -0.5;   0.5; -0.5;   0.5;  0.5; -0.5;   0.5; -0.5; -0.5; -0.5; -0.5; -0.5;
             0.5;  -0.5;  0.5;   0.5; -0.5; -0.5;   0.5;  0.5; -0.5;  0.5;  0.5;  0.5;
            -0.5;  -0.5; -0.5;  -0.5; -0.5;  0.5;  -0.5;  0.5;  0.5; -0.5;  0.5; -0.5 ]]
        let texcoords = [[float[]   0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0 ]]
        let cubeIndices = [[int[] 0;1;2;3; 4;5;6;7; 3;2;5;4; 7;6;1;0; 8;9;10;11; 12;13;14;15 ]]
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    glShadeModel(GL_SMOOTH)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    let aspect = double(display_w) / double(display_h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0lf, aspect, 0.1lf, 100.0lf)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    glTranslatef(0.0f, 0.0f, -1.6f)
    glRotatef(rot_tri * 0.25,1.0,0.0,0.0)
    glRotatef(rot_cube,0.0,1.0,0.0)
    rot_cube += 1.0
    if rot_cube > 360.
        rot_cube -= 360.
    rot_tri += 0.5
    if rot_tri > 360.
        rot_tri -= 360.
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, g_PreviewTexture)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glColor3f(1.0f, 1.0f, 1.0f)
    glEnableClientState(GL_TEXTURE_COORD_ARRAY)
    glEnableClientState(GL_VERTEX_ARRAY)
    glTexCoordPointer(2, GL_FLOAT, 0, gl_array_ptr(texcoords))
    glVertexPointer(3, GL_FLOAT, 0, gl_array_ptr(vertices))
    glDrawElements(GL_QUADS, 24, GL_UNSIGNED_INT, gl_array_ptr(cubeIndices))
    glDisableClientState(GL_VERTEX_ARRAY)
    glDisable(GL_TEXTURE_2D)
