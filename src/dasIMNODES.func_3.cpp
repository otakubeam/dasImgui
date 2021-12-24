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
void Module_dasIMNODES::initFunctions_3() {
	addExtern<ImVec2 (*)(const int),imnodes::GetNodeScreenSpacePos>(*this,lib,"GetNodeScreenSpacePos",SideEffects::worstDefault,"imnodes::GetNodeScreenSpacePos")
		->args({"node_id"});
	addExtern<ImVec2 (*)(const int),imnodes::GetNodeEditorSpacePos>(*this,lib,"GetNodeEditorSpacePos",SideEffects::worstDefault,"imnodes::GetNodeEditorSpacePos")
		->args({"node_id"});
	addExtern<ImVec2 (*)(const int),imnodes::GetNodeGridSpacePos>(*this,lib,"GetNodeGridSpacePos",SideEffects::worstDefault,"imnodes::GetNodeGridSpacePos")
		->args({"node_id"});
	addExtern<bool (*)(),imnodes::IsEditorHovered>(*this,lib,"IsEditorHovered",SideEffects::worstDefault,"imnodes::IsEditorHovered");
	addExtern<bool (*)(int *),imnodes::IsNodeHovered>(*this,lib,"IsNodeHovered",SideEffects::worstDefault,"imnodes::IsNodeHovered")
		->args({"node_id"});
	addExtern<bool (*)(int *),imnodes::IsLinkHovered>(*this,lib,"IsLinkHovered",SideEffects::worstDefault,"imnodes::IsLinkHovered")
		->args({"link_id"});
	addExtern<bool (*)(int *),imnodes::IsPinHovered>(*this,lib,"IsPinHovered",SideEffects::worstDefault,"imnodes::IsPinHovered")
		->args({"attribute_id"});
	addExtern<int (*)(),imnodes::NumSelectedNodes>(*this,lib,"NumSelectedNodes",SideEffects::worstDefault,"imnodes::NumSelectedNodes");
	addExtern<int (*)(),imnodes::NumSelectedLinks>(*this,lib,"NumSelectedLinks",SideEffects::worstDefault,"imnodes::NumSelectedLinks");
	addExtern<void (*)(int *),imnodes::GetSelectedNodes>(*this,lib,"GetSelectedNodes",SideEffects::worstDefault,"imnodes::GetSelectedNodes")
		->args({"node_ids"});
	addExtern<void (*)(int *),imnodes::GetSelectedLinks>(*this,lib,"GetSelectedLinks",SideEffects::worstDefault,"imnodes::GetSelectedLinks")
		->args({"link_ids"});
	addExtern<void (*)(),imnodes::ClearNodeSelection>(*this,lib,"ClearNodeSelection",SideEffects::worstDefault,"imnodes::ClearNodeSelection");
	addExtern<void (*)(),imnodes::ClearLinkSelection>(*this,lib,"ClearLinkSelection",SideEffects::worstDefault,"imnodes::ClearLinkSelection");
	addExtern<bool (*)(),imnodes::IsAttributeActive>(*this,lib,"IsAttributeActive",SideEffects::worstDefault,"imnodes::IsAttributeActive");
	addExtern<bool (*)(int *),imnodes::IsAnyAttributeActive>(*this,lib,"IsAnyAttributeActive",SideEffects::worstDefault,"imnodes::IsAnyAttributeActive")
		->args({"attribute_id"})
		->arg_init(0,make_smart<ExprConstPtr>());
	addExtern<bool (*)(int *),imnodes::IsLinkStarted>(*this,lib,"IsLinkStarted",SideEffects::worstDefault,"imnodes::IsLinkStarted")
		->args({"started_at_attribute_id"});
	addExtern<bool (*)(int *,bool),imnodes::IsLinkDropped>(*this,lib,"IsLinkDropped",SideEffects::worstDefault,"imnodes::IsLinkDropped")
		->args({"started_at_attribute_id","including_detached_links"})
		->arg_init(0,make_smart<ExprConstPtr>())
		->arg_init(1,make_smart<ExprConstBool>(true));
	addExtern<bool (*)(int *,int *,bool *),imnodes::IsLinkCreated>(*this,lib,"IsLinkCreated",SideEffects::worstDefault,"imnodes::IsLinkCreated")
		->args({"started_at_attribute_id","ended_at_attribute_id","created_from_snap"})
		->arg_init(2,make_smart<ExprConstPtr>());
	addExtern<bool (*)(int *,int *,int *,int *,bool *),imnodes::IsLinkCreated>(*this,lib,"IsLinkCreated",SideEffects::worstDefault,"imnodes::IsLinkCreated")
		->args({"started_at_node_id","started_at_attribute_id","ended_at_node_id","ended_at_attribute_id","created_from_snap"})
		->arg_init(4,make_smart<ExprConstPtr>());
	addExtern<bool (*)(int *),imnodes::IsLinkDestroyed>(*this,lib,"IsLinkDestroyed",SideEffects::worstDefault,"imnodes::IsLinkDestroyed")
		->args({"link_id"});
}
}

