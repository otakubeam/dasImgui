#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc6() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DeleteNode)>(*this, lib, "DeleteNode",
            SideEffects::worstDefault, "ax::NodeEditor::DeleteNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DeleteLink)>(*this, lib, "DeleteLink",
            SideEffects::worstDefault, "ax::NodeEditor::DeleteLink");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::NavigateToContent)>(*this, lib, "NavigateToContent",
            SideEffects::worstDefault, "ax::NodeEditor::NavigateToContent");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::NavigateToSelection)>(*this, lib, "NavigateToSelection",
            SideEffects::worstDefault, "ax::NodeEditor::NavigateToSelection");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::ShowNodeContextMenu)>(*this, lib, "ShowNodeContextMenu",
            SideEffects::worstDefault, "ax::NodeEditor::ShowNodeContextMenu");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::ShowPinContextMenu)>(*this, lib, "ShowPinContextMenu",
            SideEffects::worstDefault, "ax::NodeEditor::ShowPinContextMenu");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::ShowLinkContextMenu)>(*this, lib, "ShowLinkContextMenu",
            SideEffects::worstDefault, "ax::NodeEditor::ShowLinkContextMenu");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::ShowBackgroundContextMenu)>(*this, lib, "ShowBackgroundContextMenu",
            SideEffects::worstDefault, "ax::NodeEditor::ShowBackgroundContextMenu");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::EnableShortcuts)>(*this, lib, "EnableShortcuts",
            SideEffects::worstDefault, "ax::NodeEditor::EnableShortcuts");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AreShortcutsEnabled)>(*this, lib, "AreShortcutsEnabled",
            SideEffects::worstDefault, "ax::NodeEditor::AreShortcutsEnabled");
}

