options indenting = 4
options remove_unused_symbols = false

module command_que

require daslib/strings_boost

var g_que : array<lambda<():void>>

def post_event ( var evt : lambda<():void> )
    g_que |> emplace(evt)

def post_invoke_que
    for ev in g_que
        invoke(ev)
    delete g_que
