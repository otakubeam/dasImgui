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
void Module_dasIMGUI::initFunctions_21() {
	using _method_43 = das::das_call_member< void (ImGuiStorage::*)(),&ImGuiStorage::BuildSortByKey >;
	addExtern<DAS_CALL_METHOD(_method_43)>(*this,lib,"BuildSortByKey",SideEffects::worstDefault,"das_call_member< void (ImGuiStorage::*)() , &ImGuiStorage::BuildSortByKey >::invoke")
		->args({"self"});
	addCtorAndUsing<ImGuiListClipper>(*this,lib,"ImGuiListClipper","ImGuiListClipper");
	using _method_44 = das::das_call_member< void (ImGuiListClipper::*)(int,float),&ImGuiListClipper::Begin >;
	addExtern<DAS_CALL_METHOD(_method_44)>(*this,lib,"Begin",SideEffects::worstDefault,"das_call_member< void (ImGuiListClipper::*)(int,float) , &ImGuiListClipper::Begin >::invoke")
		->args({"self","items_count","items_height"})
		->arg_init(2,make_smart<ExprConstFloat>(-1.00000000000000000));
	using _method_45 = das::das_call_member< void (ImGuiListClipper::*)(),&ImGuiListClipper::End >;
	addExtern<DAS_CALL_METHOD(_method_45)>(*this,lib,"End",SideEffects::worstDefault,"das_call_member< void (ImGuiListClipper::*)() , &ImGuiListClipper::End >::invoke")
		->args({"self"});
	using _method_46 = das::das_call_member< bool (ImGuiListClipper::*)(),&ImGuiListClipper::Step >;
	addExtern<DAS_CALL_METHOD(_method_46)>(*this,lib,"Step",SideEffects::worstDefault,"das_call_member< bool (ImGuiListClipper::*)() , &ImGuiListClipper::Step >::invoke")
		->args({"self"});
	addCtorAndUsing<ImDrawCmd>(*this,lib,"ImDrawCmd","ImDrawCmd");
	addCtorAndUsing<ImDrawListSplitter>(*this,lib,"ImDrawListSplitter","ImDrawListSplitter");
	using _method_47 = das::das_call_member< void (ImDrawListSplitter::*)(),&ImDrawListSplitter::Clear >;
	addExtern<DAS_CALL_METHOD(_method_47)>(*this,lib,"Clear",SideEffects::worstDefault,"das_call_member< void (ImDrawListSplitter::*)() , &ImDrawListSplitter::Clear >::invoke")
		->args({"self"});
	using _method_48 = das::das_call_member< void (ImDrawListSplitter::*)(),&ImDrawListSplitter::ClearFreeMemory >;
	addExtern<DAS_CALL_METHOD(_method_48)>(*this,lib,"ClearFreeMemory",SideEffects::worstDefault,"das_call_member< void (ImDrawListSplitter::*)() , &ImDrawListSplitter::ClearFreeMemory >::invoke")
		->args({"self"});
	using _method_49 = das::das_call_member< void (ImDrawListSplitter::*)(ImDrawList *,int),&ImDrawListSplitter::Split >;
	addExtern<DAS_CALL_METHOD(_method_49)>(*this,lib,"Split",SideEffects::worstDefault,"das_call_member< void (ImDrawListSplitter::*)(ImDrawList *,int) , &ImDrawListSplitter::Split >::invoke")
		->args({"self","draw_list","count"});
	using _method_50 = das::das_call_member< void (ImDrawListSplitter::*)(ImDrawList *),&ImDrawListSplitter::Merge >;
	addExtern<DAS_CALL_METHOD(_method_50)>(*this,lib,"Merge",SideEffects::worstDefault,"das_call_member< void (ImDrawListSplitter::*)(ImDrawList *) , &ImDrawListSplitter::Merge >::invoke")
		->args({"self","draw_list"});
	using _method_51 = das::das_call_member< void (ImDrawListSplitter::*)(ImDrawList *,int),&ImDrawListSplitter::SetCurrentChannel >;
	addExtern<DAS_CALL_METHOD(_method_51)>(*this,lib,"SetCurrentChannel",SideEffects::worstDefault,"das_call_member< void (ImDrawListSplitter::*)(ImDrawList *,int) , &ImDrawListSplitter::SetCurrentChannel >::invoke")
		->args({"self","draw_list","channel_idx"});
	addCtorAndUsing<ImDrawList,const ImDrawListSharedData *>(*this,lib,"ImDrawList","ImDrawList")
		->args({"shared_data"});
	using _method_52 = das::das_call_member< void (ImDrawList::*)(ImVec2,ImVec2,bool),&ImDrawList::PushClipRect >;
	addExtern<DAS_CALL_METHOD(_method_52)>(*this,lib,"PushClipRect",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImVec2,ImVec2,bool) , &ImDrawList::PushClipRect >::invoke")
		->args({"self","clip_rect_min","clip_rect_max","intersect_with_current_clip_rect"})
		->arg_init(3,make_smart<ExprConstBool>(false));
	using _method_53 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::PushClipRectFullScreen >;
	addExtern<DAS_CALL_METHOD(_method_53)>(*this,lib,"PushClipRectFullScreen",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::PushClipRectFullScreen >::invoke")
		->args({"self"});
	using _method_54 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::PopClipRect >;
	addExtern<DAS_CALL_METHOD(_method_54)>(*this,lib,"PopClipRect",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::PopClipRect >::invoke")
		->args({"self"});
	using _method_55 = das::das_call_member< void (ImDrawList::*)(ImTextureID),&ImDrawList::PushTextureID >;
	addExtern<DAS_CALL_METHOD(_method_55)>(*this,lib,"PushTextureID",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)(ImTextureID) , &ImDrawList::PushTextureID >::invoke")
		->args({"self","texture_id"});
	using _method_56 = das::das_call_member< void (ImDrawList::*)(),&ImDrawList::PopTextureID >;
	addExtern<DAS_CALL_METHOD(_method_56)>(*this,lib,"PopTextureID",SideEffects::worstDefault,"das_call_member< void (ImDrawList::*)() , &ImDrawList::PopTextureID >::invoke")
		->args({"self"});
	using _method_57 = das::das_call_member< ImVec2 (ImDrawList::*)() const,&ImDrawList::GetClipRectMin >;
	addExtern<DAS_CALL_METHOD(_method_57)>(*this,lib,"GetClipRectMin",SideEffects::worstDefault,"das_call_member< ImVec2 (ImDrawList::*)() const , &ImDrawList::GetClipRectMin >::invoke")
		->args({"self"});
	using _method_58 = das::das_call_member< ImVec2 (ImDrawList::*)() const,&ImDrawList::GetClipRectMax >;
	addExtern<DAS_CALL_METHOD(_method_58)>(*this,lib,"GetClipRectMax",SideEffects::worstDefault,"das_call_member< ImVec2 (ImDrawList::*)() const , &ImDrawList::GetClipRectMax >::invoke")
		->args({"self"});
}
}

