
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
void Module_imgui::initFunctions_16() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsItemDeactivated)>(*this, lib, "IsItemDeactivated",SideEffects::worstDefault, "ImGui::IsItemDeactivated")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, ImGuiTreeNodeFlags),ImGui::CollapsingHeader>(*this, lib, "CollapsingHeader",SideEffects::worstDefault, "ImGui::CollapsingHeader")
	->args({"label","flags"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTreeNodeFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::StyleColorsDark)>(*this, lib, "StyleColorsDark",SideEffects::worstDefault, "ImGui::StyleColorsDark")
	->args({"dst"})
		->arg_init(0,make_smart<ExprConstPtr>())
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndCombo)>(*this, lib, "EndCombo",SideEffects::worstDefault, "ImGui::EndCombo")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsMouseDragging)>(*this, lib, "IsMouseDragging",SideEffects::worstDefault, "ImGui::IsMouseDragging")
	->args({"button","lock_threshold"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(1,make_smart<ExprConstFloat>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndTabItem)>(*this, lib, "EndTabItem",SideEffects::worstDefault, "ImGui::EndTabItem")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetForegroundDrawList)>(*this, lib, "GetForegroundDrawList",SideEffects::worstDefault, "ImGui::GetForegroundDrawList")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetCursorPos)>(*this, lib, "GetCursorPos",SideEffects::worstDefault, "ImGui::GetCursorPos")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsItemEdited)>(*this, lib, "IsItemEdited",SideEffects::worstDefault, "ImGui::IsItemEdited")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableNextColumn)>(*this, lib, "TableNextColumn",SideEffects::worstDefault, "ImGui::TableNextColumn")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, ImGuiTreeNodeFlags, const char *, va_list),ImGui::TreeNodeExV>(*this, lib, "TreeNodeExV",SideEffects::worstDefault, "ImGui::TreeNodeExV")
	->args({"str_id","flags","fmt","args"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableGetColumnIndex)>(*this, lib, "TableGetColumnIndex",SideEffects::worstDefault, "ImGui::TableGetColumnIndex")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PopStyleVar)>(*this, lib, "PopStyleVar",SideEffects::worstDefault, "ImGui::PopStyleVar")
	->args({"count"})
		->arg_init(0,make_smart<ExprConstInt>(1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndMainMenuBar)>(*this, lib, "EndMainMenuBar",SideEffects::worstDefault, "ImGui::EndMainMenuBar")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PopClipRect)>(*this, lib, "PopClipRect",SideEffects::worstDefault, "ImGui::PopClipRect")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetItemRectMax)>(*this, lib, "GetItemRectMax",SideEffects::worstDefault, "ImGui::GetItemRectMax")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndTabBar)>(*this, lib, "EndTabBar",SideEffects::worstDefault, "ImGui::EndTabBar")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::InputInt2)>(*this, lib, "InputInt2",SideEffects::worstDefault, "ImGui::InputInt2")
	->args({"label","v","flags"})
		->arg_type(2,makeType<ImGuiInputTextFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiInputTextFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const ImVec2 &),ImGui::IsRectVisible>(*this, lib, "IsRectVisible",SideEffects::worstDefault, "ImGui::IsRectVisible")
	->args({"size"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetCursorScreenPos)>(*this, lib, "GetCursorScreenPos",SideEffects::worstDefault, "ImGui::GetCursorScreenPos")
	->args({})
;
#endif

#endif
#endif
}
