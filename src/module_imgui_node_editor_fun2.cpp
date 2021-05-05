#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc2() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::Begin)>(*this, lib, "Begin",
            SideEffects::worstDefault, "ax::NodeEditor::Begin")
        ->args({"id","size"})
        ->arg_init(1,make_smart<ExprConstFloat2>());
    addExtern<DAS_BIND_FUN(ax::NodeEditor::End)>(*this, lib, "End",
            SideEffects::worstDefault, "ax::NodeEditor::End");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginNode)>(*this, lib, "BeginNode",
            SideEffects::worstDefault, "ax::NodeEditor::BeginNode")
        ->args({"id"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginPin)>(*this, lib, "BeginPin",
            SideEffects::worstDefault, "ax::NodeEditor::BeginPin")
        ->args({"id","kind"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinRect)>(*this, lib, "PinRect",
            SideEffects::worstDefault, "ax::NodeEditor::PinRect")
        ->args({"a","b"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotRect)>(*this, lib, "PinPivotRect",
            SideEffects::worstDefault, "ax::NodeEditor::PinPivotRect")
        ->args({"a","b"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotSize)>(*this, lib, "PinPivotSize",
            SideEffects::worstDefault, "ax::NodeEditor::PinPivotSize")
        ->args({"size"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotScale)>(*this, lib, "PinPivotScale",
            SideEffects::worstDefault, "ax::NodeEditor::PinPivotScale")
        ->args({"scale"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotAlignment)>(*this, lib, "PinPivotAlignment",
            SideEffects::worstDefault, "ax::NodeEditor::PinPivotAlignment")
        ->args({"alignment"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndPin)>(*this, lib, "EndPin",
            SideEffects::worstDefault, "ax::NodeEditor::EndPin");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::Group)>(*this, lib, "Group",
            SideEffects::worstDefault, "ax::NodeEditor::Group")
        ->args({"size"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndNode)>(*this, lib, "EndNode",
            SideEffects::worstDefault, "ax::NodeEditor::EndNode");
}
