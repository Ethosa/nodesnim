import nodesnim
import strutils


Window("Calc")

var
  first: string = ""
  second: string = ""
  sign: string = ""

proc number(self: ButtonRef, x, y: float) =
  if sign == "":
    first &= self.text
  else:
    second &= self.text

proc equal(): string =
  let f = parseFloat(first)
  result =
    case sign:
    of "+":
      $(f + parseFloat(second))
    of "-":
      $(f - parseFloat(second))
    of "x":
      $(f * parseFloat(second))
    of "/":
      $(f / parseFloat(second))
    else:
      first

proc on_sign(self: ButtonRef, x, y: float) =
  if sign != "" and second != "":
    first = equal()
    second = ""
    sign = self.text
  elif first != "":
    sign = self.text

build:
  - Scene main:
    - Vbox vbox:
      call setChildAnchor(0.5, 0.5, 0.5, 0.5)
      call setSizeAnchor(1, 1)
      - Label result:
        call setTextAlign(1, 0, 1, 0)
        call resize(160, 32)
      - GridBox buttons:
        call setRow(4)
        - Button button_7(text: "7", on_touch: number)
        - Button button_8(text: "8", on_touch: number)
        - Button button_9(text: "9", on_touch: number)
        - Button button_4(text: "4", on_touch: number)
        - Button button_5(text: "5", on_touch: number)
        - Button button_6(text: "6", on_touch: number)
        - Button button_1(text: "1", on_touch: number)
        - Button button_2(text: "2", on_touch: number)
        - Button button_3(text: "3", on_touch: number)
        - Button button_0(text: "0")
        - Button button_00(text: "00")
        - Button button_add(text: "+", on_touch: on_sign)
        # Signs
        - Button button_sub(text: "-", on_touch: on_sign)
        - Button button_mul(text: "x", on_touch: on_sign)
        - Button button_div(text: "/", on_touch: on_sign)
        - Button button_eq:
          text: "="


button_0@on_touch(self, x, y):
  if sign == "" and first != "":
    first &= "0"
  elif second != "":
    second &= "0"

button_00@on_touch(self, x, y):
  if sign == "" and first != "":
    first &= "00"
  elif second != "":
    second &= "00"


button_eq@on_touch(self, x, y):
  first = equal()
  if sign != "":
    second = ""
    sign = ""

result@on_process(self):
  if sign == "":
    result.text = first
  elif second == "":
    result.text = first & " " & sign
  else:
    result.text = first & " " & sign & " " & second

addMainScene(main)
windowLaunch()
