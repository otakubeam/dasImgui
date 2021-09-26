options indenting = 4

module preview private

require daslib/glfw_boost
require daslib/safe_addr
require daslib/static_let
require daslib/opengl_boost
require daslib/opengl_ttf

require instructions public
require model_eval
require model
require math
require strings

var public g_PreviewTexture : array<Material>
var public g_LivePreview = true
var public g_PreviewLabels = true

def make_rgba_texture(width,height:int; data:void?)
    var texture : uint
    glGenTextures(1, safe_addr(texture))
    glBindTexture(GL_TEXTURE_2D, texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
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

def public clear_preview
    delete g_PreviewTexture

var public g_PreviewUpdater : function<():void>

def public update_preview
    if g_LivePreview
        clear_preview()
        if g_PreviewUpdater != null
            invoke(g_PreviewUpdater)


var [[in, location=0]] v_position : float3
var [[in, location=1]] v_normal   : float3
var [[in, location=2]] v_texcoord : float2
var [[uniform]] v_model : float4x4
var [[uniform]] v_view : float4x4
var [[uniform]] v_projection : float4x4
var [[inout]] f_texcoord : float2
var [[inout]] f_normal : float3
var [[inout]] f_position : float3
var [[out]] f_outputColor : float4
var [[uniform, binding=0]] f_tex : sampler2D
var [[uniform, binding=1]] f_spec : sampler2D
var [[uniform, binding=2]] f_norm : sampler2D
var [[uniform]] f_kD : float
var [[uniform]] f_kS : float
var [[uniform]] f_pS : float

[vertex_program(name="PREVIEW_VERTEX_SRC",version=330)]
def vs_preview_main
    f_texcoord = v_texcoord
    gl_Position = v_projection * v_view * v_model * float4(v_position.x, v_position.y, v_position.z, 1.0)

[fragment_program(name="PREVIEW_FRAGMENT_SRC",version=330)]
def ps_preview_main
    f_outputColor = texture(f_tex,f_texcoord)

[vertex_program(name="PBR_VERTEX_SRC",version=330)]
def vs_preview_pbr
    f_texcoord = v_texcoord
    f_normal = normalize ( float3x3(v_model) * v_normal )
    let tpos = v_model * float4(v_position.x, v_position.y, v_position.z, 1.0)
    f_position = tpos.xyz
    gl_Position = v_projection * v_view * tpos

def get_normal
    let dp1  = dFdx(f_position)
    let dp2  = dFdy(f_position)
    let duv1 = dFdx(f_texcoord)
    let duv2 = dFdy(f_texcoord)
	// solve the linear system
    let N = normalize(f_normal)
  	let dp2perp = cross(dp2, N);
  	let dp1perp = cross(N, dp1);
  	let T = normalize(dp2perp * duv1.x + dp1perp * duv2.x);
  	let B = normalize(dp2perp * duv1.y + dp1perp * duv2.y);
    // let TBN = mat3(T, B, N)
    var TBN : float3x3
    TBN[0] = T
    TBN[1] = B
    TBN[2] = N
	return normalize(TBN * (texture(f_norm, f_texcoord).xyz * 2.0 - float3(1.0)))

[fragment_program(name="PBR_FRAGMENT_SRC",version=330)]
def ps_preview_pbr
    let light_dir = normalize(float3(-1,-2,-3))
    let camera_dir = normalize(f_position)
    let normal = get_normal()
    // blinn-phong
    let k = -dot(light_dir,normal)
    let diffuse = float3(saturate(k)) * f_kD
    let refl = normalize ( reflect(camera_dir,normal) )
    let kS = saturate(dot(-light_dir,refl))
    let specular = float3(pow(kS,f_pS)*f_kS)
    f_outputColor.xyz =  (
        texture(f_tex,  f_texcoord).xyz * diffuse +
        texture(f_spec, f_texcoord).xyz * specular
    )
    f_outputColor.w = 1.

[vertex_buffer]
struct PreviewVertex
    [[type=GL_FLOAT, size=3, normalized=false]] xyz    : float3
    [[type=GL_FLOAT, size=3, normalized=true]]  normal : float3
    [[type=GL_FLOAT, size=2, normalized=false]] uv     : float2

struct Fragment
    vertices : array<PreviewVertex>
    indices : array<int>
    prim : uint
    vao : uint
    vbo : uint
    ebo : uint

def create_objects ( var frag : Fragment )
    with frag
        glGenVertexArrays(1, safe_addr(vao))
        glBindVertexArray(vao)
        glGenBuffers(1, safe_addr(vbo))
        glBindBuffer(GL_ARRAY_BUFFER, vbo)
        glBufferData(GL_ARRAY_BUFFER, vertices, GL_STATIC_DRAW)
        bind_vertex_buffer(null,type<PreviewVertex>)
        glGenBuffers(1, safe_addr(ebo))
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices, GL_STATIC_DRAW)

def draw_fragment ( frag : Fragment )
    with frag
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
        glBindVertexArray(vao)
        glDrawElements(frag.prim, length(indices), GL_UNSIGNED_INT, null)

def gen_sphere ( sectorCount,stackCount:int )
    var frag : Fragment
    let sectorStep = 2. * PI / float(sectorCount)
    let stackStep = PI / float(stackCount)
    for i in range(stackCount+1)
        let stackAngle = PI / 2. -  float(i) * stackStep
        let xy = cos(stackAngle)
        let z  = sin(stackAngle)
        for j in range(sectorCount+1)
            let sectorAngle = float(j) * sectorStep
            let x = xy * cos(sectorAngle)
            let y = xy * sin(sectorAngle)
            let s = float(j) / float(sectorCount)
            let t = float(i) / float(stackCount)
            frag.vertices |> push <| [[PreviewVertex
                xyz=float3(x,y,z),
                normal=normalize(float3(x,y,z)),
                uv=float2(s,t)
            ]]
    var indices : array<int>
    var k1, k2 : int
    for i in range(stackCount)
        k1 = i * (sectorCount + 1)
        k2 = k1 + sectorCount + 1
        for j in range(sectorCount)
            if i != 0
                frag.indices |> push(k1)
                frag.indices |> push(k2)
                frag.indices |> push(k1 + 1)
            if i != (stackCount-1)
                frag.indices |> push(k1 + 1)
                frag.indices |> push(k2)
                frag.indices |> push(k2 + 1)
            ++k1
            ++k2
    frag.prim = GL_TRIANGLES
    frag |> create_objects()
    return <- frag

def gen_cube
    var frag : Fragment
    frag.vertices <- [{PreviewVertex
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
    }]
    frag.indices <- [{int 0;1;2;3; 4;5;6;7; 3;2;5;4; 7;6;1;0; 8;9;10;11; 12;13;14;15 }]
    frag.prim = GL_QUADS
    frag |> create_objects()
    return <- frag

def radians(f:float)
    return f * PI / 180.0

var program, program_pbr : uint

var ttf : bool = false
var font : Font
var cube : Fragment
var sphere : Fragment

def public create_preview_objects
    program = create_shader_program(PREVIEW_VERTEX_SRC,PREVIEW_FRAGMENT_SRC)
    program_pbr = create_shader_program(PBR_VERTEX_SRC,PBR_FRAGMENT_SRC)
    font <- load_ttf("c:/windows/fonts/arial.ttf")
    cube <- gen_cube()
    sphere <- gen_sphere(32,16)

def public draw_preview ( display_w, display_h : int )
    static_let <|
        var rot_cube = 0.
        var rot_tri = 0.

    if length(g_PreviewTexture)==0
        g_PreviewTexture |> emplace <| [[Material
            surf=make_checkerboard(),
            name="Checkerboard",
            id="nothing",
            outp="nothing"]]

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
    let stepX = 2.2
    let stepY = 2.2
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

            if g_PreviewTexture[index].norm.tex!=0u && g_PreviewTexture[index].spec.tex!=0u
                f_tex.texture2D = g_PreviewTexture[index].surf.tex
                f_spec.texture2D = g_PreviewTexture[index].spec.tex
                f_norm.texture2D = g_PreviewTexture[index].norm.tex
                f_kD = g_PreviewTexture[index].opt?["kDiff"] ?? 1.0
                f_kS = g_PreviewTexture[index].opt?["kSpec"] ?? 1.0
                f_pS = g_PreviewTexture[index].opt?["pSpec"] ?? 1.0
                glUseProgram(program_pbr)
                vs_preview_pbr_bind_uniform(program_pbr)
                ps_preview_pbr_bind_uniform(program_pbr)
                // cube |> draw_fragment()
                sphere |> draw_fragment()
            else
                f_tex.texture2D = g_PreviewTexture[index].surf.tex
                glUseProgram(program)
                vs_preview_main_bind_uniform(program)
                ps_preview_main_bind_uniform(program)
                cube |> draw_fragment()
                // sphere |> draw_fragment()

            glDisable(GL_DEPTH_TEST)

            if g_PreviewLabels
                var hw_text <- font |> create_quads(g_PreviewTexture[index].name)
                let qmodel = quads_view(hw_text, float2(1.0/300.0))
                let model = translation(float3(float(x)*stepX+halfX, (float(y)+0.45)*stepY+halfY, -2.2 - float(sqX-1)*2.)) * qmodel
                let mvp = v_projection * v_view * model
                font |> draw_quads(hw_text, mvp)
                delete hw_text

            bind_ffp()

            index ++
            if index==total
                break

