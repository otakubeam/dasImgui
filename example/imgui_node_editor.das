options persistent_heap = true
options persistent_string_heap = true

require fio
require imgui_app
require daslib/glfw_boost
require daslib/imgui_boost
require daslib/static_let
require daslib/safe_addr
require daslib/imgui_node_editor_boost
require math
require rtti

let NAVIGATION_TIME = 0.5

var window : GLFWwindow?

def make_rgba_texture(width,height:int; data:void?)
    var texture : uint
    glGenTextures(1, safe_addr(texture))
    glBindTexture(GL_TEXTURE_2D, texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glTexImage2D(GL_TEXTURE_2D, 0, int(GL_RGBA), width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data)
    glBindTexture(GL_TEXTURE_2D, GL_INVALID_VALUE)
    return texture

def make_checkerboard
    var cbt : uint[16][16]
    for y in range(16)
        for x in range(16)
            cbt[y][x] = ((x^y)&1)!=0 ? 0xff404040 : 0xff808080
    return make_rgba_texture(16,16,gl_array_ptr(cbt))

// surfaces

struct Surface
    size : int2
    data : array<float4>

def make_prewview_rgba_texture ( var s : Surface )
    var rgba : array<uint>
    rgba |> resize(s.size.x * s.size.y)
    for col,val in s.data,rgba
        val = pack_float_to_byte(col * float4(255.0f))  // todo: HDR conversion?
    let preview = make_rgba_texture(s.size.x, s.size.y, gl_array_ptr(rgba))
    delete rgba
    return preview

// instructions

struct Input
    name : string
    [[do_not_delete]] src  : Instruction?
    output : string

def connect ( var inp:Input; src:Instruction?; outp:string )
    inp.src = src
    inp.output = outp

struct Output
    name : string

class Instruction
    id : string                         // unique ID of instruction (expecting GUID)
    name : string                       // user readable name. can be duplicate
    at : int2                           // position in the node editor
    firstFrame : bool = true
    editing : bool = false
    size : int2 = int2(256,256)         // dimensions of the generated surface. never 0 or invalid
    inputs : array<Input>
    outputs : array<Output>
    def abstract generate : array<Surface>
    def abstract edit : void
    def add_input ( iname : string )
        inputs |> push([[Input name=iname]])
    def add_output ( iname : string )
        outputs |> push([[Output name=iname]])

// todo: cache
def gen_input ( var from:Instruction? ): array<Surface>
    return <- from->generate()

def SafeColorEditor4(name:string;data:float?#)
    SetNextItemWidth(300.)
    ColorPicker4(name,data,ImGuiColorEditFlags NoTooltip)

class Instruction_SolidColor : Instruction
    color : float4 = float4(.5,.5,.5,1.)
    def Instruction_SolidColor
        name = "Solid color"
        self->add_output("Out")
    def override generate : array<Surface>
        var s : Surface
        s.size = size
        s.data |> resize(size.x*size.y)
        for c in s.data
            c = color
        var result : array<Surface>
        result |> emplace(s)
        return <- result
    def override edit : void
        SafeColorEditor4("color",safe_addr(color.x))

class Instruction_Gradient : Instruction
    top_left : float4 = float4(1.,0.,0.,1.)
    top_right : float4 = float4(0.,1.,0.,1.)
    bottom_left : float4 = float4(0.,0.,1.,1.)
    bottom_right : float4 = float4(0.5,0.5,0.5,1.)
    def Instruction_Gradient
        name = "Gradient"
        self->add_output("Out")
    def override generate : array<Surface>
        var s : Surface
        s.size = size
        s.data |> resize(size.x*size.y)
        var index = 0
        for y in range(0,size.y)
            let ky = float(y)/float(size.y-1)           // todo: optimize k calc; ky += dky
            let left = lerp(top_left,bottom_left,float4(ky))
            let right = lerp(top_right,bottom_right,float4(ky))
            for x in range(0,size.x)
                let kx = float(x)/float(size.x-1)       // todo: optimize k calc; kx += dkx
                s.data[index++] = lerp(left,right,float4(kx))
        var result : array<Surface>
        result |> emplace(s)
        return <- result
    def override edit : void
        SafeColorEditor4("top-left",     safe_addr(top_left.x))
        SafeColorEditor4("top-right",    safe_addr(top_right.x))
        SafeColorEditor4("bottom-left",  safe_addr(bottom_left.x))
        SafeColorEditor4("bottom-right", safe_addr(bottom_right.x))

enum BlendOp
    Add
    Multiply

def EmbeddedListBox ( name:string; var ent:auto(EnumT)&; max_height_in_items:int=-1 )
    concept_assert(typeinfo(is_enum type<EnumT>),"expecting enum")
    if typeinfo(is_enum type<EnumT>)
        Text(name)
        var ti = typeinfo(rtti_typeinfo type<EnumT>)
        var max_tw = 0.
        for ef in *ti.enumType
            max_tw = max(max_tw, CalcTextSize(ef.name).x)
        for ef in *ti.enumType
            let isSelected = ef.value == int64(int(ent))
            if Selectable(ef.name, isSelected, ImGuiSelectableFlags None, float2(max_tw,0.))
                unsafe
                    ent = reinterpret<EnumT> (ef.value)

class Instruction_Blend : Instruction
    op  : BlendOp
    def Instruction_Blend
        name = "Blend"
        self->add_input("Src")
        self->add_input("Dst")
        self->add_output("Out")
    def override generate : array<Surface>
        var src = inputs[0].src
        var dst = inputs[1].src
        var s : Surface
        s.size = size
        s.data |> resize(size.x*size.y)
        var error = true
        if src!=null && dst!=null
            var src_r <- gen_input(src)
            var dst_r <- gen_input(dst)
            var src_s & = src_r[0]
            var dst_s & = dst_r[0]
            if src_s.size==size && dst_s.size==size
                if op==BlendOp Add
                    for c,sC,dC in s.data,src_s.data,dst_s.data
                        c = sC + dC
                elif op==BlendOp Multiply
                    for c,sC,dC in s.data,src_s.data,dst_s.data
                        c = sC * dC
                error = false
            delete src_r
            delete dst_r
        if error
            for c in s.data
                c = float4(1,0,0,1)
        var result : array<Surface>
        result |> emplace(s)
        return <- result
    def override edit : void
        EmbeddedListBox("Operation", op)

// factory

var g_instructionFactory : table < string; lambda<():Instruction?> >

[unused_argument(it_type)]
def make_instruction_factory ( it_name:string; it_type:auto(InstType) )
    g_instructionFactory[it_name] <- @ <| () : Instruction?
        return new InstType()

[init]
def init_instruction_factory
    // todo: turn into annotation
    make_instruction_factory("Solid color", type<Instruction_SolidColor>)
    make_instruction_factory("Gradient", type<Instruction_Gradient>)
    make_instruction_factory("Blend", type<Instruction_Blend>)

// project

def generate_new_id()       // TODO: generate real GUID
    static_let <|
        var uuid = 0
    uuid ++
    return "GUID_{uuid}"

class Project
    instructions : array<Instruction?>
    def clear
        for i in instructions
            unsafe
                delete i
        delete instructions
    def findalize
        self->clear()
    def add_new_insturction ( var i : Instruction? )
        i.id = generate_new_id()
        instructions |> push(i)
    def make_sample_project
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
        for i,t in instructions, range(100500)
            i.at = int2(0, t*100)
    def delete_instruction ( dinst:Instruction? )
        var idx = -1
        for i,index in instructions,range(100500)
            if i == dinst
                idx = index
            for inp in i.inputs
                if inp.src==dinst
                    inp.src = null
        assert(idx!=-1)
        instructions |> erase(idx)

var g_Project <- Project()

// PREVIEW

var g_PreviewTexture : uint

def GeneratePreview(var inst:Instruction?; outp:string)
    var surf <- inst->generate()
    var tex = 0u
    for op,opi in inst.outputs,range(100500)
        if op.name==outp
            tex = make_prewview_rgba_texture(surf[opi])
            break
    assert(tex!=0u,"could not generate preview")
    delete surf
    if g_PreviewTexture != 0u
        glDeleteTextures(1, safe_addr(g_PreviewTexture))
    g_PreviewTexture = tex

def DrawPreview ( display_w, display_h : int )
    static_let <|
        var rot_cube = 0.
        var rot_tri = 0.
        var texture = 0u

    if g_PreviewTexture==0u
        g_PreviewTexture = make_checkerboard()

    static_let <|
        let vertices = [[float[]
            -0.5;  -0.5;  0.5;   0.5; -0.5;  0.5;   0.5;  0.5;  0.5; -0.5;  0.5;  0.5;
            -0.5;   0.5; -0.5;   0.5;  0.5; -0.5;   0.5; -0.5; -0.5; -0.5; -0.5; -0.5;
             0.5;  -0.5;  0.5;   0.5; -0.5; -0.5;   0.5;  0.5; -0.5;  0.5;  0.5;  0.5;
            -0.5;  -0.5; -0.5;  -0.5; -0.5;  0.5;  -0.5;  0.5;  0.5; -0.5;  0.5; -0.5 ]]
        let texcoords = [[float[]   0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0;
                                    0.0;0.0; 1.0;0.0; 1.0;1.0; 0.0;1.0 ]]
        let cubeIndices = [[int[] 0;1;2;3; 4;5;6;7; 3;2;5;4; 7;6;1;0; 8;9;10;11; 12;13;14;15 ]]

    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    glShadeModel(GL_SMOOTH)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

    let aspect = double(display_w) / double(display_h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0lf, aspect, 0.1lf, 100.0lf)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    glTranslatef(0.0f, 0.0f, -1.6f)
    glRotatef(rot_tri * 0.25,1.0,0.0,0.0)
    glRotatef(rot_cube,0.0,1.0,0.0)
    rot_cube += 1.0
    if rot_cube > 360.
        rot_cube -= 360.
    rot_tri += 0.5
    if rot_tri > 360.
        rot_tri -= 360.

    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, g_PreviewTexture)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glColor3f(1.0f, 1.0f, 1.0f)
    glEnableClientState(GL_TEXTURE_COORD_ARRAY)
    glEnableClientState(GL_VERTEX_ARRAY)
    glTexCoordPointer(2, GL_FLOAT, 0, gl_array_ptr(texcoords))
    glVertexPointer(3, GL_FLOAT, 0, gl_array_ptr(vertices))
    glDrawElements(GL_QUADS, 24, GL_UNSIGNED_INT, gl_array_ptr(cubeIndices))
    glDisableClientState(GL_VERTEX_ARRAY)
    glDisable(GL_TEXTURE_2D)

// APP

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
        DrawPreview(display_w, display_h)
        ImGui_ImplOpenGL2_RenderDrawData(GetDrawData())
        glfwMakeContextCurrent(window)
        glfwSwapBuffers(window)
    ImGui_ImplOpenGL2_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    DestroyContext(null)
    glfwDestroyWindow(window)
    glfwTerminate()

// MAIN MENU

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


// GUID TO IMGUI ID

var guid_2_id : table<string; int>
var id_2_guid : table<int; string>
var guid_2_id_next = 1000

def get_unique_id ( guid:string ) : int
    var id = 0
    find_if_exists(guid_2_id, guid) <| $ ( val )
        id = *val
    if id == 0
        id = guid_2_id_next++
        guid_2_id[guid] = id
        id_2_guid[id] = guid
    return id

def get_input_unique_id ( inst:Instruction?; inp:string ) : int
    return get_unique_id("{inst.id} {inp}")

def get_output_unique_id ( inst:Instruction?; outp:string ) : int
    return get_unique_id("{inst.id} {outp}")


def translate_input_id ( id:int )
    pass

// COMMAND QUE

var g_que : array<lambda<():void>>

def post_event ( var evt : lambda<():void> )
    g_que |> emplace(evt)

// NODE EDITOR WINDOW

var g_Context : EditorContext?

def EditorChildWindow()
    SetCurrentEditor(g_Context)
    static_let <|
        var g_FirstFrame = true

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
                unsafe
                    Checkbox("##embedded_{inst.id}",addr(inst.editing))
                SameLine()
                Text(inst.name)
                SameLine()
                if Button("[X]##{inst.id}_E")
                    post_event() <| @
                        g_Project->delete_instruction(inst)
                        inst = null // so that lambda does not delete this pointer
                if inst.editing
                    inst->edit()
                ImGuiEx_BeginColumn()
                for inp in inst.inputs
                    let inp_id = get_input_unique_id(inst,inp.name)
                    BeginPin(inp_id, PinKind Input) <|
                        Text("-> {inp.name}")
                        if inp.src != null
                            SameLine()
                            if Button("[G]##goto_{inp}_from_{inst.id}")
                                SelectNode(get_unique_id(inp.src.id), false)
                                NavigateToSelection(false, NAVIGATION_TIME)
                ImGuiEx_NextColumn()
                for outp in inst.outputs
                    let outp_id = get_output_unique_id(inst,outp.name)
                    BeginPin(outp_id, PinKind Output) <|
                        Text("{outp.name} ->")
                        SameLine()
                        if Button("[P]##{inst.id}_E")
                            GeneratePreview(inst,outp.name)
                ImGuiEx_EndColumn()

            if inst.firstFrame
                if inst.at==int2(0)
                    CenterNodeOnScreen(get_unique_id(inst.id))
                else
                    SetNodePosition(id, float2(inst.at))
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
                    if AcceptNewItem()
                        pass
                        // print("Connecting {id_2_guid[inputPinId]} -> {id_2_guid[outputPinId]} \n")

        BeginDelete() <|
            var deletedLinkId : LinkId
            while QueryDeletedLink(safe_addr(deletedLinkId),null,null)
                if AcceptDeletedItem()
                    print("deleting link {deletedLinkId}\n")


    if g_FirstFrame
        NavigateToContent(0.)
    SetCurrentEditor(null)
    g_FirstFrame = false

def HelpMarker(desc:string; qsign:bool = false)
    if qsign
        SameLine()
        TextDisabled("[?]")
    if IsItemHovered()
        BeginTooltip()
        PushTextWrapPos(GetFontSize() * 35.0f)
        TextUnformatted(desc)
        PopTextWrapPos()
        EndTooltip()

// SIDE WINDOW

def SideChildWindow()
    SetCurrentEditor(g_Context)

    var style & = imgui::GetStyle()
    PushStyleColor(ImGuiCol ChildBg, style.Colors[int(ImGuiCol WindowBg)])
    BeginChild("Project", float2(600., -FLT_MIN), true)

    if Button("[*]")
        NavigateToContent(NAVIGATION_TIME)
    SameLine()
    HelpMarker("Navigate to content")
    SameLine()
    if Button("[.]")
        NavigateToSelection(false, 0.5)
    HelpMarker("Navigate to selection")

    if CollapsingHeader("New instruction")
        for ai in keys(g_instructionFactory)
            if Button("{ai}##make_S")
                post_event() <| @
                    var inst = invoke(g_instructionFactory[ai])
                    g_Project->add_new_insturction(inst)
    if CollapsingHeader("Project")
        for inst,idx in g_Project.instructions,range(100500)
            if TreeNode("side_{inst.id}","{inst.name}")
                /*
                if Button("[P]##{inst.id}_S")
                    GeneratePreview(inst)
                HelpMarker("Preview")
                SameLine()
                */
                if Button("<C>##{inst.id}_S")
                    CenterNodeOnScreen(get_unique_id(inst.id))
                HelpMarker("Center")
                SameLine()
                Text("id: `{inst.id}`")
                SameLine()
                if Button("[X]##{inst.id}_S")
                    post_event() <| @
                        g_Project->delete_instruction(inst)
                        inst = null // so that lambda does not delete this pointer
                HelpMarker("Delete")
                Text("name: `{inst.name}`")      // todo: make editabe
                inst->edit()
                TreePop()

    EndChild()
    imgui::PopStyleColor()

    SetCurrentEditor(null)

// MAIN WINDOW

def MainEditorScreen()
    if g_Context == null
        var config = Config()
        config.SettingsFile = "Simple.json"
        g_Context = CreateEditor(safe_addr(config))
    PushStyleVar(ImGuiStyleVar WindowPadding, float2())
    Begin("Surface project editor",null,ImGuiWindowFlags MenuBar | ImGuiWindowFlags NoTitleBar | ImGuiWindowFlags NoResize | ImGuiWindowFlags NoMove | ImGuiWindowFlags NoBackground ) <|
        imgui::PopStyleVar(1)
        var IO & = imgui::GetIO()
        SetWindowPos(float2(0.,0.), ImGuiCond Once)
        SetWindowSize(float2(IO.DisplaySize.x,IO.DisplaySize.y), ImGuiCond Always)
        MainMenu()
        SideChildWindow()
        SameLine()
        BeginChild("Node editor window", float2(0., -FLT_MIN), true, ImGuiWindowFlags NoBackground)
        EditorChildWindow()
        EndChild()

[export]
def main

    g_Project->make_sample_project()

    imgui_app("Testing IMGUI") <|
        NewFrame()
        MainEditorScreen()
        Render()
        for ev in g_que
            invoke(ev)
        delete g_que
    DestroyEditor(g_Context)

