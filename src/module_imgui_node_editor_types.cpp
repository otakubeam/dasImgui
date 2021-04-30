#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

DAS_BASE_BIND_ENUM_IMPL(ax::NodeEditor::SaveReasonFlags, SaveReasonFlags,
    None,
    Navigation,
    Position,
    Size,
    Selection,
    User);

DAS_BASE_BIND_ENUM_IMPL(ax::NodeEditor::PinKind,
    PinKind,
    Input,
    Output);

DAS_BASE_BIND_ENUM_IMPL(ax::NodeEditor::StyleColor, StyleColor,
    StyleColor_Bg,
    StyleColor_Grid,
    StyleColor_NodeBg,
    StyleColor_NodeBorder,
    StyleColor_HovNodeBorder,
    StyleColor_SelNodeBorder,
    StyleColor_NodeSelRect,
    StyleColor_NodeSelRectBorder,
    StyleColor_HovLinkBorder,
    StyleColor_SelLinkBorder,
    StyleColor_LinkSelRect,
    StyleColor_LinkSelRectBorder,
    StyleColor_PinRect,
    StyleColor_PinRectBorder,
    StyleColor_Flow,
    StyleColor_FlowMarker,
    StyleColor_GroupBg,
    StyleColor_GroupBorder);

DAS_BASE_BIND_ENUM_IMPL(ax::NodeEditor::StyleVar, StyleVar,
    StyleVar_NodePadding,
    StyleVar_NodeRounding,
    StyleVar_NodeBorderWidth,
    StyleVar_HoveredNodeBorderWidth,
    StyleVar_SelectedNodeBorderWidth,
    StyleVar_PinRounding,
    StyleVar_PinBorderWidth,
    StyleVar_LinkStrength,
    StyleVar_SourceDirection,
    StyleVar_TargetDirection,
    StyleVar_ScrollDuration,
    StyleVar_FlowMarkerDistance,
    StyleVar_FlowSpeed,
    StyleVar_FlowDuration,
    StyleVar_PivotAlignment,
    StyleVar_PivotSize,
    StyleVar_PivotScale,
    StyleVar_PinCorners,
    StyleVar_PinRadius,
    StyleVar_PinArrowSize,
    StyleVar_PinArrowWidth,
    StyleVar_GroupRounding,
    StyleVar_GroupBorderWidth);

IMPLEMENT_EXTERNAL_TYPE_FACTORY(Style, ax::NodeEditor::Style);

struct NodeEditorStyleAnnotation : ManagedStructureAnnotation <ax::NodeEditor::Style> {
    NodeEditorStyleAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("Style", ml) {
        addField<DAS_BIND_MANAGED_FIELD(NodePadding)>("NodePadding");
        addField<DAS_BIND_MANAGED_FIELD(NodeRounding)>("NodeRounding");
        addField<DAS_BIND_MANAGED_FIELD(NodeBorderWidth)>("NodeBorderWidth");
        addField<DAS_BIND_MANAGED_FIELD(HoveredNodeBorderWidth)>("HoveredNodeBorderWidth");
        addField<DAS_BIND_MANAGED_FIELD(SelectedNodeBorderWidth)>("SelectedNodeBorderWidth");
        addField<DAS_BIND_MANAGED_FIELD(PinRounding)>("PinRounding");
        addField<DAS_BIND_MANAGED_FIELD(PinBorderWidth)>("PinBorderWidth");
        addField<DAS_BIND_MANAGED_FIELD(LinkStrength)>("LinkStrength");
        addField<DAS_BIND_MANAGED_FIELD(SourceDirection)>("SourceDirection");
        addField<DAS_BIND_MANAGED_FIELD(TargetDirection)>("TargetDirection");
        addField<DAS_BIND_MANAGED_FIELD(ScrollDuration)>("ScrollDuration");
        addField<DAS_BIND_MANAGED_FIELD(FlowMarkerDistance)>("FlowMarkerDistance");
        addField<DAS_BIND_MANAGED_FIELD(FlowSpeed)>("FlowSpeed");
        addField<DAS_BIND_MANAGED_FIELD(FlowDuration)>("FlowDuration");
        addField<DAS_BIND_MANAGED_FIELD(PivotAlignment)>("PivotAlignment");
        addField<DAS_BIND_MANAGED_FIELD(PivotSize)>("PivotSize");
        addField<DAS_BIND_MANAGED_FIELD(PivotScale)>("PivotScale");
        addField<DAS_BIND_MANAGED_FIELD(PinCorners)>("PinCorners");
        addField<DAS_BIND_MANAGED_FIELD(PinRadius)>("PinRadius");
        addField<DAS_BIND_MANAGED_FIELD(PinArrowSize)>("PinArrowSize");
        addField<DAS_BIND_MANAGED_FIELD(PinArrowWidth)>("PinArrowWidth");
        addField<DAS_BIND_MANAGED_FIELD(GroupRounding)>("GroupRounding");
        addField<DAS_BIND_MANAGED_FIELD(GroupBorderWidth)>("GroupBorderWidth");
        addField<DAS_BIND_MANAGED_FIELD(Colors)>("Colors");
    }
};

IMPLEMENT_EXTERNAL_TYPE_FACTORY(EditorContext,ax::NodeEditor::EditorContext);

IMPLEMENT_EXTERNAL_TYPE_FACTORY(Config, ax::NodeEditor::Config);

struct NodeEditorConfigAnnotation : ManagedStructureAnnotation <ax::NodeEditor::Config> {
    NodeEditorConfigAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("Config", ml) {
        addField<DAS_BIND_MANAGED_FIELD(SettingsFile)>("SettingsFile").decl->constant = false;
        // todo: other fields? callbacks?
    }
    virtual bool isLocal() const override { return true; }
};

void Module_imgui_node_editor::initTypes() {
    // enumerations
    addEnumeration(make_smart<EnumerationSaveReasonFlags>());
    addEnumFlagOps<ax::NodeEditor::SaveReasonFlags>(*this,lib,"ax::NodeEditor::SaveReasonFlags");
    addEnumeration(make_smart<EnumerationPinKind>());
    addEnumeration(make_smart<EnumerationStyleColor>());
    addEnumeration(make_smart<EnumerationStyleVar>());
    // type annotations
    addAnnotation(make_smart<DummyTypeAnnotation>("EditorContext", "ax::NodeEditor::EditorContext",1, 1));
    addAnnotation(make_smart<NodeEditorStyleAnnotation>(lib));

    addAnnotation(make_smart<NodeEditorConfigAnnotation>(lib));
    addCtorAndUsing<ax::NodeEditor::Config>(*this,lib,"Config","ax::NodeEditor::Config");
}
