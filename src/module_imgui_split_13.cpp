
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
void Module_imgui::initFunctions_13() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetWindowWidth)>(*this, lib, "GetWindowWidth",SideEffects::worstDefault, "ImGui::GetWindowWidth")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::DragIntRange2)>(*this, lib, "DragIntRange2",SideEffects::worstDefault, "ImGui::DragIntRange2")
	->args({"label","v_current_min","v_current_max","v_speed","v_min","v_max","format","format_max","flags"})
		->arg_init(3,make_smart<ExprConstFloat>(1))
		->arg_init(4,make_smart<ExprConstInt>(0))
		->arg_init(5,make_smart<ExprConstInt>(0))
		->arg_init(6,make_smart<ExprConstString>("%d"))
		->arg_init(7,make_smart<ExprConstString>(""))
		->arg_type(8,makeType<ImGuiSliderFlags_>(lib))
		->arg_init(8,make_smart<ExprConstEnumeration>(0,makeType<ImGuiSliderFlags_>(lib)))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::SetImGuiContext)>(*this, lib, "SetImGuiContext",SideEffects::worstDefault, "imnodes::SetImGuiContext")
	->args({"ctx"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetTextLineHeight)>(*this, lib, "GetTextLineHeight",SideEffects::worstDefault, "ImGui::GetTextLineHeight")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetItemAllowOverlap)>(*this, lib, "SetItemAllowOverlap",SideEffects::worstDefault, "ImGui::SetItemAllowOverlap")
	->args({})
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::EditorContextGetPanning)>(*this, lib, "EditorContextGetPanning",SideEffects::worstDefault, "imnodes::EditorContextGetPanning")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetDrawData)>(*this, lib, "GetDrawData",SideEffects::worstDefault, "ImGui::GetDrawData")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetWindowContentRegionMin)>(*this, lib, "GetWindowContentRegionMin",SideEffects::worstDefault, "ImGui::GetWindowContentRegionMin")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::IsWindowAppearing)>(*this, lib, "IsWindowAppearing",SideEffects::worstDefault, "ImGui::IsWindowAppearing")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::SetNextWindowBgAlpha)>(*this, lib, "SetNextWindowBgAlpha",SideEffects::worstDefault, "ImGui::SetNextWindowBgAlpha")
	->args({"alpha"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetScrollY)>(*this, lib, "GetScrollY",SideEffects::worstDefault, "ImGui::GetScrollY")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PopAllowKeyboardFocus)>(*this, lib, "PopAllowKeyboardFocus",SideEffects::worstDefault, "ImGui::PopAllowKeyboardFocus")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetTextLineHeightWithSpacing)>(*this, lib, "GetTextLineHeightWithSpacing",SideEffects::worstDefault, "ImGui::GetTextLineHeightWithSpacing")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::Begin)>(*this, lib, "Begin",SideEffects::worstDefault, "ImGui::Begin")
	->args({"name","p_open","flags"})
		->arg_init(1,make_smart<ExprConstPtr>())
		->arg_type(2,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const char *, float, const char *),ImGui::Value>(*this, lib, "Value",SideEffects::worstDefault, "ImGui::Value")
	->args({"prefix","v","float_format"})
		->arg_init(2,make_smart<ExprConstString>(""))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetCurrentContext)>(*this, lib, "GetCurrentContext",SideEffects::worstDefault, "ImGui::GetCurrentContext")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *),ImGui::TreeNode>(*this, lib, "TreeNode",SideEffects::worstDefault, "ImGui::TreeNode")
	->args({"label"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetColumnWidth)>(*this, lib, "GetColumnWidth",SideEffects::worstDefault, "ImGui::GetColumnWidth")
	->args({"column_index"})
		->arg_init(0,make_smart<ExprConstInt>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::LogToClipboard)>(*this, lib, "LogToClipboard",SideEffects::worstDefault, "ImGui::LogToClipboard")
	->args({"auto_open_depth"})
		->arg_init(0,make_smart<ExprConstInt>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::LogFinish)>(*this, lib, "LogFinish",SideEffects::worstDefault, "ImGui::LogFinish")
	->args({})
;
#endif

#endif
#endif
}
