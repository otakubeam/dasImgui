[sideeffects]
def add(a,b)
    return a + b

[export]
def main
    var a = 1
    a = a + 1
    var b = 2
    b = b - 1
    var c = add(a,b)
    c ++
