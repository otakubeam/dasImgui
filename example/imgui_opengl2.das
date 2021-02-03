require imgui
require glfw
require imgui_app
require daslib/safe_addr
require daslib/imgui_boost


[export]
def main
	var f = 0.0
	imgui_app("Testing IMGUI") <|
        imgui::NewFrame()
        imgui::Begin("Position and color")
//        imgui::Text("Hello, world!")
        imgui::SliderFloat("float", safe_addr(f), 0.0f, 1.0f)
//        imgui::Text("This is text!")
        // imgui::ShowDemoWindow(null)
        imgui::Render()

