options indenting = 4

module preview

require daslib/glfw_boost
require daslib/safe_addr
require daslib/static_let
require daslib/opengl_boost

require instructions public
require model_eval
require model
require math

var g_PreviewTexture : array<Material>
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
    var surf = Surface(16,16)
    surf.tex = make_rgba_texture(16,16,gl_array_ptr(cbt))
    return surf

def clear_preview
    delete g_PreviewTexture

var g_PreviewUpdater : function<():void>

def update_preview
    if g_LivePreview
        clear_preview()
        if g_PreviewUpdater != null
            invoke(g_PreviewUpdater)


var [[in, location=0]] v_position : float3
var [[in, location=1]] v_texcoord : float2
var [[uniform]] v_model : float4x4
var [[uniform]] v_view : float4x4
var [[uniform]] v_projection : float4x4
var [[inout]] f_texcoord : float2
var [[out]] f_outputColor : float4
var [[uniform]] f_tex : sampler2D

[vertex_program(name="PREVIEW_VERTEX_SRC",version=330)]
def vs_preview_main
    f_texcoord = v_texcoord
    gl_Position = v_projection * v_view * v_model * float4(v_position.x, v_position.y, v_position.z, 1.0)

[fragment_program(name="PREVIEW_FRAGMENT_SRC",version=330)]
def ps_preview_main
    f_outputColor = texture(f_tex,f_texcoord)

[vertex_buffer]
struct PreviewVertex
    [[type=GL_FLOAT, size=3, normalized=false]] xyz : float3
    [[type=GL_FLOAT, size=2, normalized=false]] uv  : float2
    [[type=GL_FLOAT, size=3, normalized=true]]  normal : float3

def radians(f:float)
    return f * PI / 180.0

def draw_preview ( display_w, display_h : int )
    static_let <|
        var rot_cube = 0.
        var rot_tri = 0.
        var program : uint
        var vao : uint
        var vbo : uint
        var ebo : uint
    if program==0u
        program = create_shader_program(PREVIEW_VERTEX_SRC,PREVIEW_FRAGMENT_SRC)
    if vao==0u
        glGenVertexArrays(1, safe_addr(vao))
        glBindVertexArray(vao)
        glGenBuffers(1, safe_addr(vbo))
        glBindBuffer(GL_ARRAY_BUFFER, vbo)
        glBufferData(GL_ARRAY_BUFFER, vertices, GL_STATIC_DRAW)
    if ebo==0u
        glGenBuffers(1, safe_addr(ebo))
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices, GL_STATIC_DRAW)

    if length(g_PreviewTexture)==0
        g_PreviewTexture |> push([[Material surf=make_checkerboard(),name="Checkerboard",id="nothing",outp="nothing"]])
    static_let <|
        let vertices = [[PreviewVertex
            xyz=float3(-0.5,-0.5, 0.5), uv=float2(0.0, 0.0);
            xyz=float3( 0.5,-0.5, 0.5), uv=float2(1.0, 0.0);
            xyz=float3( 0.5, 0.5, 0.5), uv=float2(1.0, 1.0);
            xyz=float3(-0.5, 0.5, 0.5), uv=float2(0.0, 1.0);

            xyz=float3(-0.5, 0.5,-0.5), uv=float2(0.0, 0.0);
            xyz=float3( 0.5, 0.5,-0.5), uv=float2(1.0, 0.0);
            xyz=float3( 0.5,-0.5,-0.5), uv=float2(1.0, 1.0);
            xyz=float3(-0.5,-0.5,-0.5), uv=float2(0.0, 1.0);

            xyz=float3( 0.5,-0.5, 0.5), uv=float2(0.0, 0.0);
            xyz=float3( 0.5,-0.5,-0.5), uv=float2(1.0, 0.0);
            xyz=float3( 0.5, 0.5,-0.5), uv=float2(1.0, 1.0);
            xyz=float3( 0.5, 0.5, 0.5), uv=float2(0.0, 1.0);

            xyz=float3(-0.5,-0.5,-0.5), uv=float2(0.0, 0.0);
            xyz=float3(-0.5,-0.5, 0.5), uv=float2(1.0, 0.0);
            xyz=float3(-0.5, 0.5, 0.5), uv=float2(1.0, 1.0);
            xyz=float3(-0.5, 0.5,-0.5), uv=float2(0.0, 1.0)
        ]]
        let indices = [[int[] 0;1;2;3; 4;5;6;7; 3;2;5;4; 7;6;1;0; 8;9;10;11; 12;13;14;15 ]]

    rot_cube += 1.0
    if rot_cube > 360.
        rot_cube -= 360.
    rot_tri += 0.5
    if rot_tri > 360.
        rot_tri -= 360.
    let total = length(g_PreviewTexture)
    let sqX = max(1,int(ceil(sqrt(float(total)))))
    let sqY = max(1,(total+sqX-1)/sqX)
    // print("sqX={sqX} sqY={sqY} total={total}\n")
    assert(sqX * sqY >= total)
    let stepX = 2.
    let stepY = 2.
    let halfX = -stepX*float(max(sqX-1,0))*0.5
    let halfY = -stepY*float(max(sqY-1,0))*0.5
    var index = 0
    identity(v_view)
    for y in range(sqY)
        for x in range(sqX)
            let rot1 = un_quat_from_unit_vec_ang(normalize(float3(1.,0.,0.)), radians(rot_tri * 0.25))
            let rot2 = un_quat_from_unit_vec_ang(normalize(float3(0.,1.,0.)), radians(rot_cube))
            let rot = quat_mul(rot1, rot2)
            v_model = compose(
                    float4(float(x)*stepX+halfX, float(y)*stepY+halfY, -2. - float(sqX-1)*2., 0.0),
                    rot,
                    float4(1.0))
            let aspect = display_h>0 ? float(display_w)/float(display_h) : 1.0
            v_projection = perspective_opengl( radians(45.0f), aspect, 0.1f, 100.0f)
            glEnable(GL_DEPTH_TEST)
            glDepthFunc(GL_LEQUAL)
            f_tex.texture2D = g_PreviewTexture[index].surf.tex
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
            glUseProgram(program)
            bind_vertex_buffer(vbo,type<PreviewVertex>)
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
            vs_preview_main_bind_uniform(program)
            ps_preview_main_bind_uniform(program)
            glDrawElements(GL_QUADS, 24, GL_UNSIGNED_INT, null)

            glDisable(GL_TEXTURE_2D)
            glDisable(GL_DEPTH_TEST)
            bind_ffp()

            index ++
            if index==total
                break
