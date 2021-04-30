#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc4() {
    addExtern<bool (*)(), ax::NodeEditor::AcceptNewItem>(*this, lib, "AcceptNewItem",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptNewItem");
    addExtern<bool (*)(const ImVec4&, float),  ax::NodeEditor::AcceptNewItem>(*this, lib, "AcceptNewItem",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptNewItem");
    addExtern<void (*)(), ax::NodeEditor::RejectNewItem>(*this, lib, "RejectNewItem",
            SideEffects::worstDefault, "ax::NodeEditor::RejectNewItem");
    addExtern<void (*)(const ImVec4&, float), ax::NodeEditor::RejectNewItem>(*this, lib, "RejectNewItem",
            SideEffects::worstDefault, "ax::NodeEditor::RejectNewItem");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndCreate)>(*this, lib, "EndCreate",
            SideEffects::worstDefault, "ax::NodeEditor::EndCreate");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginDelete)>(*this, lib, "BeginDelete",
            SideEffects::worstDefault, "ax::NodeEditor::BeginDelete");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::QueryDeletedLink)>(*this, lib, "QueryDeletedLink",
            SideEffects::worstDefault, "ax::NodeEditor::QueryDeletedLink");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::QueryDeletedNode)>(*this, lib, "QueryDeletedNode",
            SideEffects::worstDefault, "ax::NodeEditor::QueryDeletedNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptDeletedItem)>(*this, lib, "AcceptDeletedItem",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptDeletedItem");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::RejectDeletedItem)>(*this, lib, "RejectDeletedItem",
            SideEffects::worstDefault, "ax::NodeEditor::RejectDeletedItem");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndDelete)>(*this, lib, "EndDelete",
            SideEffects::worstDefault, "ax::NodeEditor::EndDelete");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::SetNodePosition)>(*this, lib, "SetNodePosition",
            SideEffects::worstDefault, "ax::NodeEditor::SetNodePosition");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetNodePosition)>(*this, lib, "GetNodePosition",
            SideEffects::worstDefault, "ax::NodeEditor::GetNodePosition");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetNodeSize)>(*this, lib, "GetNodeSize",
            SideEffects::worstDefault, "ax::NodeEditor::GetNodeSize");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::CenterNodeOnScreen)>(*this, lib, "CenterNodeOnScreen",
            SideEffects::worstDefault, "ax::NodeEditor::CenterNodeOnScreen");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::RestoreNodeState)>(*this, lib, "RestoreNodeState",
            SideEffects::worstDefault, "ax::NodeEditor::RestoreNodeState");
}
