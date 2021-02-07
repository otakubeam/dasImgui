require strings
require imgui_app
require daslib/glfw_boost
require daslib/imgui_boost

require safe_addr

def imgui_app ( title:string; blk : block )
    if glfwInit()==0
		panic("can't init glfw")
    var window = glfwCreateWindow(1920, 1280, title, null, null)
    if window==null
		panic("can't create window")
    glfwMakeContextCurrent(window)
    glfwSwapInterval(1)
    CreateContext(null)
    var io & = GetIO()
    io.FontGlobalScale = 2.0;   // BBATKIN: note - my monitor is HUGE
    StyleColorsDark(null)
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL2_Init()
    var clear_color = float4(0.45f, 0.55f, 0.60f, 1.00f)
    while glfwWindowShouldClose(window)==0
        glfwPollEvents()
        ImGui_ImplOpenGL2_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        invoke(blk)
        var display_w, display_h : int
        glfwGetFramebufferSize(window, display_w, display_h)
        glViewport(0, 0, display_w, display_h)
        glClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL2_RenderDrawData(GetDrawData())
        glfwMakeContextCurrent(window)
        glfwSwapBuffers(window)
    ImGui_ImplOpenGL2_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    DestroyContext(null)
    glfwDestroyWindow(window)
    glfwTerminate()

def HelpMarker(desc:string)
    TextDisabled("(?)");
    if IsItemHovered()
        BeginTooltip()
        PushTextWrapPos(GetFontSize() * 35.0f)
        TextUnformatted(desc)
        PopTextWrapPos()
        EndTooltip()

def DasShowUserGuide()
    let io & = GetIO()
    BulletText("Double-click on title bar to collapse window.")
    BulletText(
        "Click and drag on lower corner to resize window\n" +
        "(double-click to auto fit window to its contents).")
    BulletText("CTRL+Click on a slider or drag box to input value as text.")
    BulletText("TAB/SHIFT+TAB to cycle through keyboard editable fields.")
    if io.FontAllowUserScaling
        BulletText("CTRL+Mouse Wheel to zoom window contents.")
    BulletText("While inputing text:\n")
    Indent()
    BulletText("CTRL+Left/Right to word jump.")
    BulletText("CTRL+A or double-click to select all.")
    BulletText("CTRL+X/C/V to use clipboard cut/copy/paste.")
    BulletText("CTRL+Z,CTRL+Y to undo/redo.")
    BulletText("ESCAPE to revert.")
    BulletText("You can apply arithmetic operators +,*,/ on numerical values.\nUse +- to subtract.")
    Unindent()
    BulletText("With keyboard navigation enabled:")
    Indent()
    BulletText("Arrow keys to navigate.")
    BulletText("Space to activate a widget.")
    BulletText("Return to input text into a widget.")
    BulletText("Escape to deactivate a widget, close popup, exit child window.")
    BulletText("Alt to jump to the menu layer of a window.")
    BulletText("CTRL+Tab to select a window.")
    Unindent()

var show_app_main_menu_bar = false
var show_app_documents = false
var show_app_console = false
var show_app_log = false
var show_app_layout = false
var show_app_property_editor = false
var show_app_long_text = false
var show_app_auto_resize = false
var show_app_constrained_resize = false
var show_app_simple_overlay = false
var show_app_window_titles = false
var show_app_custom_rendering = false

var show_app_metrics = false
var show_app_style_editor = false
var show_app_about = false

var no_titlebar = false
var no_scrollbar = false
var no_menu = false
var no_move = false
var no_resize = false
var no_collapse = false
var no_close = false
var no_nav = false
var no_background = false
var no_bring_to_front = false


def DasShowDemoWindow ( _p_open : bool? )

    var p_open = _p_open

    var window_flags : ImGuiWindowFlags
    if no_titlebar
        window_flags |= ImGuiWindowFlags NoTitleBar
    if no_scrollbar
        window_flags |= ImGuiWindowFlags NoScrollbar
    if !no_menu
        window_flags |= ImGuiWindowFlags MenuBar
    if no_move
        window_flags |= ImGuiWindowFlags NoMove
    if no_resize
        window_flags |= ImGuiWindowFlags NoResize
    if no_collapse
        window_flags |= ImGuiWindowFlags NoCollapse
    if no_nav
        window_flags |= imgui_boost::ImGuiWindowFlags_NoNav
    if no_background
        window_flags |= ImGuiWindowFlags NoBackground
    if no_bring_to_front
        window_flags |= ImGuiWindowFlags NoBringToFrontOnFocus
    if no_close
        p_open = null

    SetNextWindowPos( ImVec2(650., 20.), ImGuiCond FirstUseEver)
    SetNextWindowSize( ImVec2(550., 680.), ImGuiCond FirstUseEver)

    if !Begin("Dear ImGui Demo", p_open, window_flags)
        End()

    PushItemWidth(GetFontSize() * -12.)

    // Menu Bar
    if BeginMenuBar()
        if BeginMenu("Menu")
            ShowExampleMenuFile()
            EndMenu()
        if BeginMenu("Examples")
            MenuItem("Main menu bar", show_app_main_menu_bar)
            MenuItem("Console", show_app_console)
            MenuItem("Log", show_app_log)
            MenuItem("Simple layout", show_app_layout)
            MenuItem("Property editor", show_app_property_editor)
            MenuItem("Long text display", show_app_long_text)
            MenuItem("Auto-resizing window", show_app_auto_resize)
            MenuItem("Constrained-resizing window", show_app_constrained_resize)
            MenuItem("Simple overlay", show_app_simple_overlay)
            MenuItem("Manipulating window titles", show_app_window_titles)
            MenuItem("Custom rendering", show_app_custom_rendering)
            MenuItem("Documents", show_app_documents)
            EndMenu()
        if BeginMenu("Tools")
            MenuItem("Metrics/Debugger", show_app_metrics)
            MenuItem("Style Editor", show_app_style_editor)
            MenuItem("About Dear ImGui", show_app_about)
            EndMenu();
        EndMenuBar();

    Text("dear imgui says hello. {IMGUI_VERSION}")
    Spacing()

    if CollapsingHeader("Help")
        Text("ABOUT THIS DEMO:")
        BulletText("Sections below are demonstrating many aspects of the library.")
        BulletText("The \"Examples\" menu above leads to more demo contents.")
        BulletText("The \"Tools\" menu above gives access to: About Box, Style Editor,\n" +
                          "and Metrics/Debugger (general purpose Dear ImGui debugging tool).")
        Separator()
        Text("PROGRAMMER GUIDE:")
        BulletText("See the ShowDemoWindow() code in imgui_demo.cpp. <- you are here!")
        BulletText("See comments in imgui.cpp.")
        BulletText("See example applications in the examples/ folder.")
        BulletText("Read the FAQ at http://www.dearimgui.org/faq/")
        BulletText("Set 'io.ConfigFlags |= NavEnableKeyboard' for keyboard controls.")
        BulletText("Set 'io.ConfigFlags |= NavEnableGamepad' for gamepad controls.")
        Separator()
        Text("USER GUIDE:")
        DasShowUserGuide()

    if CollapsingHeader("Configuration")
        var io & = GetIO()
        if TreeNode("Configuration##2")
            CheckboxFlags("io.ConfigFlags: NavEnableKeyboard", io.ConfigFlags,ImGuiConfigFlags NavEnableKeyboard)
            SameLine(); HelpMarker("Enable keyboard controls.")
            CheckboxFlags("io.ConfigFlags: NavEnableGamepad", io.ConfigFlags, ImGuiConfigFlags NavEnableGamepad)
            SameLine(); HelpMarker("Enable gamepad controls. Require backend to set io.BackendFlags |= ImGuiBackendFlags_HasGamepad.\n\nRead instructions in imgui.cpp for details.")
            CheckboxFlags("io.ConfigFlags: NavEnableSetMousePos", io.ConfigFlags, ImGuiConfigFlags NavEnableSetMousePos)
            SameLine(); HelpMarker("Instruct navigation to move the mouse cursor. See comment for ImGuiConfigFlags_NavEnableSetMousePos.")
            CheckboxFlags("io.ConfigFlags: NoMouse", io.ConfigFlags, ImGuiConfigFlags NoMouse)
            var icf : ImGuiConfigFlags = ImGuiConfigFlags(io.ConfigFlags)
            if ImGuiConfigFlags(io.ConfigFlags).NoMouse
                if (float(GetTime()) % 0.40f) < 0.20f
                    SameLine()
                    Text("<<PRESS SPACE TO DISABLE>>")
                if IsKeyPressed(GetKeyIndex(ImGuiKey_ ImGuiKey_Space))
                    io.ConfigFlags &= ~int(ImGuiConfigFlags_ ImGuiConfigFlags_NoMouse);
            CheckboxFlags("io.ConfigFlags: NoMouseCursorChange", io.ConfigFlags, ImGuiConfigFlags NoMouseCursorChange)
            SameLine(); HelpMarker("Instruct backend to not alter mouse cursor shape and visibility.")
            Checkbox("io.ConfigInputTextCursorBlink", io.ConfigInputTextCursorBlink)
            SameLine(); HelpMarker("Enable blinking cursor (optional as some users consider it to be distracting)")
            Checkbox("io.ConfigDragClickToInputText", io.ConfigDragClickToInputText)
            SameLine(); HelpMarker("Enable turning DragXXX widgets into text input with a simple mouse click-release (without moving).")
            Checkbox("io.ConfigWindowsResizeFromEdges", io.ConfigWindowsResizeFromEdges)
            SameLine(); HelpMarker("Enable resizing of windows from their edges and from the lower-left corner.\nThis requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback.")
            Checkbox("io.ConfigWindowsMoveFromTitleBarOnly", io.ConfigWindowsMoveFromTitleBarOnly)
            Checkbox("io.MouseDrawCursor", io.MouseDrawCursor)
            SameLine(); HelpMarker("Instruct Dear ImGui to render a mouse cursor itself. Note that a mouse cursor rendered via your application GPU rendering path will feel more laggy than hardware cursor, but will be more in sync with your other visuals.\n\nSome desktop applications may use both kinds of cursors (e.g. enable software cursor only when resizing/dragging something).")
            Text("Also see Style->Rendering for rendering options.")
            TreePop()
            Separator()
        if TreeNode("Backend Flags")
            HelpMarker(
                "Those flags are set by the backends (imgui_impl_xxx files) to specify their capabilities.\n" +
                "Here we expose then as read-only fields to avoid breaking interactions with your backend.")
            // Make a local copy to avoid modifying actual backend flags.
            var backend_flags = io.BackendFlags
            CheckboxFlags("io.BackendFlags: HasGamepad", backend_flags, ImGuiBackendFlags HasGamepad)
            CheckboxFlags("io.BackendFlags: HasMouseCursors", backend_flags, ImGuiBackendFlags HasMouseCursors)
            CheckboxFlags("io.BackendFlags: HasSetMousePos", backend_flags, ImGuiBackendFlags HasSetMousePos)
            CheckboxFlags("io.BackendFlags: RendererHasVtxOffset", backend_flags, ImGuiBackendFlags RendererHasVtxOffset)
            TreePop()
            Separator()
        if TreeNode("Style")
            HelpMarker("The same contents can be accessed in 'Tools->Style Editor' or by calling the ShowStyleEditor() function.")
            ShowStyleEditor()
            TreePop()
            Separator()
        if TreeNode("Capture/Logging")
            HelpMarker(
                "The logging API redirects all text output so you can easily capture the content of " +
                "a window or a block. Tree nodes can be automatically expanded.\n" +
                "Try opening any of the contents below in this window and then click one of the \"Log To\" button.")
            LogButtons()
            HelpMarker("You can also call LogText() to output directly to the log without a visual output.")
            if Button("Copy \"Hello, world!\" to clipboard")
                LogToClipboard()
                LogText("Hello, world!")
                LogFinish()
            TreePop()

    if CollapsingHeader("Window options")
        if BeginTable("split", 3)
            TableNextColumn()
            Checkbox("No titlebar", no_titlebar)
            TableNextColumn()
            Checkbox("No scrollbar", no_scrollbar)
            TableNextColumn()
            Checkbox("No menu", no_menu)
            TableNextColumn()
            Checkbox("No move", no_move)
            TableNextColumn()
            Checkbox("No resize", no_resize)
            TableNextColumn()
            Checkbox("No collapse", no_collapse)
            TableNextColumn()
            Checkbox("No close", no_close)
            TableNextColumn()
            Checkbox("No nav", no_nav)
            TableNextColumn()
            Checkbox("No background", no_background)
            TableNextColumn()
            Checkbox("No bring to front", no_bring_to_front)
            EndTable()

    /*
    ShowDemoWindowWidgets()
    ShowDemoWindowLayout()
    */
    ShowDemoWindowPopups()
    /*
    ShowDemoWindowTables()
    ShowDemoWindowMisc()
    */

    PopItemWidth()
    End()

var ShowDemoWindowPopups_selected_fish = -1
var ShowDemoWindowPopups_toggles <- [{bool[] true; false; false; false; false}]
let ShowDemoWindowPopups_names <- [{auto[] "Bream"; "Haddock"; "Mackerel"; "Pollock"; "Tilefish"}]
var ShowDemoWindowPopups_value = 0.5f
var ShowDemoWindowPopups_name = reserve_string_buffer("Label1", 32)

def ShowDemoWindowPopups()
    if !CollapsingHeader("Popups & Modal windows")
        return

    if TreeNode("Popups")
        TextWrapped(
            "When a popup is active, it inhibits interacting with windows that are behind the popup. " +
            "Clicking outside the popup closes it.")

        if Button("Select..")
            OpenPopup("my_select_popup")
        SameLine()
        TextUnformatted(ShowDemoWindowPopups_selected_fish == -1 ? "<None>" : ShowDemoWindowPopups_names[ShowDemoWindowPopups_selected_fish])
        if BeginPopup("my_select_popup")
            Text("Aquarium")
            Separator()
            for name,i in ShowDemoWindowPopups_names,range(100500)
                if Selectable(name)
                    ShowDemoWindowPopups_selected_fish = i
            EndPopup()
        if Button("Toggle..")
            OpenPopup("my_toggle_popup")
        if BeginPopup("my_toggle_popup")
            for name,toggle in ShowDemoWindowPopups_names,ShowDemoWindowPopups_toggles
                imgui_boost::MenuItem(name, "", toggle)
            if BeginMenu("Sub-menu")
                MenuItem("Click me")
                EndMenu()
            Separator()
            Text("Tooltip here")
            if IsItemHovered()
                SetTooltip("I am a tooltip over a popup")
            if Button("Stacked Popup")
                OpenPopup("another popup")
            if BeginPopup("another popup")
                for name,toggle in ShowDemoWindowPopups_names,ShowDemoWindowPopups_toggles
                    imgui_boost::MenuItem(name, "", toggle);
                if BeginMenu("Sub-menu")
                    MenuItem("Click me")
                    if Button("Stacked Popup")
                        OpenPopup("another popup")
                    if BeginPopup("another popup")
                        Text("I am the last one here.")
                        EndPopup()
                    EndMenu()
                EndPopup()
            EndPopup()

        if Button("File Menu..")
            OpenPopup("my_file_popup")
        if BeginPopup("my_file_popup")
            ShowExampleMenuFile()
            EndPopup()
        TreePop()

    if TreeNode("Context menus")
        Text("Value = {ShowDemoWindowPopups_value} (<-- right-click here)")
        if BeginPopupContextItem("item context menu")
            if Selectable("Set to zero")
                ShowDemoWindowPopups_value = 0.0f
            if Selectable("Set to PI")
                ShowDemoWindowPopups_value = 3.1415f
            SetNextItemWidth(-1.)
            DragFloat("##Value", safe_addr(ShowDemoWindowPopups_value), 0.1f, 0.0f, 0.0f)
            EndPopup()
        Text("(You can also right-click me to open the same popup as above.)");
        OpenPopupOnItemClick("item context menu", 1);
        var buf = "Button: {ShowDemoWindowPopups_name}"
        Button(buf)
        if BeginPopupContextItem()
            Text("Edit name:");
            InputText("##edit", ShowDemoWindowPopups_name, 32)
            if Button("Close")
                CloseCurrentPopup()
            EndPopup()
        SameLine()
        Text("(<-- right-click here)")
        TreePop()

/*

    if (TreeNode("Modals"))
    {
        TextWrapped("Modal windows are like popups but the user cannot close them by clicking outside.");

        if (Button("Delete.."))
            OpenPopup("Delete?");

        // Always center this window when appearing
        ImVec2 center(GetIO().DisplaySize.x * 0.5f, GetIO().DisplaySize.y * 0.5f);
        SetNextWindowPos(center, ImGuiCond_Appearing, ImVec2(0.5f, 0.5f));

        if (BeginPopupModal("Delete?", NULL, ImGuiWindowFlags_AlwaysAutoResize))
        {
            Text("All those beautiful files will be deleted.\nThis operation cannot be undone!\n\n");
            Separator();

            //static int unused_i = 0;
            //Combo("Combo", &unused_i, "Delete\0Delete harder\0");

            static bool dont_ask_me_next_time = false;
            PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0, 0));
            Checkbox("Don't ask me next time", &dont_ask_me_next_time);
            PopStyleVar();

            if (Button("OK", ImVec2(120, 0))) { CloseCurrentPopup(); }
            SetItemDefaultFocus();
            SameLine();
            if (Button("Cancel", ImVec2(120, 0))) { CloseCurrentPopup(); }
            EndPopup();
        }

        if (Button("Stacked modals.."))
            OpenPopup("Stacked 1");
        if (BeginPopupModal("Stacked 1", NULL, ImGuiWindowFlags_MenuBar))
        {
            if (BeginMenuBar())
            {
                if (BeginMenu("File"))
                {
                    if (MenuItem("Some menu item")) {}
                    EndMenu();
                }
                EndMenuBar();
            }
            Text("Hello from Stacked The First\nUsing style.Colors[ImGuiCol_ModalWindowDimBg] behind it.");

            // Testing behavior of widgets stacking their own regular popups over the modal.
            static int item = 1;
            static float color[4] = { 0.4f, 0.7f, 0.0f, 0.5f };
            Combo("Combo", &item, "aaaa\0bbbb\0cccc\0dddd\0eeee\0\0");
            ColorEdit4("color", color);

            if (Button("Add another modal.."))
                OpenPopup("Stacked 2");

            // Also demonstrate passing a bool* to BeginPopupModal(), this will create a regular close button which
            // will close the popup. Note that the visibility state of popups is owned by imgui, so the input value
            // of the bool actually doesn't matter here.
            bool unused_open = true;
            if (BeginPopupModal("Stacked 2", &unused_open))
            {
                Text("Hello from Stacked The Second!");
                if (Button("Close"))
                    CloseCurrentPopup();
                EndPopup();
            }

            if (Button("Close"))
                CloseCurrentPopup();
            EndPopup();
        }

        TreePop();
    }

    if (TreeNode("Menus inside a regular window"))
    {
        TextWrapped("Below we are testing adding menu items to a regular window. It's rather unusual but should work!");
        Separator();

        // Note: As a quirk in this very specific example, we want to differentiate the parent of this menu from the
        // parent of the various popup menus above. To do so we are encloding the items in a PushID()/PopID() block
        // to make them two different menusets. If we don't, opening any popup above and hovering our menu here would
        // open it. This is because once a menu is active, we allow to switch to a sibling menu by just hovering on it,
        // which is the desired behavior for regular menus.
        PushID("foo");
        MenuItem("Menu item", "CTRL+M");
        if (BeginMenu("Menu inside a regular window"))
        {
            ShowExampleMenuFile();
            EndMenu();
        }
        PopID();
        Separator();
        TreePop();
    }
}
*/

var ShowExampleMenuFile_enabled = true
var ShowExampleMenuFile_f = 0.5f
var ShowExampleMenuFile_n = 0
var ShowExampleMenuFile_b = true

def ShowExampleMenuFile()
    MenuItem("(demo menu)", "", false, false)
    if MenuItem("New")
        pass
    if MenuItem("Open", "Ctrl+O")
        pass
    if BeginMenu("Open Recent")
        MenuItem("fish_hat.c")
        MenuItem("fish_hat.inl")
        MenuItem("fish_hat.h")
        if BeginMenu("More..")
            MenuItem("Hello")
            MenuItem("Sailor")
            if BeginMenu("Recurse..")
                ShowExampleMenuFile()
                EndMenu()
            EndMenu()
        EndMenu()
    if MenuItem("Save", "Ctrl+S")
        pass
    if MenuItem("Save As..")
        pass

    Separator()
    if BeginMenu("Options")
        imgui_boost::MenuItem("Enabled", "", ShowExampleMenuFile_enabled);
        BeginChild("child", ImVec2(0., 60.), true)
        for i in range(1)
            Text("Scrolling Text {i}");
        EndChild()
        SliderFloat("Value", ShowExampleMenuFile_f, 0.0f, 1.0f)
        InputFloat("Input", ShowExampleMenuFile_f, 0.1f)
        Combo("Combo", ShowExampleMenuFile_n, [[auto "Yes";"No";"Maybe"]])
        EndMenu()

    if BeginMenu("Colors")
        let sz = GetTextLineHeight();
        for col,i in range(100500),each_enum(type<ImGuiCol_>)
            if i == ImGuiCol_ ImGuiCol_COUNT
                continue
            let name = GetStyleColorName(col)
            let p = GetCursorScreenPos()
            // GetWindowDrawList()->AddRectFilled(p, ImVec2(p.x + sz, p.y + sz), GetColorU32((ImGuiCol)i));
            Dummy(ImVec2(sz, sz))
            SameLine()
            MenuItem(name)
        EndMenu()

    if BeginMenu("Options") // <-- Append!
        Checkbox("SomeOption", ShowExampleMenuFile_b)
        EndMenu()

    if BeginMenu("Disabled", false)
        assert(false)
    if MenuItem("Checked", "", true)
        pass
    if MenuItem("Quit", "Alt+F4")
        pass

[export]
def main
	var f = 0.0
	imgui_app("Testing IMGUI") <|
        NewFrame()
        // imgui::ShowDemoWindow(null)
        DasShowDemoWindow(null)
        Render()

