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
void Module_dasIMGUI::initFunctions_13() {
	addExtern<void (*)(const char *),ImGui::TableHeader>(*this,lib,"TableHeader",SideEffects::worstDefault,"ImGui::TableHeader")
		->args({"label"});
	addExtern<ImGuiTableSortSpecs * (*)(),ImGui::TableGetSortSpecs>(*this,lib,"TableGetSortSpecs",SideEffects::worstDefault,"ImGui::TableGetSortSpecs");
	addExtern<int (*)(),ImGui::TableGetColumnCount>(*this,lib,"TableGetColumnCount",SideEffects::worstDefault,"ImGui::TableGetColumnCount");
	addExtern<int (*)(),ImGui::TableGetColumnIndex>(*this,lib,"TableGetColumnIndex",SideEffects::worstDefault,"ImGui::TableGetColumnIndex");
	addExtern<int (*)(),ImGui::TableGetRowIndex>(*this,lib,"TableGetRowIndex",SideEffects::worstDefault,"ImGui::TableGetRowIndex");
	addExtern<const char * (*)(int),ImGui::TableGetColumnName>(*this,lib,"TableGetColumnName",SideEffects::worstDefault,"ImGui::TableGetColumnName")
		->args({"column_n"})
		->arg_init(0,make_smart<ExprConstInt>(-1));
	addExtern<int (*)(int),ImGui::TableGetColumnFlags>(*this,lib,"TableGetColumnFlags",SideEffects::worstDefault,"ImGui::TableGetColumnFlags")
		->args({"column_n"})
		->arg_init(0,make_smart<ExprConstInt>(-1))
		->res_type(makeType<ImGuiTableColumnFlags_>(lib));
	addExtern<void (*)(int,unsigned int,int),ImGui::TableSetBgColor>(*this,lib,"TableSetBgColor",SideEffects::worstDefault,"ImGui::TableSetBgColor")
		->args({"target","color","column_n"})
		->arg_type(0,makeType<ImGuiTableBgTarget_>(lib))
		->arg_init(2,make_smart<ExprConstInt>(-1));
	addExtern<void (*)(int,const char *,bool),ImGui::Columns>(*this,lib,"Columns",SideEffects::worstDefault,"ImGui::Columns")
		->args({"count","id","border"})
		->arg_init(0,make_smart<ExprConstInt>(1))
		->arg_init(1,make_smart<ExprConstString>(""))
		->arg_init(2,make_smart<ExprConstBool>(true));
	addExtern<void (*)(),ImGui::NextColumn>(*this,lib,"NextColumn",SideEffects::worstDefault,"ImGui::NextColumn");
	addExtern<int (*)(),ImGui::GetColumnIndex>(*this,lib,"GetColumnIndex",SideEffects::worstDefault,"ImGui::GetColumnIndex");
	addExtern<float (*)(int),ImGui::GetColumnWidth>(*this,lib,"GetColumnWidth",SideEffects::worstDefault,"ImGui::GetColumnWidth")
		->args({"column_index"})
		->arg_init(0,make_smart<ExprConstInt>(-1));
	addExtern<void (*)(int,float),ImGui::SetColumnWidth>(*this,lib,"SetColumnWidth",SideEffects::worstDefault,"ImGui::SetColumnWidth")
		->args({"column_index","width"});
	addExtern<float (*)(int),ImGui::GetColumnOffset>(*this,lib,"GetColumnOffset",SideEffects::worstDefault,"ImGui::GetColumnOffset")
		->args({"column_index"})
		->arg_init(0,make_smart<ExprConstInt>(-1));
	addExtern<void (*)(int,float),ImGui::SetColumnOffset>(*this,lib,"SetColumnOffset",SideEffects::worstDefault,"ImGui::SetColumnOffset")
		->args({"column_index","offset_x"});
	addExtern<int (*)(),ImGui::GetColumnsCount>(*this,lib,"GetColumnsCount",SideEffects::worstDefault,"ImGui::GetColumnsCount");
	addExtern<bool (*)(const char *,int),ImGui::BeginTabBar>(*this,lib,"BeginTabBar",SideEffects::worstDefault,"ImGui::BeginTabBar")
		->args({"str_id","flags"})
		->arg_type(1,makeType<ImGuiTabBarFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTabBarFlags_>(lib)));
	addExtern<void (*)(),ImGui::EndTabBar>(*this,lib,"EndTabBar",SideEffects::worstDefault,"ImGui::EndTabBar");
	addExtern<bool (*)(const char *,bool *,int),ImGui::BeginTabItem>(*this,lib,"BeginTabItem",SideEffects::worstDefault,"ImGui::BeginTabItem")
		->args({"label","p_open","flags"})
		->arg_init(1,make_smart<ExprConstPtr>())
		->arg_type(2,makeType<ImGuiTabItemFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTabItemFlags_>(lib)));
	addExtern<void (*)(),ImGui::EndTabItem>(*this,lib,"EndTabItem",SideEffects::worstDefault,"ImGui::EndTabItem");
}
}

