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
	using _method_134 = das::das_call_member< bool (ImFontAtlas::*)() const,&ImFontAtlas::IsBuilt >;
	addExtern<DAS_CALL_METHOD(_method_134)>(*this,lib,"IsBuilt",SideEffects::worstDefault,"das_call_member< bool (ImFontAtlas::*)() const , &ImFontAtlas::IsBuilt >::invoke")
		->args({"self"});
	using _method_135 = das::das_call_member< void (ImFontAtlas::*)(ImTextureID),&ImFontAtlas::SetTexID >;
	addExtern<DAS_CALL_METHOD(_method_135)>(*this,lib,"SetTexID",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(ImTextureID) , &ImFontAtlas::SetTexID >::invoke")
		->args({"self","id"});
	using _method_136 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesDefault >;
	addExtern<DAS_CALL_METHOD(_method_136)>(*this,lib,"GetGlyphRangesDefault",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesDefault >::invoke")
		->args({"self"});
	using _method_137 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesKorean >;
	addExtern<DAS_CALL_METHOD(_method_137)>(*this,lib,"GetGlyphRangesKorean",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesKorean >::invoke")
		->args({"self"});
	using _method_138 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesJapanese >;
	addExtern<DAS_CALL_METHOD(_method_138)>(*this,lib,"GetGlyphRangesJapanese",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesJapanese >::invoke")
		->args({"self"});
	using _method_139 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesChineseFull >;
	addExtern<DAS_CALL_METHOD(_method_139)>(*this,lib,"GetGlyphRangesChineseFull",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesChineseFull >::invoke")
		->args({"self"});
	using _method_140 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesChineseSimplifiedCommon >;
	addExtern<DAS_CALL_METHOD(_method_140)>(*this,lib,"GetGlyphRangesChineseSimplifiedCommon",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesChineseSimplifiedCommon >::invoke")
		->args({"self"});
	using _method_141 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesCyrillic >;
	addExtern<DAS_CALL_METHOD(_method_141)>(*this,lib,"GetGlyphRangesCyrillic",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesCyrillic >::invoke")
		->args({"self"});
	using _method_142 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesThai >;
	addExtern<DAS_CALL_METHOD(_method_142)>(*this,lib,"GetGlyphRangesThai",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesThai >::invoke")
		->args({"self"});
	using _method_143 = das::das_call_member< const ImWchar * (ImFontAtlas::*)(),&ImFontAtlas::GetGlyphRangesVietnamese >;
	addExtern<DAS_CALL_METHOD(_method_143)>(*this,lib,"GetGlyphRangesVietnamese",SideEffects::worstDefault,"das_call_member< const ImWchar * (ImFontAtlas::*)() , &ImFontAtlas::GetGlyphRangesVietnamese >::invoke")
		->args({"self"});
	using _method_144 = das::das_call_member< int (ImFontAtlas::*)(int,int),&ImFontAtlas::AddCustomRectRegular >;
	addExtern<DAS_CALL_METHOD(_method_144)>(*this,lib,"AddCustomRectRegular",SideEffects::worstDefault,"das_call_member< int (ImFontAtlas::*)(int,int) , &ImFontAtlas::AddCustomRectRegular >::invoke")
		->args({"self","width","height"});
	using _method_145 = das::das_call_member< int (ImFontAtlas::*)(ImFont *,ImWchar,int,int,float,const ImVec2 &),&ImFontAtlas::AddCustomRectFontGlyph >;
	addExtern<DAS_CALL_METHOD(_method_145)>(*this,lib,"AddCustomRectFontGlyph",SideEffects::worstDefault,"das_call_member< int (ImFontAtlas::*)(ImFont *,ImWchar,int,int,float,const ImVec2 &) , &ImFontAtlas::AddCustomRectFontGlyph >::invoke")
		->args({"self","font","id","width","height","advance_x","offset"});
	using _method_146 = das::das_call_member< ImFontAtlasCustomRect * (ImFontAtlas::*)(int),&ImFontAtlas::GetCustomRectByIndex >;
	addExtern<DAS_CALL_METHOD(_method_146)>(*this,lib,"GetCustomRectByIndex",SideEffects::worstDefault,"das_call_member< ImFontAtlasCustomRect * (ImFontAtlas::*)(int) , &ImFontAtlas::GetCustomRectByIndex >::invoke")
		->args({"self","index"});
	using _method_147 = das::das_call_member< void (ImFontAtlas::*)(const ImFontAtlasCustomRect *,ImVec2 *,ImVec2 *) const,&ImFontAtlas::CalcCustomRectUV >;
	addExtern<DAS_CALL_METHOD(_method_147)>(*this,lib,"CalcCustomRectUV",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(const ImFontAtlasCustomRect *,ImVec2 *,ImVec2 *) const , &ImFontAtlas::CalcCustomRectUV >::invoke")
		->args({"self","rect","out_uv_min","out_uv_max"});
	using _method_148 = das::das_call_member< bool (ImFontAtlas::*)(ImGuiMouseCursor,ImVec2 *,ImVec2 *,ImVec2 [2],ImVec2 [2]),&ImFontAtlas::GetMouseCursorTexData >;
	addExtern<DAS_CALL_METHOD(_method_148)>(*this,lib,"GetMouseCursorTexData",SideEffects::worstDefault,"das_call_member< bool (ImFontAtlas::*)(ImGuiMouseCursor,ImVec2 *,ImVec2 *,ImVec2 [2],ImVec2 [2]) , &ImFontAtlas::GetMouseCursorTexData >::invoke")
		->args({"self","cursor","out_offset","out_size","out_uv_border","out_uv_fill"})
		->arg_type(1,makeType<ImGuiMouseCursor_>(lib));
	addCtorAndUsing<ImFont>(*this,lib,"ImFont","ImFont");
	using _method_149 = das::das_call_member< const ImFontGlyph * (ImFont::*)(ImWchar) const,&ImFont::FindGlyph >;
	addExtern<DAS_CALL_METHOD(_method_149)>(*this,lib,"FindGlyph",SideEffects::worstDefault,"das_call_member< const ImFontGlyph * (ImFont::*)(ImWchar) const , &ImFont::FindGlyph >::invoke")
		->args({"self","c"});
	using _method_150 = das::das_call_member< const ImFontGlyph * (ImFont::*)(ImWchar) const,&ImFont::FindGlyphNoFallback >;
	addExtern<DAS_CALL_METHOD(_method_150)>(*this,lib,"FindGlyphNoFallback",SideEffects::worstDefault,"das_call_member< const ImFontGlyph * (ImFont::*)(ImWchar) const , &ImFont::FindGlyphNoFallback >::invoke")
		->args({"self","c"});
	using _method_151 = das::das_call_member< float (ImFont::*)(ImWchar) const,&ImFont::GetCharAdvance >;
	addExtern<DAS_CALL_METHOD(_method_151)>(*this,lib,"GetCharAdvance",SideEffects::worstDefault,"das_call_member< float (ImFont::*)(ImWchar) const , &ImFont::GetCharAdvance >::invoke")
		->args({"self","c"});
	using _method_152 = das::das_call_member< bool (ImFont::*)() const,&ImFont::IsLoaded >;
	addExtern<DAS_CALL_METHOD(_method_152)>(*this,lib,"IsLoaded",SideEffects::worstDefault,"das_call_member< bool (ImFont::*)() const , &ImFont::IsLoaded >::invoke")
		->args({"self"});
}
}

