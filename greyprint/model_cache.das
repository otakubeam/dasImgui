options indenting = 4

module model_cache shared

require debugapi

require daslib/apply_in_context
require daslib/opengl_boost
require daslib/safe_addr

var private programs : table<uint64; uint>
var private images : table<string; uint>

[apply_in_context(model_cache)]
def public cache_shader_program(vtx,frag:string# implicit) : uint
    let phash = (uint64(hash(vtx))<<32ul) | uint64(hash(frag))
    if ! programs |> key_exists(phash)
        programs[phash] = create_shader_program(vtx,frag)
    return programs[phash]

[apply_in_context(model_cache)]
def public cache_image(filename:string# implicit) : uint
    var value = 0u
    images |> find_if_exists(filename) <| $ ( pimg:uint? ) : void
        value = *pimg
    if value==0u
        value = load_image_from_file(filename, true)
        images[clone_string(filename)] = value
    return value

def private has_agent
    return has_debug_agent_context("model_cache")

def private install_agent
    install_new_debug_agent(new DapiDebugAgent(), "model_cache")

def public init_model_cache
    if !has_agent()
        fork_debug_agent_context(@@install_agent)

[apply_in_context(model_cache)]
def public reset_model_cache : bool
    for prog in values(programs)
        glDeleteProgram(prog)
    delete programs
    for img in values(images)
        glDeleteTextures(1,safe_addr(img))
    delete images
    return true
