#include "daScript/daScript.h"
#include "daScript/ast/ast_typefactory_bind.h"

#include <imgui.h>

using namespace das;

#include "need_imgui.h"

#if USE_GENERATED

#include "module_imgui.h"

#include "module_imgui.enum.cpp_inc"

#endif


namespace das {

    template <typename ET>
    struct das_operator_enum_OR {
        static ET invoke ( ET a, ET b ) {
            return ET ( uint64_t(a) | uint64_t(b) );
        }
    };

    template <typename ET>
    inline auto addEnumFlagOps ( Module & mod, ModuleLibrary & lib, const string & cppName ) {
        using method_or = das_operator_enum_OR<ET>;
        return addExtern<DAS_CALL_METHOD(method_or)>(mod, lib, "|", SideEffects::none,
            ("das_operator_enum_OR<" + cppName + ">::compute").c_str());
    }

}

void Module_imgui::initEnums() {
#if USE_GENERATED
#include "module_imgui.enum.inc"
#endif
}
