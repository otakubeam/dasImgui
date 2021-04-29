options indenting = 4
options remove_unused_symbols = false

module imgui_node_editor_boost shared

require imgui public
require imgui_node_editor public

typedef
    LinkId = int
    PinId = int
    NodeId = int

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

def BeginCreate ( color:float4 = float4(1); thickness:float = 1.0f; blk:block )
    if BeginCreate(color,thickness)
        invoke(blk)
    EndCreate()

def BeginDelete ( blk : block )
    if BeginDelete()
        invoke(blk)
    EndDelete()
