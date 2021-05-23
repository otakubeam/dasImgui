options indenting = 4
options remove_unused_symbols = false

module instructions_model

require instructions public
require preview
require instructions_ui

require math

[instruction_node(name="Scalar",category="Scalar operations")]
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
        NodeDragFloat(id,"value",value)
    def override save ( var node:table<string;JsonValue?> ) : void
        node["value"] = JV(value)
    def override load ( var node:table<string;JsonValue?> ) : void
        value = float(node["value"] as _number)

[instruction_node(name="Add scalar",category="Scalar operations")]
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
        NodeCheckbox(id,"log",log)
    def override save ( var node:table<string;JsonValue?> ) : void
        pass
    def override load ( var node:table<string;JsonValue?> ) : void
        pass

[instruction_node(name="Solid color",category="Surface operations")]
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
        NodeColorEditor4(id,"color",color)
    def override save ( var node:table<string;JsonValue?> ) : void
        node["color"] = JV(color)
    def override load ( var node:table<string;JsonValue?> ) : void
        color = from_JV(node["color"],type<float4>)

[instruction_node(name="Gradient",category="Surface operations")]
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
        NodeColorEditor4(id,"top-left",top_left)
        NodeColorEditor4(id,"top-right",top_right)
        NodeColorEditor4(id,"bottom-left",bottom_left)
        NodeColorEditor4(id,"bottom-right",bottom_right)
    def override save ( var node:table<string;JsonValue?> ) : void
        node["top-left"] = JV(top_left)
        node["top-right"] = JV(top_right)
        node["bottom-left"] = JV(bottom_left)
        node["bottom-right"] = JV(bottom_right)
    def override load ( var node:table<string;JsonValue?> ) : void
        top_left = from_JV(node["top-left"],type<float4>)
        top_right = from_JV(node["top-right"],type<float4>)
        bottom_left = from_JV(node["bottom-left"],type<float4>)
        bottom_right = from_JV(node["bottom-right"],type<float4>)

enum BlendOp
    Add
    Multiply
    Crossfade

[instruction_node(name="Blend",category="Surface operations")]
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
        NodeEditEnumeration(id,"Operation",op)
    def override save ( var node:table<string;JsonValue?> ) : void
        node["op"] = JV(op)
    def override load ( var node:table<string;JsonValue?> ) : void
        op = from_JV(node["op"],type<BlendOp>)

