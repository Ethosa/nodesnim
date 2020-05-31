# author: Ethosa
## Displays colour rectangle.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,
  ../core/enums,

  ../nodes/node,
  control


type
  ColorRectObj* = object of ControlPtr
    color*: ColorRef
  ColorRectPtr* = ptr ColorRectObj

var rects: seq[ColorRectObj] = @[]

proc ColorRect*(name: string = "ColorRect"): ColorRectPtr =
  ## Creates a new ColorRect pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var colorrect1 = ColorRect("ColorRect")
  var variable: ColorRectObj
  nodepattern(ColorRectObj)
  controlpattern()
  variable.color = Color(1f, 1f, 1f)
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.kind = COLOR_RECT_NODE
  rects.add(variable)
  return addr rects[^1]


method draw*(self: ColorRectPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method duplicate*(self: ColorRectPtr): ColorRectPtr {.base.} =
  ## Duplicates ColorRect object and create a new ColorRect pointer.
  var obj = self[]
  rects.add(obj)
  return addr rects[^1]

method setColor*(self: ColorRectPtr, color: ColorRef) {.base.} =
  ## Changes ColorRect color.
  ##
  ## Arguments:
  ## - `color` is a new color.
  self.color = color
