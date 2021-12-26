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
void Module_dasIMGUI::initFunctions_14() {
	addExtern< bool (*)(const char *,ImGuiTabItemFlags) , ImGui::TabItemButton >(*this,lib,"TabItemButton",SideEffects::worstDefault,"ImGui::TabItemButton")
		->args({"label","flags"})
		->arg_type(1,makeType<ImGuiTabItemFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTabItemFlags_>(lib)));
	addExtern< void (*)(const char *) , ImGui::SetTabItemClosed >(*this,lib,"SetTabItemClosed",SideEffects::worstDefault,"ImGui::SetTabItemClosed")
		->args({"tab_or_docked_window_label"});
	addExtern< void (*)(int) , ImGui::LogToTTY >(*this,lib,"LogToTTY",SideEffects::worstDefault,"ImGui::LogToTTY")
		->args({"auto_open_depth"})
		->arg_init(0,make_smart<ExprConstInt>(-1));
	addExtern< void (*)(int,const char *) , ImGui::LogToFile >(*this,lib,"LogToFile",SideEffects::worstDefault,"ImGui::LogToFile")
		->args({"auto_open_depth","filename"})
		->arg_init(0,make_smart<ExprConstInt>(-1))
		->arg_init(1,make_smart<ExprConstString>(""));
	addExtern< void (*)(int) , ImGui::LogToClipboard >(*this,lib,"LogToClipboard",SideEffects::worstDefault,"ImGui::LogToClipboard")
		->args({"auto_open_depth"})
		->arg_init(0,make_smart<ExprConstInt>(-1));
	addExtern< void (*)() , ImGui::LogFinish >(*this,lib,"LogFinish",SideEffects::worstDefault,"ImGui::LogFinish");
	addExtern< void (*)() , ImGui::LogButtons >(*this,lib,"LogButtons",SideEffects::worstDefault,"ImGui::LogButtons");
	addExtern< void (*)(const char *,va_list) , ImGui::LogTextV >(*this,lib,"LogTextV",SideEffects::worstDefault,"ImGui::LogTextV")
		->args({"fmt","args"});
	addExtern< bool (*)(ImGuiDragDropFlags) , ImGui::BeginDragDropSource >(*this,lib,"BeginDragDropSource",SideEffects::worstDefault,"ImGui::BeginDragDropSource")
		->args({"flags"})
		->arg_type(0,makeType<ImGuiDragDropFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiDragDropFlags_>(lib)));
	addExtern< bool (*)(const char *,const void *,size_t,ImGuiCond) , ImGui::SetDragDropPayload >(*this,lib,"SetDragDropPayload",SideEffects::worstDefault,"ImGui::SetDragDropPayload")
		->args({"type","data","sz","cond"})
		->arg_type(3,makeType<ImGuiCond_>(lib))
		->arg_init(3,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)));
	addExtern< void (*)() , ImGui::EndDragDropSource >(*this,lib,"EndDragDropSource",SideEffects::worstDefault,"ImGui::EndDragDropSource");
	addExtern< bool (*)() , ImGui::BeginDragDropTarget >(*this,lib,"BeginDragDropTarget",SideEffects::worstDefault,"ImGui::BeginDragDropTarget");
	addExtern< const ImGuiPayload * (*)(const char *,ImGuiDragDropFlags) , ImGui::AcceptDragDropPayload >(*this,lib,"AcceptDragDropPayload",SideEffects::worstDefault,"ImGui::AcceptDragDropPayload")
		->args({"type","flags"})
		->arg_type(1,makeType<ImGuiDragDropFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiDragDropFlags_>(lib)));
	addExtern< void (*)() , ImGui::EndDragDropTarget >(*this,lib,"EndDragDropTarget",SideEffects::worstDefault,"ImGui::EndDragDropTarget");
	addExtern< const ImGuiPayload * (*)() , ImGui::GetDragDropPayload >(*this,lib,"GetDragDropPayload",SideEffects::worstDefault,"ImGui::GetDragDropPayload");
	addExtern< void (*)(const ImVec2 &,const ImVec2 &,bool) , ImGui::PushClipRect >(*this,lib,"PushClipRect",SideEffects::worstDefault,"ImGui::PushClipRect")
		->args({"clip_rect_min","clip_rect_max","intersect_with_current_clip_rect"});
	addExtern< void (*)() , ImGui::PopClipRect >(*this,lib,"PopClipRect",SideEffects::worstDefault,"ImGui::PopClipRect");
	addExtern< void (*)() , ImGui::SetItemDefaultFocus >(*this,lib,"SetItemDefaultFocus",SideEffects::worstDefault,"ImGui::SetItemDefaultFocus");
	addExtern< void (*)(int) , ImGui::SetKeyboardFocusHere >(*this,lib,"SetKeyboardFocusHere",SideEffects::worstDefault,"ImGui::SetKeyboardFocusHere")
		->args({"offset"})
		->arg_init(0,make_smart<ExprConstInt>(0));
	addExtern< bool (*)(ImGuiHoveredFlags) , ImGui::IsItemHovered >(*this,lib,"IsItemHovered",SideEffects::worstDefault,"ImGui::IsItemHovered")
		->args({"flags"})
		->arg_type(0,makeType<ImGuiHoveredFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiHoveredFlags_>(lib)));
}
}

