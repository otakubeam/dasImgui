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
void Module_dasIMGUI::initFunctions_12() {
	addExtern< void (*)() , ImGui::EndTooltip >(*this,lib,"EndTooltip",SideEffects::worstDefault,"ImGui::EndTooltip");
	addExtern< void (*)(const char *,va_list) , ImGui::SetTooltipV >(*this,lib,"SetTooltipV",SideEffects::worstDefault,"ImGui::SetTooltipV")
		->args({"fmt","args"});
	addExtern< bool (*)(const char *,ImGuiWindowFlags) , ImGui::BeginPopup >(*this,lib,"BeginPopup",SideEffects::worstDefault,"ImGui::BeginPopup")
		->args({"str_id","flags"})
		->arg_type(1,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)));
	addExtern< bool (*)(const char *,bool *,ImGuiWindowFlags) , ImGui::BeginPopupModal >(*this,lib,"BeginPopupModal",SideEffects::worstDefault,"ImGui::BeginPopupModal")
		->args({"name","p_open","flags"})
		->arg_init(1,make_smart<ExprConstPtr>())
		->arg_type(2,makeType<ImGuiWindowFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiWindowFlags_>(lib)));
	addExtern< void (*)() , ImGui::EndPopup >(*this,lib,"EndPopup",SideEffects::worstDefault,"ImGui::EndPopup");
	addExtern< void (*)(const char *,ImGuiPopupFlags) , ImGui::OpenPopup >(*this,lib,"OpenPopup",SideEffects::worstDefault,"ImGui::OpenPopup")
		->args({"str_id","popup_flags"})
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< void (*)(const char *,ImGuiPopupFlags) , ImGui::OpenPopupOnItemClick >(*this,lib,"OpenPopupOnItemClick",SideEffects::worstDefault,"ImGui::OpenPopupOnItemClick")
		->args({"str_id","popup_flags"})
		->arg_init(0,make_smart<ExprConstString>(""))
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< void (*)() , ImGui::CloseCurrentPopup >(*this,lib,"CloseCurrentPopup",SideEffects::worstDefault,"ImGui::CloseCurrentPopup");
	addExtern< bool (*)(const char *,ImGuiPopupFlags) , ImGui::BeginPopupContextItem >(*this,lib,"BeginPopupContextItem",SideEffects::worstDefault,"ImGui::BeginPopupContextItem")
		->args({"str_id","popup_flags"})
		->arg_init(0,make_smart<ExprConstString>(""))
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< bool (*)(const char *,ImGuiPopupFlags) , ImGui::BeginPopupContextWindow >(*this,lib,"BeginPopupContextWindow",SideEffects::worstDefault,"ImGui::BeginPopupContextWindow")
		->args({"str_id","popup_flags"})
		->arg_init(0,make_smart<ExprConstString>(""))
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< bool (*)(const char *,ImGuiPopupFlags) , ImGui::BeginPopupContextVoid >(*this,lib,"BeginPopupContextVoid",SideEffects::worstDefault,"ImGui::BeginPopupContextVoid")
		->args({"str_id","popup_flags"})
		->arg_init(0,make_smart<ExprConstString>(""))
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< bool (*)(const char *,ImGuiPopupFlags) , ImGui::IsPopupOpen >(*this,lib,"IsPopupOpen",SideEffects::worstDefault,"ImGui::IsPopupOpen")
		->args({"str_id","flags"})
		->arg_type(1,makeType<ImGuiPopupFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiPopupFlags_>(lib)));
	addExtern< bool (*)(const char *,int,ImGuiTableFlags,const ImVec2 &,float) , ImGui::BeginTable >(*this,lib,"BeginTable",SideEffects::worstDefault,"ImGui::BeginTable")
		->args({"str_id","column","flags","outer_size","inner_width"})
		->arg_type(2,makeType<ImGuiTableFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTableFlags_>(lib)))
		->arg_init(4,make_smart<ExprConstFloat>(0.00000000000000000));
	addExtern< void (*)() , ImGui::EndTable >(*this,lib,"EndTable",SideEffects::worstDefault,"ImGui::EndTable");
	addExtern< void (*)(ImGuiTableRowFlags,float) , ImGui::TableNextRow >(*this,lib,"TableNextRow",SideEffects::worstDefault,"ImGui::TableNextRow")
		->args({"row_flags","min_row_height"})
		->arg_type(0,makeType<ImGuiTableRowFlags_>(lib))
		->arg_init(0,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTableRowFlags_>(lib)))
		->arg_init(1,make_smart<ExprConstFloat>(0.00000000000000000));
	addExtern< bool (*)() , ImGui::TableNextColumn >(*this,lib,"TableNextColumn",SideEffects::worstDefault,"ImGui::TableNextColumn");
	addExtern< bool (*)(int) , ImGui::TableSetColumnIndex >(*this,lib,"TableSetColumnIndex",SideEffects::worstDefault,"ImGui::TableSetColumnIndex")
		->args({"column_n"});
	addExtern< void (*)(const char *,ImGuiTableColumnFlags,float,ImGuiID) , ImGui::TableSetupColumn >(*this,lib,"TableSetupColumn",SideEffects::worstDefault,"ImGui::TableSetupColumn")
		->args({"label","flags","init_width_or_weight","user_id"})
		->arg_type(1,makeType<ImGuiTableColumnFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTableColumnFlags_>(lib)))
		->arg_init(2,make_smart<ExprConstFloat>(0.00000000000000000))
		->arg_init(3,make_smart<ExprConstUInt>(0x0));
	addExtern< void (*)(int,int) , ImGui::TableSetupScrollFreeze >(*this,lib,"TableSetupScrollFreeze",SideEffects::worstDefault,"ImGui::TableSetupScrollFreeze")
		->args({"cols","rows"});
	addExtern< void (*)() , ImGui::TableHeadersRow >(*this,lib,"TableHeadersRow",SideEffects::worstDefault,"ImGui::TableHeadersRow");
}
}

