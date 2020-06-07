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
  SwitchObj* = object of ControlRef
    value*: bool
    color_enable*, color_disable*: ColorRef
    back_enable*, back_disable*: ColorRef

    on_toggle*: proc(self: SwitchRef, toggled: bool): void  ## This called when switch toggled.
  SwitchRef* = ref SwitchObj


proc Switch*(name: string = "Switch"): SwitchRef =
  ## Creates a new Switch.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var colorrect1 = Switch("Switch")
  nodepattern(SwitchRef)
  controlpattern()
  result.color_disable = Color(0.4, 0.4, 0.4)
  result.color_enable = Color(0.4, 0.8, 0.4)
  result.back_disable = Color(0.16, 0.16, 0.16)
  result.back_enable = Color(0.16, 0.36, 0.16)
  result.value = false
  result.rect_size.x = 50
  result.rect_size.y = 20
  result.on_toggle = proc(self: SwitchRef, toggled: bool) = discard
  result.kind = COLOR_RECT_NODE


method draw*(self: SwitchRef, w, h: GLfloat) =
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


method duplicate*(self: SwitchRef): SwitchRef {.base.} =
  ## Duplicates Switch object and create a new Switch.
  self.deepCopy()


method handle*(self: SwitchRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.hovered and event.kind == MOUSE and event.pressed:
    self.value = not self.value
    self.on_toggle(self, self.value)


method toggle*(self: SwitchRef) {.base.} =
  ## Toggles value.
  self.value = not self.value
