# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  ../nodes/canvas


type
  ControlObj* = object of CanvasObj
    hovered*: bool
    pressed*: bool
    focused*: bool

    mousemode*: MouseMode
    background_color*: ColorRef

    mouse_enter*: proc(x, y: float): void  ## This called when the mouse enters the Control node.
    mouse_exit*: proc(x, y: float): void   ## This called when the mouse exit from the Control node.
    click*: proc(x, y: float): void        ## This called when the user clicks on the Control node.
    press*: proc(x, y: float): void        ## This called when the user holds on the mouse on the Control node.
    release*: proc(x, y: float): void      ## This called when the user no more holds on the mouse.
    focus*: proc(): void                   ## This called when the Control node gets focus.
    unfocus*: proc(): void                 ## This called when the Control node loses focus.
  ControlPtr* = ptr ControlObj


template controlpattern*: untyped =
  variable.hovered = false
  variable.focused = false
  variable.pressed = false

  variable.mousemode = MOUSEMODE_SEE
  variable.background_color = Color()

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
    if self.can_use_size_anchor:
      if self.size_anchor.x > 0.0:
        self.rect_size.x = self.parent.rect_size.x * self.size_anchor.x
      if self.size_anchor.y > 0.0:
        self.rect_size.y = self.parent.rect_size.y * self.size_anchor.y
    if self.can_use_anchor:
      self.position.x = self.parent.rect_size.x*self.anchor.x1 - self.rect_size.x*self.anchor.x2
      self.position.y = self.parent.rect_size.y*self.anchor.y1 - self.rect_size.y*self.anchor.y2

method draw*(self: ControlPtr, w, h: GLfloat) =
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method getGlobalMousePosition*(self: ControlPtr): Vector2Ref {.base, inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)

method handle*(self: ControlPtr, event: InputEvent, mouse_on: var NodePtr) =
  {.warning[LockLevel]: off.}
  if self.mousemode == MOUSEMODE_IGNORE:
    return
  let
    hasmouse = Rect2(self.global_position, self.rect_size).hasPoint(event.x, event.y)
    click = mouse_pressed and event.kind == MOUSE
  if mouse_on == nil and hasmouse:
    mouse_on = self
    # Hover
    if not self.hovered:
      self.mouse_enter(event.x, event.y)
      self.hovered = true
    # Focus
    if not self.focused and click:
      self.focused = true
      self.focus()
    # Click
    if mouse_pressed and not self.pressed:
      self.pressed = true
      self.click(event.x, event.y)
  elif not hasmouse or mouse_on != self:
    if not mouse_pressed and self.hovered:
      self.mouse_exit(event.x, event.y)
      self.hovered = false
    # Unfocus
    if self.focused and click:
      self.unfocus()
      self.focused = false
  if not mouse_pressed and self.pressed:
    self.pressed = false
    self.release(event.x, event.y)

method setBackgroundColor*(self: ControlPtr, color: ColorRef) {.base.} =
  ## Changes Control background color.
  self.background_color = color
