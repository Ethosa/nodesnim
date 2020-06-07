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

  ../nodes/node,
  control


type
  TextureRectObj* = object of ControlPtr
    texture*: Gluint
    texture_mode*: TextureMode
    texture_size*: Vector2Ref
    texture_anchor*: AnchorRef
    texture_filter*: ColorRef
  TextureRectPtr* = ptr TextureRectObj


proc TextureRect*(name: string, variable: var TextureRectObj): TextureRectPtr =
  ## Creates a new TextureRect pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a TextureRectObj variable.
  runnableExamples:
    var
      textureobj: TextureRectObj
      texture = TextureRect("TextureRect", textureobj)
  nodepattern(TextureRectObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.texture = 0
  variable.texture_mode = TEXTURE_FILL_XY
  variable.texture_size = Vector2()
  variable.texture_anchor = Anchor(0, 0, 0, 0)
  variable.texture_filter = Color(1f, 1f, 1f)
  variable.kind = TEXTURE_RECT_NODE

proc TextureRect*(obj: var TextureRectObj): TextureRectPtr {.inline.} =
  ## Creates a new TextureRect pointer with default name "TextureRect".
  ##
  ## Arguments:
  ## - `variable` is a TextureRectObj variable.
  runnableExamples:
    var
      textureobj: TextureRectObj
      texture = TextureRect(textureobj)
  TextureRect("TextureRect", obj)



method draw*(self: TextureRectPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)
  glColor4f(self.texture_filter.r, self.texture_filter.g, self.texture_filter.b, self.texture_filter.a)


  if self.texture > 0:
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

method duplicate*(self: TextureRectPtr, obj: var TextureRectObj): TextureRectPtr {.base.} =
  ## Duplicates TextureRect and create a new TextureRect pointer.
  obj = self[]
  obj.addr

method loadTexture*(self: TextureRectPtr, file: cstring) {.base.} =
  ## Loads texture from file.
  ##
  ## Arguments:
  ## - `file` is an image file path.
  var
    x: float = 0f
    y: float = 0f
  self.texture = load(file, x, y)
  self.texture_size = Vector2(x, y)

method setTexture*(self: TextureRectPtr, gltexture: GlTextureObj) {.base.} =
  ## Changes texture.
  ##
  ## Arguments:
  ## - `gltexture` is a texture, loaded via load(file, mode=GL_RGB).
  self.texture = gltexture.texture
  self.texture_size = gltexture.size

method setTextureFilter*(self: TextureRectPtr, color: ColorRef) {.base.} =
  ## Changes texture filter color.
  self.texture_filter = color

method setTextureAnchor*(self: TextureRectPtr, anchor: AnchorRef) {.base.} =
  ## Changes texture anchor.
  self.texture_anchor = anchor

method setTextureAnchor*(self: TextureRectPtr, x1, y1, x2, y2: float) {.base.} =
  ## Changes texture anchor.
  ##
  ## ARguments:
  ## - `x1` and `y1` is an anchor relative to TextureRect size.
  ## - `x2` and `y2` is an anchor relative to texture size.
  self.texture_anchor = Anchor(x1, y1, x2, y2)
