options indenting = 4
options remove_unused_symbols = false

module undo_stack

require instructions public
require preview
require guid_2_id
require imgui_node_editor
require command_que

require daslib/json_boost public

let DEBUG_UNDO = false
let DEBUG_UNDO_STACK = false

struct UndoRedo
    action : int
    what : string
    undo : lambda
    redo : lambda

struct SavedConnection
    id : string
    pin : string
    lid : string
    loutput : string

var private g_UndoStack : array<UndoRedo>
var private g_UndoStackTop = 0
var private g_UndoLastElement : string
var private g_UndoLastLink : SavedConnection
var private g_UndoAction = 0
var private g_UndoDirty = false

def is_undo_dirty
    return g_UndoDirty

def clear_undo_dirty
    g_UndoDirty = false

def create_undo ( var ur:UndoRedo )
    var l = length(g_UndoStack)
    if l != g_UndoStackTop
        for i in range(l,g_UndoStackTop)    // kill the tail
            delete g_UndoStack[i]
        resize(g_UndoStack, g_UndoStackTop)
        l = g_UndoStackTop
    if l > 0
        var pur & = g_UndoStack[l-1]
        if pur.what == ur.what              // its the same reason for undo, so collapse
            delete ur.undo
            delete pur.redo
            pur.redo <- ur.redo
            return
    g_UndoStack |> emplace(ur)
    g_UndoStackTop = length(g_UndoStack)
    g_UndoDirty = true

def next_undo_action
    g_UndoAction ++

def create_undo ( what:string; blk:block<(var ur:UndoRedo)> )
    var ur : UndoRedo
    ur.action = g_UndoAction
    ur.what = what
    invoke(blk, ur)
    create_undo(ur)

def clear_undo_stack
    g_UndoLastElement = ""
    g_UndoLastLink = [[SavedConnection]]
    delete g_UndoStack
    g_UndoStackTop = 0
    g_UndoAction = 0
    g_UndoDirty = false

def undo
    static_if DEBUG_UNDO_STACK
        debug(g_UndoStack, "undo = ")
        debug(g_UndoStackTop, "undo sp = ")
    if g_UndoStackTop > 0
        let action = g_UndoStack[g_UndoStackTop-1].action
        while g_UndoStackTop>0 && g_UndoStack[g_UndoStackTop-1].action==action
            g_UndoStackTop --
            invoke ( g_UndoStack[g_UndoStackTop].undo )
        update_preview()

def redo
    static_if DEBUG_UNDO_STACK
        debug(g_UndoStack, "redo = ")
        debug(g_UndoStackTop, "undo sp = ")
    if g_UndoStackTop != length(g_UndoStack)
        let action = g_UndoStack[g_UndoStackTop].action
        while g_UndoStackTop!=length(g_UndoStack) && g_UndoStack[g_UndoStackTop].action==action
            invoke ( g_UndoStack[g_UndoStackTop].redo )
            g_UndoStackTop ++
        update_preview()

def redo_last
    static_if DEBUG_UNDO_STACK
        debug(g_UndoStack, "undo last = ")
        debug(g_UndoStackTop, "undo sp = ")
    invoke ( g_UndoStack[g_UndoStackTop-1].redo )

def save_to_json ( var inst:Instruction? )
    var jv = inst->JV()
    var txt = write_json(jv)
    unsafe
        delete jv
    return txt

def before_instruction ( var inst:Instruction? )
    g_UndoLastElement = save_to_json(inst)

def before_link ( id,pin:string )
    g_UndoLastLink = describe_connection(id,pin)

[private]
def restore_instruction(id:string;json:string)
    var inst = (*g_CurrentProject)->find_instruction(id)
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        (*inst)->from_JV(jv)
    else
        print("{error}\nfailed to restore {id} from {json}\n")  // TODO: better error reporting
    unsafe
        delete jv

[private]
def create_and_restore_instruction(json:string)
    var inst : Instruction?
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        inst = (*g_CurrentProject)->load_instruction(jv)
    else
        print("{error}\nfailed create and to restore from {json}\n")   // TODO: better error reporting
    unsafe
        delete jv

def undo_edit_instruction(id,name:string)
    next_undo_action()
    let before = g_UndoLastElement
    var inst = (*g_CurrentProject)->find_instruction(id)
    var after = save_to_json(inst)
    create_undo("edit instruction {id} {name}") <| $ ( ur )
        ur.undo <- @ <|
            restore_instruction(id,before)
        ur.redo <- @ <|
            restore_instruction(id,after)

def undo_move_instruction(id:string;before,after:float2)
    create_undo("move instruction {id}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("undo move {id} {before}\n")
            var inst = (*g_CurrentProject)->find_instruction(id)
            inst.at = before
            inst.firstFrame = true
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("redo move {id} {after}\n")
            var inst = (*g_CurrentProject)->find_instruction(id)
            inst.at = after
            inst.firstFrame = true

def undo_delete_instruction(var inst:Instruction?)
    let before = g_UndoLastElement
    let id = inst.id
    create_undo("delete instruction {id}") <| $ ( ur )
        ur.undo <- @ <|
            create_and_restore_instruction(before)
        ur.redo <- @ <|
            post_event <| @
                var inst = (*g_CurrentProject)->find_instruction(id)
                (*g_CurrentProject)->delete_instruction(inst)

def undo_create_instruction(var inst:Instruction?)
    let before = save_to_json(inst)
    let id = inst.id
    create_undo("create instruction {id}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("undo create instruction {id}\n")
            post_event <| @
                var inst = (*g_CurrentProject)->find_instruction(id)
                (*g_CurrentProject)->delete_instruction(inst)
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("redo create instruction {id} {before}\n")
            create_and_restore_instruction(before)

[private]
def describe_connection (id,pin:string) : SavedConnection
    var inst = (*g_CurrentProject)->find_instruction(id)
    var inI = (*inst)->input_index(pin)
    var inp & =  inst.inputs[inI]
    if inp.src != null
        return [[SavedConnection id=id,pin=pin,lid=inp.src.id,loutput=inp.output]]
    else
        return [[SavedConnection id=id,pin=pin]]

[private]
def restore_connection ( before:SavedConnection )
    var inst = (*g_CurrentProject)->find_instruction(before.id)
    var inI = (*inst)->input_index(before.pin)
    var inp & =  inst.inputs[inI]
    if before.lid==""
        inp.src = null
    else
        inp.src = (*g_CurrentProject)->find_instruction(before.lid)
        inp.output = before.loutput

[private]
def destroy_connection ( before:SavedConnection )
    var inst = (*g_CurrentProject)->find_instruction(before.id)
    var inI = (*inst)->input_index(before.pin)
    var inp & =  inst.inputs[inI]
    inp.src = null

def undo_delete_connection(id,pin:string)
    var before = describe_connection(id,pin)
    create_undo("delete link {id} {pin}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("restore connection from {before}\n")
            restore_connection(before)
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("destroy connection from {before}\n")
            destroy_connection(before)

def undo_create_connection(id,pin:string)
    var before = g_UndoLastLink
    var after = describe_connection(id,pin)
    create_undo("create link {id} {pin}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("restore connection from {before}\n")
            restore_connection(before)
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("restore connection from {after}\n")
            restore_connection(after)

def restore_current_project(json:string)
    var error : string
    var jv = read_json(json,error)
    if jv!=null
        (*g_CurrentProject)->load(jv)
    else
        print("{error}\nfailed to restore project} from {json}\n")  // TODO: better error reporting
    unsafe
        delete jv

def save_project(var proj:Project?)
    var jv = (*proj)->save()
    let before = write_json(jv)
    unsafe
        delete jv
    return before

def save_current_project
    return save_project(g_CurrentProject)

def before_project
    g_UndoLastElement = save_current_project()

[generic]
def undo_new_project()
    let before = save_current_project()
    create_undo("new project {g_UndoAction}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("restore project from {before}\n")
            post_event <| @
                _::clear_project_data()
                restore_current_project(before)
                update_preview()
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("new project\n")
            post_event <| @
                _::clear_project_data()

[generic]
def undo_replace_project(event_name:string)
    let before = g_UndoLastElement
    let after  = save_current_project()
    create_undo("{event_name} project {g_UndoAction}") <| $ ( ur )
        ur.undo <- @ <|
            static_if DEBUG_UNDO
                print("restore project from {before}\n")
            post_event <| @
                _::clear_project_data()
                restore_current_project(before)
                update_preview()
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("new project\n")
            post_event <| @
                _::clear_project_data()
                restore_current_project(after)
                update_preview()
