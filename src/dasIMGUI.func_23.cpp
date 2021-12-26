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
void Module_dasIMGUI::initFunctions_23() {
	using _method_79 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &),&ImDrawList::PathLineTo >;
	addExtern<DAS_CALL_METHOD(_method_79)>(*this,lib,"PathLineTo",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &) , &ImDrawList::PathLineTo >::invoke")
		->args({"self","pos"});
	using _method_80 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &),&ImDrawList::PathLineToMergeDuplicate >;
	addExtern<DAS_CALL_METHOD(_method_80)>(*this,lib,"PathLineToMergeDuplicate",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &) , &ImDrawList::PathLineToMergeDuplicate >::invoke")
		->args({"self","pos"});
	using _method_81 = das::das_call_member< void (ImDrawList::*)(ImU32),&ImDrawList::PathFillConvex >;
	addExtern<DAS_CALL_METHOD(_method_81)>(*this,lib,"PathFillConvex",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImU32) , &ImDrawList::PathFillConvex >::invoke")
		->args({"self","col"});
	using _method_82 = das::das_call_member< void (ImDrawList::*)(ImU32,ImDrawFlags,float),&ImDrawList::PathStroke >;
	addExtern<DAS_CALL_METHOD(_method_82)>(*this,lib,"PathStroke",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImU32,ImDrawFlags,float) , &ImDrawList::PathStroke >::invoke")
		->args({"self","col","flags","thickness"})
		->arg_type(2,makeType<ImDrawFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImDrawFlags_>(lib)))
		->arg_init(3,make_smart<ExprConstFloat>(1.00000000000000000));
	using _method_83 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,float,float,int),&ImDrawList::PathArcTo >;
	addExtern<DAS_CALL_METHOD(_method_83)>(*this,lib,"PathArcTo",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,float,float,int) , &ImDrawList::PathArcTo >::invoke")
		->args({"self","center","radius","a_min","a_max","num_segments"})
		->arg_init(5,make_smart<ExprConstInt>(0));
	using _method_84 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,float,int,int),&ImDrawList::PathArcToFast >;
	addExtern<DAS_CALL_METHOD(_method_84)>(*this,lib,"PathArcToFast",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,float,int,int) , &ImDrawList::PathArcToFast >::invoke")
		->args({"self","center","radius","a_min_of_12","a_max_of_12"});
	using _method_85 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,int),&ImDrawList::PathBezierCubicCurveTo >;
	addExtern<DAS_CALL_METHOD(_method_85)>(*this,lib,"PathBezierCubicCurveTo",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,int) , &ImDrawList::PathBezierCubicCurveTo >::invoke")
		->args({"self","p2","p3","p4","num_segments"})
		->arg_init(4,make_smart<ExprConstInt>(0));
	using _method_86 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,int),&ImDrawList::PathBezierQuadraticCurveTo >;
	addExtern<DAS_CALL_METHOD(_method_86)>(*this,lib,"PathBezierQuadraticCurveTo",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,int) , &ImDrawList::PathBezierQuadraticCurveTo >::invoke")
		->args({"self","p2","p3","num_segments"})
		->arg_init(3,make_smart<ExprConstInt>(0));
	using _method_87 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,float,ImDrawFlags),&ImDrawList::PathRect >;
	addExtern<DAS_CALL_METHOD(_method_87)>(*this,lib,"PathRect",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,float,ImDrawFlags) , &ImDrawList::PathRect >::invoke")
		->args({"self","rect_min","rect_max","rounding","flags"})
		->arg_init(3,make_smart<ExprConstFloat>(0.00000000000000000))
		->arg_type(4,makeType<ImDrawFlags_>(lib))
		->arg_init(4,make_smart<ExprConstEnumeration>(0,makeType<ImDrawFlags_>(lib)));
	using _method_88 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::AddDrawCmd >;
	addExtern<DAS_CALL_METHOD(_method_88)>(*this,lib,"AddDrawCmd",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::AddDrawCmd >::invoke")
		->args({"self"});
	using _method_89 = das::das_call_member< ImDrawList * (ImDrawList::*)() const,&ImDrawList::CloneOutput >;
	addExtern<DAS_CALL_METHOD(_method_89)>(*this,lib,"CloneOutput",SideEffects::worstDefault,"das_call_member< ImDrawList * (ImDrawList::*)() const , &ImDrawList::CloneOutput >::invoke")
		->args({"self"});
	using _method_90 = das::das_call_member< void (ImDrawList::*)(int),&ImDrawList::ChannelsSplit >;
	addExtern<DAS_CALL_METHOD(_method_90)>(*this,lib,"ChannelsSplit",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(int) , &ImDrawList::ChannelsSplit >::invoke")
		->args({"self","count"});
	using _method_91 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::ChannelsMerge >;
	addExtern<DAS_CALL_METHOD(_method_91)>(*this,lib,"ChannelsMerge",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::ChannelsMerge >::invoke")
		->args({"self"});
	using _method_92 = das::das_call_member< void (ImDrawList::*)(int),&ImDrawList::ChannelsSetCurrent >;
	addExtern<DAS_CALL_METHOD(_method_92)>(*this,lib,"ChannelsSetCurrent",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(int) , &ImDrawList::ChannelsSetCurrent >::invoke")
		->args({"self","n"});
	using _method_93 = das::das_call_member< void (ImDrawList::*)(int,int),&ImDrawList::PrimReserve >;
	addExtern<DAS_CALL_METHOD(_method_93)>(*this,lib,"PrimReserve",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(int,int) , &ImDrawList::PrimReserve >::invoke")
		->args({"self","idx_count","vtx_count"});
	using _method_94 = das::das_call_member< void (ImDrawList::*)(int,int),&ImDrawList::PrimUnreserve >;
	addExtern<DAS_CALL_METHOD(_method_94)>(*this,lib,"PrimUnreserve",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(int,int) , &ImDrawList::PrimUnreserve >::invoke")
		->args({"self","idx_count","vtx_count"});
	using _method_95 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::PrimRect >;
	addExtern<DAS_CALL_METHOD(_method_95)>(*this,lib,"PrimRect",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::PrimRect >::invoke")
		->args({"self","a","b","col"});
	using _method_96 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::PrimRectUV >;
	addExtern<DAS_CALL_METHOD(_method_96)>(*this,lib,"PrimRectUV",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::PrimRectUV >::invoke")
		->args({"self","a","b","uv_a","uv_b","col"});
	using _method_97 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::PrimQuadUV >;
	addExtern<DAS_CALL_METHOD(_method_97)>(*this,lib,"PrimQuadUV",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::PrimQuadUV >::invoke")
		->args({"self","a","b","c","d","uv_a","uv_b","uv_c","uv_d","col"});
	using _method_98 = das::das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32),&ImDrawList::PrimWriteVtx >;
	addExtern<DAS_CALL_METHOD(_method_98)>(*this,lib,"PrimWriteVtx",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(const ImVec2 &,const ImVec2 &,ImU32) , &ImDrawList::PrimWriteVtx >::invoke")
		->args({"self","pos","uv","col"});
}
}

