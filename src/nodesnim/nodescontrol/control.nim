# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,

  ../nodes/node,
  ../nodes/canvas


type
  ControlObj* = object of CanvasObj
    hovered*: bool
    pressed*: bool
    focused*: bool

    mouse_enter*: proc(x, y: float): void
    mouse_exit*: proc(x, y: float): void
    click*: proc(x, y: float): void
    press*: proc(x, y: float): void
    release*: proc(x, y: float): void
    focus*: proc(): void
    unfocus*: proc(): void
  ControlPtr* = ptr ControlObj


template controlpattern*: untyped =
  variable.hovered = false
  variable.focused = false
  variable.pressed = false

  variable.mouse_enter = proc(x, y: float) = discard
  variable.mouse_exit = proc(x, y: float) = discard
  variable.click = proc(x, y: float) = discard
  variable.press = proc(x, y: float) = discard
  variable.release = proc(x, y: float) = discard
  variable.focus = proc() = discard
  variable.unfocus = proc() = discard

proc Control*(name: string, variable: var ControlObj): ControlPtr =
  nodepattern(ControlObj)
  controlpattern()

proc Control*(obj: var ControlObj): ControlPtr {.inline.} =
  Control("Control", obj)


method calcPositionAnchor*(self: ControlPtr) =
  if self.parent != nil:
    self.position.x = self.parent.rect_size.x*self.anchor.x1 - self.rect_size.x*self.anchor.x2
    self.position.y = self.parent.rect_size.y*self.anchor.y1 - self.rect_size.y*self.anchor.y2

method draw*(self: ControlPtr, w, h: GLfloat) =
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()
  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method handle*(self: ControlPtr, event: InputEvent, mouse_on: var NodePtr) =
  {.warning[LockLevel]: off.}
  let hasmouse = Rect2(self.global_position, self.rect_size).hasPoint(event.x, event.y)
  if mouse_on == nil and hasmouse:
    mouse_on = self
    # Hover
    if not self.hovered:
      self.mouse_enter(event.x, event.y)
      self.hovered = true
    else:
      self.mouse_exit(event.x, event.y)
      self.hovered = false
    # Focus
    if not self.focused:
      self.focused = true
      self.focus()
    # Click
    if mouse_pressed and not self.pressed:
      self.pressed = true
      self.click(event.x, event.y)
  # Unfocus
  if self.focused:
    self.unfocus()
  if not mouse_pressed and self.pressed:
    self.pressed = false
    self.release(event.x, event.y)

