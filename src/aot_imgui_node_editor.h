#pragma once

namespace das {
   template <> struct das_alias<ax::NodeEditor::PinId> : das_alias_ref<ax::NodeEditor::PinId,int32_t> {};
   template <> struct das_alias<ax::NodeEditor::LinkId> : das_alias_ref<ax::NodeEditor::LinkId,int32_t> {};
   template <> struct das_alias<ax::NodeEditor::NodeId> : das_alias_ref<ax::NodeEditor::NodeId,int32_t> {};
}

DAS_BIND_ENUM_CAST(ax::NodeEditor::SaveReasonFlags);
DAS_BIND_ENUM_CAST(ax::NodeEditor::PinKind);
DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleColor);
DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleVar);
