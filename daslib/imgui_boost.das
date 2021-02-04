options indenting = 4
options remove_unused_symbols = false

module imgui_boost shared

require imgui public
require glfw
require imgui_app
require daslib/safe_addr

/*
    TODO:   add test which compares bitfields with ImGui flags
        that way when version is updated, we can catch and adjust

    NOTE:
        current flags are for the version 1.81
*/

bitfield ImGuiBackendFlags
    HasGamepad
    HasMouseCursors
    HasSetMousePos
    RendererHasVtxOffset

bitfield ImGuiConfigFlags
    NavEnableKeyboard
    NavEnableGamepad
    NavEnableSetMousePos
    NavNoCaptureKeyboard
    NoMouse
    NoMouseCursorChange
    _bit6
    _bit7
    _bit8
    _bit9
    _bit10
    _bit11
    _bit12
    _bit13
    _bit14
    _bit15
    _bit16
    _bit17
    _bit18
    _bit19
    IsSRGB
    IsTouchScreen

bitfield ImGuiSliderFlags
    _bit0
    _bit1
    _bit2
    _bit3
    AlwaysClamp
    Logarithmic
    NoRoundToFormat
    NoInput

bitfield ImGuiWindowFlags
    NoTitleBar
    NoResize
    NoMove
    NoScrollbar
    NoScrollWithMouse
    NoCollapse
    AlwaysAutoResize
    NoBackground
    NoSavedSettings
    NoMouseInputs
    MenuBar
    HorizontalScrollbar
    NoFocusOnAppearing
    NoBringToFrontOnFocus
    AlwaysVerticalScrollbar
    AlwaysHorizontalScrollbar
    AlwaysUseWindowPadding
    _bit17
    NoNavInputs
    NoNavFocus
    UnsavedDocument
    _bit21
    _bit22
    NavFlattened
    ChildWindow
    Tooltip
    Popup
    Modal
    ChildMenu

let
    ImGuiWindowFlags_NoNav        = ImGuiWindowFlags NoNavInputs | ImGuiWindowFlags NoNavFocus
    ImGuiWindowFlags_NoDecoration = ImGuiWindowFlags NoTitleBar | ImGuiWindowFlags NoResize | ImGuiWindowFlags NoScrollbar | ImGuiWindowFlags NoCollapse
    ImGuiWindowFlags_NoInputs     = ImGuiWindowFlags NoMouseInputs | ImGuiWindowFlags NoNavInputs | ImGuiWindowFlags NoNavFocus

bitfield ImGuiCond
    Always
    Once
    FirstUseEver
    Appearing

bitfield ImGuiTableFlags
    Resizable
    Reorderable
    Hideable
    Sortable
    NoSavedSettings
    ContextMenuInBody
    RowBg
    BordersInnerH
    BordersOuterH
    BordersInnerV
    BordersOuterV
    NoBordersInBody
    NoBordersInBodyUntilResize
    _bit13
    _bit14
    _bit15
    NoHostExtendX
    NoHostExtendY
    NoKeepColumnsVisible
    PreciseWidths
    NoClip
    PadOuterX
    NoPadOuterX
    NoPadInnerX
    ScrollX
    ScrollY
    SortMulti
    SortTristate

let
    ImGuiTableFlags_SizingFixedFit             = bitfield(1 << 13)
    ImGuiTableFlags_SizingFixedSame            = bitfield(2 << 13)
    ImGuiTableFlags_SizingStretchProp          = bitfield(3 << 13)
    ImGuiTableFlags_SizingStretchSame          = bitfield(4 << 13)

let
    ImGuiTableFlags_BordersH                   = ImGuiTableFlags BordersInnerH | ImGuiTableFlags BordersOuterH
    ImGuiTableFlags_BordersV                   = ImGuiTableFlags BordersInnerV | ImGuiTableFlags BordersOuterV
    ImGuiTableFlags_BordersInner               = ImGuiTableFlags BordersInnerV | ImGuiTableFlags BordersInnerH
    ImGuiTableFlags_BordersOuter               = ImGuiTableFlags BordersOuterV | ImGuiTableFlags BordersOuterH
    ImGuiTableFlags_Borders                    = ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersOuter

bitfield ImGuiSelectableFlags
    DontClosePopups
    SpanAllColumns
    AllowDoubleClick
    Disabled
    AllowItemOverlap

bitfield ImGuiInputTextFlags
    CharsDecimal
    CharsHexadecimal
    CharsUppercase
    CharsNoBlank
    AutoSelectAll
    EnterReturnsTrue
    CallbackCompletion
    CallbackHistory
    CallbackAlways
    CallbackCharFilter
    AllowTabInput
    CtrlEnterForNewLine
    NoHorizontalScroll
    AlwaysInsertMode
    ReadOnly
    Password
    NoUndoRedo
    CharsScientific
    CallbackResize
    CallbackEdit

def Begin(name:string; p_open:bool?; flags:ImGuiWindowFlags  = bitfield(0))
    return imgui::Begin(name,p_open,int(flags))

def GetKeyIndex(key:ImGuiKey_)
    return imgui::GetKeyIndex(int(key))

def CheckboxFlags(lab:string; var flags:int&; flags_value:bitfield ) : bool
    return imgui::CheckboxFlags(lab,safe_addr(flags),int(flags_value))

def CheckboxFlags(lab:string; var flags:uint&; flags_value:bitfield ) : bool
    return imgui::CheckboxFlags(lab,safe_addr(flags),uint(flags_value))

def Checkbox(lab:string; var cb:bool& ) : bool
    return imgui::Checkbox(lab,safe_addr(cb))

def SliderFloat(lab:string; var v:float&;  v_min,v_max:float; format:string = "%.3f"; flags:ImGuiSliderFlags = bitfield(0))
    return imgui::SliderFloat(lab, safe_addr(v), v_min, v_max, format, int(flags))

def MenuItem(lab:string;shortcut:string;var p_selected:bool&;enabled:bool=true)
    return imgui::MenuItem(lab,shortcut,safe_addr(p_selected),enabled)

def MenuItem(lab:string;var p_selected:bool&;enabled:bool=true)
    return imgui::MenuItem(lab,"",safe_addr(p_selected),enabled)

def SetWindowPos(pos:ImVec2;cond:ImGuiCond = bitfield(0))
    imgui::SetWindowPos(pos,int(cond))

def SetNextWindowPos(pos:ImVec2;cond:ImGuiCond = bitfield(0);pivot:ImVec2 = ImVec2(0., 0.))
    imgui::SetNextWindowPos(pos,int(cond),pivot)

def SetNextWindowSize(siz:ImVec2;cond:ImGuiCond  = bitfield(0))
    imgui::SetNextWindowSize(siz,int(cond))

def Button(txt:string)
    return imgui::Button(txt,ImVec2(0.,0.))

def BeginTable(str_id:string;column:int;flags:ImGuiTableFlags = bitfield(0); outer_size:ImVec2 = ImVec2(0.0f, 0.0f); inner_width : float =  0.0f)
    return imgui::BeginTable(str_id,column,int(flags),outer_size,inner_width)

def Selectable(lab:string; selected:bool = false; flags:ImGuiSelectableFlags = bitfield(0); siz:ImVec2 = ImVec2(0.0f,0.0f))
    return imgui::Selectable(lab,selected,int(flags),siz)

def Selectable(lab:string; var selected:bool&; flags:ImGuiSelectableFlags = bitfield(0); siz:ImVec2 = ImVec2(0.0f,0.0f))
    return imgui::Selectable(lab,safe_addr(selected),int(flags),siz)

def InputFloat(lab:string; var v:float&; step:float = 0.0f; step_fast:float = 0.0f; format:string = "%.3f"; flags : ImGuiInputTextFlags = bitfield(0))
    return imgui::InputFloat(lab,safe_addr(v),step,step_fast,format,int(flags))
