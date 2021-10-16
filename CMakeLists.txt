IF(NOT DAS_IMGUI_INCLUDED)
    SET(DAS_IMGUI_INCLUDED TRUE)
    MESSAGE(STATUS "dasImgui module included.")

	SET(DAS_IMGUI_DIR ${CMAKE_SOURCE_DIR}/modules/dasImgui)

    LIST(APPEND CMAKE_MODULE_PATH ${DAS_IMGUI_DIR})

    FIND_PACKAGE(glfw3)
    FIND_PACKAGE(Vulkan)

	ADD_DEFINITIONS(-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1)

	# imgui
	SET(imgui_INCLUDE_DIR ${DAS_IMGUI_DIR}/imgui)
	SET(DAS_IMGUI_SRC
		${imgui_INCLUDE_DIR}/imconfig.h
		${imgui_INCLUDE_DIR}/imgui.cpp
		${imgui_INCLUDE_DIR}/imgui.h
		${imgui_INCLUDE_DIR}/imgui_demo.cpp
		${imgui_INCLUDE_DIR}/imgui_draw.cpp
		${imgui_INCLUDE_DIR}/imgui_internal.h
		${imgui_INCLUDE_DIR}/imgui_tables.cpp
		${imgui_INCLUDE_DIR}/imgui_widgets.cpp
		${imgui_INCLUDE_DIR}/imstb_rectpack.h
		${imgui_INCLUDE_DIR}/imstb_textedit.h
		${imgui_INCLUDE_DIR}/imstb_truetype.h
	)

	# imnodes
	SET(imnodes_INCLUDE_DIR ${DAS_IMGUI_DIR}/imnodes)
	SET(DAS_IMNODES_SRC
		${imnodes_INCLUDE_DIR}/imnodes.cpp
		${imnodes_INCLUDE_DIR}/imnodes.h
	)

	# imgui node editor
	SET(imgui_node_editor_INCLUDE_DIR ${DAS_IMGUI_DIR}/imgui-node-editor)
	SET(DAS_IMGUI_NODE_EDITOR_SRC
		${imgui_node_editor_INCLUDE_DIR}/crude_json.cpp
		${imgui_node_editor_INCLUDE_DIR}/crude_json.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_bezier_math.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_bezier_math.inl
		${imgui_node_editor_INCLUDE_DIR}/imgui_canvas.cpp
		${imgui_node_editor_INCLUDE_DIR}/imgui_canvas.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_extra_math.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_extra_math.inl
		${imgui_node_editor_INCLUDE_DIR}/imgui_node_editor.cpp
		${imgui_node_editor_INCLUDE_DIR}/imgui_node_editor.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_node_editor_api.cpp
		${imgui_node_editor_INCLUDE_DIR}/imgui_node_editor_internal.h
		${imgui_node_editor_INCLUDE_DIR}/imgui_node_editor_internal.inl
	)

	# libDasModuleImGui
	SET(DAS_IMGUI_MODULE_SRC
		${DAS_IMGUI_DIR}/src/aot_imgui.h
		${DAS_IMGUI_DIR}/src/aot_imgui_node_editor.h
		${DAS_IMGUI_DIR}/src/need_imgui.h
		${DAS_IMGUI_DIR}/src/need_imnodes.h
		${DAS_IMGUI_DIR}/src/need_imgui_node_editor.h
		${DAS_IMGUI_DIR}/src/module_imgui.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_enums.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_ann.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_fun.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_method.cpp
		${DAS_IMGUI_DIR}/src/module_imnodes_enums.cpp
		${DAS_IMGUI_DIR}/src/module_imnodes_ann.cpp
		${DAS_IMGUI_DIR}/src/module_imnodes_fun.cpp
		${DAS_IMGUI_DIR}/src/module_imnodes_method.cpp
		${DAS_IMGUI_DIR}/src/module_imgui.h
		${DAS_IMGUI_DIR}/src/module_imgui.inc
		${DAS_IMGUI_DIR}/src/module_imgui.method.inc
		${DAS_IMGUI_DIR}/src/module_imgui.enum.inc
		${DAS_IMGUI_DIR}/src/module_imgui.enum.cpp_inc
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_types.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun1.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun2.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun3.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun4.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun5.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun6.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun7.cpp
		${DAS_IMGUI_DIR}/src/module_imgui_node_editor_fun8.cpp
		${DAS_IMGUI_DIR}/src/imgui_stub.h
		${DAS_IMGUI_DIR}/src/imnodes_stub.h
		${DAS_IMGUI_DIR}/src/imgui_node_editor_stub.h
	)

	# libDasModuleImGui split
	file(GLOB DAS_IMGUI_MODULE_SRC_SPLIT
		"${DAS_IMGUI_DIR}/src/module_imgui_split_*.cpp"
	)

	ADD_MODULE_LIB(libDasModuleImGui)
	ADD_MODULE_CPP(imgui)
	ADD_MODULE_CPP(imnodes)
	ADD_MODULE_CPP(imgui_node_editor)
	ADD_MODULE_DAS(imgui daslib imgui_boost)
	ADD_MODULE_DAS(imgui daslib imnodes_boost)
	ADD_MODULE_DAS(imgui daslib imgui_node_editor_boost)
	ADD_LIBRARY(libDasModuleImGui ${DAS_IMGUI_MODULE_SRC} ${DAS_IMGUI_MODULE_SRC_SPLIT} ${DAS_IMGUI_SRC} ${DAS_IMNODES_SRC} ${DAS_IMGUI_NODE_EDITOR_SRC})
	#TARGET_LINK_LIBRARIES(libDasModuleImGui ${imgui_LIBRARIES})
	ADD_DEPENDENCIES(libDasModuleImGui libDaScript)
	TARGET_INCLUDE_DIRECTORIES(libDasModuleImGui PUBLIC ${imgui_INCLUDE_DIR} ${imnodes_INCLUDE_DIR} ${imgui_node_editor_INCLUDE_DIR})
	SETUP_CPP11(libDasModuleImGui)
	# GENERATED IMGUI
	FIND_FILE(IMGUI_H "imgui.h" ${imgui_INCLUDE_DIR})
	DAS_CPP_BIND_AST(
		IMGUI_GENERATE
		generate_imgui.das
		${DAS_IMGUI_DIR}/src/imgui_headers.h
		${DAS_IMGUI_DIR}/src/module_imgui
		${DAS_IMGUI_DIR}/src
		${imgui_INCLUDE_DIR}
		${IMGUI_H}
	)
	IF(NOT glfw3_FOUND)
		MESSAGE(STATUS "GLFW3 not found. Not building dasImguiGLFW.")
	ELSE()
		# libDasModuleImGuiApp
		SET(DAS_IMGUI_APP_MODULE_SRC
			${DAS_IMGUI_DIR}/src/module_imgui_app.cpp
			${imgui_INCLUDE_DIR}/backends/imgui_impl_glfw.cpp
			${imgui_INCLUDE_DIR}/backends/imgui_impl_glfw.h
			${imgui_INCLUDE_DIR}/backends/imgui_impl_opengl2.cpp
			${imgui_INCLUDE_DIR}/backends/imgui_impl_opengl2.h
			${DAS_IMGUI_DIR}/example/imgui_demo.das
			${DAS_IMGUI_DIR}/example/imgui_opengl2.das
			${DAS_IMGUI_DIR}/example/imnode_editor.das
		)
		ADD_MODULE_LIB(libDasModuleImGuiApp)
		ADD_MODULE_CPP(imgui_app)
		ADD_LIBRARY(libDasModuleImGuiApp ${DAS_IMGUI_APP_MODULE_SRC})
		TARGET_LINK_LIBRARIES(libDasModuleImGuiApp ${glfw_LIBRARIES})
		ADD_DEPENDENCIES(libDasModuleImGuiApp libDaScript libDasModuleImGui)
		TARGET_INCLUDE_DIRECTORIES(libDasModuleImGuiApp PUBLIC
			${imgui_INCLUDE_DIR}
			${glfw_INCLUDE_DIR}
		)
		SETUP_CPP11(libDasModuleImGuiApp)

		# demo AOT
		add_custom_target(dasImguiOpenGL_AOT)
		SET(IMGUI_OPENGL_AOT_GENERATED_SRC)
		DAS_AOT("${DAS_IMGUI_DIR}/example/imgui_demo.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/example/imgui_opengl2.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/imgui/imgui_boost.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/imgui/imgui_node_editor_boost.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/glfw/glfw_boost.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_boost.das" IMGUI_OPENGL_AOT_GENERATED_SRC dasImguiOpenGL_AOT dasAot)
		SOURCE_GROUP_FILES("aot stub" IMGUI_OPENGL_AOT_GENERATED_SRC)

		# now, the demo
		SET(IMGUI_OPENGL_DEMO_SRC
			${DAS_IMGUI_DIR}/example/imgui_opengl_aot.cpp
			${DAS_MODULES_NEED_INC}
		)
		SOURCE_GROUP_FILES("main" IMGUI_OPENGL_DEMO_SRC)
		add_executable(dasImguiOpenGL ${IMGUI_OPENGL_DEMO_SRC} ${IMGUI_OPENGL_AOT_GENERATED_SRC} ${AOT_GENERATED_SRC})
		TARGET_LINK_LIBRARIES(dasImguiOpenGL libDaScript libDasModuleUriparser libUriParser Threads::Threads)
		ADD_DEPENDENCIES(dasImguiOpenGL libDaScript libDasModuleUriparser libUriParser)
		ADD_DEPENDENCIES(dasImguiOpenGL dasImguiOpenGL_AOT dasAotStub)
		TARGET_INCLUDE_DIRECTORIES(dasImguiOpenGL PUBLIC ${imgui_INCLUDE_DIR} ${glfw_INCLUDE_DIR} ${imnodes_INCLUDE_DIR} ${imgui_node_editor_INCLUDE_DIR})
		SETUP_CPP11(dasImguiOpenGL)
		SETUP_LTO(dasImguiOpenGL)
		ADD_EXAMPLE(dasImguiOpenGL)

		# GREYPRINT AOT
		add_custom_target(GREYPRINT_AOT)
		SET(GREYPRINT_GENERATED_SRC)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/command_que.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/greyprint.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/guid_2_id.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/instructions.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/instructions_math.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/instructions_model.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/instructions_ui.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/model.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/model_eval.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/preview.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/produce.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/greyprint/undo_stack.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		# imgui
		DAS_AOT("${DAS_IMGUI_DIR}/daslib/imgui_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/daslib/imgui_node_editor_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		# glfw
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/glfw/glfw_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		# opengl
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_state.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_ttf.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_gen.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/opengl/opengl_cache.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		# glsl
		DAS_AOT("${DAS_IMGUI_DIR}/../dasGlfw/glsl/glsl.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		# daslib
		DAS_AOT("daslib/functional.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/json.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/json_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/regex.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/regex_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/strings_boost.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		DAS_AOT("daslib/random.das" GREYPRINT_GENERATED_SRC GREYPRINT_AOT dasAot)
		SOURCE_GROUP_FILES("aot stub" GREYPRINT_GENERATED_SRC)

		# now, the demo
		SET(GREYPRINT_SRC
			${DAS_IMGUI_DIR}/greyprint/greyprint.cpp
			${DAS_MODULES_NEED_INC}
		)
		SOURCE_GROUP_FILES("main" GREYPRINT_SRC)
		add_executable(Greyprint ${GREYPRINT_SRC} ${GREYPRINT_GENERATED_SRC})
		TARGET_LINK_LIBRARIES(Greyprint libDaScript libDasModuleUriparser libUriParser Threads::Threads)
		ADD_DEPENDENCIES(Greyprint libDaScript libDasModuleUriparser libUriParser)
		ADD_DEPENDENCIES(Greyprint GREYPRINT_AOT dasAotStub)
		TARGET_INCLUDE_DIRECTORIES(Greyprint PUBLIC ${imgui_INCLUDE_DIR} ${glfw_INCLUDE_DIR} ${imnodes_INCLUDE_DIR} ${imgui_node_editor_INCLUDE_DIR})
		SETUP_CPP11(Greyprint)
		SETUP_LTO(Greyprint)
		ADD_EXAMPLE(Greyprint)

		IF ((NOT Vulkan_FOUND) OR (NOT EXISTS "${DAS_IMGUI_DIR}/../dasVulkan/include/dasVulkan/module.h"))
			MESSAGE(STATUS "Vulkan not found. Not building dasImguiVulkan.")
		ELSE()
			# libDasModuleImGuiVulkan
			SET(DAS_IMGUI_VULKAN_MODULE_SRC
				${DAS_IMGUI_DIR}/src/module_imgui_vulkan.cpp
				${imgui_INCLUDE_DIR}/backends/imgui_impl_vulkan.cpp
				${imgui_INCLUDE_DIR}/backends/imgui_impl_vulkan.h
				${DAS_IMGUI_DIR}/example/imgui_demo.das
				${DAS_IMGUI_DIR}/example/imgui_vulkan.das
			)
			ADD_MODULE_LIB(libDasModuleImGuiVulkan)
			ADD_MODULE_CPP(imgui_vulkan)
			ADD_LIBRARY(libDasModuleImGuiVulkan ${DAS_IMGUI_VULKAN_MODULE_SRC})
			TARGET_LINK_LIBRARIES(libDasModuleImGuiVulkan ${glfw_LIBRARIES})
			ADD_DEPENDENCIES(libDasModuleImGuiVulkan libDaScript libDasModuleImGui)
			TARGET_INCLUDE_DIRECTORIES(libDasModuleImGuiVulkan PUBLIC
				${imgui_INCLUDE_DIR}
				${glfw_INCLUDE_DIR}
				${Vulkan_INCLUDE_DIR})
			SETUP_CPP11(libDasModuleImGuiVulkan)

			# GENERATED IMGUI VULKAN
			DAS_CPP_BIND_AST(
				IMGUI_GENERATE_VULKAN
				generate_vulkan.das
				${imgui_INCLUDE_DIR}/backends/imgui_impl_vulkan.h
				${DAS_IMGUI_DIR}/src/module_imgui_vulkan
				${DAS_IMGUI_DIR}/src
				"${Vulkan_INCLUDE_DIR};${imgui_INCLUDE_DIR}"
				""
			)
		ENDIF()
	ENDIF()
ENDIF()
