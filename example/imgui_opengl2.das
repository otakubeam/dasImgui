require imgui
require glfw
require imgui_app
require daslib/safe_addr
require daslib/imgui_boost


[export]
def main
	var f = 0.0
	var fp = 0.0
	imgui_app("Testing IMGUI") <|
        imgui::NewFrame()
//        imgui::Text("Hello, world!")
        imgui::SliderFloat("float", safe_addr(f), 0.0f, 1.0f, "%3f", 0)
//        imgui::Text("This is text!")
        imgui::ShowDemoWindow(null)
        imgui::Render()
		if fp != f
			fp = f
			print("{fp}\n")

