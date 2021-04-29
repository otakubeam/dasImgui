#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

MAKE_EXTERNAL_TYPE_FACTORY(ImDrawList, ImDrawList);

DAS_BIND_ENUM_CAST(ax::NodeEditor::SaveReasonFlags);
DAS_BASE_BIND_ENUM(ax::NodeEditor::SaveReasonFlags, SaveReasonFlags, None, Navigation, Position, Size, Selection, User);

DAS_BIND_ENUM_CAST(ax::NodeEditor::PinKind);
DAS_BASE_BIND_ENUM(ax::NodeEditor::PinKind, PinKind, Input, Output);


DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleColor);
DAS_BASE_BIND_ENUM(ax::NodeEditor::StyleColor, StyleColor,
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

DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleVar);
DAS_BASE_BIND_ENUM(ax::NodeEditor::StyleVar, StyleVar,
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

MAKE_TYPE_FACTORY(Style, ax::NodeEditor::Style);

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

MAKE_TYPE_FACTORY(EditorContext,ax::NodeEditor::EditorContext);

MAKE_TYPE_FACTORY(Config, ax::NodeEditor::Config);

struct NodeEditorConfigAnnotation : ManagedStructureAnnotation <ax::NodeEditor::Config> {
    NodeEditorConfigAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("Config", ml) {
        addField<DAS_BIND_MANAGED_FIELD(SettingsFile)>("SettingsFile").decl->constant = false;
        // todo: other fields? callbacks?
    }
    virtual bool isLocal() const override { return true; }
};

// making custom builtin module
class Module_imgui_node_editor: public Module {
    ModuleLibrary lib;
public:
    Module_imgui_node_editor() : Module("imgui_node_editor") {
    }
    bool initialized = false;
    virtual bool initDependencies() override {
        if ( initialized ) return true;
        // IMGUI
        auto mod_imgui = Module::require("imgui");
        if ( !mod_imgui ) return false;
        if ( !mod_imgui->initDependencies() ) return false;
        // time to initialize
        initialized = true;
        // make basic module
        lib.addModule(this);
        lib.addBuiltInModule();
        lib.addModule(mod_imgui);
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
        // functions
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

        addExtern<DAS_BIND_FUN(ax::NodeEditor::Begin)>(*this, lib, "Begin",
                SideEffects::worstDefault, "ax::NodeEditor::Begin");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::End)>(*this, lib, "End",
                SideEffects::worstDefault, "ax::NodeEditor::End");

        addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginNode)>(*this, lib, "BeginNode",
                SideEffects::worstDefault, "ax::NodeEditor::BeginNode");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginPin)>(*this, lib, "BeginPin",
                SideEffects::worstDefault, "ax::NodeEditor::BeginPin");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::PinRect)>(*this, lib, "PinRect",
                SideEffects::worstDefault, "ax::NodeEditor::PinRect");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotRect)>(*this, lib, "PinPivotRect",
                SideEffects::worstDefault, "ax::NodeEditor::PinPivotRect");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotSize)>(*this, lib, "PinPivotSize",
                SideEffects::worstDefault, "ax::NodeEditor::PinPivotSize");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotScale)>(*this, lib, "PinPivotScale",
                SideEffects::worstDefault, "ax::NodeEditor::PinPivotScale");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::PinPivotAlignment)>(*this, lib, "PinPivotAlignment",
                SideEffects::worstDefault, "ax::NodeEditor::PinPivotAlignment");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::EndPin)>(*this, lib, "EndPin",
                SideEffects::worstDefault, "ax::NodeEditor::EndPin");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::Group)>(*this, lib, "Group",
                SideEffects::worstDefault, "ax::NodeEditor::Group");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::EndNode)>(*this, lib, "EndNode",
                SideEffects::worstDefault, "ax::NodeEditor::EndNode");

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
                SideEffects::worstDefault, "ax::NodeEditor::Link");

        addExtern<DAS_BIND_FUN(ax::NodeEditor::Flow)>(*this, lib, "Flow",
                SideEffects::worstDefault, "ax::NodeEditor::Flow");

        addExtern<DAS_BIND_FUN(ax::NodeEditor::BeginCreate)>(*this, lib, "BeginCreate",
                SideEffects::worstDefault, "ax::NodeEditor::BeginCreate");
        addExtern<bool (*)(ax::NodeEditor::PinId *,ax::NodeEditor::PinId *),ax::NodeEditor::QueryNewLink>(*this, lib, "QueryNewLink",
                SideEffects::worstDefault, "ax::NodeEditor::QueryNewLink");
        addExtern<bool (*)(ax::NodeEditor::PinId *, ax::NodeEditor::PinId *, const ImVec4&, float) ,ax::NodeEditor::QueryNewLink>(*this, lib, "QueryNewLink",
                SideEffects::worstDefault, "ax::NodeEditor::QueryNewLink");
        addExtern<bool (*)(ax::NodeEditor::PinId *), ax::NodeEditor::QueryNewNode>(*this, lib, "QueryNewNode",
                SideEffects::worstDefault, "ax::NodeEditor::QueryNewNode");
        addExtern<bool (*)(ax::NodeEditor::PinId *, const ImVec4&, float), ax::NodeEditor::QueryNewNode>(*this, lib, "QueryNewNode",
                SideEffects::worstDefault, "ax::NodeEditor::QueryNewNode");

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
                SideEffects::worstDefault, "ax::NodeEditor::GetActionContextNodes");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::GetActionContextLinks)>(*this, lib, "GetActionContextLinks",
                SideEffects::worstDefault, "ax::NodeEditor::GetActionContextLinks");
        addExtern<DAS_BIND_FUN(ax::NodeEditor::EndShortcut)>(*this, lib, "EndShortcut",
                SideEffects::worstDefault, "ax::NodeEditor::EndShortcut");

        addExtern<DAS_BIND_FUN(ax::NodeEditor::GetCurrentZoom)>(*this, lib, "GetCurrentZoom",
                SideEffects::worstDefault, "ax::NodeEditor::GetCurrentZoom");

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

        // time to fix-up const & ImVec2 and const & ImVec4
        for ( auto fn : this->functions ) {
                const auto&  pfn = fn.second;
                for ( auto & arg : pfn->arguments ) {
                if ( arg->type->constant && arg->type->ref && arg->type->dim.size()==0 ) {
                        if ( arg->type->baseType==Type::tFloat2 || arg->type->baseType==Type::tFloat4 ) {
                        arg->type->ref = false;
                        }
                }
                }
        }

        // all good
        return true;
    }
    virtual ModuleAotType aotRequire ( TextWriter & tw ) const override {
        tw << "#include \"../modules/dasImgui/src/imgui_node_editor_stub.h\"\n";
        return ModuleAotType::cpp;
    }
};

// registering module, so that its available via 'NEED_MODULE' macro
REGISTER_MODULE(Module_imgui_node_editor);

