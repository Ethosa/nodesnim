# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/image,
  ../core/color,

  ../nodes/node,
  control


type
  TextureRectObj* = object of ControlPtr
    texture*: Gluint
    modulate*: ColorRef
  TextureRectPtr* = ptr TextureRectObj


proc TextureRect*(name: string, variable: var TextureRectObj): TextureRectPtr =
  nodepattern(TextureRectObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.texture = 0
  variable.modulate = Color(1, 1, 1)

proc TextureRect*(obj: var TextureRectObj): TextureRectPtr {.inline.} =
  TextureRect("TextureRect", obj)


method draw*(self: TextureRectPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if self.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.texture)

    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex2f(x, y)
    glTexCoord2f(0, 1)
    glVertex2f(x, y - self.rect_size.y)
    glTexCoord2f(1, 1)
    glVertex2f(x + self.rect_size.x, y - self.rect_size.y)
    glTexCoord2f(1, 0)
    glVertex2f(x + self.rect_size.x, y)
    glEnd()
    glDisable(GL_TEXTURE_2D)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method loadTexture*(self: TextureRectPtr, file: cstring) {.base.} =
  self.texture = load(file)
