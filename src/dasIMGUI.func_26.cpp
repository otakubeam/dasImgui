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
void Module_dasIMGUI::initFunctions_26() {
	using _method_155 = das::das_call_member< const char * (ImFont::*)(float,const char *,const char *,float) const,&ImFont::CalcWordWrapPositionA >;
	addExtern<DAS_CALL_METHOD(_method_155)>(*this,lib,"CalcWordWrapPositionA",SideEffects::worstDefault,"das_call_member< const char * (ImFont::*)(float,const char *,const char *,float) const,&ImFont::CalcWordWrapPositionA >::invoke")
		->args({"self","scale","text","text_end","wrap_width"});
	using _method_156 = das::das_call_member< void (ImFont::*)(ImDrawList *,float,ImVec2,unsigned int,unsigned short) const,&ImFont::RenderChar >;
	addExtern<DAS_CALL_METHOD(_method_156)>(*this,lib,"RenderChar",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(ImDrawList *,float,ImVec2,unsigned int,unsigned short) const,&ImFont::RenderChar >::invoke")
		->args({"self","draw_list","size","pos","col","c"});
	using _method_157 = das::das_call_member< void (ImFont::*)(ImDrawList *,float,ImVec2,unsigned int,const ImVec4 &,const char *,const char *,float,bool) const,&ImFont::RenderText >;
	addExtern<DAS_CALL_METHOD(_method_157)>(*this,lib,"RenderText",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(ImDrawList *,float,ImVec2,unsigned int,const ImVec4 &,const char *,const char *,float,bool) const,&ImFont::RenderText >::invoke")
		->args({"self","draw_list","size","pos","col","clip_rect","text_begin","text_end","wrap_width","cpu_fine_clip"})
		->arg_init(8,make_smart<ExprConstFloat>(0))
		->arg_init(9,make_smart<ExprConstBool>(false));
	using _method_158 = das::das_call_member< void (ImFont::*)(),&ImFont::BuildLookupTable >;
	addExtern<DAS_CALL_METHOD(_method_158)>(*this,lib,"BuildLookupTable",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(),&ImFont::BuildLookupTable >::invoke")
		->args({"self"});
	using _method_159 = das::das_call_member< void (ImFont::*)(),&ImFont::ClearOutputData >;
	addExtern<DAS_CALL_METHOD(_method_159)>(*this,lib,"ClearOutputData",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(),&ImFont::ClearOutputData >::invoke")
		->args({"self"});
	using _method_160 = das::das_call_member< void (ImFont::*)(int),&ImFont::GrowIndex >;
	addExtern<DAS_CALL_METHOD(_method_160)>(*this,lib,"GrowIndex",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(int),&ImFont::GrowIndex >::invoke")
		->args({"self","new_size"});
	using _method_161 = das::das_call_member< void (ImFont::*)(const ImFontConfig *,unsigned short,float,float,float,float,float,float,float,float,float),&ImFont::AddGlyph >;
	addExtern<DAS_CALL_METHOD(_method_161)>(*this,lib,"AddGlyph",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(const ImFontConfig *,unsigned short,float,float,float,float,float,float,float,float,float),&ImFont::AddGlyph >::invoke")
		->args({"self","src_cfg","c","x0","y0","x1","y1","u0","v0","u1","v1","advance_x"});
	using _method_162 = das::das_call_member< void (ImFont::*)(unsigned short,unsigned short,bool),&ImFont::AddRemapChar >;
	addExtern<DAS_CALL_METHOD(_method_162)>(*this,lib,"AddRemapChar",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(unsigned short,unsigned short,bool),&ImFont::AddRemapChar >::invoke")
		->args({"self","dst","src","overwrite_dst"})
		->arg_init(3,make_smart<ExprConstBool>(true));
	using _method_163 = das::das_call_member< void (ImFont::*)(unsigned short,bool),&ImFont::SetGlyphVisible >;
	addExtern<DAS_CALL_METHOD(_method_163)>(*this,lib,"SetGlyphVisible",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(unsigned short,bool),&ImFont::SetGlyphVisible >::invoke")
		->args({"self","c","visible"});
	using _method_164 = das::das_call_member< void (ImFont::*)(unsigned short),&ImFont::SetFallbackChar >;
	addExtern<DAS_CALL_METHOD(_method_164)>(*this,lib,"SetFallbackChar",SideEffects::worstDefault,"das_call_member< void (ImFont::*)(unsigned short),&ImFont::SetFallbackChar >::invoke")
		->args({"self","c"});
	using _method_165 = das::das_call_member< bool (ImFont::*)(unsigned int,unsigned int),&ImFont::IsGlyphRangeUnused >;
	addExtern<DAS_CALL_METHOD(_method_165)>(*this,lib,"IsGlyphRangeUnused",SideEffects::worstDefault,"das_call_member< bool (ImFont::*)(unsigned int,unsigned int),&ImFont::IsGlyphRangeUnused >::invoke")
		->args({"self","c_begin","c_last"});
	using _method_166 = das::das_call_member< ImVec2 (ImGuiViewport::*)() const,&ImGuiViewport::GetCenter >;
	addExtern<DAS_CALL_METHOD(_method_166)>(*this,lib,"GetCenter",SideEffects::worstDefault,"das_call_member< ImVec2 (ImGuiViewport::*)() const,&ImGuiViewport::GetCenter >::invoke")
		->args({"self"});
	using _method_167 = das::das_call_member< ImVec2 (ImGuiViewport::*)() const,&ImGuiViewport::GetWorkCenter >;
	addExtern<DAS_CALL_METHOD(_method_167)>(*this,lib,"GetWorkCenter",SideEffects::worstDefault,"das_call_member< ImVec2 (ImGuiViewport::*)() const,&ImGuiViewport::GetWorkCenter >::invoke")
		->args({"self"});
}
}

