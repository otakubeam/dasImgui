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
void Module_dasIMNODES::initFunctions_2() {
	addExtern<void (*)(imnodes::StyleVar,float),imnodes::PushStyleVar>(*this,lib,"PushStyleVar",SideEffects::worstDefault,"imnodes::PushStyleVar")
		->args({"style_item","value"});
	addExtern<void (*)(),imnodes::PopStyleVar>(*this,lib,"PopStyleVar",SideEffects::worstDefault,"imnodes::PopStyleVar");
	addExtern<void (*)(int),imnodes::BeginNode>(*this,lib,"BeginNode",SideEffects::worstDefault,"imnodes::BeginNode")
		->args({"id"});
	addExtern<void (*)(),imnodes::EndNode>(*this,lib,"EndNode",SideEffects::worstDefault,"imnodes::EndNode");
	addExtern<ImVec2 (*)(int),imnodes::GetNodeDimensions>(*this,lib,"GetNodeDimensions",SideEffects::worstDefault,"imnodes::GetNodeDimensions")
		->args({"id"});
	addExtern<void (*)(),imnodes::BeginNodeTitleBar>(*this,lib,"BeginNodeTitleBar",SideEffects::worstDefault,"imnodes::BeginNodeTitleBar");
	addExtern<void (*)(),imnodes::EndNodeTitleBar>(*this,lib,"EndNodeTitleBar",SideEffects::worstDefault,"imnodes::EndNodeTitleBar");
	addExtern<void (*)(int,imnodes::PinShape),imnodes::BeginInputAttribute>(*this,lib,"BeginInputAttribute",SideEffects::worstDefault,"imnodes::BeginInputAttribute")
		->args({"id","shape"})
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<imnodes::PinShape>(lib)));
	addExtern<void (*)(),imnodes::EndInputAttribute>(*this,lib,"EndInputAttribute",SideEffects::worstDefault,"imnodes::EndInputAttribute");
	addExtern<void (*)(int,imnodes::PinShape),imnodes::BeginOutputAttribute>(*this,lib,"BeginOutputAttribute",SideEffects::worstDefault,"imnodes::BeginOutputAttribute")
		->args({"id","shape"})
		->arg_init(1,make_smart<ExprConstEnumeration>(1,makeType<imnodes::PinShape>(lib)));
	addExtern<void (*)(),imnodes::EndOutputAttribute>(*this,lib,"EndOutputAttribute",SideEffects::worstDefault,"imnodes::EndOutputAttribute");
	addExtern<void (*)(int),imnodes::BeginStaticAttribute>(*this,lib,"BeginStaticAttribute",SideEffects::worstDefault,"imnodes::BeginStaticAttribute")
		->args({"id"});
	addExtern<void (*)(),imnodes::EndStaticAttribute>(*this,lib,"EndStaticAttribute",SideEffects::worstDefault,"imnodes::EndStaticAttribute");
	addExtern<void (*)(imnodes::AttributeFlags),imnodes::PushAttributeFlag>(*this,lib,"PushAttributeFlag",SideEffects::worstDefault,"imnodes::PushAttributeFlag")
		->args({"flag"});
	addExtern<void (*)(),imnodes::PopAttributeFlag>(*this,lib,"PopAttributeFlag",SideEffects::worstDefault,"imnodes::PopAttributeFlag");
	addExtern<void (*)(int,int,int),imnodes::Link>(*this,lib,"Link",SideEffects::worstDefault,"imnodes::Link")
		->args({"id","start_attribute_id","end_attribute_id"});
	addExtern<void (*)(int,const bool),imnodes::SetNodeDraggable>(*this,lib,"SetNodeDraggable",SideEffects::worstDefault,"imnodes::SetNodeDraggable")
		->args({"node_id","draggable"});
	addExtern<void (*)(int,const ImVec2 &),imnodes::SetNodeScreenSpacePos>(*this,lib,"SetNodeScreenSpacePos",SideEffects::worstDefault,"imnodes::SetNodeScreenSpacePos")
		->args({"node_id","screen_space_pos"});
	addExtern<void (*)(int,const ImVec2 &),imnodes::SetNodeEditorSpacePos>(*this,lib,"SetNodeEditorSpacePos",SideEffects::worstDefault,"imnodes::SetNodeEditorSpacePos")
		->args({"node_id","editor_space_pos"});
	addExtern<void (*)(int,const ImVec2 &),imnodes::SetNodeGridSpacePos>(*this,lib,"SetNodeGridSpacePos",SideEffects::worstDefault,"imnodes::SetNodeGridSpacePos")
		->args({"node_id","grid_pos"});
}
}

