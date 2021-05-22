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
require strings
require daslib/strings_boost
require daslib/json
require daslib/json_boost

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

struct Connection
    name : string
    _type : string

struct Input : Connection
    src  : Instruction?
    output : string

def finalize ( var inp: Input )
    pass

def connect ( var inp:Input; src:Instruction?; outp:string )
    inp.src = src
    inp.output = outp

struct Output : Connection {}

let TYPE_SURFACE = "surface"
let TYPE_SCALAR = "scalar"

let CATEGORY_SCALAR_OPERATIONS = "Scalar operations"
let CATEGORY_SURFACE_OPERATIONS = "Surface operations"

variant Value
    surface : Surface
    scalar  : float

class Instruction
    id : string                         // unique ID of instruction (expecting GUID)
    name : string                       // user readable name. can be duplicate
    at : int2                           // position in the node editor
    firstFrame : bool = true
    editing : bool = false
    size : int2 = int2(256,256)         // dimensions of the generated surface. never 0 or invalid
    inputs : array<Input>
    outputs : array<Output>
    def abstract generate : array<Value>
    def abstract edit : void
    def abstract save ( var node:table<string;JsonValue?> ) : void
    def abstract load ( var node:table<string;JsonValue?> ) : void
    def add_input ( iname, itype : string )
        inputs |> push([[Input name=iname,_type=itype]])
    def add_output ( iname, itype : string )
        outputs |> push([[Output name=iname,_type=itype]])
    def input_index ( iname:string ) : int
        return inputs |> find_index_if <| $ ( val )
            return val.name==iname
    def output_index ( iname:string ) : int
        return outputs |> find_index_if <| $ ( val )
            return val.name==iname

// todo: cache
def gen_input ( var from:Instruction? ): array<Value>
    return <- from->generate()

def SafeColorEditor4(name:string;data:float?#)
    SetNextItemWidth(300.)
    if ColorPicker4(name,data,ImGuiColorEditFlags NoTooltip)
        UpdatePreview()
        return true
    else
        return false

class Instruction_Scalar : Instruction
    value : float = 1.
    def Instruction_Scalar
        name = "Scalar"
        self->add_output("Out",TYPE_SCALAR)
    def override generate : array<Value>
        var result : array<Value>
        result |> emplace([[Value scalar=value]])
        return <- result
    def override edit : void
        SetNextItemWidth(300.)
        if DragFloat("value##{id}", safe_addr(value), 0.005f)
            UpdatePreview()
    def override save ( var node:table<string;JsonValue?> ) : void
        node["value"] = JV(value)

class Instruction_AddScalar : Instruction
    log : bool = false
    def Instruction_AddScalar
        name = "Add Scalar"
        self->add_input("In-1",TYPE_SCALAR)
        self->add_input("In-2",TYPE_SCALAR)
        self->add_output("Out",TYPE_SCALAR)
    def override generate : array<Value>
        var v1, v2 : float
        if inputs[0].src != null
            var outs <- gen_input(inputs[0].src)
            assert(length(outs)==1)
            assert(outs[0] is scalar)
            v1 = outs[0] as scalar
        if inputs[1].src != null
            var outs <- gen_input(inputs[1].src)
            assert(length(outs)==1)
            assert(outs[0] is scalar)
            v2 = outs[0] as scalar
        let value = v1 + v2
        if log
            print("{name}:{id} value = {value}\n")
        var result : array<Value>
        result |> emplace([[Value scalar=value]])
        return <- result
    def override edit : void
        Checkbox("log##{id}",safe_addr(log))
    def override save ( var node:table<string;JsonValue?> ) : void
        pass


class Instruction_SolidColor : Instruction
    color : float4 = float4(.5,.5,.5,1.)
    def Instruction_SolidColor
        name = "Solid color"
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
        var s : Surface
        s.size = size
        s.data |> resize(size.x*size.y)
        for c in s.data
            c = color
        var result : array<Value>
        result |> emplace([[Value surface<-s]])
        return <- result
    def override edit : void
        if SafeColorEditor4("color",safe_addr(color.x))
            UpdatePreview()
    def override save ( var node:table<string;JsonValue?> ) : void
        node["color"] = JV(color)

class Instruction_Gradient : Instruction
    top_left : float4 = float4(1.,0.,0.,1.)
    top_right : float4 = float4(0.,1.,0.,1.)
    bottom_left : float4 = float4(0.,0.,1.,1.)
    bottom_right : float4 = float4(0.5,0.5,0.5,1.)
    def Instruction_Gradient
        name = "Gradient"
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
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
        var result : array<Value>
        result |> emplace([[Value surface<-s]])
        return <- result
    def override edit : void
        if SafeColorEditor4("top-left",     safe_addr(top_left.x))
            UpdatePreview()
        if SafeColorEditor4("top-right",    safe_addr(top_right.x))
            UpdatePreview()
        if SafeColorEditor4("bottom-left",  safe_addr(bottom_left.x))
            UpdatePreview()
        if SafeColorEditor4("bottom-right", safe_addr(bottom_right.x))
            UpdatePreview()
    def override save ( var node:table<string;JsonValue?> ) : void
        node["top-left"] = JV(top_left)
        node["top-right"] = JV(top_right)
        node["bottom-left"] = JV(bottom_left)
        node["bottom-right"] = JV(bottom_right)

enum BlendOp
    Add
    Multiply
    Crossfade

class Instruction_Blend : Instruction
    op  : BlendOp = BlendOp Add
    def Instruction_Blend
        name = "Blend"
        self->add_input("Src",TYPE_SURFACE)
        self->add_input("Dst",TYPE_SURFACE)
        self->add_input("Factor",TYPE_SCALAR)
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
        var src = inputs[0].src
        var dst = inputs[1].src
        var s : Surface
        s.size = size
        s.data |> resize(size.x*size.y)
        var error = true
        if src!=null && dst!=null
            var src_r <- gen_input(src)
            var dst_r <- gen_input(dst)
            assert((length(src_r)==1) && (src_r[0] is surface))
            assert(length(dst_r)==1 && (dst_r[0] is surface))
            var src_s & = src_r[0] as surface
            var dst_s & = dst_r[0] as surface
            if src_s.size==size && dst_s.size==size
                if op==BlendOp Add
                    for c,sC,dC in s.data,src_s.data,dst_s.data
                        c = sC + dC
                elif op==BlendOp Multiply
                    for c,sC,dC in s.data,src_s.data,dst_s.data
                        c = sC * dC
                elif op==BlendOp Crossfade
                    var factor = 0.5f
                    if inputs[2].src != null
                        var fact_r <- gen_input(inputs[2].src)
                        assert((length(fact_r)==1) && (fact_r[0] is scalar))
                        factor = clamp(fact_r[0] as scalar, 0., 1.)
                        delete fact_r
                    let ifactor = 1. - factor
                    for c,sC,dC in s.data,src_s.data,dst_s.data
                        c = sC*ifactor + dC*factor
                error = false
            delete src_r
            delete dst_r
        if error
            for c in s.data
                c = float4(1,0,0,1)
        var result : array<Value>
        result |> emplace([[Value surface<-s]])
        return <- result
    def override edit : void
        if EmbeddedListBox("Operation", op)
            UpdatePreview()
    def override save ( var node:table<string;JsonValue?> ) : void
        node["op"] = JV(op)

// factory

var g_instructionFactory : table < string; lambda<():Instruction?> >

var g_instructionsByCategory : array < tuple<name:string;category:string;tname:string> >

[unused_argument(it_type)]
def make_instruction_factory ( it_name,it_category:string; it_type:auto(InstType) )
    let tname = typeinfo(typename type<InstType>)
    g_instructionFactory[tname] <- @ <| () : Instruction?
        return new InstType()
    g_instructionsByCategory |> push([[auto it_name,it_category,tname]])

[init]
def init_instruction_factory           // todo: turn into annotation
 // scalar
    make_instruction_factory("Scalar", CATEGORY_SCALAR_OPERATIONS, type<Instruction_Scalar>)
    make_instruction_factory("Add scalar", CATEGORY_SCALAR_OPERATIONS, type<Instruction_AddScalar>)
// surface
    make_instruction_factory("Solid color", CATEGORY_SURFACE_OPERATIONS, type<Instruction_SolidColor>)
    make_instruction_factory("Gradient", CATEGORY_SURFACE_OPERATIONS, type<Instruction_Gradient>)
    make_instruction_factory("Blend", CATEGORY_SURFACE_OPERATIONS, type<Instruction_Blend>)
// and prepare for production
    g_instructionsByCategory |> sort <| $(a,b)
        if a.category != b.category
            return a.category < b.category
        else
            return a.name < b.name

// project

def generate_new_id()       // TODO: generate real GUID
    static_let <|
        var uuid = 0
    uuid ++
    return "GUID_{uuid}"

class Project
    instructions : array<Instruction?>
    def clear
        delete instructions
    def finalize
        self->clear()
    def find_instruction ( id:string ) : Instruction?
        let index = instructions |> find_index_if <| $ ( val )
            return val.id==id
        return index==-1 ? null : instructions[index]
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
    def save : JsonValue?
        var nodes : array<JsonValue?>
        for inst in instructions
            var tname = class_info(*inst).name
            var inode <- {{
                "id" => JV(inst.id);
                "name" => JV(inst.name);
                "rtti" => JV(tname)
            }}
            inst->save(inode)
            nodes |> push(JV(inode))
        var links : array<JsonValue?>
        for inst in instructions
            for inp in inst.inputs
                if inp.src != null
                    var lnk <- {{
                        "input_id"    => JV(inst.id);
                        "input_name"  => JV(inp.name);
                        "output_id"   => JV(inp.src.id);
                        "output_name" => JV(inp.output)
                    }}
                    links |> push(JV(lnk))
        var root <- {{
            "nodes"=> JV(nodes);
            "links" => JV(links)
        }}
        return JV(root)

var g_Project <- Project()

// PREVIEW

var g_PreviewTexture : uint
var g_PreviewInstruction : Instruction?
var g_PreviewOutput : string
var g_LivePreview = true

def ClearPreview
    g_PreviewInstruction = null
    if g_PreviewTexture != 0u
        glDeleteTextures(1, safe_addr(g_PreviewTexture))
        g_PreviewTexture = 0u

def UpdatePreview
    if g_LivePreview && g_PreviewInstruction!=null
        GeneratePreview(g_PreviewInstruction, g_PreviewOutput)

def GeneratePreview(var inst:Instruction?; outp:string)
    g_PreviewInstruction = inst
    g_PreviewOutput = outp
    var surf <- inst->generate()
    var tex = 0u
    for op,opi in inst.outputs,range(100500)
        if op.name==outp
            assert(surf[opi] is surface)
            tex = make_prewview_rgba_texture(surf[opi] as surface)
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

var g_SavedProject : string

def SaveProject
    var jv = g_Project->save()
    g_SavedProject = write_json(jv)
    print("\n\n\n{g_SavedProject}\n\n\n")
    unsafe
        delete jv

def NewProject()
    post_event <| @
        DestroyEditor(g_Context)
        g_Context = null
        g_Project->clear()
        reset_guids()
        ClearPreview()

def MainMenu()
    BeginMenuBar <|
        BeginMenu("File") <|
            if MenuItem("New##Project")
                NewProject()
            if MenuItem("Save##Project")
                SaveProject()
        var previewName = ""
        if g_PreviewInstruction != null
            previewName = " {g_PreviewInstruction.name}:{g_PreviewInstruction.id}"
        BeginMenu("Preview{previewName}") <|
            if Checkbox("Live preview",safe_addr(g_LivePreview))
                UpdatePreview()

// GUID TO IMGUI ID

var guid_2_id : table<string; int>
var id_2_guid : table<int; string>
var guid_2_id_next = 1000

def reset_guids
    delete guid_2_id
    delete id_2_guid
    guid_2_id_next = 1000

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
    return get_unique_id("INPUT {inst.id} {inp}")

def get_output_unique_id ( inst:Instruction?; outp:string ) : int
    return get_unique_id("OUTPUT {inst.id} {outp}")

def translate_input_output_id ( id:int; typ:string ) : tuple<inst:Instruction?; pin:string> const
    assert(id_2_guid |> key_exists(id))
    var note <- split(id_2_guid[id]," ")
    assert(note[0]==typ)
    let instr = g_Project->find_instruction(note[1])
    assert(instr!=null)
    let val = [[auto instr, note[2]]]
    delete note
    return val

// COMMAND QUE

var g_que : array<lambda<():void>>

def post_event ( var evt : lambda<():void> )
    g_que |> emplace(evt)

// NODE EDITOR WINDOW

var g_Context : EditorContext?

// TODO: move to builtin
def swap ( var a,b:auto(TT)& )
    var t : TT - & <- a
    a <- b
    b <- t

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
                    DeleteNode(get_unique_id(inst.id))
                if inst.editing
                    inst->edit()
                ImGuiEx_BeginColumn()
                for inp in inst.inputs
                    let inp_id = get_input_unique_id(inst,inp.name)
                    BeginPin(inp_id, PinKind Input) <|
                        Text("-> {inp.name}:{inp._type}")
                        if inp.src != null
                            SameLine()
                            if Button("[G]##goto_{inp}_from_{inst.id}")
                                SelectNode(get_unique_id(inp.src.id), false)
                                NavigateToSelection(false, NAVIGATION_TIME)
                                ClearSelection()
                            SameLine()
                            if Button("[X]##goto_{inp}_from_{inst.id}")
                                DeleteLink(inp_id)
                ImGuiEx_NextColumn()
                for outp in inst.outputs
                    let outp_id = get_output_unique_id(inst,outp.name)
                    BeginPin(outp_id, PinKind Output) <|
                        Text("{outp.name}:{outp._type} ->")
                        SameLine()
                        if outp._type==TYPE_SURFACE
                            if Button("[P]##{inst.id}_E")
                                GeneratePreview(inst,outp.name)
                        else
                            if Button("[E]##{inst.id}_E")
                                var surf <- inst->generate()
                                delete surf

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
                    GeneratePreview(inst,outp.name)
                HelpMarker("Preview")
            else
                if Button("[E]##{inst.id}_S")
                    var surf <- inst->generate()
                    delete surf
                HelpMarker("Eval")
        inst->edit()
        TreePop()

def SideChildWindow()
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
                        var inst = invoke(g_instructionFactory[ai.tname])
                        g_Project->add_new_insturction(inst)
        if !collapsed
            TreePop()

    var snc = GetSelectedObjectCount()
    if snc != 0
        if CollapsingHeader("Selection", ImGuiTreeNodeFlags DefaultOpen)
            var sna : array<NodeId>
            sna |> resize(snc)
            unsafe
                snc = GetSelectedNodes(addr(sna[0]),snc)
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
                if ng != 0
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

