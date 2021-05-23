options indenting = 4
options remove_unused_symbols = false

module instructions

require rtti
require imgui
require daslib/json_boost public
require daslib/safe_addr
require daslib/ast_boost
require daslib/static_let

// surface

struct Surface
    size : int2
    data : array<float4>

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

let CATEGORY_UNCATEGORIZED = "Uncategorized"

variant Value
    surface : Surface
    scalar  : float

class Instruction
    id : string                             // unique ID of instruction (expecting GUID)
    name : string                           // user readable name. can be duplicate
    at : float2 = float2(-FLT_MAX,-FLT_MAX) // position in the node editor
    firstFrame : bool = true
    editing : bool = false
    size : int2 = int2(256,256)             // dimensions of the generated surface. never 0 or invalid
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

def find_input ( var inst:Instruction?; iname:string; blk : block<(var inp:Input?#):void> ) : void
    for i in inst.inputs
        if i.name==iname
            invoke(blk,safe_addr(i))
            return
    unsafe
        invoke(blk,reinterpret<Input?#> null)

// todo: cache
def gen_input ( var from:Instruction? ): array<Value>
    return <- from->generate()

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
                "rtti" => JV(tname);
                "at" => JV(inst.at)
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
    def load ( var proot:JsonValue? ): void
        if proot==null
            return
        var root & = proot.value as _object
        var nodes & = root["nodes"].value as _array
        for pnode in nodes
            var node & = pnode.value as _object
            let ntype = node["rtti"].value as _string
            var inst = make_instruction(ntype)
            inst.id = node["id"].value as _string
            inst.name = node["name"].value as _string
            inst.at = from_JV(node["at"],type<float2>)
            (*inst)->load(node)
            instructions |> push(inst)
        var links & = root["links"].value as _array
        for plink in links
            var link & = plink.value as _object
            let input_id = link["input_id"].value as _string
            var inst = self->find_instruction(input_id)
            assert(inst != null)
            let input_name = link["input_name"].value as _string
            inst |>find_input(input_name) <| $ ( inp )
                inp.output = link["output_name"].value as _string
                let output_id = link["output_id"].value as _string
                inp.src = self->find_instruction(output_id)

// factory

var g_instructionFactory : table < string; lambda<():Instruction?> >

var g_instructionsByCategory : array < tuple<name:string;category:string;tname:string> >

[unused_argument(it_type)]
def make_instruction_factory ( it_name,it_category:string; it_type:auto(InstType)-const )
    let tname = typeinfo(undecorated_typename type<InstType>)
    g_instructionFactory[tname] <- @ <| () : Instruction?
        return new InstType()
    g_instructionsByCategory |> push([[auto it_name,it_category,tname]])

def make_instruction ( it_type:string )
    if g_instructionFactory |> key_exists(it_type)
        return invoke(g_instructionFactory[it_type])
    else
        print("available types are {g_instructionFactory}\n")
        panic("making unknown instruction type {it_type}")
        return null

def seal_instruction_factory
    g_instructionsByCategory |> sort <| $(a,b)
        if a.category != b.category
            return a.category < b.category
        else
            return a.name < b.name

// add instruction type registration function
//  make_instruction_factory("Solid color", CATEGORY_SURFACE_OPERATIONS, type<Instruction_SolidColor>)
[structure_macro(name="instruction_node")]
class InstructionNodeStructureAnnotation : AstStructureAnnotation
    def override apply ( var str:StructurePtr; var group:ModuleGroup; args:AnnotationArgumentList; var errors : das_string ) : bool
        // get name and category
        var category = CATEGORY_UNCATEGORIZED
        var name = "{str.name}"
        for arg in args
            let val = get_annotation_argument_value(arg)
            if !(val is tString)
                errors := "invalid argument {arg.name}"
                return false
            let valName = "{arg.name}"
            let valValue = "{val as tString}"
            if valName=="name"
                name = valValue
            elif valName=="category"
                category = valValue
            else
                errors := "invalid argument {arg.name}"
                return false
        // generate init function
        var fn <- compiling_module() |> find_unique_function(name)
        if fn == null
            fn <- new [[Function() at=str.at, atDecl=str.at, name:="init`instruction`{str.name}"]]
            fn.flags |= FunctionFlags generated
            fn.flags |= FunctionFlags init
            fn.result <- new [[TypeDecl() baseType=Type autoinfer, at=str.at]]
            var blk <- new [[ExprBlock() at=str.at]]
            var cmt <- new [[TypeDecl() at=str.at, baseType=Type tStructure, structType=get_ptr(str)]]
            var cmi <- new [[ExprCall() at=str.at, name:="make_instruction_factory"]]
            cmi.arguments |> emplace_new() <| new [[ExprConstString() at=str.at, value:=name]]
            cmi.arguments |> emplace_new() <| new [[ExprConstString() at=str.at, value:=category]]
            cmi.arguments |> emplace_new() <| new [[ExprTypeDecl() at=str.at, typeexpr<-cmt]]
            blk.list |> emplace(cmi)
            fn.body <- blk
            if !(compiling_module() |> add_function(fn))
                panic("can't setup")
        return true

