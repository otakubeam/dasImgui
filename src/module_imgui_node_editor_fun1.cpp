#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc1() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::SetCurrentEditor)>(*this, lib, "SetCurrentEditor",
            SideEffects::worstDefault, "ax::NodeEditor::SetCurrentEditor");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetCurrentEditor)>(*this, lib, "GetCurrentEditor",
            SideEffects::worstDefault, "ax::NodeEditor::GetCurrentEditor");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::CreateEditor)>(*this, lib, "CreateEditor",
            SideEffects::worstDefault, "ax::NodeEditor::CreateEditor");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DestroyEditor)>(*this, lib, "DestroyEditor",
            SideEffects::worstDefault, "ax::NodeEditor::DestroyEditor");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetStyle)>(*this, lib, "GetStyle",
            SideEffects::worstDefault, "ax::NodeEditor::GetStyle");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetStyleColorName)>(*this, lib, "GetStyleColorName",
            SideEffects::worstDefault, "ax::NodeEditor::GetStyleColorName");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::PushStyleColor)>(*this, lib, "PushStyleColor",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleColor");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PopStyleColor)>(*this, lib, "PopStyleColor",
            SideEffects::worstDefault, "ax::NodeEditor::PopStyleColor");

    addExtern<void (*) (ax::NodeEditor::StyleVar,float), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar");
    addExtern<void (*) (ax::NodeEditor::StyleVar,const ImVec2&), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar");
    addExtern<void (*) (ax::NodeEditor::StyleVar,const ImVec4&), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PopStyleVar)>(*this, lib, "PopStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PopStyleVar");
}
