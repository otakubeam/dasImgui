#pragma once

class Module_imgui_node_editor: public Module {
    ModuleLibrary lib;
    bool initialized = false;
public:
    Module_imgui_node_editor();
protected:
    virtual bool initDependencies() override;
    virtual ModuleAotType aotRequire ( TextWriter & tw ) const override;
protected:
    void initTypes();
    void initFunc1();
    void initFunc2();
    void initFunc3();
    void initFunc4();
    void initFunc5();
    void initFunc6();
    void initFunc7();
    void initFunc8();
};

DAS_BIND_ENUM_CAST(ax::NodeEditor::SaveReasonFlags);
DAS_BASE_BIND_ENUM_GEN(ax::NodeEditor::SaveReasonFlags,SaveReasonFlags);
DAS_BIND_ENUM_CAST(ax::NodeEditor::PinKind);
DAS_BASE_BIND_ENUM_GEN(ax::NodeEditor::PinKind,PinKind);
DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleColor);
DAS_BASE_BIND_ENUM_GEN(ax::NodeEditor::StyleColor,StyleColor);
DAS_BIND_ENUM_CAST(ax::NodeEditor::StyleVar);
DAS_BASE_BIND_ENUM_GEN(ax::NodeEditor::StyleVar,StyleVar);

MAKE_EXTERNAL_TYPE_FACTORY(Style, ax::NodeEditor::Style);
MAKE_EXTERNAL_TYPE_FACTORY(EditorContext,ax::NodeEditor::EditorContext);
MAKE_EXTERNAL_TYPE_FACTORY(Config, ax::NodeEditor::Config);

MAKE_EXTERNAL_TYPE_FACTORY(ImDrawList, ImDrawList);

namespace das {

// node

template <> struct typeFactory<ax::NodeEditor::NodeId> {
	static TypeDeclPtr make(const ModuleLibrary &) {
		auto t = make_smart<TypeDecl>(Type::tInt);
		t->alias = "NodeId";
		t->aotAlias = true;
		return t;
	}
};
template <> struct typeName<ax::NodeEditor::NodeId> { constexpr static const char * name() { return "NodeId"; } };
template <> struct cast_arg<ax::NodeEditor::NodeId> {
    static __forceinline ax::NodeEditor::NodeId to ( Context & ctx, SimNode * node ) {
        vec4f res = node->eval(ctx);
        return ax::NodeEditor::NodeId(cast<int32_t>::to(res));
    }
};
template <> struct cast_res<ax::NodeEditor::NodeId> {
    static __forceinline vec4f from ( ax::NodeEditor::NodeId node ) {
        return cast<int32_t>::from(int32_t(node.Get()));
    }
};

// pin

template <> struct typeFactory<ax::NodeEditor::PinId> {
	static TypeDeclPtr make(const ModuleLibrary &) {
		auto t = make_smart<TypeDecl>(Type::tInt);
		t->alias = "PinId";
		t->aotAlias = true;
		return t;
	}
};
template <> struct typeName<ax::NodeEditor::PinId> { constexpr static const char * name() { return "PinId"; } };
template <> struct cast_arg<ax::NodeEditor::PinId> {
    static __forceinline ax::NodeEditor::PinId to ( Context & ctx, SimNode * node ) {
        vec4f res = node->eval(ctx);
        return ax::NodeEditor::PinId(cast<int32_t>::to(res));
    }
};
template <> struct cast_res<ax::NodeEditor::PinId> {
    static __forceinline vec4f from ( ax::NodeEditor::PinId node ) {
        return cast<int32_t>::from(int32_t(node.Get()));
    }
};

// link

template <> struct typeFactory<ax::NodeEditor::LinkId> {
	static TypeDeclPtr make(const ModuleLibrary &) {
		auto t = make_smart<TypeDecl>(Type::tInt);
		t->alias = "LinkId";
		t->aotAlias = true;
		return t;
	}
};
template <> struct typeName<ax::NodeEditor::LinkId> { constexpr static const char * name() { return "LinkId"; } };
template <> struct cast_arg<ax::NodeEditor::LinkId> {
    static __forceinline ax::NodeEditor::LinkId to ( Context & ctx, SimNode * node ) {
        vec4f res = node->eval(ctx);
        return ax::NodeEditor::LinkId(cast<int32_t>::to(res));
    }
};
template <> struct cast_res<ax::NodeEditor::LinkId> {
    static __forceinline vec4f from ( ax::NodeEditor::LinkId node ) {
        return cast<int32_t>::from(int32_t(node.Get()));
    }
};

}
