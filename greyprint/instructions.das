options indenting = 4
options remove_unused_symbols = false

module instructions shared

require rtti
require imgui
require uriparser
require daslib/json_boost public
require daslib/safe_addr
require daslib/ast_boost
require daslib/static_let


// surface

struct Surface
    size : int2
    data : array<float4>

def Surface ( w,h:int )
    var data : array<float4>
    data |> resize(w*h)
    return <- [[Surface size=int2(w,h), data<-data]]

// instructions

struct Connection
    name    : string
    _type   : string

struct Input : Connection
    src    : Instruction?
    output : string

def finalize ( var inp: Input )
    pass

def connect ( var inp:Input; src:Instruction?; outp:string )
    inp.src = src
    inp.output = outp

struct Output : Connection
    preview : bool
    reg     : int
    tex     : void?

let TYPE_SURFACE = "surface"
let TYPE_SCALAR = "scalar"

let CATEGORY_UNCATEGORIZED = "Uncategorized"

enum EditMode
    Sidebar         // in the side menu
    Embedded        // in the node

bitfield InstructionFlags
    Output
    HasEdit
    Comment

class Instruction
    id : string                             // unique ID of instruction (expecting GUID)
    name : string                           // user readable name. can be duplicate
    at : float2 = float2(-FLT_MAX,-FLT_MAX) // position in the node editor
    extents : float2 = float2(256.,256.)    // size in the node editor (for relevant nodes)
    flags : InstructionFlags = InstructionFlags HasEdit
    firstFrame : bool = true
    select : bool = false
    navigate : bool = false
    editing : bool = false
    inputs : array<Input>
    outputs : array<Output>
    tex : void?
    def abstract edit ( mode:EditMode ) : void
    def abstract save ( var node:table<string;JsonValue?> ) : void
    def abstract load ( var node:table<string;JsonValue?> ) : void
    def abstract produce ( var src_regs : array<int> ): array<string>
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
    def JV
        var tname = class_info(self).name
        var inode <- {{
            "id" => JV(id);
            "name" => JV(name);
            "rtti" => JV(tname);
            "at" => JV(at);
            "extents" => JV(extents);
            "flags" => JV(flags)
        }}
        self->save(inode)
        return JV(inode)
    def from_JV ( var pnode:JsonValue? )
        var node & = pnode.value as _object
        id = node["id"].value as _string
        name = node["name"].value as _string
        at = from_JV(node["at"],type<float2>)
        extents = from_JV(node["extents"],type<float2>)
        flags = from_JV(node["flags"],type<InstructionFlags>)
        self->load(node)

def find_input ( var inst:Instruction?; iname:string; blk : block<(var inp:Input?#):void> ) : void
    for i in inst.inputs
        if i.name==iname
            invoke(blk,safe_addr(i))
            return
    unsafe
        invoke(blk,reinterpret<Input?#> null)


def find_output ( var inst:Instruction?; iname:string; blk : block<(var inp:Output?#):void> ) : void
    for i in inst.outputs
        if i.name==iname
            invoke(blk,safe_addr(i))
            return
    unsafe
        invoke(blk,reinterpret<Output?#> null)

// project

def generate_new_id()
    return uriparser::make_new_guid()

class Project
    instructions : array<Instruction?>
    lookup : table<string; Instruction?>
    def clear
        delete instructions
        clear(lookup)
    def finalize
        self->clear()
    def find_instruction ( id:string ) : Instruction?
        return lookup?[id] ?? null
    def add_new_insturction ( var i : Instruction? )
        i.id = generate_new_id()
        instructions |> push(i)
        lookup[i.id] = i
    def delete_instruction ( var dinst:Instruction? )
        var idx = -1
        for i,index in instructions,range(100500)
            if i == dinst
                idx = index
            for inp in i.inputs
                if inp.src==dinst
                    inp.src = null
        assert(idx!=-1)
        instructions |> erase(idx)
        lookup |> erase(dinst.id)
        unsafe
            delete dinst
    def save : JsonValue?
        var nodes : array<JsonValue?>
        for inst in instructions
            nodes |> push(inst->JV())
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
            (*inst)->from_JV(pnode)
            instructions |> push(inst)
            lookup[inst.id] = inst
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

def find_loop ( src,inst:Instruction?; var visited:table<Instruction?;bool> )
    if visited |> key_exists(inst)
        return false
    visited[inst] = true
    for inp in inst.inputs
        if inp.src!=null
            if inp.src==src
                return true
            if find_loop(src,inp.src,visited)
                return true
    return false

def find_loop ( proj:Project )
    for inst in proj.instructions
        var visited : table<Instruction?; bool>
        if find_loop(inst, inst, visited)
            return true
    return false

// factory

struct InstructionCategory
    name:string
    category:string
    tname:string
    main_in:string
    main_out:string

var g_instructionFactory : table < string; lambda<():Instruction?> >

var g_instructionsByCategory : array<InstructionCategory>

[unused_argument(it_type)]
def make_instruction_factory ( it_name,it_category:string; it_type:auto(InstType)-const )
    let tname = typeinfo(undecorated_typename type<InstType>)
    var factory <- @ <| () : Instruction?
        return new InstType()
    var dummy = invoke(factory)
    g_instructionFactory[tname] <- factory
    var main_in  = (length(dummy.inputs)>0) ? dummy.inputs[0]._type : ""
    var main_out = (length(dummy.outputs)>0) ? dummy.outputs[0]._type : ""
    unsafe
        delete dummy
    g_instructionsByCategory |> push([[InstructionCategory
        name=it_name,
        category=it_category,
        tname=tname,
        main_in=main_in,
        main_out=main_out
    ]])

def make_instruction ( it_type:string implicit )
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

def generate_node_init(name,category:string;var str:StructurePtr)
    let fnname = "init`instruction`{str.name}"
    var fn <- compiling_module() |> find_unique_function(fnname)
    if fn == null
        fn <- new [[Function() at=str.at, atDecl=str.at, name:=fnname]]
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

// def {name} ( slef:{str._type}; var node:table<string;JsonValue> )
def generate_serialize ( name : string; var str:StructurePtr )
    var fn <- new [[Function() at=str.at, atDecl=str.at, name:=name]]
    fn.flags |= FunctionFlags generated
    fn.result <- new [[TypeDecl() baseType=Type autoinfer, at=str.at]]
    fn.arguments |> emplace_new() <| new [[Variable() at=str.at,
        name := "self",
        _type <- new [[TypeDecl() at=str.at,
            baseType=Type tStructure,
            structType=get_ptr(str)
        ]]
    ]]
    fn.arguments |> emplace_new() <| new  [[Variable() at=str.at,
        name := "node",
        _type <- clone_type() <| typeinfo(ast_typedecl type<table<string;json::JsonValue?> -const>)
    ]]
    return <- fn

// def override save ( var node:table<string;json:JsonValue?> )
def generate_node_save(var str:StructurePtr)
    let name = "{str.name}`save"
    var fn <- compiling_module() |> find_unique_function(name)
    if fn == null
        unsafe
            fn <- generate_serialize(name,str)
        var blk <- new [[ExprBlock() at=str.at]]
        for fld in str.fields
            for ann in fld.annotation
                if "{ann.name}"=="serialize"
                    // node["{fld.name}"] = JV(self.{fld.name})
                    var cll <- new [[ExprCall() at=str.at, name:="JV"]]
                    cll.arguments |> emplace_new() <| new [[ExprField() at=str.at,
                        name := fld.name,
                        value <- new [[ExprVar() at=str.at, name:="self"]]
                    ]]
                    var cpy <- new [[ExprCopy() at=str.at,
                        left <- new [[ExprAt() at=str.at,
                            subexpr <- new [[ExprVar() at=str.at, name:="node"]],
                            index <- new [[ExprConstString() at=str.at, value:=fld.name]]
                        ]],
                        right <- cll
                    ]]
                    blk.list |> emplace(cpy)
                    break
        fn.body <- blk
        if !(compiling_module() |> add_function(fn))
            panic("can't setup")
        override_method(str, "save", "_::{name}")

// def override load ( var node:table<string;json:JsonValue?> )
def generate_node_load(var str:StructurePtr)
    let name = "{str.name}`load"
    var fn <- compiling_module() |> find_unique_function(name)
    if fn == null
        unsafe
            fn <- generate_serialize(name,str)
        var blk <- new [[ExprBlock() at=str.at]]
        for fld in str.fields
            for ann in fld.annotation
                if "{ann.name}"=="serialize"
                    // self.{fld.name} = from_JV(node["{fld.name}"],type<fld.type>)
                    var cll <- new [[ExprCall() at=str.at, name:="from_JV"]]
                    cll.arguments |> emplace_new() <| new [[ExprAt() at=str.at,
                        subexpr <- new [[ExprVar() at=str.at, name:="node"]],
                        index <- new [[ExprConstString() at=str.at, value:=fld.name]]
                    ]]
                    cll.arguments |> emplace_new() <| new [[ExprTypeDecl() at=str.at,
                        typeexpr <- clone_type(fld._type)
                    ]]
                    var cpy <- new [[ExprCopy() at=str.at,
                        left <- new [[ExprField() at=str.at,
                            name := fld.name,
                            value <- new [[ExprVar() at=str.at, name:="self"]]
                        ]],
                        right <- cll
                    ]]
                    blk.list |> emplace(cpy)
                    break
        fn.body <- blk
        if !(compiling_module() |> add_function(fn))
            panic("can't setup")
        override_method(str, "load", "_::{name}")

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
        generate_node_init(name,category,str)
        generate_node_save(str)
        generate_node_load(str)
        return true

