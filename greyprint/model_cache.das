options indenting = 4

module model_cache shared

require debugapi

require daslib/apply_in_context
require daslib/opengl_boost

var private programs : table<uint64; uint>

[apply_in_context(model_cache)]
def public cache_shader_program(vtx,frag:string) : uint
    let phash = (uint64(hash(vtx))<<32ul) | uint64(hash(frag))
    if ! programs |> key_exists(phash)
        programs[phash] = create_shader_program(vtx,frag)
    return programs[phash]

def private has_agent
    return has_debug_agent_context("model_cache")

def private install_agent
    install_new_debug_agent(new DapiDebugAgent(), "model_cache")

def public init_model_cache
    if !has_agent()
        fork_debug_agent_context(@@install_agent)

def public reset_model_cache
    // note: only surfaces
    pass
