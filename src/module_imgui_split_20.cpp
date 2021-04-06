
#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include <imgui.h>
#include <imnodes.h>
using namespace das;
#include "need_imgui.h"
#if USE_GENERATED
#define GLOBAL_NAMESPACE    1
#include "module_imgui.h"
#endif
void Module_imgui::initFunctions_20() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const char *, bool, ImGuiCond),ImGui::SetWindowCollapsed>(*this, lib, "SetWindowCollapsed",SideEffects::worstDefault, "ImGui::SetWindowCollapsed")
	->args({"name","collapsed","cond"})
		->arg_type(2,makeType<ImGuiCond_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<ImU32 (*)(ImU32),ImGui::GetColorU32>(*this, lib, "GetColorU32",SideEffects::worstDefault, "ImGui::GetColorU32")
	->args({"col"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ColorEdit3)>(*this, lib, "ColorEdit3",SideEffects::worstDefault, "ImGui::ColorEdit3")
	->args({"label","col","flags"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableHeadersRow)>(*this, lib, "TableHeadersRow",SideEffects::worstDefault, "ImGui::TableHeadersRow")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndDragDropSource)>(*this, lib, "EndDragDropSource",SideEffects::worstDefault, "ImGui::EndDragDropSource")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsItemFocused)>(*this, lib, "IsItemFocused",SideEffects::worstDefault, "ImGui::IsItemFocused")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ColorConvertHSVtoRGB)>(*this, lib, "ColorConvertHSVtoRGB",SideEffects::worstDefault, "ImGui::ColorConvertHSVtoRGB")
	->args({"h","s","v","out_r","out_g","out_b"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsMouseClicked)>(*this, lib, "IsMouseClicked",SideEffects::worstDefault, "ImGui::IsMouseClicked")
	->args({"button","repeat"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(1,make_smart<ExprConstBool>(false))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetMousePos)>(*this, lib, "GetMousePos",SideEffects::worstDefault, "ImGui::GetMousePos")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TabItemButton)>(*this, lib, "TabItemButton",SideEffects::worstDefault, "ImGui::TabItemButton")
	->args({"label","flags"})
		->arg_type(1,makeType<ImGuiTabItemFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTabItemFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetCursorPosY)>(*this, lib, "SetCursorPosY",SideEffects::worstDefault, "ImGui::SetCursorPosY")
	->args({"local_y"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::LogTextV)>(*this, lib, "LogTextV",SideEffects::worstDefault, "ImGui::LogTextV")
	->args({"fmt","args"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsKeyReleased)>(*this, lib, "IsKeyReleased",SideEffects::worstDefault, "ImGui::IsKeyReleased")
	->args({"user_key_index"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetClipboardText)>(*this, lib, "SetClipboardText",SideEffects::worstDefault, "ImGui::SetClipboardText")
	->args({"text"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::GetStyle), SimNode_ExtFuncCallRef>(*this, lib, "GetStyle",SideEffects::worstDefault, "imnodes::GetStyle")
	->args({})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::PushAttributeFlag)>(*this, lib, "PushAttributeFlag",SideEffects::worstDefault, "imnodes::PushAttributeFlag")
	->args({"flag"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::LoadCurrentEditorStateFromIniFile)>(*this, lib, "LoadCurrentEditorStateFromIniFile",SideEffects::worstDefault, "imnodes::LoadCurrentEditorStateFromIniFile")
	->args({"file_name"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PopID)>(*this, lib, "PopID",SideEffects::worstDefault, "ImGui::PopID")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsItemToggledOpen)>(*this, lib, "IsItemToggledOpen",SideEffects::worstDefault, "ImGui::IsItemToggledOpen")
	->args({})
;
#endif

#endif
#endif
}
