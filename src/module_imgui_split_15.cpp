
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
void Module_imgui::initFunctions_15() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsWindowHovered)>(*this, lib, "IsWindowHovered",SideEffects::worstDefault, "ImGui::IsWindowHovered")
	->args({"flags"})
		->arg_type(0,makeType<ImGuiHoveredFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiHoveredFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SliderFloat)>(*this, lib, "SliderFloat",SideEffects::worstDefault, "ImGui::SliderFloat")
	->args({"label","v","v_min","v_max","format","flags"})
		->arg_init(4,make_smart<ExprConstString>("%.3f"))
		->arg_type(5,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(5,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableHeader)>(*this, lib, "TableHeader",SideEffects::worstDefault, "ImGui::TableHeader")
	->args({"label"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::EndNode)>(*this, lib, "EndNode",SideEffects::worstDefault, "imnodes::EndNode")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, const char *, bool *, bool),ImGui::MenuItem>(*this, lib, "MenuItem",SideEffects::worstDefault, "ImGui::MenuItem")
	->args({"label","shortcut","p_selected","enabled"})
		->arg_init(3,make_smart<ExprConstBool>(true))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::VSliderFloat)>(*this, lib, "VSliderFloat",SideEffects::worstDefault, "ImGui::VSliderFloat")
	->args({"label","size","v","v_min","v_max","format","flags"})
		->arg_init(5,make_smart<ExprConstString>("%.3f"))
		->arg_type(6,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(6,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsWindowFocused)>(*this, lib, "IsWindowFocused",SideEffects::worstDefault, "ImGui::IsWindowFocused")
	->args({"flags"})
		->arg_type(0,makeType<ImGuiFocusedFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiFocusedFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BulletTextV)>(*this, lib, "BulletTextV",SideEffects::worstDefault, "ImGui::BulletTextV")
	->args({"fmt","args"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::ClearNodeSelection)>(*this, lib, "ClearNodeSelection",SideEffects::worstDefault, "imnodes::ClearNodeSelection")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::InputInt3)>(*this, lib, "InputInt3",SideEffects::worstDefault, "ImGui::InputInt3")
	->args({"label","v","flags"})
		->arg_type(2,makeType<ImGuiInputTextFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiInputTextFlags_>(lib)))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::IsLinkDestroyed)>(*this, lib, "IsLinkDestroyed",SideEffects::worstDefault, "imnodes::IsLinkDestroyed")
	->args({"link_id"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::InvisibleButton)>(*this, lib, "InvisibleButton",SideEffects::worstDefault, "ImGui::InvisibleButton")
	->args({"str_id","size","flags"})
		->arg_type(2,makeType<ImGuiButtonFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiButtonFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetStyleColorVec4), SimNode_ExtFuncCallRef>(*this, lib, "GetStyleColorVec4",SideEffects::worstDefault, "ImGui::GetStyleColorVec4")
	->args({"idx"})
		->arg_type(0,makeType<ImGuiCol_>(lib))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsAnyItemFocused)>(*this, lib, "IsAnyItemFocused",SideEffects::worstDefault, "ImGui::IsAnyItemFocused")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::InputFloat2)>(*this, lib, "InputFloat2",SideEffects::worstDefault, "ImGui::InputFloat2")
	->args({"label","v","format","flags"})
		->arg_init(2,make_smart<ExprConstString>("%.3f"))
		->arg_type(3,makeType<ImGuiInputTextFlags_>(lib))
		->arg_init(3,make_smart<ExprConstEnumeration>(0,makeType<ImGuiInputTextFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BeginPopup)>(*this, lib, "BeginPopup",SideEffects::worstDefault, "ImGui::BeginPopup")
	->args({"str_id","flags"})
		->arg_type(1,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetBackgroundDrawList)>(*this, lib, "GetBackgroundDrawList",SideEffects::worstDefault, "ImGui::GetBackgroundDrawList")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetStyleColorName)>(*this, lib, "GetStyleColorName",SideEffects::worstDefault, "ImGui::GetStyleColorName")
	->args({"idx"})
		->arg_type(0,makeType<ImGuiCol_>(lib))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::SaveEditorStateToIniFile)>(*this, lib, "SaveEditorStateToIniFile",SideEffects::worstDefault, "imnodes::SaveEditorStateToIniFile")
	->args({"editor","file_name"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SliderScalarN)>(*this, lib, "SliderScalarN",SideEffects::worstDefault, "ImGui::SliderScalarN")
	->args({"label","data_type","p_data","components","p_min","p_max","format","flags"})
		->arg_type(1,makeType<ImGuiDataType_>(lib))
		->arg_init(6,make_smart<ExprConstString>(""))
		->arg_type(7,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(7,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif

#endif
#endif
}
