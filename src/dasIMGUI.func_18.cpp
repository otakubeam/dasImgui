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
void Module_dasIMGUI::initFunctions_18() {
	addExtern<const char * (*)(unsigned long long *),ImGui::SaveIniSettingsToMemory>(*this,lib,"SaveIniSettingsToMemory",SideEffects::worstDefault,"ImGui::SaveIniSettingsToMemory")
		->args({"out_ini_size"})
		->arg_init(0,make_smart<ExprConstPtr>());
	addExtern<bool (*)(const char *,unsigned long long,unsigned long long,unsigned long long,unsigned long long,unsigned long long,unsigned long long),ImGui::DebugCheckVersionAndDataLayout>(*this,lib,"DebugCheckVersionAndDataLayout",SideEffects::worstDefault,"ImGui::DebugCheckVersionAndDataLayout")
		->args({"version_str","sz_io","sz_style","sz_vec2","sz_vec4","sz_drawvert","sz_drawidx"});
	addExtern<void * (*)(unsigned long long),ImGui::MemAlloc>(*this,lib,"MemAlloc",SideEffects::worstDefault,"ImGui::MemAlloc")
		->args({"size"});
	addExtern<void (*)(void *),ImGui::MemFree>(*this,lib,"MemFree",SideEffects::worstDefault,"ImGui::MemFree")
		->args({"ptr"});
	addExtern<void * (*)(unsigned long long,ImNewWrapper,void *),operator new>(*this,lib," new",SideEffects::worstDefault,"operator new")
		->args({"","","ptr"});
	addExtern<void (*)(void *,ImNewWrapper,void *),operator delete>(*this,lib," delete",SideEffects::worstDefault,"operator delete")
		->args({"","",""});
	using _method_1 = das::das_call_member< void (ImGuiStyle::*)(float),&ImGuiStyle::ScaleAllSizes >;
	addExtern<DAS_CALL_METHOD(_method_1)>(*this,lib,"ScaleAllSizes",SideEffects::worstDefault,"das_call_member< void (ImGuiStyle::*)(float),&ImGuiStyle::ScaleAllSizes >::invoke")
		->args({"self","scale_factor"});
	using _method_2 = das::das_call_member< void (ImGuiIO::*)(unsigned int),&ImGuiIO::AddInputCharacter >;
	addExtern<DAS_CALL_METHOD(_method_2)>(*this,lib,"AddInputCharacter",SideEffects::worstDefault,"das_call_member< void (ImGuiIO::*)(unsigned int),&ImGuiIO::AddInputCharacter >::invoke")
		->args({"self","c"});
	using _method_3 = das::das_call_member< void (ImGuiIO::*)(unsigned short),&ImGuiIO::AddInputCharacterUTF16 >;
	addExtern<DAS_CALL_METHOD(_method_3)>(*this,lib,"AddInputCharacterUTF16",SideEffects::worstDefault,"das_call_member< void (ImGuiIO::*)(unsigned short),&ImGuiIO::AddInputCharacterUTF16 >::invoke")
		->args({"self","c"});
	using _method_4 = das::das_call_member< void (ImGuiIO::*)(const char *),&ImGuiIO::AddInputCharactersUTF8 >;
	addExtern<DAS_CALL_METHOD(_method_4)>(*this,lib,"AddInputCharactersUTF8",SideEffects::worstDefault,"das_call_member< void (ImGuiIO::*)(const char *),&ImGuiIO::AddInputCharactersUTF8 >::invoke")
		->args({"self","str"});
	using _method_5 = das::das_call_member< void (ImGuiIO::*)(),&ImGuiIO::ClearInputCharacters >;
	addExtern<DAS_CALL_METHOD(_method_5)>(*this,lib,"ClearInputCharacters",SideEffects::worstDefault,"das_call_member< void (ImGuiIO::*)(),&ImGuiIO::ClearInputCharacters >::invoke")
		->args({"self"});
	using _method_6 = das::das_call_member< void (ImGuiInputTextCallbackData::*)(int,int),&ImGuiInputTextCallbackData::DeleteChars >;
	addExtern<DAS_CALL_METHOD(_method_6)>(*this,lib,"DeleteChars",SideEffects::worstDefault,"das_call_member< void (ImGuiInputTextCallbackData::*)(int,int),&ImGuiInputTextCallbackData::DeleteChars >::invoke")
		->args({"self","pos","bytes_count"});
	using _method_7 = das::das_call_member< void (ImGuiInputTextCallbackData::*)(),&ImGuiInputTextCallbackData::SelectAll >;
	addExtern<DAS_CALL_METHOD(_method_7)>(*this,lib,"SelectAll",SideEffects::worstDefault,"das_call_member< void (ImGuiInputTextCallbackData::*)(),&ImGuiInputTextCallbackData::SelectAll >::invoke")
		->args({"self"});
	using _method_8 = das::das_call_member< void (ImGuiInputTextCallbackData::*)(),&ImGuiInputTextCallbackData::ClearSelection >;
	addExtern<DAS_CALL_METHOD(_method_8)>(*this,lib,"ClearSelection",SideEffects::worstDefault,"das_call_member< void (ImGuiInputTextCallbackData::*)(),&ImGuiInputTextCallbackData::ClearSelection >::invoke")
		->args({"self"});
	using _method_9 = das::das_call_member< bool (ImGuiInputTextCallbackData::*)() const,&ImGuiInputTextCallbackData::HasSelection >;
	addExtern<DAS_CALL_METHOD(_method_9)>(*this,lib,"HasSelection",SideEffects::worstDefault,"das_call_member< bool (ImGuiInputTextCallbackData::*)() const,&ImGuiInputTextCallbackData::HasSelection >::invoke")
		->args({"self"});
	using _method_10 = das::das_call_member< void (ImGuiPayload::*)(),&ImGuiPayload::Clear >;
	addExtern<DAS_CALL_METHOD(_method_10)>(*this,lib,"Clear",SideEffects::worstDefault,"das_call_member< void (ImGuiPayload::*)(),&ImGuiPayload::Clear >::invoke")
		->args({"self"});
	using _method_11 = das::das_call_member< bool (ImGuiPayload::*)(const char *) const,&ImGuiPayload::IsDataType >;
	addExtern<DAS_CALL_METHOD(_method_11)>(*this,lib,"IsDataType",SideEffects::worstDefault,"das_call_member< bool (ImGuiPayload::*)(const char *) const,&ImGuiPayload::IsDataType >::invoke")
		->args({"self","type"});
	using _method_12 = das::das_call_member< bool (ImGuiPayload::*)() const,&ImGuiPayload::IsPreview >;
	addExtern<DAS_CALL_METHOD(_method_12)>(*this,lib,"IsPreview",SideEffects::worstDefault,"das_call_member< bool (ImGuiPayload::*)() const,&ImGuiPayload::IsPreview >::invoke")
		->args({"self"});
	using _method_13 = das::das_call_member< bool (ImGuiPayload::*)() const,&ImGuiPayload::IsDelivery >;
	addExtern<DAS_CALL_METHOD(_method_13)>(*this,lib,"IsDelivery",SideEffects::worstDefault,"das_call_member< bool (ImGuiPayload::*)() const,&ImGuiPayload::IsDelivery >::invoke")
		->args({"self"});
	using _method_14 = das::das_call_member< bool (ImGuiTextFilter::*)(const char *,float),&ImGuiTextFilter::Draw >;
	addExtern<DAS_CALL_METHOD(_method_14)>(*this,lib,"Draw",SideEffects::worstDefault,"das_call_member< bool (ImGuiTextFilter::*)(const char *,float),&ImGuiTextFilter::Draw >::invoke")
		->args({"self","label","width"})
		->arg_init(1,make_smart<ExprConstString>("Filter (inc,-exc)"))
		->arg_init(2,make_smart<ExprConstFloat>(0));
}
}

