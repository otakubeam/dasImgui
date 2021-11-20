#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include "imgui_stub.h"
#include "imgui_node_editor_stub.h"

using namespace das;

#include "need_imgui.h"
#include "need_imgui_node_editor.h"

Module_imgui_node_editor::Module_imgui_node_editor()
    : Module("imgui_node_editor") {
}

bool Module_imgui_node_editor::initDependencies() {
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
    // contents
    initTypes();
    initFunc1();
    initFunc2();
    initFunc3();
    initFunc4();
    initFunc5();
    initFunc6();
    initFunc7();
    initFunc8();
    // time to fix-up const & ImVec2 and const & ImVec4
    for ( auto & pfn : this->functions.each() ) {
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

ModuleAotType Module_imgui_node_editor::aotRequire ( TextWriter & tw ) const  {
    tw << "#include \"../modules/dasImgui/src/imgui_node_editor_stub.h\"\n";
    tw << "#include \"../modules/dasImgui/src/aot_imgui_node_editor.h\"\n";
    return ModuleAotType::cpp;
}

// registering module, so that its available via 'NEED_MODULE' macro
REGISTER_MODULE(Module_imgui_node_editor);

