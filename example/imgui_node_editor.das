options persistent_heap = true
options persistent_string_heap = true

require imgui_app
require daslib/glfw_boost
require daslib/imgui_boost
require daslib/static_let
require daslib/safe_addr
require daslib/imgui_node_editor_boost

var window : GLFWwindow?

def imgui_app ( title:string; blk : block )
    if glfwInit()==0
		panic("can't init glfw")
    window = glfwCreateWindow(1920, 1280, title, null, null)
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

def MainMenu()
    BeginMenuBar <|
        BeginMenu("File") <|
            pass
        BeginMenu("Edit") <|
            MenuItem("Undo", "CTRL+Z") <|
                pass
            MenuItem("Redo", "CTRL+Y", false, false) <|
                pass
            Separator()
            MenuItem("Cut", "CTRL+X") <|
                pass
            MenuItem("Copy", "CTRL+C") <|
                pass
            MenuItem("Paste", "CTRL+V") <|
                pass


var g_Context : EditorContext?

struct LinkInfo
    Id : LinkId
    InputId : PinId
    OutputId : PinId

def ImGuiEx_BeginColumn()
    BeginGroup()

def ImGuiEx_NextColumn()
    EndGroup()
    SameLine()
    BeginGroup()

def ImGuiEx_EndColumn()
    EndGroup()

def EditorDemo()
    if g_Context == null
        var config = Config()
        config.SettingsFile = "Simple.json"
        g_Context = CreateEditor(safe_addr(config))
    // this is how we make sure node editor is full window and resizes
    Begin("Node editor",null,ImGuiWindowFlags MenuBar | ImGuiWindowFlags NoTitleBar | ImGuiWindowFlags NoResize | ImGuiWindowFlags NoMove) <|
        var IO & = imgui::GetIO()
        SetWindowPos(float2(0.,0.), ImGuiCond Once)
        SetWindowSize(float2(IO.DisplaySize.x,IO.DisplaySize.y), ImGuiCond Always)
        // main menu
        MainMenu()
        // editor
        SetCurrentEditor(g_Context)
        static_let <|
            var g_FirstFrame = true
            var g_Links : array<LinkInfo>
            var g_NextLinkId = 100
        Begin("My Editor", float2(0.0, 0.0f)) <|
            var uniqueId = 1
            //
            // 1) Commit known data to editor
            //
            // Submit Node A
            let nodeA_Id = uniqueId++
            let nodeA_InputPinId = uniqueId++
            let nodeA_OutputPinId = uniqueId++
            if g_FirstFrame
                SetNodePosition(nodeA_Id, float2(10, 10))
            BeginNode(nodeA_Id) <|
                Text("Node A")
                BeginPin(nodeA_InputPinId, PinKind Input) <|
                    Text("-> In")
                SameLine()
                BeginPin(nodeA_OutputPinId, PinKind Output) <|
                    Text("Out ->")
            // Submit Node B
            let nodeB_Id = uniqueId++
            let nodeB_InputPinId1 = uniqueId++
            let nodeB_InputPinId2 = uniqueId++
            let nodeB_OutputPinId = uniqueId++
            if g_FirstFrame
                SetNodePosition(nodeB_Id, float2(210, 60))
            BeginNode(nodeB_Id) <|
                Text("Node B")
                ImGuiEx_BeginColumn()
                BeginPin(nodeB_InputPinId1, PinKind Input) <|
                    Text("-> In1")
                BeginPin(nodeB_InputPinId2, PinKind Input) <|
                    Text("-> In2")
                ImGuiEx_NextColumn()
                BeginPin(nodeB_OutputPinId, PinKind Output) <|
                    Text("Out ->")
                ImGuiEx_EndColumn()
            // Submit Links
            for linkInfo in g_Links
                Link(linkInfo.Id, linkInfo.InputId, linkInfo.OutputId)
            //
            // 2) Handle interactions
            //
            // Handle creation action, returns true if editor want to create new object (node or link)
            BeginCreate(float4(1), 1.0f) <|
                var inputPinId, outputPinId : PinId
                if QueryNewLink(safe_addr(inputPinId), safe_addr(outputPinId))
                    // QueryNewLink returns true if editor want to create new link between pins.
                    //
                    // Link can be created only for two valid pins, it is up to you to
                    // validate if connection make sense. Editor is happy to make any.
                    //
                    // Link always goes from input to output. User may choose to drag
                    // link from output pin or input pin. This determine which pin ids
                    // are valid and which are not:
                    //   * input valid, output invalid - user started to drag new ling from input pin
                    //   * input invalid, output valid - user started to drag new ling from output pin
                    //   * input valid, output valid   - user dragged link over other pin, can be validated
                    if inputPinId!=0 && outputPinId!=0 // both are valid, let's accept link
                        // ed::AcceptNewItem() return true when user release mouse button.
                        if AcceptNewItem()
                            // Since we accepted new link, lets add one to our list of links.
                            let newLinkId = g_NextLinkId++
                            g_Links |> push([[LinkInfo Id=newLinkId, InputId=inputPinId, OutputId=outputPinId]])
                            // Draw new link.
                            Link(newLinkId, inputPinId, outputPinId)
                        // You may choose to reject connection between these nodes
                        // by calling ed::RejectNewItem(). This will allow editor to give
                        // visual feedback by changing link thickness and color.
            // Handle deletion action
            BeginDelete() <|
                // There may be many links marked for deletion, let's loop over them.
                var deletedLinkId : LinkId
                while QueryDeletedLink(safe_addr(deletedLinkId),null,null)
                    // If you agree that link can be deleted, accept deletion.
                    if AcceptDeletedItem()
                        let index = find_index_if(g_Links) <| $ ( lnk )
                            return lnk.Id == deletedLinkId
                        if index != -1
                            g_Links |> erase(index)
                    // You may reject link deletion by calling:
                    // ed::RejectDeletedItem();


        if g_FirstFrame
            NavigateToContent(0.0f)
        SetCurrentEditor(null)
        g_FirstFrame = false



[export]
def main
	let t = SaveReasonFlags None
	imgui_app("Testing IMGUI") <|
        NewFrame()
        EditorDemo()
        Render()
    DestroyEditor(g_Context)

