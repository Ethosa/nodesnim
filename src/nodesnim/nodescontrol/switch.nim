# author: Ethosa
## Displays colour rectangle.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,
  ../core/enums,

  ../nodes/node,
  control


type
  SwitchObj* = object of ControlPtr
    value*: bool
    color_enable*, color_disable*: ColorRef
    back_enable*, back_disable*: ColorRef

    on_toggle*: proc(toggled: bool): void  ## This called when switch toggled.
  SwitchPtr* = ptr SwitchObj

var switchs: seq[SwitchObj]

proc Switch*(name: string = "Switch"): SwitchPtr =
  ## Creates a new Switch pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var colorrect1 = Switch("Switch")
  var variable: SwitchObj
  nodepattern(SwitchObj)
  controlpattern()
  variable.color_disable = Color(0.4, 0.4, 0.4)
  variable.color_enable = Color(0.4, 0.8, 0.4)
  variable.back_disable = Color(0.16, 0.16, 0.16)
  variable.back_enable = Color(0.16, 0.36, 0.16)
  variable.value = false
  variable.rect_size.x = 50
  variable.rect_size.y = 20
  variable.on_toggle = proc(toggled: bool) = discard
  variable.kind = SWITCH_NODE
  switchs.add(variable)
  return addr switchs[^1]


method draw*(self: SwitchPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    color = if self.value: self.color_enable else: self.color_disable
    back = if self.value: self.back_enable else: self.back_disable

  glColor4f(back.r, back.g, back.b, back.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)

  glColor4f(color.r, color.g, color.b, color.a)
  if self.value:
    glRectf(x + self.rect_size.x - 10, y, x + self.rect_size.x, y-self.rect_size.y)
  else:
    glRectf(x, y, x + 10, y-self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)


method duplicate*(self: SwitchPtr): SwitchPtr {.base.} =
  ## Duplicates Switch object and create a new Switch pointer.
  var obj = self[]
  switchs.add(obj)
  return addr switchs[^1]


method handle*(self: SwitchPtr, event: InputEvent, mouse_on: var NodePtr) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.hovered and event.kind == MOUSE and event.pressed:
    self.value = not self.value
    self.on_toggle(self.value)


method toggle*(self: SwitchPtr) {.base.} =
  ## Toggles value.
  self.value = not self.value
