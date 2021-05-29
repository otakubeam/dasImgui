options indenting = 4
options remove_unused_symbols = false

module instructions_scalar

require instructions public
require model
require preview
require instructions_ui
require produce

[instruction_node(name="Debug scalar",category="Scalar operations")]
class Instruction_DebugScalar : Instruction
    override editing = true
    override flags = InstructionFlags Output | InstructionFlags HasEdit
    def Instruction_DebugScalar
        name = "Debug scalar"
        self->add_input("In",TYPE_SCALAR)
    def override edit ( mode:EditMode ): void
        if Button("Debug")
            update_preview()
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "output({to_reg_scalar(src_regs[0])},\"{name}\",\"{id}\",\"\")"
        }]

class Instruction_OpScalar : Instruction
    op : string
    def Instruction_OpScalar(Op:string)
        name = "{Op} scalar"
        op = Op
        self->add_input("In",TYPE_SCALAR)
        self->add_output("Out",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(outputs[0].reg)} = {op} {to_reg_scalar(src_regs[0])}"
        }]

class Instruction_FunScalar : Instruction_OpScalar
    def Instruction_FunScalar(Op:string)
        Instruction_OpScalar`Instruction_OpScalar(self,Op)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(outputs[0].reg)} = {op}({to_reg_scalar(src_regs[0])})"
        }]

class Instruction_Op2Scalar : Instruction
    op : string
    def Instruction_Op2Scalar(Op2:string)
        name = "{Op2} scalar"
        op = Op2
        self->add_input("In-1",TYPE_SCALAR)
        self->add_input("In-2",TYPE_SCALAR)
        self->add_output("Out",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        pass
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(outputs[0].reg)} = {to_reg_scalar(src_regs[0])} {op} {to_reg_scalar(src_regs[1])}"
        }]

[instruction_node(name="Scalar constant",category="Scalar operations")]
class Instruction_Scalar : Instruction
    override editing = true
    [[serialize]] value : float = 1.
    def Instruction_Scalar
        name = "Scalar constant"
        self->add_output("Out",TYPE_SCALAR)
    def override edit ( mode:EditMode ) : void
        NodeDragFloat(mode,id,"value",value)
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(outputs[0].reg)} = {to_produce(value)}"
        }]

// fun1

[instruction_node(name="Sin scalar",category="Scalar operations")]
class Instruction_SinScalar : Instruction_FunScalar
    def Instruction_SinScalar
        Instruction_FunScalar`Instruction_FunScalar(self,"sin")

[instruction_node(name="Cos scalar",category="Scalar operations")]
class Instruction_CosScalar : Instruction_FunScalar
    def Instruction_CosScalar
        Instruction_FunScalar`Instruction_FunScalar(self,"cos")

// op1

[instruction_node(name="Route scalar",category="Scalar operations")]
class Instruction_RouteScalar : Instruction_OpScalar
    def Instruction_RouteScalar
        Instruction_OpScalar`Instruction_OpScalar(self," ")

[instruction_node(name="Negate scalar",category="Scalar operations")]
class Instruction_Negate : Instruction_OpScalar
    def Instruction_Negate
        Instruction_OpScalar`Instruction_OpScalar(self,"-")

// op2

[instruction_node(name="Add scalar",category="Scalar operations")]
class Instruction_AddScalar : Instruction_Op2Scalar
    def Instruction_AddScalar
        Instruction_Op2Scalar`Instruction_Op2Scalar(self,"+")

[instruction_node(name="Sub scalar",category="Scalar operations")]
class Instruction_SubScalar : Instruction_Op2Scalar
    def Instruction_SubScalar
        Instruction_Op2Scalar`Instruction_Op2Scalar(self,"-")

[instruction_node(name="Mul scalar",category="Scalar operations")]
class Instruction_MulScalar : Instruction_Op2Scalar
    def Instruction_MulScalar
        Instruction_Op2Scalar`Instruction_Op2Scalar(self,"*")

[instruction_node(name="Div scalar",category="Scalar operations")]
class Instruction_DivScalar : Instruction_Op2Scalar
    def Instruction_DivScalar
        Instruction_Op2Scalar`Instruction_Op2Scalar(self,"/")
    def override produce ( var src_regs : array<int> ): array<string>
        return <- [{string
            "{to_reg_scalar(outputs[0].reg)} = ({to_reg_scalar(src_regs[1])}!=0.) ? {to_reg_scalar(src_regs[0])} / {to_reg_scalar(src_regs[1])} : 0."
        }]
