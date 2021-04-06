
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
void Module_imgui::initFunctions_12() {
#if USE_GENERATED
#if USE_GENERATED_SPLIT
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ColorPicker4)>(*this, lib, "ColorPicker4",SideEffects::worstDefault, "ImGui::ColorPicker4")
	->args({"label","col","flags","ref_col"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)))
		->arg_init(3,make_smart<ExprConstPtr>())
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::IsLinkHovered)>(*this, lib, "IsLinkHovered",SideEffects::worstDefault, "imnodes::IsLinkHovered")
	->args({"link_id"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::LabelTextV)>(*this, lib, "LabelTextV",SideEffects::worstDefault, "ImGui::LabelTextV")
	->args({"label","fmt","args"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::OpenPopupOnItemClick)>(*this, lib, "OpenPopupOnItemClick",SideEffects::worstDefault, "ImGui::OpenPopupOnItemClick")
	->args({"str_id","popup_flags"})
		->arg_init(0,make_smart<ExprConstString>(""))
		->arg_init(1,make_smart<ExprConstInt>(1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const void *, ImGuiTreeNodeFlags, const char *, va_list),ImGui::TreeNodeExV>(*this, lib, "TreeNodeExV",SideEffects::worstDefault, "ImGui::TreeNodeExV")
	->args({"ptr_id","flags","fmt","args"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::DragInt3)>(*this, lib, "DragInt3",SideEffects::worstDefault, "ImGui::DragInt3")
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
addExtern<DAS_BIND_FUN(ImGui::TableSetBgColor)>(*this, lib, "TableSetBgColor",SideEffects::worstDefault, "ImGui::TableSetBgColor")
	->args({"target","color","column_n"})
		->arg_type(0,makeType<ImGuiTableBgTarget_>(lib))
		->arg_init(2,make_smart<ExprConstInt>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(ImGuiCol, ImU32),ImGui::PushStyleColor>(*this, lib, "PushStyleColor",SideEffects::worstDefault, "ImGui::PushStyleColor")
	->args({"idx","col"})
		->arg_type(0,makeType<ImGuiCol_>(lib))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<bool (*)(const char *, int *, const char *const *, int, int),ImGui::ListBox>(*this, lib, "ListBox",SideEffects::worstDefault, "ImGui::ListBox")
	->args({"label","current_item","items","items_count","height_in_items"})
		->arg_init(4,make_smart<ExprConstInt>(-1))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::TableGetRowIndex)>(*this, lib, "TableGetRowIndex",SideEffects::worstDefault, "ImGui::TableGetRowIndex")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(const char *, const ImVec2 &, ImGuiCond),ImGui::SetWindowSize>(*this, lib, "SetWindowSize",SideEffects::worstDefault, "ImGui::SetWindowSize")
	->args({"name","size","cond"})
		->arg_type(2,makeType<ImGuiCond_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ProgressBar)>(*this, lib, "ProgressBar",SideEffects::worstDefault, "ImGui::ProgressBar")
	->args({"fraction","size_arg","overlay"})
		->arg_init(2,make_smart<ExprConstString>(""))
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::StyleColorsClassic)>(*this, lib, "StyleColorsClassic",SideEffects::worstDefault, "ImGui::StyleColorsClassic")
	->args({"dst"})
		->arg_init(0,make_smart<ExprConstPtr>())
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::ShowUserGuide)>(*this, lib, "ShowUserGuide",SideEffects::worstDefault, "ImGui::ShowUserGuide")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<void (*)(),ImGui::SetWindowFocus>(*this, lib, "SetWindowFocus",SideEffects::worstDefault, "ImGui::SetWindowFocus")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::PushFont)>(*this, lib, "PushFont",SideEffects::worstDefault, "ImGui::PushFont")
	->args({"font"})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::GetFontSize)>(*this, lib, "GetFontSize",SideEffects::worstDefault, "ImGui::GetFontSize")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::BeginDragDropTarget)>(*this, lib, "BeginDragDropTarget",SideEffects::worstDefault, "ImGui::BeginDragDropTarget")
	->args({})
;
#endif
#ifdef GLOBAL_NAMESPACE
addExtern<DAS_BIND_FUN(ImGui::AcceptDragDropPayload)>(*this, lib, "AcceptDragDropPayload",SideEffects::worstDefault, "ImGui::AcceptDragDropPayload")
	->args({"type","flags"})
		->arg_type(1,makeType<ImGuiDragDropFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiDragDropFlags_>(lib)))
;
#endif
#ifdef IMNODES_NAMESPACE
addExtern<DAS_BIND_FUN(imnodes::BeginOutputAttribute)>(*this, lib, "BeginOutputAttribute",SideEffects::worstDefault, "imnodes::BeginOutputAttribute")
	->args({"id","shape"})
;
#endif

#endif
#endif
}
