options indenting = 4
options remove_unused_symbols = false

module model_eval

require instructions public

require produce

require daslib/strings_boost
require daslib/static_let
require daslib/algorithm

def collect_instruction ( inst:Instruction?; var used:table<Instruction?;bool>; var reval:array<Instruction?> )
    if used |> key_exists(inst)
        return
    used[inst] = true
    reval |> push(inst)
    for inp in inst.pins.inputs
        if inp.src!=null
            collect_instruction(inp.src, used, reval)

def collect_instructions
    var reval : array<Instruction?>
    var used : table<Instruction?;bool>
    for inst in g_CurrentProject.instructions
        if inst.flags.Output
            var ireval : array<Instruction?>
            collect_instruction(inst, used, ireval)
            var neval <- combine(ireval, reval)
            swap(reval, neval)
    return <- reval

def assign_registers ( var reval:array<Instruction?> ) : int
    var reg_total = 0
    for inst in reval
        for outp in inst.pins.outputs
            outp.reg = reg_total ++
    return reg_total ++

def need_to_produce_delete(outptype:string)
    return outptype=="surface"

def reg_type ( outptype:string )
    static_let <|
        let reg_type <- {{
            "scalar" => "float";
            "surface" => "Surface"
        }}
    return reg_type?[outptype] ?? "unknown"

def produce_eval ( var reval:array<Instruction?>; reg_total:int )
    // note: we are generating everything in reverse order
    // that very its very obvious when to 'delete'
    var reg_used : array<bool>
    reg_used |> resize(reg_total)
    var eval:array<string>
    for inst in reval
        // first time seeing means last its used, and needs to be deleted
        var inp_regs : array<int>
        for inp in inst.pins.inputs
            if inp.src != null
                let oidx = inp.src->output_index(inp.output)
                assert(oidx!=-1)
                var outp & = inp.src.pins.outputs[oidx]
                let reg = outp.reg
                inp_regs |> push(reg)
                if !reg_used[reg]
                    reg_used[reg] = true
                    if need_to_produce_delete(outp._type)
                        eval |> push("    delete_{outp._type}({to_reg(reg)})")
            else
                inp_regs |> push(-1)
        // preview
        for outp in inst.pins.outputs
            if outp.preview
                eval |> push("    preview({to_reg(outp.reg)},\"{inst.name}\",\"{inst.id}\",\"{outp.name}\")")
        // instruction produces generation, we invert again
        var ipod <- inst->produce(inp_regs)
        reverse(ipod)
        for ib in ipod
            eval |> push("    {ib}")
        delete ipod
        // register declaration
        for outp in inst.pins.outputs
            eval |> push("    var {to_reg(outp.reg)} : {reg_type(outp._type)}")
        // comment
        let irt = join([{for r in inp_regs; "{to_reg(r)}"}],",")
        let ort = join([{for r in inst.pins.outputs; "{to_reg(r.reg)}"}],",")
        // eval |> push("    // eval {inst.__rtti} -> {inst.name}:{inst.id} [[pins.inputs {irt}]] [[pins.outputs {ort}]]")
    if length(reval)==0
        eval |> push("    pass")
    // now back to normal order
    reverse(eval)
    return <- eval

def produce_eval
    for inst in g_CurrentProject.instructions
        for outp in inst.pins.outputs
            outp.reg = -1
    var reval <- collect_instructions()
    let nreg = assign_registers(reval)
    return <- produce_eval(reval, nreg)

def produce_project_text
    var evl <- produce_eval()
    let st = build_string() <| $ (var writer)
        write(writer,"require instructions\n")
        write(writer,"require model\n")
        write(writer,"require math")
        write(writer,"\n")
        write(writer,"[export]\n")
        write(writer,"def main\n")
        for t in evl
            write(writer,"{t}\n")
        write(writer,"\n")
    delete evl
    return st



