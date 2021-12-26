// this file is generated via daScript automatic C++ binder
// all user modifications will be lost after this file is re-generated

#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMGUI.h"
#include "need_dasIMGUI.h"
namespace das {
void Module_dasIMGUI::initFunctions_20() {
	using _method_26 = das::das_call_member< void (ImGuiTextBuffer::*)(int),&ImGuiTextBuffer::reserve >;
	addExtern<DAS_CALL_METHOD(_method_26)>(*this,lib,"reserve",SideEffects::worstDefault,"das_call_member< void (ImGuiTextBuffer::*)(int) , &ImGuiTextBuffer::reserve >::invoke")
		->args({"self","capacity"});
	using _method_27 = das::das_call_member< const char * (ImGuiTextBuffer::*)() const,&ImGuiTextBuffer::c_str >;
	addExtern<DAS_CALL_METHOD(_method_27)>(*this,lib,"c_str",SideEffects::worstDefault,"das_call_member< const char * (ImGuiTextBuffer::*)() const , &ImGuiTextBuffer::c_str >::invoke")
		->args({"self"});
	using _method_28 = das::das_call_member< void (ImGuiTextBuffer::*)(const char *,va_list),&ImGuiTextBuffer::appendfv >;
	addExtern<DAS_CALL_METHOD(_method_28)>(*this,lib,"appendfv",SideEffects::worstDefault,"das_call_member< void (ImGuiTextBuffer::*)(const char *,va_list) , &ImGuiTextBuffer::appendfv >::invoke")
		->args({"self","fmt","args"});
	addCtorAndUsing<ImGuiStorage::ImGuiStoragePair,unsigned int,int>(*this,lib,"ImGuiStoragePair","ImGuiStorage::ImGuiStoragePair")
		->args({"_key","_val_i"});
	addCtorAndUsing<ImGuiStorage::ImGuiStoragePair,unsigned int,float>(*this,lib,"ImGuiStoragePair","ImGuiStorage::ImGuiStoragePair")
		->args({"_key","_val_f"});
	addCtorAndUsing<ImGuiStorage::ImGuiStoragePair,unsigned int,void *>(*this,lib,"ImGuiStoragePair","ImGuiStorage::ImGuiStoragePair")
		->args({"_key","_val_p"});
	using _method_29 = das::das_call_member< void (ImGuiStorage::*)(),&ImGuiStorage::Clear >;
	addExtern<DAS_CALL_METHOD(_method_29)>(*this,lib,"Clear",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)() , &ImGuiStorage::Clear >::invoke")
		->args({"self"});
	using _method_30 = das::das_call_member< int (ImGuiStorage::*)(ImGuiID,int) const,&ImGuiStorage::GetInt >;
	addExtern<DAS_CALL_METHOD(_method_30)>(*this,lib,"GetInt",SideEffects::worstDefault,"das_call_member< int (ImGuiStorage::*)(ImGuiID,int) const , &ImGuiStorage::GetInt >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstInt>(0));
	using _method_31 = das::das_call_member< void (ImGuiStorage::*)(ImGuiID,int),&ImGuiStorage::SetInt >;
	addExtern<DAS_CALL_METHOD(_method_31)>(*this,lib,"SetInt",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)(ImGuiID,int) , &ImGuiStorage::SetInt >::invoke")
		->args({"self","key","val"});
	using _method_32 = das::das_call_member< bool (ImGuiStorage::*)(ImGuiID,bool) const,&ImGuiStorage::GetBool >;
	addExtern<DAS_CALL_METHOD(_method_32)>(*this,lib,"GetBool",SideEffects::worstDefault,"das_call_member< bool (ImGuiStorage::*)(ImGuiID,bool) const , &ImGuiStorage::GetBool >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstBool>(false));
	using _method_33 = das::das_call_member< void (ImGuiStorage::*)(ImGuiID,bool),&ImGuiStorage::SetBool >;
	addExtern<DAS_CALL_METHOD(_method_33)>(*this,lib,"SetBool",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)(ImGuiID,bool) , &ImGuiStorage::SetBool >::invoke")
		->args({"self","key","val"});
	using _method_34 = das::das_call_member< float (ImGuiStorage::*)(ImGuiID,float) const,&ImGuiStorage::GetFloat >;
	addExtern<DAS_CALL_METHOD(_method_34)>(*this,lib,"GetFloat",SideEffects::worstDefault,"das_call_member< float (ImGuiStorage::*)(ImGuiID,float) const , &ImGuiStorage::GetFloat >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstFloat>(0.00000000000000000));
	using _method_35 = das::das_call_member< void (ImGuiStorage::*)(ImGuiID,float),&ImGuiStorage::SetFloat >;
	addExtern<DAS_CALL_METHOD(_method_35)>(*this,lib,"SetFloat",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)(ImGuiID,float) , &ImGuiStorage::SetFloat >::invoke")
		->args({"self","key","val"});
	using _method_36 = das::das_call_member< void * (ImGuiStorage::*)(ImGuiID) const,&ImGuiStorage::GetVoidPtr >;
	addExtern<DAS_CALL_METHOD(_method_36)>(*this,lib,"GetVoidPtr",SideEffects::worstDefault,"das_call_member< void * (ImGuiStorage::*)(ImGuiID) const , &ImGuiStorage::GetVoidPtr >::invoke")
		->args({"self","key"});
	using _method_37 = das::das_call_member< void (ImGuiStorage::*)(ImGuiID,void *),&ImGuiStorage::SetVoidPtr >;
	addExtern<DAS_CALL_METHOD(_method_37)>(*this,lib,"SetVoidPtr",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)(ImGuiID,void *) , &ImGuiStorage::SetVoidPtr >::invoke")
		->args({"self","key","val"});
	using _method_38 = das::das_call_member< int * (ImGuiStorage::*)(ImGuiID,int),&ImGuiStorage::GetIntRef >;
	addExtern<DAS_CALL_METHOD(_method_38)>(*this,lib,"GetIntRef",SideEffects::worstDefault,"das_call_member< int * (ImGuiStorage::*)(ImGuiID,int) , &ImGuiStorage::GetIntRef >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstInt>(0));
	using _method_39 = das::das_call_member< bool * (ImGuiStorage::*)(ImGuiID,bool),&ImGuiStorage::GetBoolRef >;
	addExtern<DAS_CALL_METHOD(_method_39)>(*this,lib,"GetBoolRef",SideEffects::worstDefault,"das_call_member< bool * (ImGuiStorage::*)(ImGuiID,bool) , &ImGuiStorage::GetBoolRef >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstBool>(false));
	using _method_40 = das::das_call_member< float * (ImGuiStorage::*)(ImGuiID,float),&ImGuiStorage::GetFloatRef >;
	addExtern<DAS_CALL_METHOD(_method_40)>(*this,lib,"GetFloatRef",SideEffects::worstDefault,"das_call_member< float * (ImGuiStorage::*)(ImGuiID,float) , &ImGuiStorage::GetFloatRef >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstFloat>(0.00000000000000000));
	using _method_41 = das::das_call_member< void ** (ImGuiStorage::*)(ImGuiID,void *),&ImGuiStorage::GetVoidPtrRef >;
	addExtern<DAS_CALL_METHOD(_method_41)>(*this,lib,"GetVoidPtrRef",SideEffects::worstDefault,"das_call_member< void ** (ImGuiStorage::*)(ImGuiID,void *) , &ImGuiStorage::GetVoidPtrRef >::invoke")
		->args({"self","key","default_val"})
		->arg_init(2,make_smart<ExprConstPtr>());
	using _method_42 = das::das_call_member< void (ImGuiStorage::*)(int),&ImGuiStorage::SetAllInt >;
	addExtern<DAS_CALL_METHOD(_method_42)>(*this,lib,"SetAllInt",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)(int) , &ImGuiStorage::SetAllInt >::invoke")
		->args({"self","val"});
}
}

