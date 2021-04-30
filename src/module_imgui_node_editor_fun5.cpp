#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc5() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::Suspend)>(*this, lib, "Suspend",
            SideEffects::worstDefault, "ax::NodeEditor::Suspend");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::Resume)>(*this, lib, "Resume",
            SideEffects::worstDefault, "ax::NodeEditor::Resume");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::IsSuspended)>(*this, lib, "IsSuspended",
            SideEffects::worstDefault, "ax::NodeEditor::IsSuspended");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::IsActive)>(*this, lib, "IsActive",
            SideEffects::worstDefault, "ax::NodeEditor::IsActive");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::HasSelectionChanged)>(*this, lib, "HasSelectionChanged",
            SideEffects::worstDefault, "ax::NodeEditor::HasSelectionChanged");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetSelectedObjectCount)>(*this, lib, "GetSelectedObjectCount",
            SideEffects::worstDefault, "ax::NodeEditor::GetSelectedObjectCount");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetSelectedNodes)>(*this, lib, "GetSelectedNodes",
            SideEffects::worstDefault, "ax::NodeEditor::GetSelectedNodes");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetSelectedLinks)>(*this, lib, "GetSelectedLinks",
            SideEffects::worstDefault, "ax::NodeEditor::GetSelectedLinks");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::ClearSelection)>(*this, lib, "ClearSelection",
            SideEffects::worstDefault, "ax::NodeEditor::ClearSelection");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::SelectNode)>(*this, lib, "SelectNode",
            SideEffects::worstDefault, "ax::NodeEditor::SelectNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::SelectLink)>(*this, lib, "SelectLink",
            SideEffects::worstDefault, "ax::NodeEditor::SelectLink");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DeselectNode)>(*this, lib, "DeselectNode",
            SideEffects::worstDefault, "ax::NodeEditor::DeselectNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DeselectLink)>(*this, lib, "DeselectLink",
            SideEffects::worstDefault, "ax::NodeEditor::DeselectLink");
}
