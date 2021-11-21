# author: Ethosa
## It provides a primitive display image.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/image,
  ../core/enums,
  ../core/color,
  ../private/templates,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  TextureRectObj* = object of ControlRef
    texture*: Gluint
    texture_mode*: TextureMode
    texture_size*: Vector2Obj
    texture_anchor*: AnchorObj
    texture_filter*: ColorRef
  TextureRectRef* = ref TextureRectObj


proc TextureRect*(name: string = "TextureRect"): TextureRectRef =
  ## Creates a new TextureRect.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var texture = TextureRect("TextureRect")
  nodepattern(TextureRectRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.texture = 0
  result.texture_mode = TEXTURE_FILL_XY
  result.texture_size = Vector2()
  result.texture_anchor = START_ANCHOR
  result.texture_filter = Color(1f, 1f, 1f)
  result.kind = TEXTURE_RECT_NODE



method draw*(self: TextureRectRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)
  glColor(self.texture_filter)

  if self.texture > 0'u32:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.texture)

    glBegin(GL_QUADS)
    case self.texture_mode
    of TEXTURE_FILL_XY:
      glTexCoord2f(0, 0)
      glVertex2f(x, y)
      glTexCoord2f(0, 1)
      glVertex2f(x, y - self.rect_size.y)
      glTexCoord2f(1, 1)
      glVertex2f(x + self.rect_size.x, y - self.rect_size.y)
      glTexCoord2f(1, 0)
      glVertex2f(x + self.rect_size.x, y)
    of TEXTURE_KEEP_ASPECT_RATIO:
      let
        w = self.rect_size.x / self.texture_size.x
        h = self.rect_size.y / self.texture_size.y
        q = if w < h: w else: h
        x1 = x + (self.rect_size.x*self.texture_anchor.x1) - (self.texture_size.x*q)*self.texture_anchor.x2
        y1 = y - (self.rect_size.y*self.texture_anchor.y1) + (self.texture_size.y*q)*self.texture_anchor.y2
        x2 = x1 + self.texture_size.x*q
        y2 = y1 - self.texture_size.y*q
      glTexCoord2f(0, 0)
      glVertex2f(x1, y1)
      glTexCoord2f(0, 1)
      glVertex2f(x1, y2)
      glTexCoord2f(1, 1)
      glVertex2f(x2, y2)
      glTexCoord2f(1, 0)
      glVertex2f(x2, y1)
    of TEXTURE_CROP:
      if self.texture_size.x < self.rect_size.x:
        let q = self.rect_size.x / self.texture_size.x
        self.texture_size.x *= q
        self.texture_size.y *= q
      if self.texture_size.y < self.rect_size.y:
        let q = self.rect_size.y / self.texture_size.y
        self.texture_size.x *= q
        self.texture_size.y *= q
      let
        x1 = self.rect_size.x / self.texture_size.x
        y1 = self.rect_size.y / self.texture_size.y
        x2 = normalize(self.texture_anchor.x1 - x1*self.texture_anchor.x2, 0, 1)
        y2 = normalize(self.texture_anchor.y1 - y1*self.texture_anchor.y2, 0, 1)
        x3 = normalize(x2 + x1, 0, 1)
        y3 = normalize(y2 + y1, 0, 1)
      glTexCoord2f(x2, y2)
      glVertex2f(x, y)
      glTexCoord2f(x2, y3)
      glVertex2f(x, y - self.rect_size.y)
      glTexCoord2f(x3, y3)
      glVertex2f(x + self.rect_size.x, y - self.rect_size.y)
      glTexCoord2f(x3, y2)
      glVertex2f(x + self.rect_size.x, y)
    glEnd()
    glDisable(GL_TEXTURE_2D)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: TextureRectRef): TextureRectRef {.base.} =
  ## Duplicates TextureRect and create a new TextureRect.
  self.deepCopy()

method loadTexture*(self: TextureRectRef, file: string) {.base.} =
  ## Loads texture from file.
  ##
  ## Arguments:
  ## - `file` is an image file path.
  var
    x: float = 0f
    y: float = 0f
  if self.texture > 0'u32:
    glDeleteTextures(1, addr self.texture)
  self.texture = load(file, x, y)
  self.texture_size = Vector2(x, y)

method setTexture*(self: TextureRectRef, gltexture: GlTextureObj) {.base.} =
  ## Changes texture.
  ##
  ## Arguments:
  ## - `gltexture` is a texture, loaded via load(file, mode=GL_RGB).
  if self.texture > 0'u32:
    glDeleteTextures(1, addr self.texture)
  self.texture = gltexture.texture
  self.texture_size = gltexture.size

method setTextureFilter*(self: TextureRectRef, color: ColorRef) {.base.} =
  ## Changes texture filter color.
  self.texture_filter = color

method setTextureAnchor*(self: TextureRectRef, anchor: AnchorObj) {.base.} =
  ## Changes texture anchor.
  self.texture_anchor = anchor

method setTextureAnchor*(self: TextureRectRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes texture anchor.
  ##
  ## ARguments:
  ## - `x1` and `y1` is an anchor relative to TextureRect size.
  ## - `x2` and `y2` is an anchor relative to texture size.
  self.texture_anchor = Anchor(x1, y1, x2, y2)
