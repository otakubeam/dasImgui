require daslib/cpp_gen

[export]
def main

    // configure

    blocked_type_names <- [{auto[]
        "ImVector";
        "ImGuiStoragePair";
        "ImDrawListSharedData";
        "ImGuiInputTextCallback"
    }]

    blocked_functions <- [{auto[]
        "operator delete";
        "operator new"
    }]

    cmres_functions <- [{auto[]
        "ImGui_ImplVulkanH_SelectSurfaceFormat"
    }]

    // generate

    var args <- get_command_line_arguments()
    bindHeaders(args[3], args[4])
