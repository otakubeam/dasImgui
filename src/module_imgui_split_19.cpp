
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
void Module_imgui::initFunctions_19() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ColorPicker3)>(*this, lib, "ColorPicker3",SideEffects::worstDefault, "ImGui::ColorPicker3")
	->args({"label","col","flags"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ColorConvertFloat4ToU32)>(*this, lib, "ColorConvertFloat4ToU32",SideEffects::worstDefault, "ImGui::ColorConvertFloat4ToU32")
	->args({"in"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::End)>(*this, lib, "End",SideEffects::worstDefault, "ImGui::End")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetCursorPos)>(*this, lib, "SetCursorPos",SideEffects::worstDefault, "ImGui::SetCursorPos")
	->args({"local_pos"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SliderInt4)>(*this, lib, "SliderInt4",SideEffects::worstDefault, "ImGui::SliderInt4")
	->args({"label","v","v_min","v_max","format","flags"})
		->arg_init(4,make_smart<ExprConstString>("%d"))
		->arg_type(5,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(5,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::InputScalarN)>(*this, lib, "InputScalarN",SideEffects::worstDefault, "ImGui::InputScalarN")
	->args({"label","data_type","p_data","components","p_step","p_step_fast","format","flags"})
		->arg_type(1,makeType<ImGuiDataType_>(lib))
		->arg_init(4,make_smart<ExprConstPtr>())
		->arg_init(5,make_smart<ExprConstPtr>())
		->arg_init(6,make_smart<ExprConstString>(""))
		->arg_type(7,makeType<ImGuiInputTextFlags_>(lib))
		->arg_init(7,make_smart<ExprConstEnumeration>(0,makeType<ImGuiInputTextFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetMouseDragDelta)>(*this, lib, "GetMouseDragDelta",SideEffects::worstDefault, "ImGui::GetMouseDragDelta")
	->args({"button","lock_threshold"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiMouseButton_>(lib)))
		->arg_init(1,make_smart<ExprConstFloat>(-1))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::SetNodeScreenSpacePos)>(*this, lib, "SetNodeScreenSpacePos",SideEffects::worstDefault, "imnodes::SetNodeScreenSpacePos")
	->args({"node_id","screen_space_pos"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::NumSelectedNodes)>(*this, lib, "NumSelectedNodes",SideEffects::worstDefault, "imnodes::NumSelectedNodes")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const char *, const char *),ImGui::PushID>(*this, lib, "PushID",SideEffects::worstDefault, "ImGui::PushID")
	->args({"str_id_begin","str_id_end"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BeginTable)>(*this, lib, "BeginTable",SideEffects::worstDefault, "ImGui::BeginTable")
	->args({"str_id","column","flags","outer_size","inner_width"})
		->arg_type(2,makeType<ImGuiTableFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTableFlags_>(lib)))
		->arg_init(4,make_smart<ExprConstFloat>(0))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::LoadEditorStateFromIniString)>(*this, lib, "LoadEditorStateFromIniString",SideEffects::worstDefault, "imnodes::LoadEditorStateFromIniString")
	->args({"editor","data","data_size"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetAllocatorFunctions)>(*this, lib, "GetAllocatorFunctions",SideEffects::worstDefault, "ImGui::GetAllocatorFunctions")
	->args({"p_alloc_func","p_free_func","p_user_data"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::MemFree)>(*this, lib, "MemFree",SideEffects::worstDefault, "ImGui::MemFree")
	->args({"ptr"})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::Link)>(*this, lib, "Link",SideEffects::worstDefault, "imnodes::Link")
	->args({"id","start_attribute_id","end_attribute_id"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BeginTooltip)>(*this, lib, "BeginTooltip",SideEffects::worstDefault, "ImGui::BeginTooltip")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const ImVec2 &, ImGuiCond),ImGui::SetWindowPos>(*this, lib, "SetWindowPos",SideEffects::worstDefault, "ImGui::SetWindowPos")
	->args({"pos","cond"})
		->arg_type(1,makeType<ImGuiCond_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetWindowPos)>(*this, lib, "GetWindowPos",SideEffects::worstDefault, "ImGui::GetWindowPos")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PopButtonRepeat)>(*this, lib, "PopButtonRepeat",SideEffects::worstDefault, "ImGui::PopButtonRepeat")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetNextWindowSizeConstraints)>(*this, lib, "SetNextWindowSizeConstraints",SideEffects::worstDefault, "ImGui::SetNextWindowSizeConstraints")
	->args({"size_min","size_max","custom_callback","custom_callback_data"})
		->arg_init(2,make_smart<ExprConstPtr>())
		->arg_init(3,make_smart<ExprConstPtr>())
;
#endif

#endif
#endif
}
