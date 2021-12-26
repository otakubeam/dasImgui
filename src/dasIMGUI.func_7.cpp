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
void Module_dasIMGUI::initFunctions_7() {
	addExtern< ImGuiID (*)(const void *) , ImGui::GetID >(*this,lib,"GetID",SideEffects::worstDefault,"ImGui::GetID")
		->args({"ptr_id"});
	addExtern< void (*)(const char *,va_list) , ImGui::TextV >(*this,lib,"TextV",SideEffects::worstDefault,"ImGui::TextV")
		->args({"fmt","args"});
	addExtern< void (*)(const ImVec4 &,const char *,va_list) , ImGui::TextColoredV >(*this,lib,"TextColoredV",SideEffects::worstDefault,"ImGui::TextColoredV")
		->args({"col","fmt","args"});
	addExtern< void (*)(const char *,va_list) , ImGui::TextDisabledV >(*this,lib,"TextDisabledV",SideEffects::worstDefault,"ImGui::TextDisabledV")
		->args({"fmt","args"});
	addExtern< void (*)(const char *,va_list) , ImGui::TextWrappedV >(*this,lib,"TextWrappedV",SideEffects::worstDefault,"ImGui::TextWrappedV")
		->args({"fmt","args"});
	addExtern< void (*)(const char *,const char *,va_list) , ImGui::LabelTextV >(*this,lib,"LabelTextV",SideEffects::worstDefault,"ImGui::LabelTextV")
		->args({"label","fmt","args"});
	addExtern< void (*)(const char *,va_list) , ImGui::BulletTextV >(*this,lib,"BulletTextV",SideEffects::worstDefault,"ImGui::BulletTextV")
		->args({"fmt","args"});
	addExtern< bool (*)(const char *,const ImVec2 &) , ImGui::Button >(*this,lib,"Button",SideEffects::worstDefault,"ImGui::Button")
		->args({"label","size"});
	addExtern< bool (*)(const char *) , ImGui::SmallButton >(*this,lib,"SmallButton",SideEffects::worstDefault,"ImGui::SmallButton")
		->args({"label"});
	addExtern< bool (*)(const char *,const ImVec2 &,ImGuiButtonFlags) , ImGui::InvisibleButton >(*this,lib,"InvisibleButton",SideEffects::worstDefault,"ImGui::InvisibleButton")
		->args({"str_id","size","flags"})
		->arg_type(2,makeType<ImGuiButtonFlags_>(lib))
		->arg_init(2,make_smart<ExprConstEnumeration>(0,makeType<ImGuiButtonFlags_>(lib)));
	addExtern< bool (*)(const char *,ImGuiDir) , ImGui::ArrowButton >(*this,lib,"ArrowButton",SideEffects::worstDefault,"ImGui::ArrowButton")
		->args({"str_id","dir"})
		->arg_type(1,makeType<ImGuiDir_>(lib));
	addExtern< void (*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,const ImVec4 &,const ImVec4 &) , ImGui::Image >(*this,lib,"Image",SideEffects::worstDefault,"ImGui::Image")
		->args({"user_texture_id","size","uv0","uv1","tint_col","border_col"});
	addExtern< bool (*)(ImTextureID,const ImVec2 &,const ImVec2 &,const ImVec2 &,int,const ImVec4 &,const ImVec4 &) , ImGui::ImageButton >(*this,lib,"ImageButton",SideEffects::worstDefault,"ImGui::ImageButton")
		->args({"user_texture_id","size","uv0","uv1","frame_padding","bg_col","tint_col"})
		->arg_init(4,make_smart<ExprConstInt>(-1));
	addExtern< bool (*)(const char *,bool *) , ImGui::Checkbox >(*this,lib,"Checkbox",SideEffects::worstDefault,"ImGui::Checkbox")
		->args({"label","v"});
	addExtern< bool (*)(const char *,int *,int) , ImGui::CheckboxFlags >(*this,lib,"CheckboxFlags",SideEffects::worstDefault,"ImGui::CheckboxFlags")
		->args({"label","flags","flags_value"});
	addExtern< bool (*)(const char *,unsigned int *,unsigned int) , ImGui::CheckboxFlags >(*this,lib,"CheckboxFlags",SideEffects::worstDefault,"ImGui::CheckboxFlags")
		->args({"label","flags","flags_value"});
	addExtern< bool (*)(const char *,bool) , ImGui::RadioButton >(*this,lib,"RadioButton",SideEffects::worstDefault,"ImGui::RadioButton")
		->args({"label","active"});
	addExtern< bool (*)(const char *,int *,int) , ImGui::RadioButton >(*this,lib,"RadioButton",SideEffects::worstDefault,"ImGui::RadioButton")
		->args({"label","v","v_button"});
	addExtern< void (*)(float,const ImVec2 &,const char *) , ImGui::ProgressBar >(*this,lib,"ProgressBar",SideEffects::worstDefault,"ImGui::ProgressBar")
		->args({"fraction","size_arg","overlay"})
		->arg_init(2,make_smart<ExprConstString>(""));
	addExtern< void (*)() , ImGui::Bullet >(*this,lib,"Bullet",SideEffects::worstDefault,"ImGui::Bullet");
}
}

