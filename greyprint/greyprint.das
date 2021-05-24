options persistent_heap = true
options persistent_string_heap = true

require fio
require imgui_app
require math
require rtti

require daslib/glfw_boost
require daslib/imgui_boost
require daslib/static_let
require daslib/safe_addr
require daslib/imgui_node_editor_boost
require daslib/strings_boost

require instructions
require instructions_ui
require preview
require guid_2_id
require command_que

// note - can be different model for every new editor type
require instructions_model

let NAVIGATION_TIME = 0.5

// window and app

var window : GLFWwindow?
var g_Context : EditorContext?

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
    io.FontGlobalScale = 2.0
    imgui::GetStyle() |> ScaleAllSizes(2.0)

    StyleColorsDark(null)
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL2_Init()
    var clear_color = float4(0.05f, 0.05f, 0.15f, 1.00f) // float4(0.45f, 0.55f, 0.60f, 1.00f)
    while glfwWindowShouldClose(window)==0
        glfwPollEvents()
        ImGui_ImplOpenGL2_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        invoke(blk)
        var display_w, display_h : int
        glfwGetFramebufferSize(window, display_w, display_h)
        glViewport(0, 0, display_w, display_h)
        glClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w)
        glClearDepth(1.0lf)
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
        draw_preview(display_w, display_h)
        ImGui_ImplOpenGL2_RenderDrawData(GetDrawData())
        glfwMakeContextCurrent(window)
        glfwSwapBuffers(window)
    ImGui_ImplOpenGL2_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    DestroyContext(null)
    glfwDestroyWindow(window)
    glfwTerminate()

// PROJECT

var g_Project <- Project()
var g_FirstFrame = true

def translate_input_output_id ( id:int; typ:string ) : tuple<inst:Instruction?; pin:string> const
    assert(id_2_guid |> key_exists(id))
    var note <- split(id_2_guid[id]," ")
    assert(note[0]==typ)
    let instr = g_Project->find_instruction(note[1])
    assert(instr!=null)
    let val = [[auto instr, note[2]]]
    delete note
    return val

def make_sample_project(var self:Project)
    self->clear()
    // 1st example
    var src_node = new Instruction_SolidColor()
    var dst_node = new Instruction_Gradient()
    var blend_node = new Instruction_Blend()
    blend_node.inputs[0] |> connect(src_node,"Out")
    blend_node.inputs[1] |> connect(dst_node,"Out")
    self->add_new_insturction(src_node)
    self->add_new_insturction(dst_node)
    self->add_new_insturction(blend_node)
    // now, lets sort everything vertically
    for i,t in self.instructions, range(100500)
        i.at = float2(0, t*300)

var g_SavedProject : string

def save_project
    SetCurrentEditor(g_Context)
    for inst in g_Project.instructions
        inst.at = GetNodePosition(get_unique_id(inst.id))
    SetCurrentEditor(null)
    var jv = g_Project->save()
    g_SavedProject = write_json(jv)
    print("\n\n\n{g_SavedProject}\n\n\n")
    unsafe
        delete jv

def clear_project_data()
    DestroyEditor(g_Context)
    g_Context = null
    g_Project->clear()
    reset_guids()
    clear_preview()
    g_FirstFrame = true

def new_project()
    post_event <| @
        clear_project_data()

def load_project()
    post_event <| @
        clear_project_data()
        var error : string
        var jv = read_json(g_SavedProject,error)
        g_Project->load(jv)

// MAIN MENU

def main_menu()
    BeginMenuBar <|
        BeginMenu("File") <|
            if MenuItem("New##Project")
                new_project()
            if MenuItem("Load##Project")
                load_project()
            if MenuItem("Save##Project")
                save_project()
        var previewName = ""
        if g_PreviewInstruction != null
            previewName = " {g_PreviewInstruction.name}:{g_PreviewInstruction.id}"
        BeginMenu("Preview{previewName}") <|
            if Checkbox("Live preview",safe_addr(g_LivePreview))
                update_preview()

// NODE EDITOR WINDOW

def in_pin(id: int; blk: block<():void>)
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinArrowSize, 10f)
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinArrowWidth, 10f)
    // imgui_node_editor::PushStyleColor(StyleColor StyleColor_PinRect, float4(1f, 0f, 0f, 1f))
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinCorners, 3f)
    BeginPin(id, PinKind Input) <|
        var io & = GetIO()
        Dummy(float2(10. * io.FontGlobalScale))
        let offset = float2(3, 3)
        let min = GetItemRectMin() - float2(8, 0)
        let max = GetItemRectMax() - float2(8, 0)
        var drawList = GetWindowDrawList()
        // *drawList |> AddRectFilled(min, max, 0xFFFFFFFF)
        *drawList |> AddTriangleFilled(min, float2(max.x, (min.y + max.y) * 0.5), float2(min.x, max.y), 0xFFFFFFFF)
        // *drawList |> AddCircleFilled((min + max) * 0.5, 5f, 0xFFFFFFFF)// 0xFFFFb032)
        PinRect(min - offset, max + offset)
        let pin = float2(min.x, (min.y + max.y) * 0.5) + float2(1, 0)
        PinPivotRect(pin, pin)
        blk |> invoke()
    // imgui_node_editor::PopStyleVar(2)
    // imgui_node_editor::PopStyleColor(1)

def out_pin(id: int; text: string implicit; blk: block<():void>)
    out_pin(id, text, DEFAULT_NODE_WIDTH - CalcTextSize(text).x, blk)

def out_pin(id: int; text: string implicit; indent: float; blk: block<():void>)
    ImGuiEx_BeginColumn()
    if indent > 0f
        imgui::Indent(indent)
    imgui::TextUnformatted(text)
    blk |> invoke()
    ImGuiEx_NextColumn()
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinArrowSize, 10f)
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinArrowWidth, 10f)
    // imgui_node_editor::PushStyleVar(StyleVar StyleVar_PinCorners, 3f)
    // let size = GetNodeSize()
    // SetNextItemWidth(-FLT_MIN)
    BeginPin(id, PinKind Output) <|
        var io & = GetIO()
        Dummy(float2(10. * io.FontGlobalScale))
        let offset = float2(3, 3)
        let min = GetItemRectMin() + float2(8, 3)
        let max = GetItemRectMax() + float2(8, 3)
        var drawList = GetWindowDrawList()
        // *drawList |> AddRectFilled(min, max, 0xFFFFFFFF)
        // *drawList |> AddCircleFilled((min + max) * 0.5, 5f, 0xFFFFFFFF)
        *drawList |> AddTriangleFilled(min, float2(max.x, (min.y + max.y) * 0.5), float2(min.x, max.y), 0xFFFFFFFF)
        PinRect(min - offset, max + offset)
        let pin = float2(min.x, (min.y + max.y) * 0.5) + float2(9, 0)
        PinPivotRect(pin, pin)
    //blk |> invoke()
    // imgui_node_editor::PopStyleVar(2)
    ImGuiEx_EndColumn()

def editor_child_window()
    SetCurrentEditor(g_Context)
    var style & = imgui_node_editor::GetStyle()
    style.NodeRounding = 0f
    style.GroupRounding = 0f
    style.PinRounding = 0f
    style.NodePadding = float4(4)
    style.Colors[int(StyleColor StyleColor_Bg)].w = 0.
    style.Colors[int(StyleColor StyleColor_Grid)].w = 0.
    Begin("My Editor", float2(0.0, 0.0f)) <|
        for inst in g_Project.instructions
            let id = get_unique_id(inst.id)
            BeginNode(id) <|
                Dummy(float2(DEFAULT_NODE_WIDTH,0.))
                ImGuiEx_BeginColumn()
                unsafe
                    Checkbox("##embedded_{inst.id}",addr(inst.editing))
                SameLine()
                Text(inst.name)
                let sz = ImGuiEx_NextColumn()
                SameLine(DEFAULT_NODE_WIDTH - sz.x - CalcTextSize("[X]").x - 2.0)
                if Button("[X]##{inst.id}_E")
                    DeleteNode(get_unique_id(inst.id))
                ImGuiEx_EndColumn()
                if inst.editing
                    inst->edit(EditMode Embedded)
                ImGuiEx_BeginColumn()
                for inp in inst.inputs
                    let inp_id = get_input_unique_id(inst,inp.name)
                    in_pin(inp_id) <|
                        SameLine()
                        Text("{inp.name}:{inp._type}")
                        SameLine()
                        if inp.src != null
                            SameLine()
                            if Button("[G]##goto_{inp}_from_{inst.id}")
                                SelectNode(get_unique_id(inp.src.id), false)
                                NavigateToSelection(false, NAVIGATION_TIME)
                                ClearSelection()
                            SameLine()
                            if Button("[X]##goto_{inp}_from_{inst.id}")
                                DeleteLink(inp_id)
                let lw = ImGuiEx_NextColumn()
                for outp in inst.outputs
                    let outp_id = get_output_unique_id(inst,outp.name)
                    let text = "{outp.name}:{outp._type}"
                    out_pin(outp_id, text, DEFAULT_NODE_WIDTH - CalcTextSize(text).x - lw.x) <|
                        if outp._type==TYPE_SURFACE
                            if Button("[P]##{inst.id}_E")
                                generate_preview(inst,outp.name)
                        else
                            if Button("[E]##{inst.id}_E")
                                var surf <- inst->generate()
                                delete surf
                ImGuiEx_EndColumn()
            if inst.firstFrame
                if inst.at.x==-FLT_MAX
                    CenterNodeOnScreen(get_unique_id(inst.id))
                else
                    SetNodePosition(id, inst.at)
                inst.firstFrame = false
        for inst in g_Project.instructions
            for inp in inst.inputs
                if inp.src != null
                    let inp_id = get_input_unique_id(inst,inp.name)
                    let outp_id = get_output_unique_id(inp.src,inp.output)
                    Link(inp_id, inp_id, outp_id)
        BeginCreate(float4(1), 1.0f) <|
            var inputPinId, outputPinId : PinId
            if QueryNewLink(safe_addr(inputPinId), safe_addr(outputPinId))
                if inputPinId!=0 && outputPinId!=0 // both are valid, let's accept link
                    if inputPinId==outputPinId
                        RejectNewItem()
                    else
                        if id_2_guid[inputPinId] |> starts_with("OUTPUT")
                            swap(inputPinId,outputPinId)
                        if !(id_2_guid[inputPinId] |> starts_with("INPUT")) || !(id_2_guid[outputPinId] |> starts_with("OUTPUT"))
                            RejectNewItem()
                        else
                            var inL = translate_input_output_id(inputPinId,"INPUT")
                            var outL = translate_input_output_id(outputPinId,"OUTPUT")
                            let inI = inL.inst->input_index(inL.pin)
                            assert(inI!=-1)
                            let outI = outL.inst->output_index(outL.pin)
                            assert(outI!=-1)
                            if inL.inst==outL.inst                                              // linking to itself
                                RejectNewItem()
                            elif inL.inst.inputs[inI]._type != outL.inst.outputs[outI]._type    // type mismatch
                                RejectNewItem()
                            elif AcceptNewItem()
                                inL.inst.inputs[inI] |> connect(outL.inst, outL.pin)
        BeginDelete() <|
            var deletedLinkId : LinkId
            while QueryDeletedLink(safe_addr(deletedLinkId),null,null)
                if AcceptDeletedItem()
                    post_event <| @
                        DeleteConnection(deletedLinkId)
            var deletedNodeId : NodeId
            while QueryDeletedNode(safe_addr(deletedNodeId))
                if AcceptDeletedItem()
                    post_event <| @
                        let inst_id = id_2_guid[deletedNodeId]
                        let inst = g_Project->find_instruction(inst_id)
                        assert(inst!=null)
                        DeleteInstruction(inst)
    if g_FirstFrame
        NavigateToContent(NAVIGATION_TIME)
    SetCurrentEditor(null)
    g_FirstFrame = false

// SIDE WINDOW

def DeleteInstruction ( inst:Instruction? )
    g_Project->delete_instruction(inst)
    if g_PreviewInstruction==inst
        g_PreviewInstruction = null

def DeleteConnection ( id:LinkId )
    var inL = translate_input_output_id(id,"INPUT")
    let inI = inL.inst->input_index(inL.pin)
    inL.inst.inputs[inI].src = null

def SideEditInstance( var inst:Instruction?; flags:ImGuiTreeNodeFlags = ImGuiTreeNodeFlags None )
    if TreeNodeEx("side_{inst.id}{flags}",flags,"{inst.name}:{inst.id}")
        if Button("[G]##goto_{inst.id}")
            SelectNode(get_unique_id(inst.id), false)
            NavigateToSelection(false, NAVIGATION_TIME)
            ClearSelection()
        HelpMarker("Center")
        SameLine()
        if Button("<C>##{inst.id}_S")
            CenterNodeOnScreen(get_unique_id(inst.id))
        HelpMarker("Center")
        SameLine()
        Text("id: `{inst.id}`")
        SameLine()
        if Button("[X]##{inst.id}_S")
            DeleteNode(get_unique_id(inst.id))
        HelpMarker("Delete")
        Text("name: `{inst.name}`")      // todo: make editabe
        for outp in inst.outputs
            Text("-> {outp.name}:{outp._type}")
            SameLine()
            if outp._type==TYPE_SURFACE
                if Button("[P]##{inst.id}_S")
                    generate_preview(inst,outp.name)
                HelpMarker("Preview")
            else
                if Button("[E]##{inst.id}_S")
                    var surf <- inst->generate()
                    delete surf
                HelpMarker("Eval")
        inst->edit(EditMode Sidebar)
        TreePop()

def side_child_window()
    SetCurrentEditor(g_Context)
    var style & = imgui::GetStyle()
    PushStyleColor(ImGuiCol ChildBg, style.Colors[int(ImGuiCol WindowBg)])
    BeginChild("Project", float2(600., -FLT_MIN), true)
    if Button("[*]")
        NavigateToContent(NAVIGATION_TIME)
    HelpMarker("Navigate to content")
    if CollapsingHeader("New instruction")
        var prevCategory = ""
        var collapsed = true
        for ai in g_instructionsByCategory
            if prevCategory != ai.category
                if !collapsed
                    TreePop()
                prevCategory = ai.category
                collapsed = !TreeNode(ai.category)
            if !collapsed
                if Button("{ai.name}##make_S")
                    post_event() <| @
                        var inst = make_instruction(ai.tname)
                        g_Project->add_new_insturction(inst)
        if !collapsed
            TreePop()
    var snc = GetSelectedObjectCount()
    if snc != 0
        var sna <- GetSelectedNodes()
        if CollapsingHeader("Selection", ImGuiTreeNodeFlags DefaultOpen)
            if Button("[X]##delete selection")
                for ng in sna
                    if ng != 0
                        DeleteNode(ng)
            HelpMarker("Delete selection")
            SameLine()
            if Button("[.]##navigate to selection")
                NavigateToSelection(false, 0.5)
            HelpMarker("Navigate to selection")
            for ng in sna
                let nid = id_2_guid[ng]
                var inst = g_Project->find_instruction(nid)
                if inst==null
                    print("Not found {ng} -> '{nid}'\n")
                assert(inst!=null)
                SideEditInstance(inst, ImGuiTreeNodeFlags DefaultOpen)
    if CollapsingHeader("Project")
        for inst in g_Project.instructions
            SideEditInstance(inst)
    EndChild()
    imgui::PopStyleColor()
    SetCurrentEditor(null)

// MAIN WINDOW

def main_editor_screen()
    if g_Context == null
        var config = Config()
        config.SettingsFile = "Simple.json"
        g_Context = CreateEditor(safe_addr(config))
        /*
        SetCurrentEditor(g_Context)
        EnableShortcuts(true)
        SetCurrentEditor(null)
        */
    PushStyleVar(ImGuiStyleVar WindowPadding, float2())
    Begin("Surface project editor",null,ImGuiWindowFlags MenuBar | ImGuiWindowFlags NoTitleBar | ImGuiWindowFlags NoResize | ImGuiWindowFlags NoMove | ImGuiWindowFlags NoBackground ) <|
        imgui::PopStyleVar(1)
        var IO & = imgui::GetIO()
        SetWindowPos(float2(0.,0.), ImGuiCond Once)
        SetWindowSize(float2(IO.DisplaySize.x,IO.DisplaySize.y), ImGuiCond Always)
        main_menu()
        side_child_window()
        SameLine()
        BeginChild("Node editor window", float2(0., -FLT_MIN), true, ImGuiWindowFlags NoBackground)
        editor_child_window()
        EndChild()

[export]
def main
    seal_instruction_factory()          // initialize everything greyprint related
    g_Project |> make_sample_project()  // make a sample project for now
    imgui_app("Testing IMGUI") <|
        NewFrame()
        main_editor_screen()
        Render()
        post_invoke_que()
    DestroyEditor(g_Context)

