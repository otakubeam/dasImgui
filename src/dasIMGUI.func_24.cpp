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
void Module_dasIMGUI::initFunctions_24() {
	using _method_115 = das::das_call_member< void (ImFontGlyphRangesBuilder::*)(unsigned long long),&ImFontGlyphRangesBuilder::SetBit >;
	addExtern<DAS_CALL_METHOD(_method_115)>(*this,lib,"SetBit",SideEffects::worstDefault,"das_call_member< void (ImFontGlyphRangesBuilder::*)(unsigned long long),&ImFontGlyphRangesBuilder::SetBit >::invoke")
		->args({"self","n"});
	using _method_116 = das::das_call_member< void (ImFontGlyphRangesBuilder::*)(unsigned short),&ImFontGlyphRangesBuilder::AddChar >;
	addExtern<DAS_CALL_METHOD(_method_116)>(*this,lib,"AddChar",SideEffects::worstDefault,"das_call_member< void (ImFontGlyphRangesBuilder::*)(unsigned short),&ImFontGlyphRangesBuilder::AddChar >::invoke")
		->args({"self","c"});
	using _method_117 = das::das_call_member< void (ImFontGlyphRangesBuilder::*)(const char *,const char *),&ImFontGlyphRangesBuilder::AddText >;
	addExtern<DAS_CALL_METHOD(_method_117)>(*this,lib,"AddText",SideEffects::worstDefault,"das_call_member< void (ImFontGlyphRangesBuilder::*)(const char *,const char *),&ImFontGlyphRangesBuilder::AddText >::invoke")
		->args({"self","text","text_end"})
		->arg_init(2,make_smart<ExprConstString>(""));
	using _method_118 = das::das_call_member< void (ImFontGlyphRangesBuilder::*)(const unsigned short *),&ImFontGlyphRangesBuilder::AddRanges >;
	addExtern<DAS_CALL_METHOD(_method_118)>(*this,lib,"AddRanges",SideEffects::worstDefault,"das_call_member< void (ImFontGlyphRangesBuilder::*)(const unsigned short *),&ImFontGlyphRangesBuilder::AddRanges >::invoke")
		->args({"self","ranges"});
	using _method_119 = das::das_call_member< void (ImFontGlyphRangesBuilder::*)(ImVector<unsigned short> *),&ImFontGlyphRangesBuilder::BuildRanges >;
	addExtern<DAS_CALL_METHOD(_method_119)>(*this,lib,"BuildRanges",SideEffects::worstDefault,"das_call_member< void (ImFontGlyphRangesBuilder::*)(ImVector<unsigned short> *),&ImFontGlyphRangesBuilder::BuildRanges >::invoke")
		->args({"self","out_ranges"});
	using _method_120 = das::das_call_member< bool (ImFontAtlasCustomRect::*)() const,&ImFontAtlasCustomRect::IsPacked >;
	addExtern<DAS_CALL_METHOD(_method_120)>(*this,lib,"IsPacked",SideEffects::worstDefault,"das_call_member< bool (ImFontAtlasCustomRect::*)() const,&ImFontAtlasCustomRect::IsPacked >::invoke")
		->args({"self"});
	using _method_121 = das::das_call_member< ImFont * (ImFontAtlas::*)(const ImFontConfig *),&ImFontAtlas::AddFont >;
	addExtern<DAS_CALL_METHOD(_method_121)>(*this,lib,"AddFont",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(const ImFontConfig *),&ImFontAtlas::AddFont >::invoke")
		->args({"self","font_cfg"});
	using _method_122 = das::das_call_member< ImFont * (ImFontAtlas::*)(const ImFontConfig *),&ImFontAtlas::AddFontDefault >;
	addExtern<DAS_CALL_METHOD(_method_122)>(*this,lib,"AddFontDefault",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(const ImFontConfig *),&ImFontAtlas::AddFontDefault >::invoke")
		->args({"self","font_cfg"})
		->arg_init(1,make_smart<ExprConstPtr>());
	using _method_123 = das::das_call_member< ImFont * (ImFontAtlas::*)(const char *,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromFileTTF >;
	addExtern<DAS_CALL_METHOD(_method_123)>(*this,lib,"AddFontFromFileTTF",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(const char *,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromFileTTF >::invoke")
		->args({"self","filename","size_pixels","font_cfg","glyph_ranges"})
		->arg_init(3,make_smart<ExprConstPtr>())
		->arg_init(4,make_smart<ExprConstPtr>());
	using _method_124 = das::das_call_member< ImFont * (ImFontAtlas::*)(void *,int,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryTTF >;
	addExtern<DAS_CALL_METHOD(_method_124)>(*this,lib,"AddFontFromMemoryTTF",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(void *,int,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryTTF >::invoke")
		->args({"self","font_data","font_size","size_pixels","font_cfg","glyph_ranges"})
		->arg_init(4,make_smart<ExprConstPtr>())
		->arg_init(5,make_smart<ExprConstPtr>());
	using _method_125 = das::das_call_member< ImFont * (ImFontAtlas::*)(const void *,int,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryCompressedTTF >;
	addExtern<DAS_CALL_METHOD(_method_125)>(*this,lib,"AddFontFromMemoryCompressedTTF",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(const void *,int,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryCompressedTTF >::invoke")
		->args({"self","compressed_font_data","compressed_font_size","size_pixels","font_cfg","glyph_ranges"})
		->arg_init(4,make_smart<ExprConstPtr>())
		->arg_init(5,make_smart<ExprConstPtr>());
	using _method_126 = das::das_call_member< ImFont * (ImFontAtlas::*)(const char *,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryCompressedBase85TTF >;
	addExtern<DAS_CALL_METHOD(_method_126)>(*this,lib,"AddFontFromMemoryCompressedBase85TTF",SideEffects::worstDefault,"das_call_member< ImFont * (ImFontAtlas::*)(const char *,float,const ImFontConfig *,const unsigned short *),&ImFontAtlas::AddFontFromMemoryCompressedBase85TTF >::invoke")
		->args({"self","compressed_font_data_base85","size_pixels","font_cfg","glyph_ranges"})
		->arg_init(3,make_smart<ExprConstPtr>())
		->arg_init(4,make_smart<ExprConstPtr>());
	using _method_127 = das::das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearInputData >;
	addExtern<DAS_CALL_METHOD(_method_127)>(*this,lib,"ClearInputData",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearInputData >::invoke")
		->args({"self"});
	using _method_128 = das::das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearTexData >;
	addExtern<DAS_CALL_METHOD(_method_128)>(*this,lib,"ClearTexData",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearTexData >::invoke")
		->args({"self"});
	using _method_129 = das::das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearFonts >;
	addExtern<DAS_CALL_METHOD(_method_129)>(*this,lib,"ClearFonts",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::ClearFonts >::invoke")
		->args({"self"});
	using _method_130 = das::das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::Clear >;
	addExtern<DAS_CALL_METHOD(_method_130)>(*this,lib,"Clear",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(),&ImFontAtlas::Clear >::invoke")
		->args({"self"});
	using _method_131 = das::das_call_member< bool (ImFontAtlas::*)(),&ImFontAtlas::Build >;
	addExtern<DAS_CALL_METHOD(_method_131)>(*this,lib,"Build",SideEffects::worstDefault,"das_call_member< bool (ImFontAtlas::*)(),&ImFontAtlas::Build >::invoke")
		->args({"self"});
	using _method_132 = das::das_call_member< void (ImFontAtlas::*)(unsigned char **,int *,int *,int *),&ImFontAtlas::GetTexDataAsAlpha8 >;
	addExtern<DAS_CALL_METHOD(_method_132)>(*this,lib,"GetTexDataAsAlpha8",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(unsigned char **,int *,int *,int *),&ImFontAtlas::GetTexDataAsAlpha8 >::invoke")
		->args({"self","out_pixels","out_width","out_height","out_bytes_per_pixel"})
		->arg_init(4,make_smart<ExprConstPtr>());
	using _method_133 = das::das_call_member< void (ImFontAtlas::*)(unsigned char **,int *,int *,int *),&ImFontAtlas::GetTexDataAsRGBA32 >;
	addExtern<DAS_CALL_METHOD(_method_133)>(*this,lib,"GetTexDataAsRGBA32",SideEffects::worstDefault,"das_call_member< void (ImFontAtlas::*)(unsigned char **,int *,int *,int *),&ImFontAtlas::GetTexDataAsRGBA32 >::invoke")
		->args({"self","out_pixels","out_width","out_height","out_bytes_per_pixel"})
		->arg_init(4,make_smart<ExprConstPtr>());
	using _method_134 = das::das_call_member< bool (ImFontAtlas::*)() const,&ImFontAtlas::IsBuilt >;
	addExtern<DAS_CALL_METHOD(_method_134)>(*this,lib,"IsBuilt",SideEffects::worstDefault,"das_call_member< bool (ImFontAtlas::*)() const,&ImFontAtlas::IsBuilt >::invoke")
		->args({"self"});
}
}

