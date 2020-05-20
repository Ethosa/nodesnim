# author: Ethosa
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
  TextureRectPtr* = ptr TextureRectObj


proc TextureRect*(name: string, variable: var TextureRectObj): TextureRectPtr =
  nodepattern(TextureRectObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.texture = 0
  variable.texture_mode = TEXTURE_FILL_XY
  variable.texture_size = Vector2()
  variable.texture_anchor = Anchor(0, 0, 0, 0)

proc TextureRect*(obj: var TextureRectObj): TextureRectPtr {.inline.} =
  TextureRect("TextureRect", obj)



method draw*(self: TextureRectPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)


  if self.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.texture)

    glBegin(GL_QUADS)
    if self.texture_mode == TEXTURE_FILL_XY:
      glTexCoord2f(0, 0)
      glVertex2f(x, y)
      glTexCoord2f(0, 1)
      glVertex2f(x, y - self.rect_size.y)
      glTexCoord2f(1, 1)
      glVertex2f(x + self.rect_size.x, y - self.rect_size.y)
      glTexCoord2f(1, 0)
      glVertex2f(x + self.rect_size.x, y)
    elif self.texture_mode == TEXTURE_KEEP_ASPECT_RATIO:
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
    elif self.texture_mode == TEXTURE_CROP:
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
    self.press(last_event.x, last_event.y)

method dublicate*(self: TextureRectPtr, obj: var TextureRectObj): TextureRectPtr {.base.} =
  obj = self[]
  obj.addr

method loadTexture*(self: TextureRectPtr, file: cstring) {.base.} =
  var size: Vector2Ref = Vector2Ref()
  self.texture = load(file, size)
  self.texture_size = size

method setTexture*(self: TextureRectPtr, gltexture: GlTexture) {.base.} =
  self.texture = gltexture.texture
  self.texture_size = gltexture.size
