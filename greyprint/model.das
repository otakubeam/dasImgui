options indenting = 4
options remove_unused_symbols = false

module model

require instructions public
require math

def create_surface ( var reg:Value; w,h:int )
    reg <- [[ Value surface<-Surface(w,h) ]]

def scalar_scalar ( var reg:Value; value:float )
    reg <- [[Value scalar=value]]

def scalar_add ( var reg:Value; a,b:float )
    reg <- [[Value scalar=a + b]]

def surface_solid_color ( var reg:Value; color:float4 )
    for c in (reg as surface).data
        c = color

def surface_gradient ( var reg:Value; top_left,top_right,bottom_left,bottom_right:float4 )
    var surf & = reg as surface
    var index = 0
    let iS = float2(1) / ( float2(surf.size) - float2(1) )
    for y in range(0,surf.size.y)
        let ky = float(y)*iS.y
        let left = lerp(top_left,bottom_left,float4(ky))
        let right = lerp(top_right,bottom_right,float4(ky))
        for x in range(0,surf.size.x)
            let kx = float(x)*iS.x
            surf.data[index++] = lerp(left,right,float4(kx))

def surface_blend_add ( var reg:Value; src,dst:Value )
    for c,sC,dC in (reg as surface).data,(src as surface).data,(dst as surface).data
        c = sC + dC

def surface_blend_mul ( var reg:Value; src,dst:Value )
    for c,sC,dC in (reg as surface).data,(src as surface).data,(dst as surface).data
        c = sC * dC

def surface_blend_crossfade ( var reg:Value; src,dst:Value; var factor:Value )
    surface_blend_crossfade(reg, src, dst, factor as scalar)

def surface_blend_crossfade ( var reg:Value; src,dst:Value; var factor:float )
    factor = clamp(factor,0.,1.)
    let ifactor = 1. - factor
    for c,sC,dC in (reg as surface).data,(src as surface).data,(dst as surface).data
        c = sC*ifactor + dC*factor
