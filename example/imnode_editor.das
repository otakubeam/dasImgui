options persistent_heap = true
options persistent_string_heap = true

require imgui_app
require daslib/glfw_boost
require daslib/imgui_boost
require daslib/static_let

require imnodes

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
    imnodes::Initialize()
    var io & = imgui::GetIO()
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
    imnodes::Shutdown()
    ImGui_ImplOpenGL2_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    DestroyContext(null)
    glfwDestroyWindow(window)
    glfwTerminate()

def EditNode(id:int;cap:string)
    imnodes::BeginNode(id)
    imnodes::BeginNodeTitleBar()
    TextUnformatted("{cap} id:{id}")
    imnodes::EndNodeTitleBar()
    imnodes::BeginInputAttribute(id*1000+2)
    Text("input")
    imnodes::EndInputAttribute()
    imnodes::BeginOutputAttribute(id*1000+3)
    Indent(40.)
    Text("output")
    imnodes::EndOutputAttribute()
    imnodes::EndNode()

def LinkNode(lid,id1,id2:int)
    imnodes::Link(lid,id1*1000+2,id2*1000+3)

def EditorDemo()
    static_let <|
        var edc : EditorContext?
    if edc==null
        edc = imnodes::EditorContextCreate()
    Begin("Node editor")
    imnodes::EditorContextSet(edc)
    imnodes::BeginNodeEditor()
    EditNode(1,"One")
    EditNode(2,"Two")
    LinkNode(1234,1,2)
    imnodes::EndNodeEditor()
    End()

[export]
def main
	var f = 0.0
	imgui_app("Testing IMGUI") <|
        NewFrame()
        EditorDemo()
        Render()
