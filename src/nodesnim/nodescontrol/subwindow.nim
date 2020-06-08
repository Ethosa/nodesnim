# author: Ethosa
## Extended version of SubWindow node.
import
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,
  ../core/image,

  ../nodes/node,
  control,
  popup,
  label


type
  SubWindowObj* = object of PopupObj
    left_taked*, right_taked*, top_taked*, bottom_taked*: bool
    title_taked*: bool
    icon*: GlTextureObj
    title_bar_color*: ColorRef
    border_color*: ColorRef
    title_taked_pos*: Vector2Ref
    title*: LabelRef
  SubWindowRef* = ref SubWindowObj


proc SubWindow*(name: string = "SubWindow"): SubWindowRef =
  ## Creates a new SubWindow.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var window = SubWindow("SubWindow")
  nodepattern(SubWindowRef)
  controlpattern()
  result.background_color = Color(0x454545ff)
  result.title_bar_color = Color(0x303030ff)
  result.border_color = Color(0x212121ff)
  result.rect_size.x = 320
  result.rect_size.y = 220
  result.visible = false
  result.title = Label("Title")
  result.title.setText("Title")
  result.title.parent = result
  result.left_taked = false
  result.right_taked = false
  result.top_taked = false
  result.bottom_taked = false
  result.title_taked = false
  result.title_taked_pos = Vector2()
  result.icon = GlTextureObj(texture: 0)
  result.kind = SUB_WINDOW_NODE


method close*(self: SubWindowRef) {.base.} =
  ## Closes the window. alias of hide() method.
  self.hide()


method draw*(self: SubWindowRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  for child in self.getChildIter():
    child.calcGlobalPosition()
    if child.global_position.x > self.global_position.x + self.rect_size.x:
      child.visible = false
    elif child.global_position.y > self.global_position.y + self.rect_size.y:
      child.visible = false
    elif child.global_position.x + child.rect_size.x < self.global_position.x:
      child.visible = false
    elif child.global_position.y + child.rect_size.y < self.global_position.y:
      child.visible = false
    else:
      child.visible = true

  glColor4f(self.border_color.r, self.border_color.g, self.border_color.b, self.border_color.a)
  glBegin(GL_LINE_LOOP)
  glVertex2f(x, y)
  glVertex2f(x+self.rect_size.x, y)
  glVertex2f(x+self.rect_size.x, y-self.rect_size.y)
  glVertex2f(x, y-self.rect_size.y)
  glEnd()

  glBegin(GL_QUADS)

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glVertex2f(x+1, y-32)
  glVertex2f(x + self.rect_size.x - 1, y-32)
  glVertex2f(x + self.rect_size.x - 1, y - self.rect_size.y + 32)
  glVertex2f(x+1, y - self.rect_size.y + 32)

  glColor4f(self.title_bar_color.r, self.title_bar_color.g, self.title_bar_color.b, self.title_bar_color.a)
  glVertex2f(x+1, y-1)
  glVertex2f(x + self.rect_size.x - 1, y-1)
  glVertex2f(x + self.rect_size.x - 1, y-31)
  glVertex2f(x+1, y-31)

  glEnd()

  let size = self.title.getTextSize()
  self.title.position.x = self.rect_size.x / 2 - size.x / 2
  self.title.position.y = 1 + 15 - size.y / 2
  self.title.calcGlobalPosition()
  self.title.draw(w, h)

  if self.icon.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.icon.texture)
    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex2f(x+2, y-2)
    glTexCoord2f(0, 1)
    glVertex2f(x+2, y - 28)
    glTexCoord2f(1, 1)
    glVertex2f(x + 28, y - 28)
    glTexCoord2f(1, 0)
    glVertex2f(x + 28, y-2)
    glEnd()
    glDisable(GL_TEXTURE_2D)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)


method duplicate*(self: SubWindowRef): SubWindowRef {.base.} =
  ## Duplicates SubWindow object and create a new SubWindow.
  self.deepCopy()


method handle*(self: SubWindowRef, event: InputEvent, mouse_on: var NodeRef) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  let
    left = event.x >= self.global_position.x-1 and event.x <= self.global_position.x+2
    right = event.x <= self.global_position.x+self.rect_size.x+1 and event.x >= self.global_position.x+self.rect_size.x-1
    top = event.y >= self.global_position.y-1 and event.y <= self.global_position.y+2
    bottom = event.y <= self.global_position.y+self.rect_size.y+1 and event.y >= self.global_position.y+self.rect_size.y-1
    title = Rect2(self.global_position+2, Vector2(self.rect_size.x-4, 32)).contains(event.x, event.y)

  when not defined(android) and not defined(ios):
    if left and top:
      glutSetCursor(GLUT_CURSOR_TOP_LEFT_CORNER)
    elif left and bottom:
      glutSetCursor(GLUT_CURSOR_BOTTOM_LEFT_CORNER)
    elif right and top:
      glutSetCursor(GLUT_CURSOR_TOP_RIGHT_CORNER)
    elif right and bottom:
      glutSetCursor(GLUT_CURSOR_BOTTOM_RIGHT_CORNER)
    elif left or right:
      glutSetCursor(GLUT_CURSOR_LEFT_RIGHT)
    elif bottom or top:
      glutSetCursor(GLUT_CURSOR_UP_DOWN)
    else:
      glutSetCursor(GLUT_CURSOR_LEFT_ARROW)

  if event.kind == MOUSE:
    if event.pressed:
      if left and top:
        self.left_taked = true
        self.top_taked = true
      elif left and bottom:
        self.left_taked = true
        self.bottom_taked = true
      elif right and top:
        self.right_taked = true
        self.top_taked = true
      elif right and bottom:
        self.right_taked = true
        self.bottom_taked = true

      elif left:
        self.left_taked = true
      elif right:
        self.right_taked = true
      elif bottom:
        self.bottom_taked = true
      elif top:
        self.top_taked = true

      if title:
        self.title_taked = true
        self.title_taked_pos = Vector2(self.global_position.x - event.x, self.global_position.y - event.y)
    else:
      self.left_taked = false
      self.right_taked = false
      self.top_taked = false
      self.bottom_taked = false
      self.title_taked = false

  let
    left_p = self.global_position.x - event.x
    right_p = self.global_position.x + self.rect_size.x - event.x
    top_p = self.global_position.y - event.y
    bottom_p = self.global_position.y + self.rect_size.y - event.y

  if self.left_taked and self.rect_size.x + left_p > 128:
    self.position.x -= left_p
    self.rect_size.x += left_p

  if self.right_taked and self.rect_size.x - right_p > 128:
    self.rect_size.x -= right_p

  if self.top_taked and self.rect_size.y + top_p > 64:
    self.position.y -= top_p
    self.rect_size.y += top_p

  if self.bottom_taked and self.rect_size.y - bottom_p > 64:
    self.rect_size.y -= bottom_p

  if self.title_taked:
    self.position.x -= self.global_position.x - event.x
    self.position.y -= self.global_position.y - event.y
    self.position += self.title_taked_pos


method open*(self: SubWindowRef) {.base.} =
  ## Opens the window. alias of show() method.
  self.show()


method resize*(self: SubWindowRef, w, h: float) {.base.} =
  ## Resizes subwindow, if available.
  ##
  ## Arguments:
  ## - `w` is a new width.
  ## - `h` is a new height.
  if w > 128:
    self.rect_size.x = w
  if h > 64:
    self.rect_size.y = h


method setBorderColor*(self: SubWindowRef, color: ColorRef) {.base.} =
  ## Changes border color.
  ##
  ## Arguments:
  ## - `color` is a new border color.
  self.border_color = color


method setIcon*(self: SubWindowRef, gltexture: GlTextureObj) {.base.} =
  ## Changes icon.
  ##
  ## Arguments:
  ## - `gltexture` is a texture, loaded via load(file, mode=GL_RGB).
  self.icon = gltexture


method setIcon*(self: SubWindowRef, file: cstring) {.base.} =
  ## Loads icon from file.
  ##
  ## Arguments:
  ## - `file` is an image file path.
  self.icon = load(file)


method setTitleBarColor*(self: SubWindowRef, color: ColorRef) {.base.} =
  ## Changes title bar color.
  ##
  ## Arguments:
  ## - `color` is a new title bar color.
  self.title_bar_color = color


method setTitle*(self: SubWindowRef, title: string) {.base.} =
  ## Changes subwindow title.
  ##
  ## Arguments:
  ## - `title` is a new title.
  self.title.setText(title)
