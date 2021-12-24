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
void Module_dasIMGUI::initFunctions_10() {
	addExtern<bool (*)(const char *,int,void *,int,const void *,const void *,const char *,int),ImGui::InputScalarN>(*this,lib,"InputScalarN",SideEffects::worstDefault,"ImGui::InputScalarN")
		->args({"label","data_type","p_data","components","p_step","p_step_fast","format","flags"})
		->arg_type(1,makeType<ImGuiDataType_>(lib))
		->arg_init(4,make_smart<ExprConstPtr>())
		->arg_init(5,make_smart<ExprConstPtr>())
		->arg_init(6,make_smart<ExprConstString>(""))
		->arg_type(7,makeType<ImGuiInputTextFlags_>(lib))
		->arg_init(7,make_smart<ExprConstEnumeration>(0,makeType<ImGuiInputTextFlags_>(lib)));
	addExtern<bool (*)(const char *,float [3],int),ImGui::ColorEdit3>(*this,lib,"ColorEdit3",SideEffects::worstDefault,"ImGui::ColorEdit3")
		->args({"label","col","flags"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)));
	addExtern<bool (*)(const char *,float [4],int),ImGui::ColorEdit4>(*this,lib,"ColorEdit4",SideEffects::worstDefault,"ImGui::ColorEdit4")
		->args({"label","col","flags"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)));
	addExtern<bool (*)(const char *,float [3],int),ImGui::ColorPicker3>(*this,lib,"ColorPicker3",SideEffects::worstDefault,"ImGui::ColorPicker3")
		->args({"label","col","flags"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)));
	addExtern<bool (*)(const char *,float [4],int,const float *),ImGui::ColorPicker4>(*this,lib,"ColorPicker4",SideEffects::worstDefault,"ImGui::ColorPicker4")
		->args({"label","col","flags","ref_col"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)))
		->arg_init(3,make_smart<ExprConstPtr>());
	addExtern<bool (*)(const char *,const ImVec4 &,int,ImVec2),ImGui::ColorButton>(*this,lib,"ColorButton",SideEffects::worstDefault,"ImGui::ColorButton")
		->args({"desc_id","col","flags","size"})
		->arg_type(2,makeType<ImGuiColorEditFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiColorEditFlags_>(lib)));
	addExtern<void (*)(int),ImGui::SetColorEditOptions>(*this,lib,"SetColorEditOptions",SideEffects::worstDefault,"ImGui::SetColorEditOptions")
		->args({"flags"})
		->arg_type(0,makeType<ImGuiColorEditFlags_>(lib));
	addExtern<bool (*)(const char *),ImGui::TreeNode>(*this,lib,"TreeNode",SideEffects::worstDefault,"ImGui::TreeNode")
		->args({"label"});
	addExtern<bool (*)(const char *,const char *,char *),ImGui::TreeNodeV>(*this,lib,"TreeNodeV",SideEffects::worstDefault,"ImGui::TreeNodeV")
		->args({"str_id","fmt","args"});
	addExtern<bool (*)(const void *,const char *,char *),ImGui::TreeNodeV>(*this,lib,"TreeNodeV",SideEffects::worstDefault,"ImGui::TreeNodeV")
		->args({"ptr_id","fmt","args"});
	addExtern<bool (*)(const char *,int),ImGui::TreeNodeEx>(*this,lib,"TreeNodeEx",SideEffects::worstDefault,"ImGui::TreeNodeEx")
		->args({"label","flags"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTreeNodeFlags_>(lib)));
	addExtern<bool (*)(const char *,int,const char *,char *),ImGui::TreeNodeExV>(*this,lib,"TreeNodeExV",SideEffects::worstDefault,"ImGui::TreeNodeExV")
		->args({"str_id","flags","fmt","args"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib));
	addExtern<bool (*)(const void *,int,const char *,char *),ImGui::TreeNodeExV>(*this,lib,"TreeNodeExV",SideEffects::worstDefault,"ImGui::TreeNodeExV")
		->args({"ptr_id","flags","fmt","args"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib));
	addExtern<void (*)(const char *),ImGui::TreePush>(*this,lib,"TreePush",SideEffects::worstDefault,"ImGui::TreePush")
		->args({"str_id"});
	addExtern<void (*)(const void *),ImGui::TreePush>(*this,lib,"TreePush",SideEffects::worstDefault,"ImGui::TreePush")
		->args({"ptr_id"})
		->arg_init(0,make_smart<ExprConstPtr>());
	addExtern<void (*)(),ImGui::TreePop>(*this,lib,"TreePop",SideEffects::worstDefault,"ImGui::TreePop");
	addExtern<float (*)(),ImGui::GetTreeNodeToLabelSpacing>(*this,lib,"GetTreeNodeToLabelSpacing",SideEffects::worstDefault,"ImGui::GetTreeNodeToLabelSpacing");
	addExtern<bool (*)(const char *,int),ImGui::CollapsingHeader>(*this,lib,"CollapsingHeader",SideEffects::worstDefault,"ImGui::CollapsingHeader")
		->args({"label","flags"})
		->arg_type(1,makeType<ImGuiTreeNodeFlags_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTreeNodeFlags_>(lib)));
	addExtern<bool (*)(const char *,bool *,int),ImGui::CollapsingHeader>(*this,lib,"CollapsingHeader",SideEffects::worstDefault,"ImGui::CollapsingHeader")
		->args({"label","p_visible","flags"})
		->arg_type(2,makeType<ImGuiTreeNodeFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiTreeNodeFlags_>(lib)));
	addExtern<void (*)(bool,int),ImGui::SetNextItemOpen>(*this,lib,"SetNextItemOpen",SideEffects::worstDefault,"ImGui::SetNextItemOpen")
		->args({"is_open","cond"})
		->arg_type(1,makeType<ImGuiCond_>(lib))
		->arg_init(1,make_smart<ExprConstEnumeration>(0,makeType<ImGuiCond_>(lib)));
}
}

