options indenting = 4
options remove_unused_symbols = false

module imnodes_boost shared

require imgui public
require imnodes public

def BeginNodeEditor ( blk:block )
    BeginNodeEditor()
    invoke(blk)
    EndNodeEditor()

def BeginNode ( id:int; blk:block )
    BeginNode(id)
    invoke(blk)
    EndNode()

def BeginNodeTitleBar ( blk:block )
    BeginNodeTitleBar()
    invoke(blk)
    EndNodeTitleBar()

def BeginInputAttribute ( id:int; shape:ImNodesPinShape; blk:block )
    BeginInputAttribute(id,shape)
    invoke(blk)
    EndInputAttribute()

def BeginInputAttribute ( id:int; blk:block )
    BeginInputAttribute(id,ImNodesPinShape CircleFilled)
    invoke(blk)
    EndInputAttribute()

def BeginOutputAttribute ( id:int; shape:ImNodesPinShape; blk:block )
    BeginOutputAttribute(id,shape)
    invoke(blk)
    EndInputAttribute()

def BeginOutputAttribute ( id:int; blk:block )
    BeginOutputAttribute(id,ImNodesPinShape CircleFilled)
    invoke(blk)
    EndInputAttribute()
