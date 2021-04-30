#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

void Module_imgui_node_editor::initFunc3() {
    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginGroupHint)>(*this, lib, "BeginGroupHint",
            SideEffects::worstDefault, "ax::NodeEditor::BeginGroupHint");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetGroupMin)>(*this, lib, "GetGroupMin",
            SideEffects::worstDefault, "ax::NodeEditor::GetGroupMin");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetGroupMax)>(*this, lib, "GetGroupMax",
            SideEffects::worstDefault, "ax::NodeEditor::GetGroupMax");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetHintForegroundDrawList)>(*this, lib, "GetHintForegroundDrawList",
            SideEffects::worstDefault, "ax::NodeEditor::GetHintForegroundDrawList");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetHintBackgroundDrawList)>(*this, lib, "GetHintBackgroundDrawList",
            SideEffects::worstDefault, "ax::NodeEditor::GetHintBackgroundDrawList");
    addExtern<DAS_BIND_FUN(ax::NodeEditor::EndGroupHint)>(*this, lib, "EndGroupHint",
            SideEffects::worstDefault, "ax::NodeEditor::EndGroupHint");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::GetNodeBackgroundDrawList)>(*this, lib, "GetNodeBackgroundDrawList",
            SideEffects::worstDefault, "ax::NodeEditor::GetNodeBackgroundDrawList");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::Link)>(*this, lib, "Link",
            SideEffects::worstDefault, "ax::NodeEditor::Link")
            ->arg_init(3, make_smart<ExprConstFloat4>(float4(1.0f)))
            ->arg_init(4, make_smart<ExprConstFloat>(1.0f));

    addExtern<DAS_BIND_FUN(ax::NodeEditor::Flow)>(*this, lib, "Flow",
            SideEffects::worstDefault, "ax::NodeEditor::Flow");

    addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginCreate)>(*this, lib, "BeginCreate",
            SideEffects::worstDefault, "ax::NodeEditor::BeginCreate")
            ->arg_init(0, make_smart<ExprConstFloat4>(float4(1.0f)))
            ->arg_init(1, make_smart<ExprConstFloat>(1.0f));
    addExtern<bool (*)(ax::NodeEditor::PinId *,ax::NodeEditor::PinId *),ax::NodeEditor::QueryNewLink>(*this, lib, "QueryNewLink",
            SideEffects::worstDefault, "ax::NodeEditor::QueryNewLink");
    addExtern<bool (*)(ax::NodeEditor::PinId *, ax::NodeEditor::PinId *, const ImVec4&, float) ,ax::NodeEditor::QueryNewLink>(*this, lib, "QueryNewLink",
            SideEffects::worstDefault, "ax::NodeEditor::QueryNewLink");
    addExtern<bool (*)(ax::NodeEditor::PinId *), ax::NodeEditor::QueryNewNode>(*this, lib, "QueryNewNode",
            SideEffects::worstDefault, "ax::NodeEditor::QueryNewNode");
    addExtern<bool (*)(ax::NodeEditor::PinId *, const ImVec4&, float), ax::NodeEditor::QueryNewNode>(*this, lib, "QueryNewNode",
            SideEffects::worstDefault, "ax::NodeEditor::QueryNewNode");
}
