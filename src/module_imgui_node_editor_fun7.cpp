#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc7() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginShortcut)>(*this, lib, "BeginShortcut",
            SideEffects::worstDefault, "ax::NodeEditor::BeginShortcut");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptCut)>(*this, lib, "AcceptCut",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptCut");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptCopy)>(*this, lib, "AcceptCopy",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptCopy");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptPaste)>(*this, lib, "AcceptPaste",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptPaste");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptDuplicate)>(*this, lib, "AcceptDuplicate",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptDuplicate");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::AcceptCreateNode)>(*this, lib, "AcceptCreateNode",
            SideEffects::worstDefault, "ax::NodeEditor::AcceptCreateNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetActionContextSize)>(*this, lib, "GetActionContextSize",
            SideEffects::worstDefault, "ax::NodeEditor::GetActionContextSize");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetActionContextNodes)>(*this, lib, "GetActionContextNodes",
            SideEffects::worstDefault, "ax::NodeEditor::GetActionContextNodes")
        ->args({"nodes","size"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetActionContextLinks)>(*this, lib, "GetActionContextLinks",
            SideEffects::worstDefault, "ax::NodeEditor::GetActionContextLinks")
        ->args({"links","size"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndShortcut)>(*this, lib, "EndShortcut",
            SideEffects::worstDefault, "ax::NodeEditor::EndShortcut");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetCurrentZoom)>(*this, lib, "GetCurrentZoom",
            SideEffects::worstDefault, "ax::NodeEditor::GetCurrentZoom");
}
