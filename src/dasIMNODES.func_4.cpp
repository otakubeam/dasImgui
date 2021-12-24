// this file is generated via daScript automatic C++ binder
// all user modifications will be lost after this file is re-generated

#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMNODES.h"
#include "need_dasIMNODES.h"
namespace das {
void Module_dasIMNODES::initFunctions_4() {
	addExtern<const char * (*)(unsigned long long *),imnodes::SaveCurrentEditorStateToIniString>(*this,lib,"SaveCurrentEditorStateToIniString",SideEffects::worstDefault,"imnodes::SaveCurrentEditorStateToIniString")
		->args({"data_size"})
		->arg_init(0,make_smart<ExprConstPtr>());
	addExtern<const char * (*)(const imnodes::EditorContext *,unsigned long long *),imnodes::SaveEditorStateToIniString>(*this,lib,"SaveEditorStateToIniString",SideEffects::worstDefault,"imnodes::SaveEditorStateToIniString")
		->args({"editor","data_size"})
		->arg_init(1,make_smart<ExprConstPtr>());
	addExtern<void (*)(const char *,unsigned long long),imnodes::LoadCurrentEditorStateFromIniString>(*this,lib,"LoadCurrentEditorStateFromIniString",SideEffects::worstDefault,"imnodes::LoadCurrentEditorStateFromIniString")
		->args({"data","data_size"});
	addExtern<void (*)(imnodes::EditorContext *,const char *,unsigned long long),imnodes::LoadEditorStateFromIniString>(*this,lib,"LoadEditorStateFromIniString",SideEffects::worstDefault,"imnodes::LoadEditorStateFromIniString")
		->args({"editor","data","data_size"});
	addExtern<void (*)(const char *),imnodes::SaveCurrentEditorStateToIniFile>(*this,lib,"SaveCurrentEditorStateToIniFile",SideEffects::worstDefault,"imnodes::SaveCurrentEditorStateToIniFile")
		->args({"file_name"});
	addExtern<void (*)(const imnodes::EditorContext *,const char *),imnodes::SaveEditorStateToIniFile>(*this,lib,"SaveEditorStateToIniFile",SideEffects::worstDefault,"imnodes::SaveEditorStateToIniFile")
		->args({"editor","file_name"});
	addExtern<void (*)(const char *),imnodes::LoadCurrentEditorStateFromIniFile>(*this,lib,"LoadCurrentEditorStateFromIniFile",SideEffects::worstDefault,"imnodes::LoadCurrentEditorStateFromIniFile")
		->args({"file_name"});
	addExtern<void (*)(imnodes::EditorContext *,const char *),imnodes::LoadEditorStateFromIniFile>(*this,lib,"LoadEditorStateFromIniFile",SideEffects::worstDefault,"imnodes::LoadEditorStateFromIniFile")
		->args({"editor","file_name"});
}
}

