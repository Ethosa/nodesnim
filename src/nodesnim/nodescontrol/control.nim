# author: Ethosa
## The base of other Control nodes.
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

    on_mouse_enter*: proc(self: ControlPtr, x, y: float): void  ## This called when the mouse enters the Control node.
    on_mouse_exit*: proc(self: ControlPtr, x, y: float): void   ## This called when the mouse exit from the Control node.
    on_click*: proc(self: ControlPtr, x, y: float): void        ## This called when the user clicks on the Control node.
    on_press*: proc(self: ControlPtr, x, y: float): void        ## This called when the user holds on the mouse on the Control node.
    on_release*: proc(self: ControlPtr, x, y: float): void      ## This called when the user no more holds on the mouse.
    on_focus*: proc(self: ControlPtr): void                   ## This called when the Control node gets focus.
    on_unfocus*: proc(self: ControlPtr): void                 ## This called when the Control node loses focus.
  ControlPtr* = ptr ControlObj


template controlpattern*: untyped =
  variable.hovered = false
  variable.focused = false
  variable.pressed = false

  variable.mousemode = MOUSEMODE_SEE
  variable.background_color = Color()

  variable.on_mouse_enter = proc(self: ControlPtr, x, y: float) = discard
  variable.on_mouse_exit = proc(self: ControlPtr, x, y: float) = discard
  variable.on_click = proc(self: ControlPtr, x, y: float) = discard
  variable.on_press = proc(self: ControlPtr, x, y: float) = discard
  variable.on_release = proc(self: ControlPtr, x, y: float) = discard
  variable.on_focus = proc(self: ControlPtr) = discard
  variable.on_unfocus = proc(self: ControlPtr) = discard

proc Control*(name: string, variable: var ControlObj): ControlPtr =
  ## Creates a new Control pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a ControlObj variable.
  runnableExamples:
    var
      ctrl_obj: ControlObj
      ctrl = Control("Control", ctrl_obj)
  nodepattern(ControlObj)
  controlpattern()
  variable.kind = CONTROL_NODE

proc Control*(obj: var ControlObj): ControlPtr {.inline.} =
  ## Creates a new Control pointer with deffault node name "Control".
  ##
  ## Arguments:
  ## - `variable` is a ControlObj variable.
  runnableExamples:
    var
      ctrl_obj: ControlObj
      ctrl = Control(ctrl_obj)
  Control("Control", obj)


method calcPositionAnchor*(self: ControlPtr) =
  ## Calculates node position. This uses in the `scene.nim`.
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
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: ControlPtr, obj: var ControlObj): ControlPtr {.base.} =
  ## Duplicates Control object and create a new Control pointer.
  obj = self[]
  obj.addr

method getGlobalMousePosition*(self: ControlPtr): Vector2Ref {.base, inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)

method handle*(self: ControlPtr, event: InputEvent, mouse_on: var NodePtr) =
  ## Handles user input. This uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  if self.mousemode == MOUSEMODE_IGNORE:
    return
  let
    hasmouse = Rect2(self.global_position, self.rect_size).contains(event.x, event.y)
    click = mouse_pressed and event.kind == MOUSE
  if mouse_on == nil and hasmouse:
    mouse_on = self
    # Hover
    if not self.hovered:
      self.on_mouse_enter(self, event.x, event.y)
      self.hovered = true
    # Focus
    if not self.focused and click:
      self.focused = true
      self.on_focus(self)
    # Click
    if mouse_pressed and not self.pressed:
      self.pressed = true
      self.on_click(self, event.x, event.y)
  elif not hasmouse or mouse_on != self:
    if not mouse_pressed and self.hovered:
      self.on_mouse_exit(self, event.x, event.y)
      self.hovered = false
    # Unfocus
    if self.focused and click:
      self.on_unfocus(self)
      self.focused = false
  if not mouse_pressed and self.pressed:
    self.pressed = false
    self.on_release(self, event.x, event.y)

method setBackgroundColor*(self: ControlPtr, color: ColorRef) {.base.} =
  ## Changes Control background color.
  self.background_color = color
