#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include <imgui.h>

using namespace das;

#define USE_GENERATED   1

/*
template <typename TT>
struct typeName<ImVector<TT>> {
    static string name() {
        return string("ImVector`") + typeName<TT>::name(); // TODO: compilation time concat
    }
};

// ImDrawListSharedData to void * TODO: make dummy type
template <>
struct typeFactory<const ImDrawListSharedData *> {
    static TypeDeclPtr make(const ModuleLibrary & library ) {
        return typeFactory<void *>::make(library);
    };
};

// ImFont
template <>
struct typeName<ImFont *> : das::typeName<void *> {
};

template <>
struct typeFactory<ImFont *> {
    static TypeDeclPtr make(const ModuleLibrary & library ) {
        return typeFactory<void *>::make(library);
    };
};

template <typename TT>
struct typeFactory<ImVector<TT>> {
    using VT = ImVector<TT>;
    static TypeDeclPtr make(const ModuleLibrary & library ) {
        string declN = typeName<VT>::name();
        if ( library.findAnnotation(declN,nullptr).size()==0 ) {
            auto declT = makeType<TT>(library);
            auto ann = make_smart<ManagedVectorAnnotation<VT>>(declN,const_cast<ModuleLibrary &>(library));
            ann->cppName = "ImVector<" + describeCppType(declT) + ">";
            auto mod = library.front();
            mod->addAnnotation(ann);
            //registerVectorFunctions<TT>::init(mod,library,
                //declT->canCopy(),
                //declT->canMove()
            //);
        }
        return makeHandleType(library,declN.c_str());
    }
};
*/

MAKE_TYPE_FACTORY(ImGuiContext,ImGuiContext);
MAKE_TYPE_FACTORY(ImDrawListSharedData,ImDrawListSharedData);

#if USE_GENERATED

#include "module_imgui.h"

#include "module_imgui.cpp_inc"

#endif

template <>
struct cast_arg<ImVec2> {
    static __forceinline ImVec2 to ( Context & ctx, SimNode * node ) {
        return * (ImVec2 *) node->evalPtr(ctx);
    }
};

// making custom builtin module
class Module_imgui : public Module {
    ModuleLibrary lib;
public:
    Module_imgui() : Module("imgui") {
        // check version
        IMGUI_CHECKVERSION();
        // make basic module
        lib.addModule(this);
        lib.addBuiltInModule();
        addAnnotation(make_smart<DummyTypeAnnotation>("ImGuiContext", "ImGuiContext",
            1, 1)); // sizeof(ImGuiContext), alignof(ImGuiContext)));
        addAnnotation(make_smart<DummyTypeAnnotation>("ImDrawListSharedData", "ImDrawListSharedData",
            1, 1)); // sizeof(ImGuiContext), alignof(ImGuiContext)));
    }
    bool initialized = false;
    virtual bool initDependencies() override {
        if ( initialized ) return true;
        initialized = true;
#if USE_GENERATED
#include "module_imgui.inc"
#endif
        return true;
    }
    virtual ModuleAotType aotRequire ( TextWriter & tw ) const override {
        // add your stuff here
        tw << "#include <imgui.h>\n";
        // specifying AOT type, in this case direct cpp mode (and not hybrid mode)
        return ModuleAotType::cpp;
    }
};

// registering module, so that its available via 'NEED_MODULE' macro
REGISTER_MODULE(Module_imgui);
