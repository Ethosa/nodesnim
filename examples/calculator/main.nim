import nodesnim
import strutils


Window("Calc")

var
  main = Scene("Main")

  first: string = ""
  second: string = ""
  sign: string = ""

  vbox = VBox()

  result = Label("Result")

  buttons = GridBox("Buttons")

  button_7 = Button("Button 7")
  button_8 = Button("Button 8")
  button_9 = Button("Button 9")
  button_4 = Button("Button 4")
  button_5 = Button("Button 5")
  button_6 = Button("Button 6")
  button_1 = Button("Button 1")
  button_2 = Button("Button 2")
  button_3 = Button("Button 3")
  button_0 = Button("Button 0")
  button_00 = Button("Button 00")
  button_add = Button("Button +")
  button_sub = Button("Button -")
  button_mul = Button("Button *")
  button_div = Button("Button /")
  button_eq = Button("Button =")

main.addChild(vbox)
vbox.addChild(result)
vbox.addChild(buttons)
vbox.setChildAnchor(0.5, 0.5, 0.5, 0.5)
vbox.setSizeAnchor(1, 1)
buttons.setRow(4)

buttons.addChild(button_7)
button_7.text = "7"
button_7.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "7"
    else:
      second &= "7"

buttons.addChild(button_8)
button_8.text = "8"
button_8.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "8"
    else:
      second &= "8"

buttons.addChild(button_9)
button_9.text = "9"
button_9.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "9"
    else:
      second &= "9"

buttons.addChild(button_add)
button_add.text = "+"
button_add.on_click =
  proc(x, y: float) =
    sign = "+"

buttons.addChild(button_4)
button_4.text = "4"
button_4.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "4"
    else:
      second &= "4"

buttons.addChild(button_5)
button_5.text = "5"
button_5.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "5"
    else:
      second &= "5"

buttons.addChild(button_6)
button_6.text = "6"
button_6.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "6"
    else:
      second &= "6"

buttons.addChild(button_sub)
button_sub.text = "-"
button_sub.on_click =
  proc(x, y: float) =
    sign = "-"

buttons.addChild(button_1)
button_1.text = "1"
button_1.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "1"
    else:
      second &= "1"

buttons.addChild(button_2)
button_2.text = "2"
button_2.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "2"
    else:
      second &= "2"

buttons.addChild(button_3)
button_3.text = "3"
button_3.on_click =
  proc(x, y: float) =
    if sign == "":
      first &= "3"
    else:
      second &= "3"

buttons.addChild(button_mul)
button_mul.text = "*"
button_mul.on_click =
  proc(x, y: float) =
    sign = "*"

buttons.addChild(button_0)
button_0.text = "0"
button_0.on_click =
  proc(x, y: float) =
    if sign == "" and first != "":
      first &= "0"
    elif sign != "/":
      second &= "0"

buttons.addChild(button_00)
button_00.text = "00"
button_00.on_click =
  proc(x, y: float) =
    if sign == "" and first != "":
      first &= "00"
    elif second != "":
      second &= "00"

buttons.addChild(button_div)
button_div.text = "/"
button_div.on_click =
  proc(x, y: float) =
    sign = "/"

buttons.addChild(button_eq)
button_eq.text = "="
button_eq.on_click =
  proc(x, y: float) =
    first =
      if sign == "+":
        $(parseFloat(first) + parseFloat(second))
      elif sign == "-":
        $(parseFloat(first) - parseFloat(second))
      elif sign == "*":
        $(parseFloat(first) * parseFloat(second))
      elif sign == "/":
        $(parseFloat(first) / parseFloat(second))
      else:
        first
    if sign != "":
      second = ""
      sign = ""

result.setTextAlign(1, 0, 1, 0)
result.resize(160, 32)
result.process =
  proc() =
    if sign == "":
      result.text = first
    elif second == "":
      result.text = first & " " & sign
    else:
      result.text = first & " " & sign & " " & second


addScene(main)
setMainScene("Main")
windowLaunch()
