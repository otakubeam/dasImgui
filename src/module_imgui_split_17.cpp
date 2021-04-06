
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
void Module_imgui::initFunctions_17() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, bool *, ImGuiTreeNodeFlags),ImGui::CollapsingHeader>(*this, lib, "CollapsingHeader",SideEffects::worstDefault, "ImGui::CollapsingHeader")
	->args({"label","p_visible","flags"})
		->arg_type(2,makeType<ImGuiTreeNodeFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTreeNodeFlags_>(lib)))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::SetNodeGridSpacePos)>(*this, lib, "SetNodeGridSpacePos",SideEffects::worstDefault, "imnodes::SetNodeGridSpacePos")
	->args({"node_id","grid_pos"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::Bullet)>(*this, lib, "Bullet",SideEffects::worstDefault, "ImGui::Bullet")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::DragFloat3)>(*this, lib, "DragFloat3",SideEffects::worstDefault, "ImGui::DragFloat3")
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
addExtern<DAS_BIND_FUN(ImGui::BeginPopupModal)>(*this, lib, "BeginPopupModal",SideEffects::worstDefault, "ImGui::BeginPopupModal")
	->args({"name","p_open","flags"})
		->arg_init(1,make_smart<ExprConstPtr>())
		->arg_type(2,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ResetMouseDragDelta)>(*this, lib, "ResetMouseDragDelta",SideEffects::worstDefault, "ImGui::ResetMouseDragDelta")
	->args({"button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiMouseButton_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ShowFontSelector)>(*this, lib, "ShowFontSelector",SideEffects::worstDefault, "ImGui::ShowFontSelector")
	->args({"label"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetFrameHeightWithSpacing)>(*this, lib, "GetFrameHeightWithSpacing",SideEffects::worstDefault, "ImGui::GetFrameHeightWithSpacing")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetTabItemClosed)>(*this, lib, "SetTabItemClosed",SideEffects::worstDefault, "ImGui::SetTabItemClosed")
	->args({"tab_or_docked_window_label"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsMousePosValid)>(*this, lib, "IsMousePosValid",SideEffects::worstDefault, "ImGui::IsMousePosValid")
	->args({"mouse_pos"})
		->arg_init(0,make_smart<ExprConstPtr>())
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::SetCurrentContext)>(*this, lib, "SetCurrentContext",SideEffects::worstDefault, "imnodes::SetCurrentContext")
	->args({"ctx"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::EndChild)>(*this, lib, "EndChild",SideEffects::worstDefault, "ImGui::EndChild")
	->args({})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<bool (*)(int *, int *, int *, int *, bool *),imnodes::IsLinkCreated>(*this, lib, "IsLinkCreated",SideEffects::worstDefault, "imnodes::IsLinkCreated")
	->args({"started_at_node_id","started_at_attribute_id","ended_at_node_id","ended_at_attribute_id","created_from_snap"})
		->arg_init(4,make_smart<ExprConstPtr>())
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<bool (*)(int *, int *, bool *),imnodes::IsLinkCreated>(*this, lib, "IsLinkCreated",SideEffects::worstDefault, "imnodes::IsLinkCreated")
	->args({"started_at_attribute_id","ended_at_attribute_id","created_from_snap"})
		->arg_init(2,make_smart<ExprConstPtr>())
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableGetColumnCount)>(*this, lib, "TableGetColumnCount",SideEffects::worstDefault, "ImGui::TableGetColumnCount")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BeginChildFrame)>(*this, lib, "BeginChildFrame",SideEffects::worstDefault, "ImGui::BeginChildFrame")
	->args({"id","size","flags"})
		->arg_type(2,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PushItemWidth)>(*this, lib, "PushItemWidth",SideEffects::worstDefault, "ImGui::PushItemWidth")
	->args({"item_width"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetFontTexUvWhitePixel)>(*this, lib, "GetFontTexUvWhitePixel",SideEffects::worstDefault, "ImGui::GetFontTexUvWhitePixel")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::Checkbox)>(*this, lib, "Checkbox",SideEffects::worstDefault, "ImGui::Checkbox")
	->args({"label","v"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::BeginNodeEditor)>(*this, lib, "BeginNodeEditor",SideEffects::worstDefault, "imnodes::BeginNodeEditor")
	->args({})
;
#endif

#endif
#endif
}
