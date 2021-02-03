require imgui
require glfw
require imgui_app
require daslib/safe_addr
require daslib/imgui_boost

def HelpMarker(desc:string)
    imgui::TextDisabled("(?)");
    if imgui::IsItemHovered()
        imgui::BeginTooltip()
        imgui::PushTextWrapPos(imgui::GetFontSize() * 35.0f)
        imgui::TextUnformatted(desc)
        imgui::PopTextWrapPos()
        imgui::EndTooltip()

def safe_io_addr(var expr : auto&)
    unsafe
        return addr(expr)

def showDemoWindow
    if imgui::CollapsingHeader("Configuration")
        var io & = imgui::GetIO()
        if imgui::TreeNode("Configuration##2")
            imgui::CheckboxFlags("io.ConfigFlags: NavEnableKeyboard",    safe_io_addr(io.ConfigFlags),
                int(ImGuiConfigFlags_ ImGuiConfigFlags_NavEnableKeyboard))
            imgui::SameLine(); HelpMarker("Enable keyboard controls.")
            imgui::CheckboxFlags("io.ConfigFlags: NavEnableGamepad",     safe_io_addr(io.ConfigFlags),
                int(ImGuiConfigFlags_ ImGuiConfigFlags_NavEnableGamepad))
            imgui::SameLine(); HelpMarker("Enable gamepad controls. Require backend to set io.BackendFlags |= ImGuiBackendFlags_HasGamepad.\n\nRead instructions in imgui.cpp for details.")
            imgui::CheckboxFlags("io.ConfigFlags: NavEnableSetMousePos", safe_io_addr(io.ConfigFlags),
                int(ImGuiConfigFlags_ ImGuiConfigFlags_NavEnableSetMousePos))
            imgui::SameLine(); HelpMarker("Instruct navigation to move the mouse cursor. See comment for ImGuiConfigFlags_NavEnableSetMousePos.")
            imgui::CheckboxFlags("io.ConfigFlags: NoMouse",              safe_io_addr(io.ConfigFlags),
                int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouse))
            if (io.ConfigFlags & int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouse)) != 0
                if (float(imgui::GetTime()) % 0.40f) < 0.20f
                    imgui::SameLine()
                    imgui::Text("<<PRESS SPACE TO DISABLE>>")
                if imgui::IsKeyPressed(imgui::GetKeyIndex(int(ImGuiKey_ ImGuiKey_Space)))
                    io.ConfigFlags &= ~int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouse);
            imgui::CheckboxFlags("io.ConfigFlags: NoMouseCursorChange", safe_io_addr(io.ConfigFlags),
                int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouseCursorChange))
            imgui::SameLine(); HelpMarker("Instruct backend to not alter mouse cursor shape and visibility.")
            imgui::Checkbox("io.ConfigInputTextCursorBlink", safe_io_addr(io.ConfigInputTextCursorBlink))
            imgui::SameLine(); HelpMarker("Enable blinking cursor (optional as some users consider it to be distracting)")
            imgui::Checkbox("io.ConfigDragClickToInputText", safe_io_addr(io.ConfigDragClickToInputText))
            imgui::SameLine(); HelpMarker("Enable turning DragXXX widgets into text input with a simple mouse click-release (without moving).")
            imgui::Checkbox("io.ConfigWindowsResizeFromEdges", safe_io_addr(io.ConfigWindowsResizeFromEdges))
            imgui::SameLine(); HelpMarker("Enable resizing of windows from their edges and from the lower-left corner.\nThis requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback.")
            imgui::Checkbox("io.ConfigWindowsMoveFromTitleBarOnly", safe_io_addr(io.ConfigWindowsMoveFromTitleBarOnly))
            imgui::Checkbox("io.MouseDrawCursor", safe_io_addr(io.MouseDrawCursor))
            imgui::SameLine(); HelpMarker("Instruct Dear ImGui to render a mouse cursor itself. Note that a mouse cursor rendered via your application GPU rendering path will feel more laggy than hardware cursor, but will be more in sync with your other visuals.\n\nSome desktop applications may use both kinds of cursors (e.g. enable software cursor only when resizing/dragging something).")
            imgui::Text("Also see Style->Rendering for rendering options.")
            imgui::TreePop()
            imgui::Separator()
        if imgui::TreeNode("Backend Flags")
            HelpMarker(
                "Those flags are set by the backends (imgui_impl_xxx files) to specify their capabilities.\n" +
                "Here we expose then as read-only fields to avoid breaking interactions with your backend.")
            // Make a local copy to avoid modifying actual backend flags.
            var backend_flags = io.BackendFlags
            imgui::CheckboxFlags("io.BackendFlags: HasGamepad",           safe_addr(backend_flags),
                int(ImGuiBackendFlags_ ImGuiBackendFlags_HasGamepad))
            imgui::CheckboxFlags("io.BackendFlags: HasMouseCursors",      safe_addr(backend_flags),
                int(ImGuiBackendFlags_ ImGuiBackendFlags_HasMouseCursors))
            imgui::CheckboxFlags("io.BackendFlags: HasSetMousePos",       safe_addr(backend_flags),
                int(ImGuiBackendFlags_ ImGuiBackendFlags_HasSetMousePos))
            imgui::CheckboxFlags("io.BackendFlags: RendererHasVtxOffset", safe_addr(backend_flags),
                int(ImGuiBackendFlags_ ImGuiBackendFlags_RendererHasVtxOffset))
            imgui::TreePop()
            imgui::Separator()
        if imgui::TreeNode("Style")
            HelpMarker("The same contents can be accessed in 'Tools->Style Editor' or by calling the ShowStyleEditor() function.")
            imgui::ShowStyleEditor()
            imgui::TreePop()
            imgui::Separator()
        if imgui::TreeNode("Capture/Logging")
            HelpMarker(
                "The logging API redirects all text output so you can easily capture the content of " +
                "a window or a block. Tree nodes can be automatically expanded.\n" +
                "Try opening any of the contents below in this window and then click one of the \"Log To\" button.")
            imgui::LogButtons()
            HelpMarker("You can also call imgui::LogText() to output directly to the log without a visual output.")
            if imgui::Button("Copy \"Hello, world!\" to clipboard", [[ImVec2() x=0.,y=0.]])
                imgui::LogToClipboard()
                imgui::LogText("Hello, world!")
                imgui::LogFinish()
            imgui::TreePop()

[export]
def main
	var f = 0.0
	imgui_app("Testing IMGUI") <|
        imgui::NewFrame()
        imgui::Begin("Position and color")
        imgui::Text("Hello, world!")
        imgui::SliderFloat("float", safe_addr(f), 0.0f, 1.0f)
        imgui::Text("This is text!")
        // imgui::ShowDemoWindow(null)

        showDemoWindow()

        imgui::Render()

