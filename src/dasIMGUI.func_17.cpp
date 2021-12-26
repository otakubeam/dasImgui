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
void Module_dasIMGUI::initFunctions_17() {
	addExtern< bool (*)(ImGuiMouseButton) , ImGui::IsMouseDown >(*this,lib,"IsMouseDown",SideEffects::worstDefault,"ImGui::IsMouseDown")
		->args({"button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib));
	addExtern< bool (*)(ImGuiMouseButton,bool) , ImGui::IsMouseClicked >(*this,lib,"IsMouseClicked",SideEffects::worstDefault,"ImGui::IsMouseClicked")
		->args({"button","repeat"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(1,make_smart<ExprConstBool>(false));
	addExtern< bool (*)(ImGuiMouseButton) , ImGui::IsMouseReleased >(*this,lib,"IsMouseReleased",SideEffects::worstDefault,"ImGui::IsMouseReleased")
		->args({"button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib));
	addExtern< bool (*)(ImGuiMouseButton) , ImGui::IsMouseDoubleClicked >(*this,lib,"IsMouseDoubleClicked",SideEffects::worstDefault,"ImGui::IsMouseDoubleClicked")
		->args({"button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib));
	addExtern< bool (*)(const ImVec2 &,const ImVec2 &,bool) , ImGui::IsMouseHoveringRect >(*this,lib,"IsMouseHoveringRect",SideEffects::worstDefault,"ImGui::IsMouseHoveringRect")
		->args({"r_min","r_max","clip"})
		->arg_init(2,make_smart<ExprConstBool>(true));
	addExtern< bool (*)(const ImVec2 *) , ImGui::IsMousePosValid >(*this,lib,"IsMousePosValid",SideEffects::worstDefault,"ImGui::IsMousePosValid")
		->args({"mouse_pos"})
		->arg_init(0,make_smart<ExprConstPtr>());
	addExtern< bool (*)() , ImGui::IsAnyMouseDown >(*this,lib,"IsAnyMouseDown",SideEffects::worstDefault,"ImGui::IsAnyMouseDown");
	addExtern< ImVec2 (*)() , ImGui::GetMousePos >(*this,lib,"GetMousePos",SideEffects::worstDefault,"ImGui::GetMousePos");
	addExtern< ImVec2 (*)() , ImGui::GetMousePosOnOpeningCurrentPopup >(*this,lib,"GetMousePosOnOpeningCurrentPopup",SideEffects::worstDefault,"ImGui::GetMousePosOnOpeningCurrentPopup");
	addExtern< bool (*)(ImGuiMouseButton,float) , ImGui::IsMouseDragging >(*this,lib,"IsMouseDragging",SideEffects::worstDefault,"ImGui::IsMouseDragging")
		->args({"button","lock_threshold"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(1,make_smart<ExprConstFloat>(-1.00000000000000000));
	addExtern< ImVec2 (*)(ImGuiMouseButton,float) , ImGui::GetMouseDragDelta >(*this,lib,"GetMouseDragDelta",SideEffects::worstDefault,"ImGui::GetMouseDragDelta")
		->args({"button","lock_threshold"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiMouseButton_>(lib)))
		->arg_init(1,make_smart<ExprConstFloat>(-1.00000000000000000));
	addExtern< void (*)(ImGuiMouseButton) , ImGui::ResetMouseDragDelta >(*this,lib,"ResetMouseDragDelta",SideEffects::worstDefault,"ImGui::ResetMouseDragDelta")
		->args({"button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiMouseButton_>(lib)));
	addExtern< ImGuiMouseCursor (*)() , ImGui::GetMouseCursor >(*this,lib,"GetMouseCursor",SideEffects::worstDefault,"ImGui::GetMouseCursor")
		->res_type(makeType<ImGuiMouseCursor_>(lib));
	addExtern< void (*)(ImGuiMouseCursor) , ImGui::SetMouseCursor >(*this,lib,"SetMouseCursor",SideEffects::worstDefault,"ImGui::SetMouseCursor")
		->args({"cursor_type"})
		->arg_type(0,makeType<ImGuiMouseCursor_>(lib));
	addExtern< void (*)(bool) , ImGui::CaptureMouseFromApp >(*this,lib,"CaptureMouseFromApp",SideEffects::worstDefault,"ImGui::CaptureMouseFromApp")
		->args({"want_capture_mouse_value"})
		->arg_init(0,make_smart<ExprConstBool>(true));
	addExtern< const char * (*)() , ImGui::GetClipboardText >(*this,lib,"GetClipboardText",SideEffects::worstDefault,"ImGui::GetClipboardText");
	addExtern< void (*)(const char *) , ImGui::SetClipboardText >(*this,lib,"SetClipboardText",SideEffects::worstDefault,"ImGui::SetClipboardText")
		->args({"text"});
	addExtern< void (*)(const char *) , ImGui::LoadIniSettingsFromDisk >(*this,lib,"LoadIniSettingsFromDisk",SideEffects::worstDefault,"ImGui::LoadIniSettingsFromDisk")
		->args({"ini_filename"});
	addExtern< void (*)(const char *,size_t) , ImGui::LoadIniSettingsFromMemory >(*this,lib,"LoadIniSettingsFromMemory",SideEffects::worstDefault,"ImGui::LoadIniSettingsFromMemory")
		->args({"ini_data","ini_size"})
		->arg_init(1,make_smart<ExprConstUInt64>(0x0));
	addExtern< void (*)(const char *) , ImGui::SaveIniSettingsToDisk >(*this,lib,"SaveIniSettingsToDisk",SideEffects::worstDefault,"ImGui::SaveIniSettingsToDisk")
		->args({"ini_filename"});
}
}

