#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc1() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::SetCurrentEditor)>(*this, lib, "SetCurrentEditor",
            SideEffects::worstDefault, "ax::NodeEditor::SetCurrentEditor")
        ->args({"ctx"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetCurrentEditor)>(*this, lib, "GetCurrentEditor",
            SideEffects::worstDefault, "ax::NodeEditor::GetCurrentEditor");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::CreateEditor)>(*this, lib, "CreateEditor",
            SideEffects::worstDefault, "ax::NodeEditor::CreateEditor")
        ->args({"config"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::DestroyEditor)>(*this, lib, "DestroyEditor",
            SideEffects::worstDefault, "ax::NodeEditor::DestroyEditor")
        ->args({"ctx"});

    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetStyle), SimNode_ExtFuncCallRef>(*this, lib, "GetStyle",
            SideEffects::worstDefault, "ax::NodeEditor::GetStyle");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetStyleColorName)>(*this, lib, "GetStyleColorName",
            SideEffects::worstDefault, "ax::NodeEditor::GetStyleColorName")
        ->args({"colorIndex"});

    addExtern<DAS_BIND_FUN(ax::NodeEditor::PushStyleColor)>(*this, lib, "PushStyleColor",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleColor")
        ->args({"colorIndex","color"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PopStyleColor)>(*this, lib, "PopStyleColor",
            SideEffects::worstDefault, "ax::NodeEditor::PopStyleColor")
        ->args({"count"})
        ->arg_init(0,make_smart<ExprConstInt>(1));

    addExtern<void (*) (ax::NodeEditor::StyleVar,float), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar")
        ->args({"varIndex","value"});
    addExtern<void (*) (ax::NodeEditor::StyleVar,const ImVec2&), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar")
        ->args({"varIndex","value"});
    addExtern<void (*) (ax::NodeEditor::StyleVar,const ImVec4&), ax::NodeEditor::PushStyleVar>(*this, lib, "PushStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PushStyleVar")
        ->args({"varIndex","value"});
    addExtern<DAS_BIND_FUN(ax::NodeEditor::PopStyleVar)>(*this, lib, "PopStyleVar",
            SideEffects::worstDefault, "ax::NodeEditor::PopStyleVar")
        ->args({"count"})
        ->arg_init(0,make_smart<ExprConstInt>(1));
}
