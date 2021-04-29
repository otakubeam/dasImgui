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
        Begin("My Editor", float2(0.0, 0.0f)) <|
            var uniqueId = 1
            for n in range(3)
                BeginNode(uniqueId++) <|
                    Text("Node {n}")
                    BeginPin(uniqueId++, PinKind Input) <|
                        Text("-> In")
                    SameLine()
                    BeginPin(uniqueId++, PinKind Output) <|
                        Text("Out ->")
        SetCurrentEditor(null)


[export]
def main
	let t = SaveReasonFlags None
	imgui_app("Testing IMGUI") <|
        NewFrame()
        EditorDemo()
        Render()
    DestroyEditor(g_Context)

