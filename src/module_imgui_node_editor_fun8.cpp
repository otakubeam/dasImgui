#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc8() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetDoubleClickedNode)>(*this, lib, "GetDoubleClickedNode",
            SideEffects::worstDefault, "ax::NodeEditor::GetDoubleClickedNode");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetDoubleClickedPin)>(*this, lib, "GetDoubleClickedPin",
            SideEffects::worstDefault, "ax::NodeEditor::GetDoubleClickedPin");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetDoubleClickedLink)>(*this, lib, "GetDoubleClickedLink",
            SideEffects::worstDefault, "ax::NodeEditor::GetDoubleClickedLink");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::IsBackgroundClicked)>(*this, lib, "IsBackgroundClicked",
            SideEffects::worstDefault, "ax::NodeEditor::IsBackgroundClicked");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::IsBackgroundDoubleClicked)>(*this, lib, "IsBackgroundDoubleClicked",
            SideEffects::worstDefault, "ax::NodeEditor::IsBackgroundDoubleClicked");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::PinHadAnyLinks)>(*this, lib, "PinHadAnyLinks",
            SideEffects::worstDefault, "ax::NodeEditor::PinHadAnyLinks");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetScreenSize)>(*this, lib, "GetScreenSize",
            SideEffects::worstDefault, "ax::NodeEditor::GetScreenSize");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::ScreenToCanvas)>(*this, lib, "ScreenToCanvas",
            SideEffects::worstDefault, "ax::NodeEditor::ScreenToCanvas");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::CanvasToScreen)>(*this, lib, "CanvasToScreen",
            SideEffects::worstDefault, "ax::NodeEditor::CanvasToScreen");
}
