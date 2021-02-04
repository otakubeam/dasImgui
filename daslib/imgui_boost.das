options indenting = 4
options remove_unused_symbols = false

module imgui_boost shared

require imgui public
require glfw
require imgui_app
require daslib/safe_addr

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

bitfield ImGuiCond
    Always
    Once
    FirstUseEver
    Appearing

let
    ImGuiWindowFlags_NoNav        = ImGuiWindowFlags NoNavInputs | ImGuiWindowFlags NoNavFocus
    ImGuiWindowFlags_NoDecoration = ImGuiWindowFlags NoTitleBar | ImGuiWindowFlags NoResize | ImGuiWindowFlags NoScrollbar | ImGuiWindowFlags NoCollapse
    ImGuiWindowFlags_NoInputs     = ImGuiWindowFlags NoMouseInputs | ImGuiWindowFlags NoNavInputs | ImGuiWindowFlags NoNavFocus


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
    return imgui::MenuItem(lab,shortcut,p_selected,enabled)

def MenuItem(lab:string;var p_selected:bool&;enabled:bool=true)
    return imgui::MenuItem(lab,"",p_selected,enabled)

def SetWindowPos(pos:ImVec2;cond:ImGuiCond = bitfield(0))
    imgui::SetWindowPos(pos,int(cond))

def SetNextWindowPos(pos:ImVec2;cond:ImGuiCond = bitfield(0);pivot:ImVec2 = ImVec2(0., 0.))
    imgui::SetNextWindowPos(pos,int(cond),pivot)

def SetNextWindowSize(siz:ImVec2;cond:ImGuiCond  = bitfield(0))
    imgui::SetNextWindowSize(siz,int(cond))
