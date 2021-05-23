options indenting = 4
options remove_unused_symbols = false

module guid_2_id

require instructions

require daslib/strings_boost

var guid_2_id : table<string; int>
var id_2_guid : table<int; string>
var guid_2_id_next = 1000

def reset_guids
    delete guid_2_id
    delete id_2_guid
    guid_2_id_next = 1000

def get_unique_id ( guid:string ) : int
    var id = 0
    find_if_exists(guid_2_id, guid) <| $ ( val )
        id = *val
    if id == 0
        id = guid_2_id_next++
        guid_2_id[guid] = id
        id_2_guid[id] = guid
    return id

def get_input_unique_id ( inst:Instruction?; inp:string ) : int
    return get_unique_id("INPUT {inst.id} {inp}")

def get_output_unique_id ( inst:Instruction?; outp:string ) : int
    return get_unique_id("OUTPUT {inst.id} {outp}")

