import nodesnim
import strutils


Window("Calc")

var
  main_obj: SceneObj
  main = Scene("Main", main_obj)

  first: string = ""
  second: string = ""
  sign: string = ""

  vbox_obj: VBoxObj
  vbox = VBox(vbox_obj)

  result_obj: LabelObj
  result = Label("Result", result_obj)

  buttons_obj: GridBoxObj
  buttons = GridBox("Buttons", buttons_obj)

  button_7_obj: ButtonObj
  button_8_obj: ButtonObj
  button_9_obj: ButtonObj
  button_4_obj: ButtonObj
  button_5_obj: ButtonObj
  button_6_obj: ButtonObj
  button_1_obj: ButtonObj
  button_2_obj: ButtonObj
  button_3_obj: ButtonObj
  button_0_obj: ButtonObj
  button_00_obj: ButtonObj
  button_add_obj: ButtonObj
  button_sub_obj: ButtonObj
  button_mul_obj: ButtonObj
  button_div_obj: ButtonObj
  button_eq_obj: ButtonObj
  button_7 = Button("Button 7", button_7_obj)
  button_8 = Button("Button 8", button_8_obj)
  button_9 = Button("Button 9", button_9_obj)
  button_4 = Button("Button 4", button_4_obj)
  button_5 = Button("Button 5", button_5_obj)
  button_6 = Button("Button 6", button_6_obj)
  button_1 = Button("Button 1", button_1_obj)
  button_2 = Button("Button 2", button_2_obj)
  button_3 = Button("Button 3", button_3_obj)
  button_0 = Button("Button 0", button_0_obj)
  button_00 = Button("Button 00", button_00_obj)
  button_add = Button("Button +", button_add_obj)
  button_sub = Button("Button -", button_sub_obj)
  button_mul = Button("Button *", button_mul_obj)
  button_div = Button("Button /", button_div_obj)
  button_eq = Button("Button =", button_eq_obj)

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


proc number(self: ButtonPtr, x, y: float) =
  if sign == "":
    first &= self.text
  else:
    second &= self.text

proc on_sign(self: ButtonPtr, x, y: float) =
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
  proc(self: ButtonPtr, x, y: float) =
    if sign == "" and first != "":
      first &= "0"
    elif sign != "/":
      second &= "0"

button_00.text = "00"
button_00.on_touch =
  proc(self: ButtonPtr, x, y: float) =
    if sign == "" and first != "":
      first &= "00"
    elif second != "":
      second &= "00"


button_eq.text = "="
button_eq.on_touch =
  proc(self: ButtonPtr, x, y: float) =
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
  proc(self: NodePtr) =
    if sign == "":
      result.text = first
    elif second == "":
      result.text = first & " " & sign
    else:
      result.text = first & " " & sign & " " & second


addScene(main)
setMainScene("Main")
windowLaunch()
