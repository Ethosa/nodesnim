# author: Ethosa
## The base of other Control nodes.
import ../thirdparty/sdl2 except Color, glBindTexture
import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,
  ../core/stylesheet,
  ../private/templates,

  ../graphics/drawable,

  ../nodes/node,
  ../nodes/canvas,
  strutils


type
  ControlXYHandler* = proc(self: ControlRef, x, y: float)
  ControlHandler* = proc(self: ControlRef)
  ControlObj* = object of CanvasObj
    hovered*: bool
    pressed*: bool
    focused*: bool

    mousemode*: MouseMode
    padding*: AnchorObj                      ## Only for Box, VBox, HBox, GridBox and Label objects!
    margin*: AnchorObj                       ## Only for HBox and VBox objects!
    background*: DrawableRef

    on_mouse_enter*: ControlXYHandler        ## This called when the mouse enters the Control node.
    on_mouse_exit*: ControlXYHandler         ## This called when the mouse exit from the Control node.
    on_click*: ControlXYHandler              ## This called when the user clicks on the Control node.
    on_press*: ControlXYHandler              ## This called when the user holds on the mouse on the Control node.
    on_release*: ControlXYHandler            ## This called when the user no more holds on the mouse.
    on_focus*: ControlHandler                ## This called when the Control node gets focus.
    on_unfocus*: ControlHandler              ## This called when the Control node loses focus.
  ControlRef* = ref ControlObj

let
  control_handler* = proc(self: ControlRef) = discard
  control_xy_handler* = proc(self: ControlRef, x, y: float) = discard

proc Control*(name: string = "Control"): ControlRef =
  ## Creates a new Control.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var ctrl = Control("Control")
  nodepattern(ControlRef)
  controlpattern()
  result.kind = CONTROL_NODE

method calcPositionAnchor*(self: ControlRef) =
  ## Calculates node position. This uses in the `scene.nim`.
  if self.parent != nil:
    if self.size_anchor.x > 0.0:
      self.rect_size.x = self.parent.CanvasRef.rect_size.x * self.size_anchor.x
    if self.size_anchor.y > 0.0:
      self.rect_size.y = self.parent.CanvasRef.rect_size.y * self.size_anchor.y
    if not self.anchor.isEmpty():
      self.position.x = self.parent.CanvasRef.rect_size.x*self.anchor.x1 - (self.rect_size.x+self.padding.x1+self.padding.x2)*self.anchor.x2
      self.position.y = self.parent.CanvasRef.rect_size.y*self.anchor.y1 - (self.rect_size.y+self.padding.y1+self.padding.y2)*self.anchor.y2

method draw*(self: ControlRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.background.draw(
    x, y, self.rect_size.x + self.padding.x1 + self.padding.x2,
    self.rect_size.y + self.padding.y1 + self.padding.y2)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: ControlRef): ControlRef {.base.} =
  ## Duplicates Control object and create a new Control.
  self.deepCopy()

method getGlobalMousePosition*(self: ControlRef): Vector2Obj {.base, inline.} =
  ## Returns mouse position.
  Vector2Obj(x: last_event.x, y: last_event.y)

method handle*(self: ControlRef, event: InputEvent, mouse_on: var NodeRef) =
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

method setBackground*(self: ControlRef, drawable: DrawableRef) {.base, inline.} =
  ## Changes background drawable.
  ##
  ## Arguments:
  ## - `drawable` - can be `DrawableRef` or `GradientDrawableRef`.
  self.background = drawable

method setBackgroundColor*(self: ControlRef, color: ColorRef) {.base, inline.} =
  ## Changes Control background color.
  self.background.setColor(color)

method setMargin*(self: ControlRef, margin: AnchorObj) {.base, inline.} =
  ## Changes Control margin.
  ##
  ## See also:
  ## - `setMargin method <#setMargin.e,ControlRef,float,float,float,float>`_
  self.margin = margin

method setMargin*(self: ControlRef, x1, y1, x2, y2: float) {.base, inline.} =
  ## Changes Control margin.
  ##
  ## Arguments:
  ## - `x1` - left margin.
  ## - `y1` - top margin.
  ## - `x2` - right margin.
  ## - `y2` - bottom margin.
  ##
  ## See also:
  ## - `setMargin method <#setMargin.e,ControlRef,AnchorObj>`_
  self.margin = Anchor(x1, y1, x2, y2)


method setPadding*(self: ControlRef, padding: AnchorObj) {.base, inline.} =
  ## Changes Control padding.
  ##
  ## See also:
  ## - `setPadding method <#setPadding.e,ControlRef,float,float,float,float>`_
  self.padding = padding

method setPadding*(self: ControlRef, x1, y1, x2, y2: float) {.base, inline.} =
  ## Changes Control padding.
  ##
  ## Arguments:
  ## - `x1` - left padding.
  ## - `y1` - top padding.
  ## - `x2` - right padding.
  ## - `y2` - bottom padding.
  ##
  ## See also:
  ## - `setPadding method <#setPadding.e,ControlRef,AnchorObj>`_
  self.padding = Anchor(x1, y1, x2, y2)

method setStyle*(self: ControlRef, style: StyleSheetRef) {.base.} =
  ## Changes control node style.
  ##
  ## Styles:
  ## - `size-anchor` - `1`, `1.0`, `0.5 1`
  ## - `position-anchor` - `1`, `0.5 1 0.5 1`
  ## - `margin` - `8`, `2 4 6 8`
  ## - `padding` - `8`, `2 4 6 8`
  self.background.setStyle(style)
  for i in style.dict:
    case i.key
    # size-anchor: 1.0
    # size-anchor: 0.5 1
    of "size-anchor":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        self.setSizeAnchor(Vector2(parseFloat(tmp[0])))
      elif tmp.len() == 2:
        self.setSizeAnchor(Vector2(parseFloat(tmp[0]), parseFloat(tmp[1])))
    # position-anchor: 1
    # position-anchor: 0.5 1 0.5 1
    of "position-anchor":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        let tmp2 = parseFloat(tmp[0])
        self.setAnchor(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setAnchor(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    # padding: 1
    # padding: 0.5 1 0.5 1
    of "padding":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        let tmp2 = parseFloat(tmp[0])
        self.setPadding(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setPadding(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    # margin: 1
    # margin: 0.5 1 0.5 1
    of "margin":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        let tmp2 = parseFloat(tmp[0])
        self.setMargin(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setMargin(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    else:
      discard
