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
void Module_dasIMGUI::initFunctions_15() {
	addExtern< bool (*)() , ImGui::IsItemActive >(*this,lib,"IsItemActive",SideEffects::worstDefault,"ImGui::IsItemActive");
	addExtern< bool (*)() , ImGui::IsItemFocused >(*this,lib,"IsItemFocused",SideEffects::worstDefault,"ImGui::IsItemFocused");
	addExtern< bool (*)(ImGuiMouseButton) , ImGui::IsItemClicked >(*this,lib,"IsItemClicked",SideEffects::worstDefault,"ImGui::IsItemClicked")
		->args({"mouse_button"})
		->arg_type(0,makeType<ImGuiMouseButton_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiMouseButton_>(lib)));
	addExtern< bool (*)() , ImGui::IsItemVisible >(*this,lib,"IsItemVisible",SideEffects::worstDefault,"ImGui::IsItemVisible");
	addExtern< bool (*)() , ImGui::IsItemEdited >(*this,lib,"IsItemEdited",SideEffects::worstDefault,"ImGui::IsItemEdited");
	addExtern< bool (*)() , ImGui::IsItemActivated >(*this,lib,"IsItemActivated",SideEffects::worstDefault,"ImGui::IsItemActivated");
	addExtern< bool (*)() , ImGui::IsItemDeactivated >(*this,lib,"IsItemDeactivated",SideEffects::worstDefault,"ImGui::IsItemDeactivated");
	addExtern< bool (*)() , ImGui::IsItemDeactivatedAfterEdit >(*this,lib,"IsItemDeactivatedAfterEdit",SideEffects::worstDefault,"ImGui::IsItemDeactivatedAfterEdit");
	addExtern< bool (*)() , ImGui::IsItemToggledOpen >(*this,lib,"IsItemToggledOpen",SideEffects::worstDefault,"ImGui::IsItemToggledOpen");
	addExtern< bool (*)() , ImGui::IsAnyItemHovered >(*this,lib,"IsAnyItemHovered",SideEffects::worstDefault,"ImGui::IsAnyItemHovered");
	addExtern< bool (*)() , ImGui::IsAnyItemActive >(*this,lib,"IsAnyItemActive",SideEffects::worstDefault,"ImGui::IsAnyItemActive");
	addExtern< bool (*)() , ImGui::IsAnyItemFocused >(*this,lib,"IsAnyItemFocused",SideEffects::worstDefault,"ImGui::IsAnyItemFocused");
	addExtern< ImVec2 (*)() , ImGui::GetItemRectMin >(*this,lib,"GetItemRectMin",SideEffects::worstDefault,"ImGui::GetItemRectMin");
	addExtern< ImVec2 (*)() , ImGui::GetItemRectMax >(*this,lib,"GetItemRectMax",SideEffects::worstDefault,"ImGui::GetItemRectMax");
	addExtern< ImVec2 (*)() , ImGui::GetItemRectSize >(*this,lib,"GetItemRectSize",SideEffects::worstDefault,"ImGui::GetItemRectSize");
	addExtern< void (*)() , ImGui::SetItemAllowOverlap >(*this,lib,"SetItemAllowOverlap",SideEffects::worstDefault,"ImGui::SetItemAllowOverlap");
	addExtern< ImGuiViewport * (*)() , ImGui::GetMainViewport >(*this,lib,"GetMainViewport",SideEffects::worstDefault,"ImGui::GetMainViewport");
	addExtern< bool (*)(const ImVec2 &) , ImGui::IsRectVisible >(*this,lib,"IsRectVisible",SideEffects::worstDefault,"ImGui::IsRectVisible")
		->args({"size"});
	addExtern< bool (*)(const ImVec2 &,const ImVec2 &) , ImGui::IsRectVisible >(*this,lib,"IsRectVisible",SideEffects::worstDefault,"ImGui::IsRectVisible")
		->args({"rect_min","rect_max"});
	addExtern< double (*)() , ImGui::GetTime >(*this,lib,"GetTime",SideEffects::worstDefault,"ImGui::GetTime");
}
}

