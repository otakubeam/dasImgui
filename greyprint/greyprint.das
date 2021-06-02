options persistent_heap = true
options persistent_string_heap = true

require fio
require imgui_app
require math
require rtti
require debugapi
require stddlg

require daslib/glfw_boost
require daslib/imgui_boost
require daslib/static_let
require daslib/safe_addr
require daslib/imgui_node_editor_boost
require daslib/strings_boost
require daslib/lpipe

require instructions
require instructions_ui
require preview
require guid_2_id
require command_que
require undo_stack

// note - can be different model for every new editor type
require instructions_model
require model_eval

let SIDE_PANNEL_WIDTH = 600.
let CONTEXT_MENU_WIDTH = 400.
let INSTRUCTION_PANNEL_HEIGHT = 350.
let SELECTION_PANNEL_HEIGHT = 600.

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

var g_FirstFrame = true

def save_project(fname:string)
    for inst in g_CurrentProject.instructions
        inst.at = GetNodePosition(get_unique_id(inst.id))
    var jv = (*g_CurrentProject)->save()
    let save_text = write_json(jv)
    fopen(fname,"wb") <| $ ( json_file )
        if json_file != null
            fwrite(json_file, save_text)
        else
            get_dlg_ok_from_user("Error","Can't save {fname}")
    unsafe
        delete jv

def export_project(fname:string)
    let save_text = produce_project_text()
    fopen(fname,"wb") <| $ ( das_file )
        if das_file != null
            fwrite(das_file, save_text)
        else
            get_dlg_ok_from_user("Error","Can't export {fname}")

def clear_project_data()
    clear_undo_stack()          // TODO: undo stack between projects
    SetCurrentEditor(null)
    DestroyEditor(g_Context)
    g_Context = null
    (*g_CurrentProject)->clear()
    reset_guids()
    clear_preview()
    g_FirstFrame = true

def new_project()
    post_event <| @
        clear_project_data()
        update_preview()

def load_project(fname:string)
    var text : string
    fopen(fname,"rb") <| $ ( json_file )
        if json_file != null
            fmap(json_file) <| $ ( data )
                text := data
        else
            get_dlg_ok_from_user("Error","Can't load {fname}")
    if !empty(text)
        post_event <| @
            clear_project_data()
            var error : string
            var jv = read_json(text,error)
            (*g_CurrentProject)->load(jv)
            update_preview()
            unsafe
                delete jv

// MAIN MENU

def main_menu()
    BeginMenuBar <|
        BeginMenu("File##Main menu") <|
            if MenuItem("New##File")
                //if get_dlg_ok_from_user("caption","body")
                new_project()
            if MenuItem("Load##File")
                let fname = get_dlg_open_file("","greyprint")
                if !empty(fname)
                    load_project(fname)
            if MenuItem("Save##File")
                let fname = get_dlg_save_file("new_name.greyprint","","greyprint")
                if !empty(fname)
                    save_project(fname)
            if MenuItem("Export##File")
                let fname = get_dlg_save_file("new_name.das","","greyprint")
                if !empty(fname)
                    export_project(fname)
        BeginMenu("Edit##Main menu") <|
            if MenuItem("Undo##Edit")
                ClearSelection()
                undo()
            if MenuItem("Redo##Edit")
                ClearSelection()
                redo()
        BeginMenu("Preview##Main menu") <|
            if Checkbox("Live preview##Preview",safe_addr(g_LivePreview))
                update_preview()
            if MenuItem("View generated code##Preview")
                g_ProjectSource = produce_project_text()
                post_event <| @
                    OpenPopup("PREVIEW SOURCE")

    var IO & = GetIO()
    if IO.KeyCtrl
        if IsKeyPressed(GetKeyIndex(ImGuiKey Z))
            ClearSelection()
            undo()
        if IsKeyPressed(GetKeyIndex(ImGuiKey Y))
            ClearSelection()
            redo()

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

def editor_hint(desc:string)
    Suspend()
    BeginTooltip()
    PushTextWrapPos(GetFontSize() * 35.0f)
    TextUnformatted(desc)
    PopTextWrapPos()
    EndTooltip()
    Resume()

def editor_child_window()
    var style & = imgui_node_editor::GetStyle()
    style.NodeRounding = 0f
    style.GroupRounding = 0f
    style.PinRounding = 0f
    style.NodePadding = float4(4)
    style.Colors[int(StyleColor StyleColor_Bg)].w = 0.
    style.Colors[int(StyleColor StyleColor_Grid)].w = 0.
    Begin("My Editor", float2(0.0, 0.0f)) <|
        for inst in g_CurrentProject.instructions
            let id = get_unique_id(inst.id)
            if !inst.flags.Comment
                // REGULAR NODE
                BeginNode(id) <|
                    Dummy(float2(DEFAULT_NODE_WIDTH,0.))
                    ImGuiEx_BeginColumn()
                    if inst.flags.HasEdit
                        unsafe
                            Checkbox("##embedded_{inst.id}",addr(inst.editing))
                        SameLine()
                    Text(inst.name)
                    let sz = ImGuiEx_NextColumn()
                    Dummy(float2(DEFAULT_NODE_WIDTH - sz.x,0.))
                    SameLine()
                    if Button("[X]##{inst.id}_E")
                        next_undo_action()
                        DeleteNode(id)
                    ImGuiEx_EndColumn()
                    if inst.tex != null
                        Image(inst.tex,float2(128,128),float2(0.,0.),float2(1.,1.),float4(1),float4(1))
                    if inst.editing
                        if inst.flags.HasEdit
                            before_instruction(inst)
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
                                    SelectNode(id, false)
                                    NavigateToSelection(false, NAVIGATION_TIME)
                                    ClearSelection()
                                SameLine()
                                if Button("[X]##goto_{inp}_from_{inst.id}")
                                    next_undo_action()
                                    DeleteLink(inp_id)
                    let lw = ImGuiEx_NextColumn()
                    for outp in inst.outputs
                        let outp_id = get_output_unique_id(inst,outp.name)
                        let text = "{outp.name}:{outp._type}"
                        out_pin(outp_id, text, DEFAULT_NODE_WIDTH - CalcTextSize(text).x - lw.x) <|
                            SameLine()
                            unsafe
                                if Checkbox("##prewview_{inst.id}_{outp.name}_E",addr(outp.preview))
                                    update_preview()
                            if outp.tex != null
                                Image(outp.tex,float2(128,128),float2(0.,0.),float2(1.,1.),float4(1),float4(1))
                    ImGuiEx_EndColumn()
            else
                var comment : string
                unsafe
                    let cinst = upcast<Instruction_Comment?> inst
                    comment = cinst.comment
                let commentAlpha = 0.75f
                PushStyleVar(ImGuiStyleVar Alpha, commentAlpha)
                imgui_node_editor::BeginNode(id);
                Text(comment)
                Group(inst.extents)
                EndNode()
                imgui::PopStyleVar(1)
                inst.extents = GetNodeSize(id)
                if BeginGroupHint(id)
                    let bgAlpha = int(imgui::GetStyle().Alpha * 255.)
                    imgui::PushStyleVar(ImGuiStyleVar Alpha, commentAlpha * imgui::GetStyle().Alpha)
                    let minR = GetGroupMin()
                    SetCursorScreenPos(minR - float2(-8., GetTextLineHeightWithSpacing() + 4.))
                    BeginGroup();
                    TextUnformatted(inst.name)
                    EndGroup()
                    var drawList = GetHintBackgroundDrawList()
                    var hintBounds      = ImGui_GetItemRect()
                    var hintFrameBounds = ImRect_Expanded(hintBounds, 8., 4.)
                    (*drawList) |> AddRectFilled(
                        hintFrameBounds |> GetTL(),
                        hintFrameBounds |> GetBR(),
                        IM_COL32(255, 255, 255, 64 * bgAlpha / 255), 4.0f)
                    (*drawList) |> AddRect(
                        hintFrameBounds |> GetTL(),
                        hintFrameBounds |> GetBR(),
                        IM_COL32(255, 255, 255, 128 * bgAlpha / 255), 4.0f)
                    imgui::PopStyleVar()
                EndGroupHint()

            if inst.firstFrame
                if !inst.hasPosition
                    CenterNodeOnScreen(id)
                else
                    SetNodePosition(id, inst.at)    // note: what we set and what gets returned differs (via m_Bounds.floor())
                inst.at = GetNodePosition(id)
                inst.firstFrame = false
            else
                let newAt = GetNodePosition(id)
                if inst.at != newAt
                    next_undo_action()
                    undo_move_instruction(inst.id,inst.at,newAt)
                    inst.at = newAt
            if inst.select
                SelectNode(id)
                if inst.navigate
                    NavigateToSelection(false,NAVIGATION_TIME)
                inst.select = false

        for inst in g_CurrentProject.instructions
            for inp in inst.inputs
                if inp.src != null
                    let inp_id = get_input_unique_id(inst,inp.name)
                    let outp_id = get_output_unique_id(inp.src,inp.output)
                    Link(inp_id, inp_id, outp_id)

        /*
        if (ed::ShowNodeContextMenu(&contextNodeId))
            ImGui::OpenPopup("Node Context Menu");
        else if (ed::ShowPinContextMenu(&contextPinId))
            ImGui::OpenPopup("Pin Context Menu");
        else if (ed::ShowLinkContextMenu(&contextLinkId))
            ImGui::OpenPopup("Link Context Menu");
        else if (ed::ShowBackgroundContextMenu())
        {
            ImGui::OpenPopup("Create New Node");
            newNodeLinkPin = nullptr;
        }
        */

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
                                editor_hint("Error: can't link to itself")
                                RejectNewItem(float4(1,0,0,1),3.)
                            elif inL.inst.inputs[inI]._type != outL.inst.outputs[outI]._type    // type mismatch
                                editor_hint("Error: can't link {inL.inst.inputs[inI]._type} to {outL.inst.outputs[outI]._type}")
                                RejectNewItem(float4(1,0,0,1),3.)
                            else
                                before_link(inL.inst.id, inL.pin)
                                var old_input = inL.inst.inputs[inI]
                                inL.inst.inputs[inI] |> connect(outL.inst, outL.pin)
                                if g_CurrentProject |> find_loop()
                                    inL.inst.inputs[inI] = old_input
                                    editor_hint("Error: link creates loop")
                                    RejectNewItem(float4(1,0,0,1),3.)
                                else
                                    AcceptNewItem()
                                    next_undo_action()
                                    undo_create_connection(inL.inst.id,inL.pin)
                                    update_preview()

        BeginDelete() <|
            var deletedLinkId : LinkId
            while QueryDeletedLink(safe_addr(deletedLinkId),null,null)
                if AcceptDeletedItem()
                    post_event <| @
                        delete_connection(deletedLinkId)
            var deletedNodeId : NodeId
            while QueryDeletedNode(safe_addr(deletedNodeId))
                if AcceptDeletedItem()
                    post_event <| @
                        let inst_id = id_2_guid[deletedNodeId]
                        var inst = (*g_CurrentProject)->find_instruction(inst_id)
                        assert(inst!=null)
                        delete_instruction(inst)

        instruction_context_menu()

    if g_FirstFrame
        NavigateToContent(NAVIGATION_TIME)
    g_FirstFrame = false

// SIDE WINDOW

def delete_instruction ( var inst:Instruction? )
    before_instruction(inst)
    undo_delete_instruction(inst)
    redo_last()
    update_preview()

def delete_connection ( id:LinkId )
    var inL = translate_input_output_id(id,"INPUT")
    undo_delete_connection(inL.inst.id,inL.pin)
    redo_last()
    update_preview()

def side_edit_instance( var inst:Instruction?; flags:ImGuiTreeNodeFlags = ImGuiTreeNodeFlags None )
    if TreeNodeEx("side_{inst.id}{flags}",flags,"{inst.name}")
        if Button("[G]##goto_{inst.id}")
            SelectNode(get_unique_id(inst.id), false)
            NavigateToSelection(false, NAVIGATION_TIME)
            ClearSelection()
        HelpMarker("Navigate to node")
        SameLine()
        if Button("<C>##{inst.id}_S")
            CenterNodeOnScreen(get_unique_id(inst.id))
        HelpMarker("Center")
        SameLine()
        if Button("[X]##{inst.id}_S")
            next_undo_action()
            DeleteNode(get_unique_id(inst.id))
        HelpMarker("Delete")
        Text("id: `{inst.id}`")
        before_instruction(inst)
        var buf = get_next_text_buffer(inst.name)
        if InputText("name##{inst.id}_EDIT",*buf)
            inst.name = to_string(*buf)
            undo_edit_instruction(inst.id,"name")
            update_preview()
        for outp in inst.outputs
            unsafe
                if Checkbox("##preview_{inst.id}_{outp.name}_S",addr(outp.preview))
                    update_preview()
            SameLine()
            Text("-> {outp.name}:{outp._type}")
        if inst.flags.HasEdit
            inst->edit(EditMode Sidebar)
        TreePop()

// context menu

def instruction_context_menu
    let icm = "Create New Instruction"
    static_let <|
        var link_inst : Instruction?
        var link_pin : string
        var node_pos : float2
    Suspend()
    if ShowBackgroundContextMenu()
        OpenPopup(icm)  // contextless node
        link_inst = null
        node_pos = ScreenToCanvas(GetMousePos())
    var context_link_id = 0
    if ShowLinkContextMenu(safe_addr(context_link_id))
        OpenPopup(icm)  // link node
        var inL = translate_input_output_id(context_link_id,"INPUT")
        link_inst = inL.inst
        link_pin = inL.pin
    if !IsPopupOpen(icm)
        if IsKeyPressed(GetKeyIndex(ImGuiKey Tab)) || IsKeyPressed(GetKeyIndex(ImGuiKey Space))
            var snc = GetSelectedObjectCount()
            if snc==1
                var sna <- GetSelectedNodes()
                var snl <- GetSelectedLinks()
                if length(sna)==1
                    let nid = id_2_guid[sna[0]]
                    var outL = (*g_CurrentProject)->find_instruction(nid)
                    assert(outL!=null)
                    if length(outL.outputs)>=1
                        OpenPopup(icm)  // tab node
                        link_inst = outL
                        link_pin = ""
                elif length(snl)==1
                    OpenPopup(icm)  // link node
                    context_link_id = snl[0]
                    var inL = translate_input_output_id(context_link_id,"INPUT")
                    link_inst = inL.inst
                    link_pin = inL.pin
                delete sna
                delete snl
            elif snc==0
                OpenPopup(icm)  // contextless node
                link_inst = null
                node_pos = float2(-FLT_MAX)
    if BeginPopup(icm)
        if link_inst==null
            create_instruction_contextless(node_pos)
        elif !empty(link_pin)
            edit_link_instructions(link_inst,link_pin)
        else
            edit_tab_instructions(link_inst,link_inst.outputs[0].name)
        EndPopup()
    Resume()

bitfield EditInstructionsFlags
    FromContextMenu
    DisplayCategories

def create_instruction_ex(flags:EditInstructionsFlags;evt:block<(ai:InstructionCategory?#):void>;skip:block<(ai:InstructionCategory?#):bool>)
    if flags.FromContextMenu
        Text("Create new instruction")
    static_let <|
        var filter = new ImGuiTextFilter
    *filter |> Draw("##edit_instruction",(flags.FromContextMenu ? CONTEXT_MENU_WIDTH : SIDE_PANNEL_WIDTH)-10.)
    if flags.FromContextMenu
        if IsWindowAppearing()
            SetKeyboardFocusHere()
        if IsKeyPressed(GetKeyIndex(ImGuiKey Escape))
            CloseCurrentPopup()
    var make_first = false
    if flags.FromContextMenu && IsKeyPressed(GetKeyIndex(ImGuiKey Enter))
        make_first = true
    var prevCategory = ""
    var collapsed = true
    for ai in g_instructionsByCategory
        if prevCategory != ai.category
            prevCategory = ai.category
            if flags.DisplayCategories
                if !collapsed
                    TreePop()
                collapsed = !TreeNodeEx(ai.category,ImGuiTreeNodeFlags DefaultOpen)
        if !collapsed || !flags.DisplayCategories
            if ! ((*filter) |> PassFilter(ai.name))
                continue
            if skip |> invoke(safe_addr(ai))
                continue
            if Button("{ai.name}##make_S") || make_first
                make_first = false
                if flags.FromContextMenu
                    CloseCurrentPopup()
                invoke(evt, safe_addr(ai))
    if flags.DisplayCategories
        if !collapsed
            TreePop()

def create_instruction_side_menu()
    create_instruction_ex(EditInstructionsFlags DisplayCategories) <| $ ( ai )
        let type_name = ai.tname
        post_event() <| @   // context free instruction which will be centered
            next_undo_action()
            var inst = make_instruction(type_name)
            (*g_CurrentProject)->add_new_insturction(inst)
            inst.select = true
            undo_create_instruction(inst)
            update_preview()
    lpipe() <| $ ( ai )
        return false

def create_instruction_contextless(pos:float2)
    create_instruction_ex(EditInstructionsFlags DisplayCategories | EditInstructionsFlags FromContextMenu) <| $ ( ai )
        let type_name = ai.tname
        post_event() <| @   // context free instruction at mouse position
            next_undo_action()
            var inst = make_instruction(type_name)
            (*g_CurrentProject)->add_new_insturction(inst)
            inst.select = true
            inst.at = pos
            inst.hasPosition = true
            undo_create_instruction(inst)
            update_preview()
    lpipe <| $ ( ai )
        return false

def edit_link_instructions(var inst:Instruction?;pin:string )
    let pid = inst->input_index(pin)
    assert(pid!=-1)
    let iotype = inst.inputs[pid]._type
    create_instruction_ex(EditInstructionsFlags FromContextMenu) <| $ ( ai )
        let type_name = ai.tname
        post_event() <| @   // link between input and output
            next_undo_action()
            var link_inst = make_instruction(type_name)
            (*g_CurrentProject)->add_new_insturction(link_inst)
            link_inst.select = true
            let p0 = GetNodePosition(guid_2_id[inst.id])
            let p1 = GetNodePosition(guid_2_id[inst.inputs[pid].src.id])
            link_inst.at = (p0+p1) * 0.5
            link_inst.hasPosition = true
            before_link(link_inst.id,link_inst.inputs[0].name)
            link_inst.inputs[0].src = inst.inputs[pid].src
            link_inst.inputs[0].output = inst.inputs[pid].output
            undo_create_instruction(link_inst)
            undo_create_connection(link_inst.id,link_inst.inputs[0].name)
            before_link(inst.id,pin)
            inst.inputs[pid].src = link_inst
            inst.inputs[pid].output = link_inst.outputs[0].name
            undo_create_connection(inst.id,pin)
            update_preview()
        finally
            inst = null
    lpipe <| $ ( ai )
        return ai.main_in!=iotype || ai.main_out!=iotype

def edit_tab_instructions(var inst:Instruction?;pin:string )
    let pid = inst->output_index(pin)
    assert(pid!=-1)
    let iotype = inst.outputs[pid]._type
    create_instruction_ex(EditInstructionsFlags FromContextMenu) <| $ ( ai )
        let type_name = ai.tname
        post_event() <| @   // link to main output
            next_undo_action()
            var out_inst = make_instruction(type_name)
            (*g_CurrentProject)->add_new_insturction(out_inst)
            out_inst.select = true
            out_inst.navigate = true
            out_inst.at = inst.at + float2(DEFAULT_NODE_WIDTH + 200.0,0.)
            out_inst.hasPosition = true
            let srcpin = out_inst.inputs[0].name
            before_link(out_inst.id, srcpin)
            out_inst.inputs[0].src = inst
            out_inst.inputs[0].output = pin
            undo_create_instruction(out_inst)
            undo_create_connection(out_inst.id,srcpin)
            update_preview()
        finally
            inst = null
    lpipe <| $ ( ai )
        return ai.main_in!=iotype

var g_ProjectSource = ""
var g_ProjectErrors = ""
var g_ProjectErrorsMessage = ""

def eval_project ()
    var failed = false
    g_ProjectSource = produce_project_text()
    g_ProjectErrors = ""
    g_ProjectErrorsMessage = ""
    compile("project",g_ProjectSource, CodeOfPolicies()) <| $ ( ok; prog; errors )
        if ok
            simulate(prog,false) <| $ ( sok; context; serrors ) // no aot for now
                if sok
                    unsafe
                        invoke_in_context(context,"main")
                        var pout = get_context_global_variable(context,"G_OUTPUT")
                        var OUTPUT  & = * ( reinterpret<array<tuple<surf:Surface;name:string;id:string;outp:string>>?> pout )
                        clear_preview()
                        for inst in g_CurrentProject.instructions
                            inst.tex = null
                            for outp in inst.outputs
                                outp.tex = null
                        for outprev in OUTPUT
                            let tex = make_prewview_rgba_texture(outprev.surf)
                            g_PreviewTexture |> push(tex)
                            var pinst = (*g_CurrentProject)->find_instruction(outprev.id)
                            assert(pinst!=null)
                            if !empty(outprev.outp)
                                pinst |> find_output(outprev.outp) <| $ ( outp )
                                    if outp != null
                                        outp.tex = reinterpret<void?> tex
                            else
                                pinst.tex = reinterpret<void?> tex
                else
                    g_ProjectErrorsMessage = "generated code failed to simulate"
                    g_ProjectErrors = "{serrors}"
                    failed = true
        else
            g_ProjectErrorsMessage = "generated code failed to compile"
            g_ProjectErrors = "{errors}"
            failed = true

def side_child_window()
    var style & = imgui::GetStyle()
    PushStyleColor(ImGuiCol ChildBg, style.Colors[int(ImGuiCol WindowBg)])
    BeginGroup()
// instructions
    BeginChild("Instructions", float2(SIDE_PANNEL_WIDTH, INSTRUCTION_PANNEL_HEIGHT), true)
    if CollapsingHeader("New instruction",ImGuiTreeNodeFlags DefaultOpen)
        create_instruction_side_menu()
    EndChild()
// selection
    var snc = GetSelectedObjectCount()
    if snc != 0
        var sna <- GetSelectedNodes()
        BeginChild("Selection", float2(SIDE_PANNEL_WIDTH, SELECTION_PANNEL_HEIGHT), true)
        if Button("[X]##delete selection")
            next_undo_action()
            for ng in sna
                DeleteNode(ng)
        HelpMarker("Delete selection")
        SameLine()
        if Button("[*]##navigate to selection")
            NavigateToSelection(true, 0.5)
        HelpMarker("Navigate to selection")
        for ng in sna
            let nid = id_2_guid[ng]
            var inst = (*g_CurrentProject)->find_instruction(nid)
            side_edit_instance(inst, ImGuiTreeNodeFlags DefaultOpen)
        EndChild()
// project
    BeginChild("Project", float2(SIDE_PANNEL_WIDTH, -FLT_MIN), true)
    if Button("[*]")
        NavigateToContent(NAVIGATION_TIME)
    HelpMarker("Navigate to content")
    SameLine()
    static_let <|
        var project_filter = new ImGuiTextFilter
    *project_filter |> Draw("",SIDE_PANNEL_WIDTH-10.)
    for inst in g_CurrentProject.instructions
        if *project_filter|>PassFilter(inst.name) || *project_filter|>PassFilter(inst.id)
            side_edit_instance(inst)
    EndChild()
// and done
    EndGroup()
    imgui::PopStyleColor()

// error preview

def preview_errors
    if !empty(g_ProjectErrors)
        if Button("[!]##PROJECT ERRORS")
            OpenPopup("EVAL")
        SameLine()
        TextColored(float4(1.,0.5,0.,1.),g_ProjectErrorsMessage)
    if IsPopupOpen("EVAL")
        SetNextWindowSize(float2(1280.,800.0))
        if BeginPopup("EVAL",ImGuiWindowFlags HorizontalScrollbar)
            BeginGroup()
            TextUnformatted(g_ProjectSource)
            TextUnformatted("")
            TextColored(float4(1.,0.5,0.,1.0),g_ProjectErrorsMessage)
            TextUnformatted("")
            TextUnformatted(g_ProjectErrors)
            EndGroup()
            EndPopup()
    if IsPopupOpen("PREVIEW SOURCE")
        SetNextWindowSize(float2(1280.,800.0))
        if BeginPopup("PREVIEW SOURCE",ImGuiWindowFlags HorizontalScrollbar)
            BeginGroup()
            TextUnformatted(g_ProjectSource)
            EndGroup()
            EndPopup()


// MAIN WINDOW

def main_editor_screen()
    if g_Context == null
        var config = Config()
        config.SettingsFile = ""
        g_Context = CreateEditor(safe_addr(config))
        SetCurrentEditor(g_Context)
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
        preview_errors()
        side_child_window()
        SameLine()
        BeginChild("Node editor window", float2(0., -FLT_MIN), true, ImGuiWindowFlags NoBackground)
        editor_child_window()
        EndChild()
        post_invoke_que()

def preview_updater
    eval_project()

[export]
def main
    g_CurrentProject = new Project()
    g_PreviewUpdater = @@preview_updater
    seal_instruction_factory()          // initialize everything greyprint related
    imgui_app("Testing IMGUI") <|
        NewFrame()
        main_editor_screen()
        Render()
        clear_text_buffers()
    if g_Context != null
        SetCurrentEditor(null)
        DestroyEditor(g_Context)

