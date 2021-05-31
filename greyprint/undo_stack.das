options indenting = 4
options remove_unused_symbols = false

module undo_stack

require instructions public
require preview
require guid_2_id
require imgui_node_editor
require command_que

require daslib/json_boost public

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

def clear_undo_stack
    g_UndoLastInstruction = ""
    delete g_UndoStack
    g_UndoStackTop = 0

def undo
    if g_UndoStackTop > 0
        g_UndoStackTop --
        invoke ( g_UndoStack[g_UndoStackTop].undo )
        update_preview()

def redo
    if g_UndoStackTop != length(g_UndoStack)
        invoke ( g_UndoStack[g_UndoStackTop].redo )
        g_UndoStackTop ++
        update_preview()

def before_instruction ( var inst:Instruction? )
    var jv = inst->JV()
    g_UndoLastInstruction = write_json(jv)
    unsafe
        delete jv

[private]
def restore_instruction(id:string;json:string)
    var inst = (*g_CurrentProject)->find_instruction(id)
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        (*inst)->from_JV(jv)
    else
        // TODO: better error reporting
        print("{error}\nfailed to restore {id} from {json}\n")
    inst.select = true
    inst.navigate = true
    unsafe
        delete jv

def undo_edit_instruction(id,name:string)
    let before = g_UndoLastInstruction
    var ur : UndoRedo
    var inst = (*g_CurrentProject)->find_instruction(id)
    var jv = (*inst)->JV()
    var after = write_json(jv)
    unsafe
        delete jv
    ur.what = "edit instruction {id} {name}"
    ur.undo <- @ <|
        restore_instruction(id,before)
    ur.redo <- @ <|
        restore_instruction(id,after)
    create_undo(ur)

def undo_move_instruction(id:string;before,after:float2)
    var ur : UndoRedo
    ur.what = "move instruction {id}"
    ur.undo <- @ <|
        var inst = (*g_CurrentProject)->find_instruction(id)
        inst.at = before
        inst.firstFrame = true
        inst.select = true
        inst.navigate = true
    ur.redo <- @ <|
        var inst = (*g_CurrentProject)->find_instruction(id)
        inst.at = after
        inst.firstFrame = true
        inst.select = true
        inst.navigate = true
    create_undo(ur)

[private]
def restore_instruction(json:string)
    var inst : Instruction?
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        inst = (*g_CurrentProject)->load_instruction(jv)
    else
        // TODO: better error reporting
        print("{error}\nfailed to restore from {json}\n")
        return
    inst.firstFrame = true
    inst.select = true
    inst.navigate = true
    unsafe
        delete jv

def undo_delete_instruction(inst:Instruction?)
    let before = g_UndoLastInstruction
    let id = inst.id
    var ur : UndoRedo
    ur.what = "delete instruction {id}"
    ur.undo <- @ <|
        restore_instruction(before)
    ur.redo <- @ <|
        post_event <| @
            var inst = (*g_CurrentProject)->find_instruction(id)
            (*g_CurrentProject)->delete_instruction(inst)
    create_undo(ur)

def undo_delete_connecction(id,pin,lid,loutput:string)
    var ur : UndoRedo
    ur.what = "delete link {id} {pin} {lid}"
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
    create_undo(ur)