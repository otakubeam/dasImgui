options indenting = 4
options remove_unused_symbols = false

module instructions_ui

require instructions public
require preview

require rtti
require daslib/imgui_boost public
require daslib/glfw_boost
require daslib/safe_addr
require math

let DEFAULT_NODE_WIDTH  = 500.
let DEFAULT_ELEMENT_WIDTH = DEFAULT_NODE_WIDTH - 20.
let DEFAULT_NAMED_ELEMENT_WIDTH = DEFAULT_NODE_WIDTH - 20.

def NodeEditEnumeration(mode:EditMode; id,name:string; var op : auto&)
    SetNextItemWidth(DEFAULT_NAMED_ELEMENT_WIDTH)
    Text(name)
    if EmbeddedListBox("{name}##{id}{mode}_Enumeration", op)
        update_preview()
        return true
    else
        return false

def NodeColorEditor4(mode:EditMode; id,name:string; var data:float4&)
    Dummy(float2(DEFAULT_ELEMENT_WIDTH - CalcTextSize(name).x,0.))
    SameLine()
    Text(name)
    SetNextItemWidth(DEFAULT_ELEMENT_WIDTH - 50.)
    var flags = ImGuiColorEditFlags AlphaBar
    if mode==EditMode Embedded
        flags |= ImGuiColorEditFlags NoTooltip | ImGuiColorEditFlags NoOptions
    if ColorPicker4("##{name}{id}{mode}_ColorEditor4",safe_addr(data.x),flags)
        update_preview()
        return true
    else
        return false

def NodeInputInt2(mode:EditMode; id,name:string; var data:int2&)
    SetNextItemWidth(DEFAULT_NAMED_ELEMENT_WIDTH - CalcTextSize(name).x)
    if InputInt2("{name}##{id}{mode}_DragFloat",safe_addr(data.x))
        update_preview()
        return true
    else
        return false

def NodeDragFloat(mode:EditMode; id,name:string; var data:float&; step:float=0.01f)
    SetNextItemWidth(DEFAULT_NAMED_ELEMENT_WIDTH - CalcTextSize(name).x)
    if DragFloat("{name}##{id}{mode}_DragFloat",safe_addr(data),step)
        update_preview()
        return true
    else
        return false

def NodeCheckbox(mode:EditMode; id,name:string; var data:bool&)
    SetNextItemWidth(DEFAULT_NAMED_ELEMENT_WIDTH -  - CalcTextSize(name).x)
    if Checkbox("{name}##{id}{mode}_Checkbox",safe_addr(data))
        update_preview()
        return true
    else
        return false

def make_prewview_rgba_texture ( var s : Surface )
    var rgba : array<uint>
    rgba |> resize(s.size.x * s.size.y)
    for col,val in s.data,rgba
        val = pack_float_to_byte(col * float4(255.0f))  // todo: HDR conversion?
    let preview = make_rgba_texture(s.size.x, s.size.y, gl_array_ptr(rgba))
    delete rgba
    return preview

def generate_preview(var inst:Instruction?; outp:string)
    g_PreviewInstruction = inst
    g_PreviewOutput = outp
    var surf <- inst->generate()
    var tex = 0u
    for op,opi in inst.outputs,range(100500)
        if op.name==outp
            assert(surf[opi] is surface)
            tex = make_prewview_rgba_texture(surf[opi] as surface)
            break
    assert(tex!=0u,"could not generate preview")
    delete surf
    if g_PreviewTexture != 0u
        glDeleteTextures(1, safe_addr(g_PreviewTexture))
    g_PreviewTexture = tex

def update_preview
    if g_LivePreview && g_PreviewInstruction!=null
        generate_preview(g_PreviewInstruction, g_PreviewOutput)
