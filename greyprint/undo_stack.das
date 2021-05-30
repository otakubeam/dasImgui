options indenting = 4
options remove_unused_symbols = false

module undo_stack

require instructions public
require preview

require daslib/json_boost public

struct UndoRedo
    what : string
    undo : lambda
    redo : lambda

var g_UndoStack : array<UndoRedo>
var g_UndoStackTop = 0
var g_UndoLastInstruction : string
var g_UndoFindInstruction : function<(id:string):Instruction?>

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
def find_undo_instruction(id:string)
    var res = invoke(g_UndoFindInstruction, id)
    assert(res!=null,"instruction not found")
    return res

[private]
def restore_instruction(id:string;json:string)
    var inst = find_undo_instruction(id)
    var error = ""
    var jv = read_json(json,error)
    if jv!=null
        inst->from_JV(jv)
    else
        // TODO: better error reporting
        print("{error}\nfailed to restore {id} from {json}\n")
    unsafe
        delete jv

def undo_instruction(id,name:string)
    let before = g_UndoLastInstruction
    var ur : UndoRedo
    var inst = find_undo_instruction(id)
    var jv = inst->JV()
    var after = write_json(jv)
    unsafe
        delete jv
    ur.what = "instruction {id} {name}"
    ur.undo <- @ <|
        restore_instruction(id,before) // select and navigate?
        update_preview()
    ur.redo <- @ <|
        restore_instruction(id,after)  // select and navigate?
        update_preview()
    create_undo(ur)