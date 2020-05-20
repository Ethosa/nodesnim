# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,

  ../nodes/node,
  control


type
  ColorRectObj* = object of ControlPtr
    color*: ColorRef
  ColorRectPtr* = ptr ColorRectObj


proc ColorRect*(name: string, variable: var ColorRectObj): ColorRectPtr =
  nodepattern(ColorRectObj)
  controlpattern()
  variable.color = Color(1f, 1f, 1f)
  variable.rect_size.x = 40
  variable.rect_size.y = 40

proc ColorRect*(obj: var ColorRectObj): ColorRectPtr {.inline.} =
  ColorRect("ColorRect", obj)


method draw*(self: ColorRectPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method dublicate*(self: ColorRectPtr, obj: var ColorRectObj): ColorRectPtr {.base.} =
  obj = self[]
  obj.addr
