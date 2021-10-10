#include "daScript/daScript.h"

#include "msvc32.inc"

using namespace das;

#define APP_NAME   "/modules/dasImgui/greyprint/greyprint.das"

#define USE_AOT     1

void application () {
    TextPrinter tout;
    ModuleGroup dummyLibGroup;
    CodeOfPolicies policies;
    auto fAccess = make_smart<FsFileAccess>();
    auto program = compileDaScript(getDasRoot() + APP_NAME, fAccess, tout, dummyLibGroup, false, policies);
    if ( program->failed() ) {
        tout << "failed to compile\n";
        for ( auto & err : program->errors ) {
            tout << reportError(err.at, err.what, err.extra, err.fixme, err.cerr );
        }
        return;
    }
    Context ctx(program->getContextStackSize());
    if ( !program->simulate(ctx, tout) ) {
        tout << "failed to simulate\n";
        for ( auto & err : program->errors ) {
            tout << reportError(err.at, err.what, err.extra, err.fixme, err.cerr );
        }
        return;
    }
    if ( USE_AOT ) {
        // now, what we get to do is to link AOT
        program->linkCppAot(ctx, getGlobalAotLibrary(), tout);
        if ( program->failed() ) {
            tout << "failed to link AOT\n";
            for ( auto & err : program->errors ) {
                tout << reportError(err.at, err.what, err.extra, err.fixme, err.cerr );
            }
            return;
        }
    }
    auto fnTest = ctx.findFunction("main");
    if ( !fnTest ) {
        tout << "function 'main' not found\n";
        return;
    }
    if ( !verifyCall<void>(fnTest->debugInfo, dummyLibGroup) ) {
        tout << "function 'main', call arguments do not match. expecting def main : void\n";
        return;
    }
    ctx.eval(fnTest, nullptr);
    if ( auto ex = ctx.getException() ) {       // if function cased panic, report it
        tout << "exception: " << ex << "\n";
        return;
    }
}

int main( int, char * [] ) {
    NEED_ALL_DEFAULT_MODULES;
    NEED_MODULE(Module_UriParser);
    #include "modules/external_need.inc"
    Module::Initialize();
    application();
    Module::Shutdown();
    return 0;
}
