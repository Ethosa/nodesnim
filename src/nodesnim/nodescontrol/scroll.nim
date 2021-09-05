# author: Ethosa
## It provides primitive scroll box.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  ../nodes/canvas,
  ../graphics/drawable,
  control


type
  ScrollObj* = object of ControlObj
    thumb_y_has_mouse*, thumb_x_has_mouse*: bool
    thumb_width*, thumb_height*: float
    viewport_w*, viewport_h*: float
    viewport_x*, viewport_y*: float
    thumb_color*: ColorRef
    back_color*: ColorRef
  ScrollRef* = ref ScrollObj


proc Scroll*(name: string = "Scroll"): ScrollRef =
  ## Creates a new Scroll.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var sc = Scroll("Scroll")
  nodepattern(ScrollRef)
  controlpattern()
  result.rect_size.x = 256
  result.rect_size.y = 256
  result.viewport_h = 256
  result.viewport_w = 256
  result.viewport_x = 0
  result.viewport_y = 0
  result.thumb_width = 8
  result.thumb_height = 8
  result.back_color = Color(0, 0, 0, 128)
  result.thumb_color = Color(0, 0, 0, 128)
  result.thumb_y_has_mouse = false
  result.thumb_x_has_mouse = false
  result.mousemode = MOUSEMODE_IGNORE
  result.kind = SCROLL_NODE


method addChild*(self: ScrollRef, other: NodeRef) =
  ## Adds a new node in Scroll.
  ##
  ## Arguments:
  ## - `other` is other Node.
  if self.children.len() == 0:
    self.children.add(other)
    other.parent = self


method duplicate*(self: ScrollRef): ScrollRef {.base.} =
  ## Duplicates Scroll object and create a new Scroll.
  self.deepCopy()


method resize*(canvas: ScrollRef, w, h: GLfloat) =
  ## Resizes scroll.
  ##
  ## Arguments:
  ## - `w` is a new width.
  ## - `h` is a new height.
  canvas.rect_size.x = w
  canvas.rect_size.y = h


method draw*(self: ScrollRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)


method scrollBy*(self: ScrollRef, x, y: float) {.base.} =
  ## Scrolls by `x` and `y`, if available.
  if x + self.viewport_x + self.viewport_w < self.rect_size.x and x + self.viewport_x > 0:
    self.viewport_x += x
  elif x < 0:
    self.viewport_x = 0
  elif x > 0:
    self.viewport_x = self.rect_size.x - self.viewport_w

  if y + self.viewport_y + self.viewport_h < self.rect_size.y and y + self.viewport_y > 0:
    self.viewport_y += y
  elif y < 0:
    self.viewport_y = 0
  elif y > 0:
    self.viewport_y = self.rect_size.y - self.viewport_h


method scrollTo*(self: ScrollRef, x, y: float) {.base.} =
  ## Scrolls to `x` and `y` position.
  if x + self.viewport_w < self.rect_size.x and x > 0:
    self.viewport_x = x
  elif x < 0:
    self.viewport_x = 0
  elif x > 0:
    self.viewport_x = self.rect_size.x - self.viewport_w

  if y + self.viewport_h < self.rect_size.y and y > 0:
    self.viewport_y = y
  elif y < 0:
    self.viewport_y = 0
  elif y > 0:
    self.viewport_y = self.rect_size.y - self.viewport_h


method handle*(self: ScrollRef, event: InputEvent, mouse_on: var NodeRef) =
  ## handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  let
    mouse_in = Rect2(self.global_position, Vector2(self.viewport_w, self.viewport_h)).contains(event.x, event.y)
    thumb_h = self.viewport_h * (self.viewport_h / self.rect_size.y)
    thumb_w = self.viewport_w * (self.viewport_w / self.rect_size.x)
    thumb_x = self.viewport_w * (self.viewport_x / self.rect_size.x)
    thumb_y = self.viewport_h * (self.viewport_y / self.rect_size.y)
    mouse_in_y = Rect2(
        self.global_position.x + self.viewport_w - self.thumb_width,
        self.global_position.y + thumb_y,
        self.thumb_width,
        thumb_h
      ).contains(event.x, event.y)
    mouse_in_x = Rect2(
        self.global_position.x + thumb_x,
        self.global_position.y + self.viewport_h - self.thumb_height,
        thumb_w,
        self.thumb_height
      ).contains(event.x, event.y)

  if mouse_in:  # Keyboard movement
    if event.kind == KEYBOARD:
      if event.key_cint in pressed_keys_cints:  # Special chars
        if event.key_cint == K_UP:
          self.scrollBy(0, -40)
        elif event.key_cint == K_DOWN:
          self.scrollBy(0, 40)
    elif event.kind == WHEEL:
      self.scrollBy(0, -20 * event.yrel)

  # Mouse Y
  if (mouse_in_y and mouse_pressed and event.kind == MOUSE) or self.thumb_y_has_mouse:
    self.thumb_y_has_mouse = true
    self.scrollBy(0, -event.yrel)
    mouse_on = self
  if not mouse_pressed and self.thumb_y_has_mouse:
    self.thumb_y_has_mouse = false
    mouse_on = nil

  # Mouse X
  if (mouse_in_x and mouse_pressed and event.kind == MOUSE) or self.thumb_x_has_mouse:
    self.thumb_x_has_mouse = true
    self.scrollBy(-event.xrel, 0)
    mouse_on = self
  if not mouse_pressed and self.thumb_x_has_mouse:
    self.thumb_x_has_mouse = false
    mouse_on = nil


method postdraw*(self: ScrollRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if self.children.len() > 0:
    var child = self.children[0]
    self.resize(child.CanvasRef.rect_size.x, child.CanvasRef.rect_size.y)
    let
      thumb_h = self.viewport_h * (self.viewport_h / self.rect_size.y)
      thumb_w = self.viewport_w * (self.viewport_w / self.rect_size.x)
      thumb_x = self.viewport_w * (self.viewport_x / self.rect_size.x)
      thumb_y = self.viewport_h * (self.viewport_y / self.rect_size.y)
    child.CanvasRef.position.x = -self.viewport_x
    child.CanvasRef.position.y = -self.viewport_y

    # Vertical
    if self.viewport_h < self.rect_size.y:
      # Back:
      glColor4f(self.back_color.r, self.back_color.g, self.back_color.b, self.back_color.a)
      glRectf(x + self.viewport_w - self.thumb_width, y, x+self.viewport_w, y-self.viewport_h)

      # Thumb:
      glColor4f(self.thumb_color.r, self.thumb_color.g, self.thumb_color.b, self.thumb_color.a)
      glRectf(x + self.viewport_w - self.thumb_width, y - thumb_y, x+self.viewport_w, y - thumb_y - thumb_h)

    # Horizontal
    if self.viewport_w < self.rect_size.x:
      # Back:
      glColor4f(self.back_color.r, self.back_color.g, self.back_color.b, self.back_color.a)
      glRectf(x, y - self.viewport_h + self.thumb_height, x + self.viewport_w - self.thumb_width, y-self.viewport_h)

      # Thumb:
      glColor4f(self.thumb_color.r, self.thumb_color.g, self.thumb_color.b, self.thumb_color.a)
      glRectf(x + thumb_x, y - self.viewport_h + self.thumb_height, x + thumb_x + thumb_w, y-self.viewport_h)
