options indenting = 4
options remove_unused_symbols = false

module imgui_node_editor_boost shared

require imgui public
require imgui_node_editor public

def Begin ( name:string; sz:float2; blk:block )
    Begin(name, sz)
    invoke(blk)
    imgui_node_editor::End()

def BeginNode ( id:int; blk:block )
    BeginNode(id)
    invoke(blk)
    EndNode()

def BeginPin ( id:int; kind:PinKind; blk:block )
    BeginPin(id,kind)
    invoke(blk)
    EndPin()