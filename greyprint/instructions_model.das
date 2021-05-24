options indenting = 4
options remove_unused_symbols = false

module instructions_model

require instructions public
require model
require preview
require instructions_ui

[instruction_node(name="Scalar",category="Scalar operations")]
class Instruction_Scalar : Instruction
    override editing = true
    [[serialize]] value : float = 1.
    def Instruction_Scalar
        name = "Scalar"
        self->add_output("Out",TYPE_SCALAR)
    def override generate : array<Value>
        var result : array<Value>
        var reg : Value
        scalar_scalar(reg, value)
        return <- [{Value reg}]
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"value",value)

[instruction_node(name="Add scalar",category="Scalar operations")]
class Instruction_AddScalar : Instruction
    override editing = true
    log : bool = false
    last_eval : float = 0.
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
        var reg : Value
        scalar_add(reg,v1,v2)
        last_eval = reg as scalar
        if log
            print("{name}:{id} value = {reg}\n")
        return <- [{Value reg}]
    def override edit ( mode:EditMode ) : void
        let text = "-> {last_eval}"
        Text(text)
        SameLine(CalcTextSize(text).x + 5.)
        NodeCheckbox(mode,id,"log",log)


[instruction_node(name="Solid color",category="Surface operations")]
class Instruction_SolidColor : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] color : float4 = float4(.5,.5,.5,1.)
    def Instruction_SolidColor
        name = "Solid color"
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
        var s : Value
        create_surface(s, size.x, size.y)
        surface_solid_color(s, color)
        return <- [{Value s}]
    def override edit ( mode:EditMode ): void
        NodeInputInt2(mode,id,"size",size)
        NodeColorEditor4(mode,id,"color",color)

[instruction_node(name="Gradient",category="Surface operations")]
class Instruction_Gradient : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] top_left : float4 = float4(1.,0.,0.,1.)
    [[serialize]] top_right : float4 = float4(0.,1.,0.,1.)
    [[serialize]] bottom_left : float4 = float4(0.,0.,1.,1.)
    [[serialize]] bottom_right : float4 = float4(0.5,0.5,0.5,1.)
    def Instruction_Gradient
        name = "Gradient"
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
        var s : Value
        create_surface(s, size.x, size.y)
        surface_gradient(s, top_left, top_right, bottom_left, bottom_right)
        return <- [{Value s}]
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
        NodeColorEditor4(mode,id,"top-left",top_left)
        NodeColorEditor4(mode,id,"top-right",top_right)
        NodeColorEditor4(mode,id,"bottom-left",bottom_left)
        NodeColorEditor4(mode,id,"bottom-right",bottom_right)

enum BlendOp
    Add
    Multiply
    Crossfade

[instruction_node(name="Blend",category="Surface operations")]
class Instruction_Blend : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] op  : BlendOp = BlendOp Add
    def Instruction_Blend
        name = "Blend"
        self->add_input("Src",TYPE_SURFACE)
        self->add_input("Dst",TYPE_SURFACE)
        self->add_input("Factor",TYPE_SCALAR)
        self->add_output("Out",TYPE_SURFACE)
    def override generate : array<Value>
        var src = inputs[0].src
        var dst = inputs[1].src
        var s : Value
        create_surface(s, size.x, size.y)
        var error = true
        if src!=null && dst!=null
            var src_r <- gen_input(src)
            var dst_r <- gen_input(dst)
            assert((length(src_r)==1) && (src_r[0] is surface))
            assert(length(dst_r)==1 && (dst_r[0] is surface))
            if (src_r[0] as surface).size==size && (dst_r[0] as surface).size==size
                if op==BlendOp Add
                    surface_blend_add(s,src_r[0],dst_r[0])
                elif op==BlendOp Multiply
                    surface_blend_mul(s,src_r[0],dst_r[0])
                elif op==BlendOp Crossfade
                    if inputs[2].src != null
                        var fact_r <- gen_input(inputs[2].src)
                        assert((length(fact_r)==1) && (fact_r[0] is scalar))
                        surface_blend_crossfade(s,src_r[0],dst_r[0],fact_r[0])
                        delete fact_r
                    else
                        surface_blend_crossfade(s,src_r[0],dst_r[0],0.5)
                error = false
            delete src_r
            delete dst_r
        if error
            surface_solid_color(s,float4(1,0,0,1))
        return <- [{Value s}]
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
        NodeEditEnumeration(mode,id,"Operation",op)

