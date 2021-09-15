options indenting = 4

module instructions_model

require instructions public
require model
require preview
require instructions_ui
require produce

require instructions_math public

require daslib/strings_boost

// actions

[instruction_node(name="Call action",category="Actions")]
class Instruction_CallAction : Instruction
    [[serialize]] fn : string
    pin_fn : string
    def Instruction_CallAction
        pass
    def override pre_sync : void
        unsafe
            delete pins
        pins <- collect_action_pins(g_CurrentProject, fn)
        pin_fn = fn
    def override sync : void
        if pin_fn == fn
            var new_pins <- collect_action_pins(g_CurrentProject, fn)
            for i,ni in pins.inputs,new_pins.inputs
                if ni.name==i.name && ni._type==i._type
                    ni.src = i.src
                    ni.output = i.output
            unsafe
                delete pins
            pins <- new_pins
        else
            self->pre_sync()
    def override edit ( mode:EditMode ) : void
        assert(owner!=null)
        Text("Action: {fn}")
    def override produce ( var src_regs : array<int> ): array<string>
        var args <- [{for reg,inp in src_regs,pins.inputs; to_reg_any(reg,inp._type)}]
        for oreg in pins.outputs
            if oreg.reg != -1
                args |> push(to_reg(oreg.reg))  // always real register
        var astr = join(args, ",")
        return <- [{string
            "{decorate_name(fn)}({astr})"
        }]

// action arguments

class Instruction_ActionArgumentAny : Instruction_Argument
    override flags = InstructionFlags HasEdit | InstructionFlags Argument | InstructionFlags Input
    override argument_name = "Arg"
    def Instruction_ActionArgumentAny(argt:string)
        argument_type = argt
        self->add_output("Out",argument_type)
    def override edit ( mode:EditMode ) : void
        NodeArgumentName(mode,id,"Argument name",argument_name,owner)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_any(pins.outputs[0].reg,argument_type)} = {decorate_name(argument_name)}"
        }]

[instruction_node(name="Argument, scalar",category="Actions")]
class Instruction_ActionArgumentScalar : Instruction_ActionArgumentAny
    def Instruction_ActionArgumentScalar
        Instruction_ActionArgumentAny`Instruction_ActionArgumentAny(self,TYPE_SCALAR)

[instruction_node(name="Argument, vector2",category="Actions")]
class Instruction_ActionArgumentVector2 : Instruction_ActionArgumentAny
    def Instruction_ActionArgumentVector2
        Instruction_ActionArgumentAny`Instruction_ActionArgumentAny(self,TYPE_VECTOR2)

[instruction_node(name="Argument, vector3",category="Actions")]
class Instruction_ActionArgumentVector3 : Instruction_ActionArgumentAny
    def Instruction_ActionArgumentVector3
        Instruction_ActionArgumentAny`Instruction_ActionArgumentAny(self,TYPE_VECTOR3)

[instruction_node(name="Argument, vector4",category="Actions")]
class Instruction_ActionArgumentVector4 : Instruction_ActionArgumentAny
    def Instruction_ActionArgumentVector4
        Instruction_ActionArgumentAny`Instruction_ActionArgumentAny(self,TYPE_VECTOR4)

[instruction_node(name="Argument, surface",category="Actions")]
class Instruction_ActionArgumentSurface : Instruction_ActionArgumentAny
    def Instruction_ActionArgumentSurface
        Instruction_ActionArgumentAny`Instruction_ActionArgumentAny(self,TYPE_SURFACE)

// action results

class Instruction_ActionResultAny : Instruction_Argument
    override flags = InstructionFlags HasEdit | InstructionFlags Argument | InstructionFlags Output
    override argument_name = "Res"
    def Instruction_ActionResultAny(argt:string)
        argument_type = argt
        self->add_input("In",argument_type)
    def override edit ( mode:EditMode ) : void
        NodeArgumentName(mode,id,"Result name",argument_name,owner)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{decorate_name(argument_name)} = {to_reg_any(src_regs[0],argument_type)}"
        }]

[instruction_node(name="Result, scalar",category="Actions")]
class Instruction_ActionResultScalar : Instruction_ActionResultAny
    def Instruction_ActionResultScalar
        Instruction_ActionResultAny`Instruction_ActionResultAny(self,TYPE_SCALAR)

[instruction_node(name="Result, vector2",category="Actions")]
class Instruction_ActionResultVector2 : Instruction_ActionResultAny
    def Instruction_ActionResultVector2
        Instruction_ActionResultAny`Instruction_ActionResultAny(self,TYPE_VECTOR2)

[instruction_node(name="Result, vector3",category="Actions")]
class Instruction_ActionResultVector3 : Instruction_ActionResultAny
    def Instruction_ActionResultVector3
        Instruction_ActionResultAny`Instruction_ActionResultAny(self,TYPE_VECTOR3)

[instruction_node(name="Result, vector4",category="Actions")]
class Instruction_ActionResultVector4 : Instruction_ActionResultAny
    def Instruction_ActionResultVector4
        Instruction_ActionResultAny`Instruction_ActionResultAny(self,TYPE_VECTOR4)

[instruction_node(name="Result, surface",category="Actions")]
class Instruction_ActionResultSurface : Instruction_ActionResultAny
    def Instruction_ActionResultSurface
        Instruction_ActionResultAny`Instruction_ActionResultAny(self,TYPE_SURFACE)

// comment

[instruction_node(name="Comment",category="Miscellaneous")]
class Instruction_Comment : Instruction
    [[serialize]] comment : string = "Comment"
    override flags = InstructionFlags Comment | InstructionFlags HasEdit
    def Instruction_Comment
        pass
    def override edit ( mode:EditMode ): void
        NodeTextMultiline(mode,id,"comment",comment,256)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [[array<string>]]

// output

[instruction_node(name="Output surface",category="Surface operations")]
class Instruction_OutputSurface : Instruction
    override flags = InstructionFlags Output
    def Instruction_OutputSurface
        self->add_input("In",TYPE_SURFACE)
    def override edit ( mode:EditMode ): void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "output({to_reg_surface(src_regs[0])},\"{name}\",\"{id}\",\"\")"
        }]

// surface operations

[instruction_node(name="Solid color",category="Surface operations")]
class Instruction_SolidColor : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] color : float4 = float4(.5,.5,.5,1.)
    def Instruction_SolidColor
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ): void
        NodeInputInt2(mode,id,"size",size)
        NodeColorEditor4(mode,id,"color",color)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_solid_color({to_reg(pins.outputs[0].reg)},{to_produce(color)})"
        }]

[instruction_node(name="Image file",category="Surface operations")]
class Instruction_ImageFile : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] fileName : string = ""
    def Instruction_ImageFile
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ): void
        NodeFileName(mode,id,"file",fileName)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_image({to_reg(pins.outputs[0].reg)},\"{escape(fileName)}\")"
        }]

[instruction_node(name="Blur",category="Surface operations")]
class Instruction_Blur : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] sigma : float = 2.0
    def Instruction_Blur
        self->add_input("Inp",TYPE_SURFACE)
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
        NodeDragFloat(mode,id,"sigma",sigma)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_blur({to_reg(pins.outputs[0].reg)},{to_reg_surface(src_regs[0])},{sigma})"
        }]

[instruction_node(name="Sobel",category="Surface operations")]
class Instruction_Sobel : Instruction
    [[serialize]] size : int2 = int2(256,256)
    def Instruction_Sobel
        self->add_input("Inp",TYPE_SURFACE)
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_sobel({to_reg(pins.outputs[0].reg)},{to_reg_surface(src_regs[0])})"
        }]

[instruction_node(name="Greyscale",category="Surface operations")]
class Instruction_Greyscale : Instruction
    [[serialize]] size : int2 = int2(256,256)
    def Instruction_Greyscale
        self->add_input("Inp",TYPE_SURFACE)
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_greyscale({to_reg(pins.outputs[0].reg)},{to_reg_surface(src_regs[0])})"
        }]

[instruction_node(name="Gradient",category="Surface operations")]
class Instruction_Gradient : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] top_left : float4 = float4(1.,0.,0.,1.)
    [[serialize]] top_right : float4 = float4(0.,1.,0.,1.)
    [[serialize]] bottom_left : float4 = float4(0.,0.,1.,1.)
    [[serialize]] bottom_right : float4 = float4(0.5,0.5,0.5,1.)
    def Instruction_Gradient
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
        NodeColorEditor4(mode,id,"top-left",top_left)
        NodeColorEditor4(mode,id,"top-right",top_right)
        NodeColorEditor4(mode,id,"bottom-left",bottom_left)
        NodeColorEditor4(mode,id,"bottom-right",bottom_right)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_gen_gradient({to_reg(pins.outputs[0].reg)},{to_produce(top_left)},{to_produce(top_right)},{to_produce(bottom_left)},{to_produce(bottom_right)})"
        }]

enum BlendOp
    Add
    Multiply
    Crossfade

[instruction_node(name="Blend",category="Surface operations")]
class Instruction_Blend : Instruction
    [[serialize]] size : int2 = int2(256,256)
    [[serialize]] op  : BlendOp = BlendOp Add
    def Instruction_Blend
        self->add_input("Src",TYPE_SURFACE)
        self->add_input("Dst",TYPE_SURFACE)
        self->add_input("Factor",TYPE_SCALAR)
        self->add_output("Out",TYPE_SURFACE)
    def override edit ( mode:EditMode ) : void
        NodeInputInt2(mode,id,"size",size)
        NodeEditEnumeration(mode,id,"Operation",op)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "create_surface({to_reg(pins.outputs[0].reg)},{to_produce(size)})";
            "surface_blend_{op}({to_reg(pins.outputs[0].reg)},{to_reg_surface(src_regs[0])},{to_reg_surface(src_regs[1])},{to_reg(src_regs[2],"0.5f")})"
        }]

