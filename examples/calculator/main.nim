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
buttons.addChilds(
  button_7, button_8, button_9, button_add,
  button_4, button_5, button_6, button_sub,
  button_1, button_2, button_3, button_mul,
  button_0, button_00, button_div, button_eq)


proc number(self: ButtonRef, x, y: float) =
  if sign == "":
    first &= self.text
  else:
    second &= self.text

proc on_sign(self: ButtonRef, x, y: float) =
  if first != "":
    sign = self.text


button_7.text = "7"
button_8.text = "8"
button_9.text = "9"
button_add.text = "+"
button_4.text = "4"
button_5.text = "5"
button_6.text = "6"
button_sub.text = "-"
button_1.text = "1"
button_2.text = "2"
button_3.text = "3"
button_mul.text = "*"
button_div.text = "/"

button_1.on_touch = number
button_2.on_touch = number
button_3.on_touch = number
button_4.on_touch = number
button_5.on_touch = number
button_6.on_touch = number
button_7.on_touch = number
button_8.on_touch = number
button_9.on_touch = number
button_add.on_touch = on_sign
button_sub.on_touch = on_sign
button_mul.on_touch = on_sign
button_div.on_touch = on_sign


button_0.text = "0"
button_0.on_touch =
  proc(self: ButtonRef, x, y: float) =
    if sign == "" and first != "":
      first &= "0"
    elif sign != "/":
      second &= "0"

button_00.text = "00"
button_00.on_touch =
  proc(self: ButtonRef, x, y: float) =
    if sign == "" and first != "":
      first &= "00"
    elif second != "":
      second &= "00"


button_eq.text = "="
button_eq.on_touch =
  proc(self: ButtonRef, x, y: float) =
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
result.on_process =
  proc(self: NodeRef) =
    if sign == "":
      result.text = first
    elif second == "":
      result.text = first & " " & sign
    else:
      result.text = first & " " & sign & " " & second


addScene(main)
setMainScene("Main")
windowLaunch()
