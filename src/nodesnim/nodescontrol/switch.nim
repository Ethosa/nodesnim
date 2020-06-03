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

    on_toggle*: proc(self: SwitchPtr, toggled: bool): void  ## This called when switch toggled.
  SwitchPtr* = ptr SwitchObj


proc Switch*(name: string, variable: var SwitchObj): SwitchPtr =
  ## Creates a new Switch pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a SwitchObj variable
  runnableExamples:
    var
      colorrect1_obj: SwitchObj
      colorrect1 = Switch("Switch", colorrect1_obj)
  nodepattern(SwitchObj)
  controlpattern()
  variable.color_disable = Color(0.4, 0.4, 0.4)
  variable.color_enable = Color(0.4, 0.8, 0.4)
  variable.back_disable = Color(0.16, 0.16, 0.16)
  variable.back_enable = Color(0.16, 0.36, 0.16)
  variable.value = false
  variable.rect_size.x = 50
  variable.rect_size.y = 20
  variable.on_toggle = proc(self: SwitchPtr, toggled: bool) = discard
  variable.kind = COLOR_RECT_NODE

proc Switch*(obj: var SwitchObj): SwitchPtr {.inline.} =
  ## Creates a new Switch pointer with default node name "Switch".
  ##
  ## Arguments:
  ## - `variable` is a SwitchObj variable
  runnableExamples:
    var
      colorrect1_obj: SwitchObj
      colorrect1 = Switch(colorrect1_obj)
  Switch("Switch", obj)


method draw*(self: SwitchPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
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
    self.on_press(self, last_event.x, last_event.y)


method duplicate*(self: SwitchPtr, obj: var SwitchObj): SwitchPtr {.base.} =
  ## Duplicates Switch object and create a new Switch pointer.
  obj = self[]
  obj.addr


method handle*(self: SwitchPtr, event: InputEvent, mouse_on: var NodePtr) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.hovered and event.kind == MOUSE and event.pressed:
    self.value = not self.value
    self.on_toggle(self, self.value)


method toggle*(self: SwitchPtr) {.base.} =
  ## Toggles value.
  self.value = not self.value
