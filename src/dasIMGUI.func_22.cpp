// this file is generated via daScript automatic C++ binder
// all user modifications will be lost after this file is re-generated

#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMGUI.h"
#include "need_dasIMGUI.h"
namespace das {
void Module_dasIMGUI::initFunctions_22() {
	using _method_59 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float),&ImDrawList::AddLine >;
	addExtern<DAS_CALL_METHOD(_method_59)>(*this,lib,"AddLine",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float) , &ImDrawList::AddLine >::invoke")
		->args({"self","p1","p2","col","thickness"})
		->arg_init(4,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_60 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags,float),&ImDrawList::AddRect >;
	addExtern<DAS_CALL_METHOD(_method_60)>(*this,lib,"AddRect",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags,float) , &ImDrawList::AddRect >::invoke")
		->args({"self","p_min","p_max","col","rounding","flags","thickness"})
		->arg_init(4,make_smart<ExprConstFloat>(0.00000000000000000))
		->arg_type(5,makeType<ImDrawFlags_>(lib))
		->arg_init(5,make_smart<ExprConstEnumeration>(0,makeType<ImDrawFlags_>(lib)))
		->arg_init(6,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_61 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags),&ImDrawList::AddRectFilled >;
	addExtern<DAS_CALL_METHOD(_method_61)>(*this,lib,"AddRectFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags) , &ImDrawList::AddRectFilled >::invoke")
		->args({"self","p_min","p_max","col","rounding","flags"})
		->arg_init(4,make_smart<ExprConstFloat>(0.00000000000000000))
		->arg_type(5,makeType<ImDrawFlags_>(lib))
		->arg_init(5,make_smart<ExprConstEnumeration>(0,makeType<ImDrawFlags_>(lib)));
	using _method_62 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,ImU32,ImU32,ImU32),&ImDrawList::AddRectFilledMultiColor >;
	addExtern<DAS_CALL_METHOD(_method_62)>(*this,lib,"AddRectFilledMultiColor",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32,ImU32,ImU32,ImU32) , &ImDrawList::AddRectFilledMultiColor >::invoke")
		->args({"self","p_min","p_max","col_upr_left","col_upr_right","col_bot_right","col_bot_left"});
	using _method_63 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float),&ImDrawList::AddQuad >;
	addExtern<DAS_CALL_METHOD(_method_63)>(*this,lib,"AddQuad",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float) , &ImDrawList::AddQuad >::invoke")
		->args({"self","p1","p2","p3","p4","col","thickness"})
		->arg_init(6,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_64 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::AddQuadFilled >;
	addExtern<DAS_CALL_METHOD(_method_64)>(*this,lib,"AddQuadFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::AddQuadFilled >::invoke")
		->args({"self","p1","p2","p3","p4","col"});
	using _method_65 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float),&ImDrawList::AddTriangle >;
	addExtern<DAS_CALL_METHOD(_method_65)>(*this,lib,"AddTriangle",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float) , &ImDrawList::AddTriangle >::invoke")
		->args({"self","p1","p2","p3","col","thickness"})
		->arg_init(5,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_66 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::AddTriangleFilled >;
	addExtern<DAS_CALL_METHOD(_method_66)>(*this,lib,"AddTriangleFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::AddTriangleFilled >::invoke")
		->args({"self","p1","p2","p3","col"});
	using _method_67 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int,float),&ImDrawList::AddCircle >;
	addExtern<DAS_CALL_METHOD(_method_67)>(*this,lib,"AddCircle",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int,float) , &ImDrawList::AddCircle >::invoke")
		->args({"self","center","radius","col","num_segments","thickness"})
		->arg_init(4,make_smart<ExprConstInt>(0))
		->arg_init(5,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_68 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int),&ImDrawList::AddCircleFilled >;
	addExtern<DAS_CALL_METHOD(_method_68)>(*this,lib,"AddCircleFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int) , &ImDrawList::AddCircleFilled >::invoke")
		->args({"self","center","radius","col","num_segments"})
		->arg_init(4,make_smart<ExprConstInt>(0));
	using _method_69 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int,float),&ImDrawList::AddNgon >;
	addExtern<DAS_CALL_METHOD(_method_69)>(*this,lib,"AddNgon",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int,float) , &ImDrawList::AddNgon >::invoke")
		->args({"self","center","radius","col","num_segments","thickness"})
		->arg_init(5,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_70 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int),&ImDrawList::AddNgonFilled >;
	addExtern<DAS_CALL_METHOD(_method_70)>(*this,lib,"AddNgonFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,ImU32,int) , &ImDrawList::AddNgonFilled >::invoke")
		->args({"self","center","radius","col","num_segments"});
	using _method_71 = das::das_call_member< void (ImDrawList::*)(const ImVec2 *,int,ImU32,ImDrawFlags,float),&ImDrawList::AddPolyline >;
	addExtern<DAS_CALL_METHOD(_method_71)>(*this,lib,"AddPolyline",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 *,int,ImU32,ImDrawFlags,float) , &ImDrawList::AddPolyline >::invoke")
		->args({"self","points","num_points","col","flags","thickness"})
		->arg_type(4,makeType<ImDrawFlags_>(lib));
	using _method_72 = das::das_call_member< void (ImDrawList::*)(const ImVec2 *,int,ImU32),&ImDrawList::AddConvexPolyFilled >;
	addExtern<DAS_CALL_METHOD(_method_72)>(*this,lib,"AddConvexPolyFilled",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 *,int,ImU32) , &ImDrawList::AddConvexPolyFilled >::invoke")
		->args({"self","points","num_points","col"});
	using _method_73 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,int),&ImDrawList::AddBezierCubic >;
	addExtern<DAS_CALL_METHOD(_method_73)>(*this,lib,"AddBezierCubic",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,int) , &ImDrawList::AddBezierCubic >::invoke")
		->args({"self","p1","p2","p3","p4","col","thickness","num_segments"})
		->arg_init(7,make_smart<ExprConstInt>(0));
	using _method_74 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,int),&ImDrawList::AddBezierQuadratic >;
	addExtern<DAS_CALL_METHOD(_method_74)>(*this,lib,"AddBezierQuadratic",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,int) , &ImDrawList::AddBezierQuadratic >::invoke")
		->args({"self","p1","p2","p3","col","thickness","num_segments"})
		->arg_init(6,make_smart<ExprConstInt>(0));
	using _method_75 = das::das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::AddImage >;
	addExtern<DAS_CALL_METHOD(_method_75)>(*this,lib,"AddImage",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::AddImage >::invoke")
		->args({"self","user_texture_id","p_min","p_max","uv_min","uv_max","col"})
		->arg_init(6,make_smart<ExprConstUInt>(0xffffffff));
	using _method_76 = das::das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::AddImageQuad >;
	addExtern<DAS_CALL_METHOD(_method_76)>(*this,lib,"AddImageQuad",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::AddImageQuad >::invoke")
		->args({"self","user_texture_id","p1","p2","p3","p4","uv1","uv2","uv3","uv4","col"})
		->arg_init(10,make_smart<ExprConstUInt>(0xffffffff));
	using _method_77 = das::das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags),&ImDrawList::AddImageRounded >;
	addExtern<DAS_CALL_METHOD(_method_77)>(*this,lib,"AddImageRounded",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32,float,ImDrawFlags) , &ImDrawList::AddImageRounded >::invoke")
		->args({"self","user_texture_id","p_min","p_max","uv_min","uv_max","col","rounding","flags"})
		->arg_type(8,makeType<ImDrawFlags_>(lib))
		->arg_init(8,make_smart<ExprConstEnumeration>(0,makeType<ImDrawFlags_>(lib)));
	using _method_78 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::PathClear >;
	addExtern<DAS_CALL_METHOD(_method_78)>(*this,lib,"PathClear",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::PathClear >::invoke")
		->args({"self"});
}
}

