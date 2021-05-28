options indenting = 4
options remove_unused_symbols = false

module model shared

require instructions public
require math


/*
// bin_op_arg1
// bin_op_arg2
// ...

def bin_op ( var a,b:Value; var res:Value; name:string )
    if name=="add"
        pass
    elif name=="sub"
        pass
*/

def create_surface ( var reg:Surface; sz:int2 )
    reg <- Surface(sz.x,sz.y)

def delete_surface ( var reg:Surface )
    delete reg

def surface_gen_solid_color ( var reg:Surface; color:float4 )
    for c in reg.data
        c = color

def surface_gen_gradient ( var surf:Surface; top_left,top_right,bottom_left,bottom_right:float4 )
    var index = 0
    let iS = float2(1) / ( float2(surf.size) - float2(1) )
    for y in range(0,surf.size.y)
        let ky = float(y)*iS.y
        let left = lerp(top_left,bottom_left,float4(ky))
        let right = lerp(top_right,bottom_right,float4(ky))
        for x in range(0,surf.size.x)
            let kx = float(x)*iS.x
            surf.data[index++] = lerp(left,right,float4(kx))

[unused_argument(factor)]
def surface_blend_Add ( var reg:Surface; src,dst:Surface; factor:float )
    for c,sC,dC in reg.data,src.data,dst.data
        c = sC + dC

[unused_argument(factor)]
def surface_blend_Multiply ( var reg:Surface; src,dst:Surface; factor:float )
    for c,sC,dC in reg.data,src.data,dst.data
        c = sC * dC

def surface_blend_Crossfade  ( var reg:Surface; src,dst:Surface; var factor:float )
    factor = clamp(factor,0.,1.)
    let ifactor = 1. - factor
    for c,sC,dC in reg.data,src.data,dst.data
        c = sC*ifactor + dC*factor

var G_OUTPUT : array<tuple<Surface;string;string;string>>

def preview ( var reg:Surface; name,id,outp:string )
    var creg := reg
    G_OUTPUT |> push_clone([[auto creg,name,id,outp]])

def output ( var reg:Surface; name,id,outp:string )
    var creg := reg
    G_OUTPUT |> push_clone([[auto creg,name,id,outp]])

def output ( var reg:float; name,id,outp:string )
    print(" {name}:{outp} = {reg} // {id}\n")
