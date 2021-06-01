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
    what : string
    undo : lambda
    redo : lambda

var private g_UndoStack : array<UndoRedo>
var private g_UndoStackTop = 0
var private g_UndoLastInstruction : string

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

def create_undo ( what:string; blk:block<(var ur:UndoRedo)> )
    var ur : UndoRedo
    ur.what = what
    invoke(blk, ur)
    create_undo(ur)

def clear_undo_stack
    g_UndoLastInstruction = ""
    delete g_UndoStack
    g_UndoStackTop = 0

def undo
    static_if DEBUG_UNDO_STACK
        debug(g_UndoStack, "undo = ")
        debug(g_UndoStackTop, "undo sp = ")
    if g_UndoStackTop > 0
        g_UndoStackTop --
        invoke ( g_UndoStack[g_UndoStackTop].undo )
        update_preview()

def redo
    static_if DEBUG_UNDO_STACK
        debug(g_UndoStack, "redo = ")
        debug(g_UndoStackTop, "undo sp = ")
    if g_UndoStackTop != length(g_UndoStack)
        invoke ( g_UndoStack[g_UndoStackTop].redo )
        g_UndoStackTop ++
        update_preview()

def save_to_json ( var inst:Instruction? )
    var jv = inst->JV()
    var txt = write_json(jv)
    unsafe
        delete jv
    return txt

def before_instruction ( var inst:Instruction? )
    g_UndoLastInstruction = save_to_json(inst)

def select_and_navigate ( var inst:Instruction?; fframe:bool=true )
    inst.firstFrame = fframe
    inst.select = true
    inst.navigate = true

[private]
def restore_instruction(id:string;json:string)
    var inst = (*g_CurrentProject)->find_instruction(id)
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        (*inst)->from_JV(jv)
        select_and_navigate(inst,false)
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
        select_and_navigate(inst)
    else
        print("{error}\nfailed create and to restore from {json}\n")   // TODO: better error reporting
    unsafe
        delete jv

def undo_edit_instruction(id,name:string)
    let before = g_UndoLastInstruction
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
            select_and_navigate(inst)
        ur.redo <- @ <|
            static_if DEBUG_UNDO
                print("redo move {id} {after}\n")
            var inst = (*g_CurrentProject)->find_instruction(id)
            inst.at = after
            select_and_navigate(inst)

def undo_delete_instruction(var inst:Instruction?)
    let before = g_UndoLastInstruction
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

def undo_delete_connecction(id,pin,lid,loutput:string)
    create_undo("delete link {id} {pin} {lid}") <| $ ( ur )
        ur.undo <- @ <|
            var inst = (*g_CurrentProject)->find_instruction(id)
            let inI = (*inst)->input_index(pin)
            var linst = (*g_CurrentProject)->find_instruction(lid)
            inst.inputs[inI].src = linst
            inst.inputs[inI].output = loutput
        ur.redo <- @ <|
            post_event <| @
                var inst = (*g_CurrentProject)->find_instruction(id)
                var inI = (*inst)->input_index(pin)
                var inp & =  inst.inputs[inI]
                inp.src = null
