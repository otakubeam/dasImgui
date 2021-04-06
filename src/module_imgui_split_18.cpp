
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
void Module_imgui::initFunctions_18() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::GetNodeScreenSpacePos)>(*this, lib, "GetNodeScreenSpacePos",SideEffects::worstDefault, "imnodes::GetNodeScreenSpacePos")
	->args({"node_id"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetDragDropPayload)>(*this, lib, "SetDragDropPayload",SideEffects::worstDefault, "ImGui::SetDragDropPayload")
	->args({"type","data","sz","cond"})
		->arg_type(3,makeType<ImGuiCond_>(lib))
		->arg_init(3,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TextV)>(*this, lib, "TextV",SideEffects::worstDefault, "ImGui::TextV")
	->args({"fmt","args"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetVersion)>(*this, lib, "GetVersion",SideEffects::worstDefault, "ImGui::GetVersion")
	->args({})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::BeginNodeTitleBar)>(*this, lib, "BeginNodeTitleBar",SideEffects::worstDefault, "imnodes::BeginNodeTitleBar")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, int *, const char *const *, int, int),ImGui::Combo>(*this, lib, "Combo",SideEffects::worstDefault, "ImGui::Combo")
	->args({"label","current_item","items","items_count","popup_max_height_in_items"})
		->arg_init(4,make_smart<ExprConstInt>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetColumnsCount)>(*this, lib, "GetColumnsCount",SideEffects::worstDefault, "ImGui::GetColumnsCount")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::AlignTextToFramePadding)>(*this, lib, "AlignTextToFramePadding",SideEffects::worstDefault, "ImGui::AlignTextToFramePadding")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const char *, const ImVec2 &, ImGuiCond),ImGui::SetWindowPos>(*this, lib, "SetWindowPos",SideEffects::worstDefault, "ImGui::SetWindowPos")
	->args({"name","pos","cond"})
		->arg_type(2,makeType<ImGuiCond_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetIO), SimNode_ExtFuncCallRef>(*this, lib, "GetIO",SideEffects::worstDefault, "ImGui::GetIO")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndGroup)>(*this, lib, "EndGroup",SideEffects::worstDefault, "ImGui::EndGroup")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, int *, int),ImGui::CheckboxFlags>(*this, lib, "CheckboxFlags",SideEffects::worstDefault, "ImGui::CheckboxFlags")
	->args({"label","flags","flags_value"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::CloseCurrentPopup)>(*this, lib, "CloseCurrentPopup",SideEffects::worstDefault, "ImGui::CloseCurrentPopup")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableNextRow)>(*this, lib, "TableNextRow",SideEffects::worstDefault, "ImGui::TableNextRow")
	->args({"row_flags","min_row_height"})
		->arg_type(0,makeType<ImGuiTableRowFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTableRowFlags_>(lib)))
		->arg_init(1,make_smart<ExprConstFloat>(0))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::DragFloat2)>(*this, lib, "DragFloat2",SideEffects::worstDefault, "ImGui::DragFloat2")
	->args({"label","v","v_speed","v_min","v_max","format","flags"})
		->arg_init(2,make_smart<ExprConstFloat>(1))
		->arg_init(3,make_smart<ExprConstFloat>(0))
		->arg_init(4,make_smart<ExprConstFloat>(0))
		->arg_init(5,make_smart<ExprConstString>("%.3f"))
		->arg_type(6,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(6,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsItemActive)>(*this, lib, "IsItemActive",SideEffects::worstDefault, "ImGui::IsItemActive")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::DragInt)>(*this, lib, "DragInt",SideEffects::worstDefault, "ImGui::DragInt")
	->args({"label","v","v_speed","v_min","v_max","format","flags"})
		->arg_init(2,make_smart<ExprConstFloat>(1))
		->arg_init(3,make_smart<ExprConstInt>(0))
		->arg_init(4,make_smart<ExprConstInt>(0))
		->arg_init(5,make_smart<ExprConstString>("%d"))
		->arg_type(6,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(6,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetScrollY)>(*this, lib, "SetScrollY",SideEffects::worstDefault, "ImGui::SetScrollY")
	->args({"scroll_y"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<ImGuiID (*)(const char *, const char *),ImGui::GetID>(*this, lib, "GetID",SideEffects::worstDefault, "ImGui::GetID")
	->args({"str_id_begin","str_id_end"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::NewLine)>(*this, lib, "NewLine",SideEffects::worstDefault, "ImGui::NewLine")
	->args({})
;
#endif

#endif
#endif
}
