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

/*
[build] EXEC : warning : variadic function LabelText aka ImGui::LabelText [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
[build] EXEC : warning : variadic function BulletText aka ImGui::BulletText [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
[build] EXEC : warning : variadic function SetTooltip aka ImGui::SetTooltip [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
[build] EXEC : warning : variadic function TextWrapped aka ImGui::TextWrapped [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
[build] EXEC : warning : variadic function TextColored aka ImGui::TextColored [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
[build] EXEC : warning : variadic function TreeNode aka ImGui::TreeNode [C:\Users\Boris\Work\yzg\build\IMGUI_GENERATE.vcxproj]
*/

namespace das {
    void Text ( const char * txt ) {
        ImGui::Text(txt);
    }
    void TextDisabled ( const char * txt ) {
        ImGui::TextDisabled(txt);
    }
    void LogText ( const char * txt ) {
        ImGui::LogText(txt);
    }
    void TreeNode ( const char * id, const char * txt ) {
        ImGui::TreeNode(id,txt);
    }
    void TreeNodeEx ( const char * id, ImGuiTreeNodeFlags flags, const char * txt ) {
        ImGui::TreeNodeEx(id, flags, txt);
    }
    void TreeNodeEx2 ( const void * id, ImGuiTreeNodeFlags flags, const char * txt ) {
        ImGui::TreeNodeEx(id, flags, txt);
    }
    void TextUnformatted ( const char * txt ) {
        ImGui::TextUnformatted(txt, nullptr);
    }
    void BulletText ( const char * txt ) {
        ImGui::BulletText(txt);
    }
}

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
        // variadic functions
        addExtern<DAS_BIND_FUN(das::Text)>(*this,lib,"Text",
            SideEffects::worstDefault,"das::Text");
        addExtern<DAS_BIND_FUN(das::TextDisabled)>(*this,lib,"TextDisabled",
            SideEffects::worstDefault,"das::TextDisabled");
        addExtern<DAS_BIND_FUN(das::LogText)>(*this,lib,"LogText",
            SideEffects::worstDefault,"das::LogText");
        addExtern<DAS_BIND_FUN(das::TreeNode)>(*this,lib,"TreeNode",
            SideEffects::worstDefault,"das::TreeNode");
        addExtern<DAS_BIND_FUN(das::TreeNodeEx)>(*this,lib,"TreeNodeEx",
            SideEffects::worstDefault,"das::TreeNodeEx");
        addExtern<DAS_BIND_FUN(das::TreeNodeEx2)>(*this,lib,"TreeNodeEx",
            SideEffects::worstDefault,"das::TreeNodeEx2");
        addExtern<DAS_BIND_FUN(das::BulletText)>(*this,lib,"BulletText",
            SideEffects::worstDefault,"das::BulletText");
        // text unfromatted
        addExtern<DAS_BIND_FUN(das::TextUnformatted)>(*this, lib, "TextUnformatted",
            SideEffects::worstDefault, "das::TextUnformatted")
            ->arg("text");
        // constants
        addConstant(*this,"IMGUI_VERSION", IMGUI_VERSION);
        addConstant(*this,"IMGUI_VERSION_NUM", IMGUI_VERSION_NUM);
   }
    bool initialized = false;
    virtual bool initDependencies() override {
        if ( initialized ) return true;
        initialized = true;
#if USE_GENERATED
#include "module_imgui.inc"
#endif
        // vector C-tors
        addCtor<ImVec2>(*this,lib,"ImVec2","ImVec2");
        addCtor<ImVec2,float,float>(*this,lib,"ImVec2","ImVec2");
        addCtor<ImVec4>(*this,lib,"ImVec4","ImVec4");
        addCtor<ImVec4,float,float,float,float>(*this,lib,"ImVec4","ImVec4");
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
