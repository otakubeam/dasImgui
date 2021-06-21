options indenting = 4
options remove_unused_symbols = false

module instructions_math

require instructions public
require model
require preview
require instructions_ui
require produce

class Instruction_DebugCommon : Instruction
    override editing = true
    override flags = InstructionFlags Output | InstructionFlags HasEdit
    debug_type : string
    def Instruction_DebugCommon(dtype:string)
        debug_type = dtype
        self->add_input("In",debug_type)
    def override edit ( mode:EditMode ): void
        if Button("Debug")
            update_preview()
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "output({to_reg_any(src_regs[0],debug_type)},\"{name}\",\"{id}\",\"\")"
        }]

[instruction_node(name="Debug scalar",category="Scalar operations")]
class Instruction_DebugScalar : Instruction_DebugCommon
    def Instruction_DebugScalar
        Instruction_DebugCommon`Instruction_DebugCommon(self,TYPE_SCALAR)

[instruction_node(name="Debug vector2",category="Vector2 operations")]
class Instruction_DebugVector2 : Instruction_DebugCommon
    def Instruction_DebugVector2
        Instruction_DebugCommon`Instruction_DebugCommon(self,TYPE_VECTOR2)

[instruction_node(name="Debug vector3",category="Vector3 operations")]
class Instruction_DebugVector3 : Instruction_DebugCommon
    def Instruction_DebugVector3
        Instruction_DebugCommon`Instruction_DebugCommon(self,TYPE_VECTOR3)

[instruction_node(name="Debug vector4",category="Vector4 operations")]
class Instruction_DebugVector4 : Instruction_DebugCommon
    def Instruction_DebugVector4
        Instruction_DebugCommon`Instruction_DebugCommon(self,TYPE_VECTOR4)

class Instruction_OpCommon : Instruction
    op : string
    op_type : string
    def Instruction_OpCommon(Op:string;OpType:string)
        op = Op
        op_type = OpType
        self->add_input("In",op_type)
        self->add_output("Out",op_type)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_any(pins.outputs[0].reg,op_type)} = {op} {to_reg_any(src_regs[0],op_type)}"
        }]

class Instruction_FunCommon : Instruction_OpCommon
    def Instruction_FunCommon(Op:string;OpType:string)
        Instruction_OpCommon`Instruction_OpCommon(self,Op,OpType)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_any(pins.outputs[0].reg,op_type)} = {op}({to_reg_any(src_regs[0],op_type)})"
        }]

class Instruction_Op2Common : Instruction
    op : string
    op_type : string
    def Instruction_Op2Common(Op2:string;OpType:string)
        op = Op2
        op_type = OpType
        self->add_input("In-1",op_type)
        self->add_input("In-2",op_type)
        self->add_output("Out",op_type)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_any(pins.outputs[0].reg,op_type)} = {to_reg_any(src_regs[0],op_type)} {op} {to_reg_any(src_regs[1],op_type)}"
        }]

[instruction_node(name="Scalar constant",category="Scalar operations")]
class Instruction_Scalar : Instruction
    override editing = true
    [[serialize]] value : float = 1.
    def Instruction_Scalar
        self->add_output("Out",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"value",value)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(pins.outputs[0].reg)} = {to_produce(value)}"
        }]

[instruction_node(name="Vector2 constant",category="Vector2 operations")]
class Instruction_Vector2 : Instruction
    override editing = true
    [[serialize]] x : float = 1.
    [[serialize]] y : float = 1.
    def Instruction_Vector2
        self->add_output("Out",TYPE_VECTOR2)
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"x",x)
        NodeDragFloat(mode,id,"y",y)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(pins.outputs[0].reg)} = float2({to_produce(x)},{to_produce(y)})"
        }]

[instruction_node(name="Vector2 combine",category="Vector2 operations")]
class Instruction_Vector2Combine : Instruction
    def Instruction_Vector2Combine()
        self->add_input("In-1",TYPE_SCALAR)
        self->add_input("In-2",TYPE_SCALAR)
        self->add_output("Out",TYPE_VECTOR2)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_vector2(pins.outputs[0].reg)} = float2({to_reg_scalar(src_regs[0])},{to_reg_scalar(src_regs[1])})"
        }]

[instruction_node(name="Vector2 split",category="Vector2 operations")]
class Instruction_Vector2Split : Instruction
    def Instruction_Vector2Split()
        self->add_input("In",TYPE_VECTOR2)
        self->add_output("Out-1",TYPE_SCALAR)
        self->add_output("Out-2",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        var res : array<string>
        if pins.outputs[0].reg!=-1
            res |> push("{to_reg(pins.outputs[0].reg)} = {to_reg_vector2(src_regs[0])}.x")
        if pins.outputs[1].reg!=-1
            res |> push("{to_reg(pins.outputs[1].reg)} = {to_reg_vector2(src_regs[0])}.y")
        return <- res

[instruction_node(name="Vector3 constant",category="Vector3 operations")]
class Instruction_Vector3 : Instruction
    override editing = true
    [[serialize]] x : float = 1.
    [[serialize]] y : float = 1.
    [[serialize]] z : float = 1.
    def Instruction_Vector3
        self->add_output("Out",TYPE_VECTOR3)
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"x",x)
        NodeDragFloat(mode,id,"y",y)
        NodeDragFloat(mode,id,"z",z)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(pins.outputs[0].reg)} = float3({to_produce(x)},{to_produce(y)},{to_produce(z)})"
        }]

[instruction_node(name="Vector3 combine",category="Vector3 operations")]
class Instruction_Vector3Combine : Instruction
    def Instruction_Vector3Combine()
        self->add_input("In-1",TYPE_SCALAR)
        self->add_input("In-2",TYPE_SCALAR)
        self->add_input("In-3",TYPE_SCALAR)
        self->add_output("Out",TYPE_VECTOR3)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_vector3(pins.outputs[0].reg)} = float3({to_reg_scalar(src_regs[0])},{to_reg_scalar(src_regs[1])},{to_reg_scalar(src_regs[2])})"
        }]

[instruction_node(name="Vector3 split",category="Vector3 operations")]
class Instruction_Vector3Split : Instruction
    def Instruction_Vector3Split()
        self->add_input("In",TYPE_VECTOR3)
        self->add_output("Out-1",TYPE_SCALAR)
        self->add_output("Out-2",TYPE_SCALAR)
        self->add_output("Out-3",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        var res : array<string>
        if pins.outputs[0].reg!=-1
            res |> push("{to_reg(pins.outputs[0].reg)} = {to_reg_vector3(src_regs[0])}.x")
        if pins.outputs[1].reg!=-1
            res |> push("{to_reg(pins.outputs[1].reg)} = {to_reg_vector3(src_regs[0])}.y")
        if pins.outputs[2].reg!=-1
            res |> push("{to_reg(pins.outputs[2].reg)} = {to_reg_vector3(src_regs[0])}.z")
        return <- res

[instruction_node(name="Vector4 constant",category="Vector4 operations")]
class Instruction_Vector4 : Instruction
    override editing = true
    [[serialize]] x : float = 1.
    [[serialize]] y : float = 1.
    [[serialize]] z : float = 1.
    [[serialize]] w : float = 1.
    def Instruction_Vector4
        self->add_output("Out",TYPE_VECTOR4)
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"x",x)
        NodeDragFloat(mode,id,"y",y)
        NodeDragFloat(mode,id,"z",z)
        NodeDragFloat(mode,id,"w",w)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(pins.outputs[0].reg)} = float4({to_produce(x)},{to_produce(y)},{to_produce(z)},{to_produce(w)})"
        }]

[instruction_node(name="Vector4 combine",category="Vector4 operations")]
class Instruction_Vector4Combine : Instruction
    def Instruction_Vector4Combine()
        self->add_input("In-1",TYPE_SCALAR)
        self->add_input("In-2",TYPE_SCALAR)
        self->add_input("In-3",TYPE_SCALAR)
        self->add_input("In-4",TYPE_SCALAR)
        self->add_output("Out",TYPE_VECTOR4)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_vector4(pins.outputs[0].reg)} = float4({to_reg_scalar(src_regs[0])},{to_reg_scalar(src_regs[1])},{to_reg_scalar(src_regs[2])},{to_reg_scalar(src_regs[3])})"
        }]

[instruction_node(name="Vector4 split",category="Vector4 operations")]
class Instruction_Vector4Split : Instruction
    def Instruction_Vector4Split()
        self->add_input("In",TYPE_VECTOR4)
        self->add_output("Out-1",TYPE_SCALAR)
        self->add_output("Out-2",TYPE_SCALAR)
        self->add_output("Out-3",TYPE_SCALAR)
        self->add_output("Out-4",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        var res : array<string>
        if pins.outputs[0].reg!=-1
            res |> push("{to_reg(pins.outputs[0].reg)} = {to_reg_vector4(src_regs[0])}.x")
        if pins.outputs[1].reg!=-1
            res |> push("{to_reg(pins.outputs[1].reg)} = {to_reg_vector4(src_regs[0])}.y")
        if pins.outputs[2].reg!=-1
            res |> push("{to_reg(pins.outputs[2].reg)} = {to_reg_vector4(src_regs[0])}.z")
        if pins.outputs[3].reg!=-1
            res |> push("{to_reg(pins.outputs[3].reg)} = {to_reg_vector4(src_regs[0])}.z")
        return <- res

// fun1

[instruction_node(name="Sin scalar",category="Scalar operations")]
class Instruction_SinScalar : Instruction_FunCommon
    def Instruction_SinScalar
        Instruction_FunCommon`Instruction_FunCommon(self,"sin",TYPE_SCALAR)

[instruction_node(name="Cos scalar",category="Scalar operations")]
class Instruction_CosScalar : Instruction_FunCommon
    def Instruction_CosScalar
        Instruction_FunCommon`Instruction_FunCommon(self,"cos",TYPE_SCALAR)

// op1

[instruction_node(name="Route scalar",category="Scalar operations")]
class Instruction_RouteScalar : Instruction_OpCommon
    def Instruction_RouteScalar
        Instruction_OpCommon`Instruction_OpCommon(self," ",TYPE_SCALAR)

[instruction_node(name="Negate scalar",category="Scalar operations")]
class Instruction_Negate : Instruction_OpCommon
    def Instruction_Negate
        Instruction_OpCommon`Instruction_OpCommon(self,"-",TYPE_SCALAR)

// op2

[instruction_node(name="Add scalar",category="Scalar operations")]
class Instruction_AddScalar : Instruction_Op2Common
    def Instruction_AddScalar
        Instruction_Op2Common`Instruction_Op2Common(self,"+",TYPE_SCALAR)

[instruction_node(name="Sub scalar",category="Scalar operations")]
class Instruction_SubScalar : Instruction_Op2Common
    def Instruction_SubScalar
        Instruction_Op2Common`Instruction_Op2Common(self,"-",TYPE_SCALAR)

[instruction_node(name="Mul scalar",category="Scalar operations")]
class Instruction_MulScalar : Instruction_Op2Common
    def Instruction_MulScalar
        Instruction_Op2Common`Instruction_Op2Common(self,"*",TYPE_SCALAR)

[instruction_node(name="Div scalar",category="Scalar operations")]
class Instruction_DivScalar : Instruction_Op2Common
    def Instruction_DivScalar
        Instruction_Op2Common`Instruction_Op2Common(self,"/",TYPE_SCALAR)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(pins.outputs[0].reg)} = ({to_reg_scalar(src_regs[1])}!=0.) ? {to_reg_scalar(src_regs[0])} / {to_reg_scalar(src_regs[1])} : 0."
        }]
