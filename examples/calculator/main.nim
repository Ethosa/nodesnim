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
  if second == "":
    return first
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
    sign = $self.text
  elif first != "":
    sign = $self.text

build:
  - Scene main:
    - Vbox vbox:
      call setSizeAnchor(1, 1)
      call setChildAnchor(0.5, 0.5, 0.5, 0.5)
      - Label result:
        call setTextAlign(1, 0, 1, 0)
        call resize(160, 32)
      - GridBox buttons:
        call setRow(4)
        - Button button_1(text: stext"1", on_touch: number)
        - Button button_2(text: stext"2", on_touch: number)
        - Button button_3(text: stext"3", on_touch: number)
        - Button button_add(text: stext"+", on_touch: on_sign)
        - Button button_4(text: stext"4", on_touch: number)
        - Button button_5(text: stext"5", on_touch: number)
        - Button button_6(text: stext"6", on_touch: number)
        - Button button_sub(text: stext"-", on_touch: on_sign)
        - Button button_7(text: stext"7", on_touch: number)
        - Button button_8(text: stext"8", on_touch: number)
        - Button button_9(text: stext"9", on_touch: number)
        - Button button_mul(text: stext"x", on_touch: on_sign)
        - Button button_0(text: stext"0")
        - Button button_00(text: stext"00")
        - Button button_div(text: stext"/", on_touch: on_sign)
        - Button button_eq:
          text: stext"="


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
    result.setText(first)
  elif second == "":
    result.setText(first & " " & sign)
  else:
    result.setText(first & " " & sign & " " & second)

addMainScene(main)
windowLaunch()
