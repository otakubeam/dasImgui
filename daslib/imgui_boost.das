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
