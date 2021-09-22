options indenting = 4

module model shared private

require model_cache

require instructions public
require math

require daslib/opengl_boost
require daslib/safe_addr
require daslib/static_let
require daslib/unroll

var [[uniform]] f_grad_tl : float4
var [[uniform]] f_grad_tr : float4
var [[uniform]] f_grad_bl : float4
var [[uniform]] f_grad_br : float4
var [[uniform]] f_weights : float[9]
var [[uniform]] f_iweights_summ : float
var [[in, location=0]] v_position : float2
var [[in, location=1]] v_texcoord : float2
var [[inout]] f_texcoord : float2
var [[out]] f_outputColor : float4
var [[uniform, binding=0]] f_tex : sampler2D
var [[uniform, binding=1]] f_tex2 : sampler2D
var [[uniform, binding=2]] f_tex3 : sampler2D
var [[uniform]] f_blend_factor : float

[vertex_program(name="ANY_EFFECT_VERTEX_SRC",version=330)]
def vs_any_effect
    f_texcoord = v_texcoord
    gl_Position = float4(v_position.x, v_position.y, 0.0, 1.0)

[fragment_program(name="COPY_FRAGMENT_SRC",version=330)]
def ps_copy_effect
    f_outputColor = texture(f_tex,f_texcoord)

[fragment_program(name="GREYSCALE_FRAGMENT_SRC",version=330)]
def ps_greyscale_effect
    let color = texture(f_tex,f_texcoord)
    let b = color.x * 0.299 + color.y * 0.587 + color.z * 0.114
    f_outputColor = float4(b, b, b, 1.0)

def make_kernel_3x3 ( var n : float4[9]; tex:sampler2D; coord:float2 )
	n[0] = textureOffset(tex, coord, int2(-1,-1))
	n[1] = textureOffset(tex, coord, int2( 0,-1))
	n[2] = textureOffset(tex, coord, int2( 1,-1))
	n[3] = textureOffset(tex, coord, int2(-1, 0))
	n[4] = textureOffset(tex, coord, int2( 0, 0))
	n[5] = textureOffset(tex, coord, int2( 1, 0))
	n[6] = textureOffset(tex, coord, int2(-1, 1))
	n[7] = textureOffset(tex, coord, int2( 0, 1))
	n[8] = textureOffset(tex, coord, int2( 1, 1))

[fragment_program(name="SOBEL_FRAGMENT_SRC",version=330)]
def ps_sobel_effect
    var n : float4[9]
    make_kernel_3x3(n, f_tex, f_texcoord)
	let sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6])
  	let sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8])
	f_outputColor = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v))

def make_kernel_9x1 ( var n : float4[9]; tex:sampler2D; coord:float2 )
    unroll <|
        for i in range(9)
	        n[i] = textureOffset(tex, coord, int2(i-4,0))

def make_kernel_1x9 ( var n : float4[9]; tex:sampler2D; coord:float2 )
    unroll <|
        for i in range(9)
	        n[i] = textureOffset(tex, coord, int2(0,i-4))

def gaussian(x, sigma:float)
    return ( 1. / ( sqrt(2.*PI) * sigma ) ) * exp( -(x*x) / (2.*sigma*sigma) )

[fragment_program(name="HBLUR_FRAGMENT_SRC",version=330)]
def ps_hblur_effect
    var n : float4[9]
    make_kernel_9x1(n, f_tex, f_texcoord)
    var c : float4
    for a,w in n,f_weights
        c += a * float4(w)
    f_outputColor = c * f_iweights_summ

[fragment_program(name="VBLUR_FRAGMENT_SRC",version=330)]
def ps_vblur_effect
    var n : float4[9]
    make_kernel_1x9(n, f_tex, f_texcoord)
    var c : float4
    for a,w in n,f_weights
        c += a * float4(w)
    f_outputColor = c * f_iweights_summ

[fragment_program(name="GRADIENT_FRAGMENT_SRC",version=330)]
def ps_gradient_effect
    let l = lerp(f_grad_tl,f_grad_bl,float4(f_texcoord.y))
    var r = lerp(f_grad_tr,f_grad_br,float4(f_texcoord.y))
    f_outputColor = lerp(l, r, float4(f_texcoord.x))

[fragment_program(name="BLEND_ADD_FRAGMENT_SRC",version=330)]
def ps_blend_add_effect
    let c1 = texture ( f_tex, f_texcoord )
    let c2 = texture ( f_tex2, f_texcoord )
    f_outputColor = c1 + c2

[fragment_program(name="BLEND_MUL_FRAGMENT_SRC",version=330)]
def ps_blend_mul_effect
    let c1 = texture ( f_tex, f_texcoord )
    let c2 = texture ( f_tex2, f_texcoord )
    f_outputColor = c1 * c2

[fragment_program(name="BLEND_CROSSFADE_FRAGMENT_SRC",version=330)]
def ps_blend_crossfade_effect
    let c1 = texture ( f_tex, f_texcoord )
    let c2 = texture ( f_tex2, f_texcoord )
    f_outputColor = lerp(c1, c2, float4(f_blend_factor))

[fragment_program(name="BLEND_TX_CROSSFADE_FRAGMENT_SRC",version=330)]
def ps_tx_blend_crossfade_effect
    let c1 = texture ( f_tex, f_texcoord )
    let c2 = texture ( f_tex2, f_texcoord )
    let cfactor = texture ( f_tex3, f_texcoord)
    f_outputColor = lerp(c1, c2, cfactor)

[vertex_buffer]
struct EffectVertex
    [[type=GL_FLOAT, size=2, normalized=false]] xy  : float2
    [[type=GL_FLOAT, size=2, normalized=false]] uv  : float2

let private effect_vertices = [[EffectVertex
        xy=float2(-1.0, 1.0), uv=float2(0.0,1.0);
        xy=float2( 1.0, 1.0), uv=float2(1.0,1.0);
        xy=float2( 1.0,-1.0), uv=float2(1.0,0.0);
        xy=float2(-1.0,-1.0), uv=float2(0.0,0.0)
]]

let private effect_indices = [[int 0; 1; 2; 2; 3; 0]]

var private effect_vao = 0u
var private effect_vbo = 0u
var private effect_ebo = 0u

def create_effect_data
    if effect_vao==0u
        glGenVertexArrays(1, safe_addr(effect_vao))
        glBindVertexArray(effect_vao);
    if effect_vbo==0u
        glGenBuffers(1, safe_addr(effect_vbo))
        glBindBuffer(GL_ARRAY_BUFFER, effect_vbo)
        glBufferData(GL_ARRAY_BUFFER, effect_vertices, GL_STATIC_DRAW)
    if effect_ebo==0u
        glGenBuffers(1, safe_addr(effect_ebo))
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, effect_ebo)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, effect_indices, GL_STATIC_DRAW)

def bind_effect ( var surf:Surface; prog:uint )
    create_effect_data()
    glBindFramebuffer(GL_FRAMEBUFFER, surf.fbo)
    glViewport(0, 0, surf.size.x, surf.size.y)
    glDisable(GL_DEPTH_TEST)
    glUseProgram(prog)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, effect_ebo)
    bind_vertex_buffer(effect_vbo, type<EffectVertex>)

def public create_surface ( var reg:Surface; sz:int2 )
    reg <- Surface(sz.x,sz.y)
    glGenFramebuffers(1, safe_addr(reg.fbo))
    glBindFramebuffer(GL_FRAMEBUFFER, reg.fbo)
    glGenTextures(1, safe_addr(reg.tex))
    glBindTexture(GL_TEXTURE_2D, reg.tex)
    glTexImage2D(GL_TEXTURE_2D, 0, int(GL_RGB), reg.size.x, reg.size.y, 0, GL_RGB, GL_UNSIGNED_BYTE, null)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, reg.tex, 0)
    if glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE
        panic("fbo failed")
    if DEBUG_TEXTURE_LIFETIME
        print("create_surface {reg.tex}\n")

def public surface_gen_tex ( var surf:Surface )
    var scopy : Surface
    if DEBUG_TEXTURE_LIFETIME
        print("IN surface_gen_tex:\n")
    create_surface(scopy, surf.size)
    let copy_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,COPY_FRAGMENT_SRC)
    bind_effect(scopy, copy_program)
    f_tex.texture2D = surf.tex
    vs_any_effect_bind_uniform(copy_program)
    ps_copy_effect_bind_uniform(copy_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()
    var res <- scopy.tex
    delete scopy
    if DEBUG_TEXTURE_LIFETIME
        print("create copy {res} from {surf.tex}\n")
    return res

def public empty_surface()
    return <- [[Surface]]

def public delete_surface ( var reg:Surface )
    if DEBUG_TEXTURE_LIFETIME
        print("delete surface {reg.tex}\n")
    delete reg

def public surface_gen_image ( var reg:Surface; fileName:string )
    var imgtex = cache_image(fileName)
    let copy_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,COPY_FRAGMENT_SRC)
    bind_effect(reg, copy_program)
    f_tex.texture2D = imgtex
    vs_any_effect_bind_uniform(copy_program)
    ps_copy_effect_bind_uniform(copy_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_gen_solid_color ( var reg:Surface; color:float4 )
    bind_effect(reg, 0u)
    glClearColor(color.x, color.y, color.z, color.w)
    glClear(GL_COLOR_BUFFER_BIT)
    bind_ffp()

def public surface_gen_copy ( var surf:Surface; src:Surface )
    if DEBUG_TEXTURE_LIFETIME
        print("copy_image {surf.tex} <- {src.tex}\n")
    let copy_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,COPY_FRAGMENT_SRC)
    bind_effect ( surf, copy_program )
    f_tex.texture2D = src.tex
    vs_any_effect_bind_uniform(copy_program)
    ps_copy_effect_bind_uniform(copy_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_gen_greyscale ( var surf:Surface; src:Surface )
    let greyscale_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,GREYSCALE_FRAGMENT_SRC)
    bind_effect ( surf, greyscale_program )
    f_tex.texture2D = src.tex
    vs_any_effect_bind_uniform(greyscale_program)
    ps_greyscale_effect_bind_uniform(greyscale_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_gen_blur ( var surf:Surface; src:Surface; var sigma:float )
    // bindings and weights
    sigma = max(sigma, 0.01)
    f_weights = [[float[9]
        gaussian(-4., sigma);   gaussian(-3., sigma);   gaussian(-2., sigma);   gaussian(-1., sigma);
        gaussian( 0., sigma);
        gaussian( 1., sigma);   gaussian( 2., sigma);   gaussian( 3., sigma);   gaussian( 4., sigma)
    ]]
    f_iweights_summ = 0.
    for w in f_weights
        f_iweights_summ += w
    f_iweights_summ = 1.0 / f_iweights_summ
    // temp surface
    if DEBUG_TEXTURE_LIFETIME
        print("IN surface_gen_blur:\n")
    var temp : Surface
    create_surface(temp, surf.size)
    // horizontal
    let hblur_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,HBLUR_FRAGMENT_SRC)
    bind_effect (temp,hblur_program )
    f_tex.texture2D = src.tex
    vs_any_effect_bind_uniform(hblur_program)
    ps_hblur_effect_bind_uniform(hblur_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    // vertical
    let vblur_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,VBLUR_FRAGMENT_SRC)
    bind_effect (surf,vblur_program )
    f_tex.texture2D = temp.tex
    vs_any_effect_bind_uniform(vblur_program)
    ps_vblur_effect_bind_uniform(vblur_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    // back to ffp, also cleanup
    bind_ffp()
    if DEBUG_TEXTURE_LIFETIME
        print("delete temp texture {temp.tex}\n")
    delete temp

def public surface_gen_sobel ( var surf:Surface; src:Surface )
    let sobel_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,SOBEL_FRAGMENT_SRC)
    bind_effect ( surf, sobel_program )
    f_tex.texture2D = src.tex
    vs_any_effect_bind_uniform(sobel_program)
    ps_sobel_effect_bind_uniform(sobel_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_gen_gradient ( var surf:Surface; top_left,top_right,bottom_left,bottom_right:float4 )
    let gradient_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,GRADIENT_FRAGMENT_SRC)
    bind_effect ( surf, gradient_program )
    f_grad_tl = top_left
    f_grad_tr = top_right
    f_grad_bl = bottom_left
    f_grad_br = bottom_right
    vs_any_effect_bind_uniform(gradient_program)
    ps_gradient_effect_bind_uniform(gradient_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

[unused_argument(factor)]
def public surface_blend_Add ( var reg:Surface; src,dst:Surface; factor:float )
    let blend_add_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,BLEND_ADD_FRAGMENT_SRC)
    bind_effect ( reg, blend_add_program )
    f_tex.texture2D = src.tex
    f_tex2.texture2D = dst.tex
    vs_any_effect_bind_uniform(blend_add_program)
    ps_blend_add_effect_bind_uniform(blend_add_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

[unused_argument(factor)]
def public surface_blend_Multiply ( var reg:Surface; src,dst:Surface; factor:float )
    let blend_mul_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,BLEND_MUL_FRAGMENT_SRC)
    bind_effect ( reg, blend_mul_program )
    f_tex.texture2D = src.tex
    f_tex2.texture2D = dst.tex
    vs_any_effect_bind_uniform(blend_mul_program)
    ps_blend_mul_effect_bind_uniform(blend_mul_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_blend_Crossfade  ( var reg:Surface; src,dst:Surface; var factor:float )
    let blend_crossfade_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,BLEND_CROSSFADE_FRAGMENT_SRC)
    bind_effect ( reg, blend_crossfade_program )
    f_blend_factor = clamp(factor,0.,1.)
    f_tex.texture2D = src.tex
    f_tex2.texture2D = dst.tex
    vs_any_effect_bind_uniform(blend_crossfade_program)
    ps_blend_crossfade_effect_bind_uniform(blend_crossfade_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()

def public surface_blend_tex_Crossfade  ( var reg:Surface; src,dst,factor:Surface )
    let tx_blend_crossfade_program = cache_shader_program(ANY_EFFECT_VERTEX_SRC,BLEND_TX_CROSSFADE_FRAGMENT_SRC)
    bind_effect ( reg, tx_blend_crossfade_program )
    f_tex.texture2D = src.tex
    f_tex2.texture2D = dst.tex
    f_tex3.texture2D = factor.tex
    vs_any_effect_bind_uniform(tx_blend_crossfade_program)
    ps_tx_blend_crossfade_effect_bind_uniform(tx_blend_crossfade_program)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null)
    bind_ffp()


var G_OUTPUT : array<tuple<Surface;string;string;string>>

def public preview ( var reg:Surface; name,id,outp:string )
    if reg.size.x!=0 && reg.size.y!=0
        var creg : Surface
        if DEBUG_TEXTURE_LIFETIME
            print("IN preview:\n")
        create_surface(creg, reg.size)
        creg.tex = surface_gen_tex(reg)
        if DEBUG_TEXTURE_LIFETIME
            print("preview {creg.tex}\n")
        G_OUTPUT |> push_clone([[auto creg,name,id,outp]])

def public output ( var reg:Surface; name,id,outp:string )
    if reg.size.x!=0 && reg.size.y!=0
        var creg : Surface
        if DEBUG_TEXTURE_LIFETIME
            print("IN output:\n")
        create_surface(creg, reg.size)
        creg.tex = surface_gen_tex(reg)
        if DEBUG_TEXTURE_LIFETIME
            print("output {creg.tex}\n")
        G_OUTPUT |> push_clone([[auto creg,name,id,outp]])

def public output ( var reg:float; name,id,outp:string )
    print(" {name}:{outp} = {reg} // {id}\n")

def public output ( var reg:float2; name,id,outp:string )
    print(" {name}:{outp} = {reg} // {id}\n")

def public output ( var reg:float3; name,id,outp:string )
    print(" {name}:{outp} = {reg} // {id}\n")

def public output ( var reg:float4; name,id,outp:string )
    print(" {name}:{outp} = {reg} // {id}\n")
