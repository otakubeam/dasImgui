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
void Module_dasIMGUI::initFunctions_16() {
	addExtern<int (*)(),ImGui::GetFrameCount>(*this,lib,"GetFrameCount",SideEffects::worstDefault,"ImGui::GetFrameCount");
	addExtern<ImDrawList * (*)(),ImGui::GetBackgroundDrawList>(*this,lib,"GetBackgroundDrawList",SideEffects::worstDefault,"ImGui::GetBackgroundDrawList");
	addExtern<ImDrawList * (*)(),ImGui::GetForegroundDrawList>(*this,lib,"GetForegroundDrawList",SideEffects::worstDefault,"ImGui::GetForegroundDrawList");
	addExtern<ImDrawListSharedData * (*)(),ImGui::GetDrawListSharedData>(*this,lib,"GetDrawListSharedData",SideEffects::worstDefault,"ImGui::GetDrawListSharedData");
	addExtern<const char * (*)(int),ImGui::GetStyleColorName>(*this,lib,"GetStyleColorName",SideEffects::worstDefault,"ImGui::GetStyleColorName")
		->args({"idx"})
		->arg_type(0,makeType<ImGuiCol_>(lib));
	addExtern<void (*)(ImGuiStorage *),ImGui::SetStateStorage>(*this,lib,"SetStateStorage",SideEffects::worstDefault,"ImGui::SetStateStorage")
		->args({"storage"});
	addExtern<ImGuiStorage * (*)(),ImGui::GetStateStorage>(*this,lib,"GetStateStorage",SideEffects::worstDefault,"ImGui::GetStateStorage");
	addExtern<void (*)(int,float,int *,int *),ImGui::CalcListClipping>(*this,lib,"CalcListClipping",SideEffects::worstDefault,"ImGui::CalcListClipping")
		->args({"items_count","items_height","out_items_display_start","out_items_display_end"});
	addExtern<bool (*)(unsigned int,const ImVec2 &,int),ImGui::BeginChildFrame>(*this,lib,"BeginChildFrame",SideEffects::worstDefault,"ImGui::BeginChildFrame")
		->args({"id","size","flags"})
		->arg_type(2,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)));
	addExtern<void (*)(),ImGui::EndChildFrame>(*this,lib,"EndChildFrame",SideEffects::worstDefault,"ImGui::EndChildFrame");
	addExtern<ImVec4 (*)(unsigned int),ImGui::ColorConvertU32ToFloat4>(*this,lib,"ColorConvertU32ToFloat4",SideEffects::worstDefault,"ImGui::ColorConvertU32ToFloat4")
		->args({"in"});
	addExtern<unsigned int (*)(const ImVec4 &),ImGui::ColorConvertFloat4ToU32>(*this,lib,"ColorConvertFloat4ToU32",SideEffects::worstDefault,"ImGui::ColorConvertFloat4ToU32")
		->args({"in"});
	addExtern<void (*)(float,float,float,float &,float &,float &),ImGui::ColorConvertRGBtoHSV>(*this,lib,"ColorConvertRGBtoHSV",SideEffects::worstDefault,"ImGui::ColorConvertRGBtoHSV")
		->args({"r","g","b","out_h","out_s","out_v"});
	addExtern<void (*)(float,float,float,float &,float &,float &),ImGui::ColorConvertHSVtoRGB>(*this,lib,"ColorConvertHSVtoRGB",SideEffects::worstDefault,"ImGui::ColorConvertHSVtoRGB")
		->args({"h","s","v","out_r","out_g","out_b"});
	addExtern<int (*)(int),ImGui::GetKeyIndex>(*this,lib,"GetKeyIndex",SideEffects::worstDefault,"ImGui::GetKeyIndex")
		->args({"imgui_key"})
		->arg_type(0,makeType<ImGuiKey_>(lib));
	addExtern<bool (*)(int),ImGui::IsKeyDown>(*this,lib,"IsKeyDown",SideEffects::worstDefault,"ImGui::IsKeyDown")
		->args({"user_key_index"});
	addExtern<bool (*)(int,bool),ImGui::IsKeyPressed>(*this,lib,"IsKeyPressed",SideEffects::worstDefault,"ImGui::IsKeyPressed")
		->args({"user_key_index","repeat"})
		->arg_init(1,make_smart<ExprConstBool>(true));
	addExtern<bool (*)(int),ImGui::IsKeyReleased>(*this,lib,"IsKeyReleased",SideEffects::worstDefault,"ImGui::IsKeyReleased")
		->args({"user_key_index"});
	addExtern<int (*)(int,float,float),ImGui::GetKeyPressedAmount>(*this,lib,"GetKeyPressedAmount",SideEffects::worstDefault,"ImGui::GetKeyPressedAmount")
		->args({"key_index","repeat_delay","rate"});
	addExtern<void (*)(bool),ImGui::CaptureKeyboardFromApp>(*this,lib,"CaptureKeyboardFromApp",SideEffects::worstDefault,"ImGui::CaptureKeyboardFromApp")
		->args({"want_capture_keyboard_value"})
		->arg_init(0,make_smart<ExprConstBool>(true));
}
}

