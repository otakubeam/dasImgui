require imgui_app
require daslib/glfw_boost
require daslib/imgui_boost

def imgui_app ( title:string; blk : block )
    if glfwInit()==0
		panic("can't init glfw")
    var window = glfwCreateWindow(1280, 720, title, null, null)
    if window==null
		panic("can't create window")
    glfwMakeContextCurrent(window)
    glfwSwapInterval(1)
    CreateContext(null)
    var io & = GetIO()
    io.FontGlobalScale = 2.0;   // BBATKIN: note - my monitor is HUGE
    StyleColorsDark(null)
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL2_Init()
    var clear_color = float4(0.45f, 0.55f, 0.60f, 1.00f)
    while glfwWindowShouldClose(window)==0
        glfwPollEvents()
        ImGui_ImplOpenGL2_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        invoke(blk)
        var display_w, display_h : int
        glfwGetFramebufferSize(window, display_w, display_h)
        glViewport(0, 0, display_w, display_h)
        glClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL2_RenderDrawData(GetDrawData())
        glfwMakeContextCurrent(window)
        glfwSwapBuffers(window)
    ImGui_ImplOpenGL2_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    DestroyContext(null)
    glfwDestroyWindow(window)
    glfwTerminate()

def HelpMarker(desc:string)
    TextDisabled("(?)");
    if IsItemHovered()
        BeginTooltip()
        PushTextWrapPos(GetFontSize() * 35.0f)
        TextUnformatted(desc)
        PopTextWrapPos()
        EndTooltip()

def showDemoWindow
    if CollapsingHeader("Configuration")
        var io & = GetIO()
        if TreeNode("Configuration##2")
            CheckboxFlags("io.ConfigFlags: NavEnableKeyboard", io.ConfigFlags,ImGuiConfigFlags NavEnableKeyboard)
            SameLine(); HelpMarker("Enable keyboard controls.")
            CheckboxFlags("io.ConfigFlags: NavEnableGamepad", io.ConfigFlags, ImGuiConfigFlags NavEnableGamepad)
            SameLine(); HelpMarker("Enable gamepad controls. Require backend to set io.BackendFlags |= ImGuiBackendFlags_HasGamepad.\n\nRead instructions in imgui.cpp for details.")
            CheckboxFlags("io.ConfigFlags: NavEnableSetMousePos", io.ConfigFlags, ImGuiConfigFlags NavEnableSetMousePos)
            SameLine(); HelpMarker("Instruct navigation to move the mouse cursor. See comment for ImGuiConfigFlags_NavEnableSetMousePos.")
            CheckboxFlags("io.ConfigFlags: NoMouse", io.ConfigFlags, ImGuiConfigFlags NoMouse)
            var icf : ImGuiConfigFlags = ImGuiConfigFlags(io.ConfigFlags)
            if ImGuiConfigFlags(io.ConfigFlags).NoMouse
                if (float(GetTime()) % 0.40f) < 0.20f
                    SameLine()
                    Text("<<PRESS SPACE TO DISABLE>>")
                if IsKeyPressed(GetKeyIndex(ImGuiKey_ ImGuiKey_Space))
                    io.ConfigFlags &= ~int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouse);
            CheckboxFlags("io.ConfigFlags: NoMouseCursorChange", io.ConfigFlags, ImGuiConfigFlags NoMouseCursorChange)
            SameLine(); HelpMarker("Instruct backend to not alter mouse cursor shape and visibility.")
            Checkbox("io.ConfigInputTextCursorBlink", io.ConfigInputTextCursorBlink)
            SameLine(); HelpMarker("Enable blinking cursor (optional as some users consider it to be distracting)")
            Checkbox("io.ConfigDragClickToInputText", io.ConfigDragClickToInputText)
            SameLine(); HelpMarker("Enable turning DragXXX widgets into text input with a simple mouse click-release (without moving).")
            Checkbox("io.ConfigWindowsResizeFromEdges", io.ConfigWindowsResizeFromEdges)
            SameLine(); HelpMarker("Enable resizing of windows from their edges and from the lower-left corner.\nThis requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback.")
            Checkbox("io.ConfigWindowsMoveFromTitleBarOnly", io.ConfigWindowsMoveFromTitleBarOnly)
            Checkbox("io.MouseDrawCursor", io.MouseDrawCursor)
            SameLine(); HelpMarker("Instruct Dear ImGui to render a mouse cursor itself. Note that a mouse cursor rendered via your application GPU rendering path will feel more laggy than hardware cursor, but will be more in sync with your other visuals.\n\nSome desktop applications may use both kinds of cursors (e.g. enable software cursor only when resizing/dragging something).")
            Text("Also see Style->Rendering for rendering options.")
            TreePop()
            Separator()
        if TreeNode("Backend Flags")
            HelpMarker(
                "Those flags are set by the backends (imgui_impl_xxx files) to specify their capabilities.\n" +
                "Here we expose then as read-only fields to avoid breaking interactions with your backend.")
            // Make a local copy to avoid modifying actual backend flags.
            var backend_flags = io.BackendFlags
            CheckboxFlags("io.BackendFlags: HasGamepad", backend_flags, ImGuiBackendFlags HasGamepad)
            CheckboxFlags("io.BackendFlags: HasMouseCursors", backend_flags, ImGuiBackendFlags HasMouseCursors)
            CheckboxFlags("io.BackendFlags: HasSetMousePos", backend_flags, ImGuiBackendFlags HasSetMousePos)
            CheckboxFlags("io.BackendFlags: RendererHasVtxOffset", backend_flags, ImGuiBackendFlags RendererHasVtxOffset)
            TreePop()
            Separator()
        if TreeNode("Style")
            HelpMarker("The same contents can be accessed in 'Tools->Style Editor' or by calling the ShowStyleEditor() function.")
            ShowStyleEditor()
            TreePop()
            Separator()
        if TreeNode("Capture/Logging")
            HelpMarker(
                "The logging API redirects all text output so you can easily capture the content of " +
                "a window or a block. Tree nodes can be automatically expanded.\n" +
                "Try opening any of the contents below in this window and then click one of the \"Log To\" button.")
            LogButtons()
            HelpMarker("You can also call LogText() to output directly to the log without a visual output.")
            if Button("Copy \"Hello, world!\" to clipboard", ImVec2(0.,0.))
                LogToClipboard()
                LogText("Hello, world!")
                LogFinish()
            TreePop()

[export]
def main
	var f = 0.0
	imgui_app("Testing IMGUI") <|
        NewFrame()
        Begin("Position and color")
        Text("Hello, world!")
        SliderFloat("float", f, 0.0f, 1.0f)
        Text("This is text!")
        // imgui::ShowDemoWindow(null)
        showDemoWindow()
        Render()

