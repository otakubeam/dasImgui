options indenting = 4
options remove_unused_symbols = false

module imgui_boost shared

require imgui public
require glfw
require imgui_app
require daslib/safe_addr

let IM_COL32_WHITE = IM_COL32(255,255,255,255)
let IM_COL32_BLACK = IM_COL32(0,0,0,255)
let IM_COL32_BLACK_TRANS = IM_COL32(0,0,0,0)

def IM_COL32(R,G,B,A:uint)
    return (A<<IM_COL32_A_SHIFT) | (B<<IM_COL32_B_SHIFT) | (G<<IM_COL32_G_SHIFT) | (R<<IM_COL32_R_SHIFT)

def IM_COL32(R,G,B,A:int)
    return (uint(A)<<IM_COL32_A_SHIFT) | (uint(B)<<IM_COL32_B_SHIFT) | (uint(G)<<IM_COL32_G_SHIFT) | (uint(R)<<IM_COL32_R_SHIFT)

def ImVec4 ( col:ImColor )
    return col.Value

def Combo ( lab:string; var current_item:int&; items:array<string>; popul_max_heigh_in_items : int = -1 )
    let nItems = length(items)
    unsafe
        if nItems != 0
            imgui::Combo(lab,addr(current_item),addr(items[0]),nItems,popul_max_heigh_in_items)
        else
            imgui::Combo(lab,addr(current_item),null,0,popul_max_heigh_in_items)

def Combo ( lab:string; var current_item:int&; items:string[]; popul_max_heigh_in_items : int = -1 )
    let nItems = typeinfo(dim items)
    unsafe
        imgui::Combo(lab,addr(current_item),addr(items[0]),nItems,popul_max_heigh_in_items)

