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
  ../graphics/drawable,
  control


type
  ColorRectObj* = object of ControlRef
    color*: ColorRef
  ColorRectRef* = ref ColorRectObj


proc ColorRect*(name: string = "ColorRect"): ColorRectRef =
  ## Creates a new ColorRect.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var colorrect1 = ColorRect("ColorRect")
  nodepattern(ColorRectRef)
  controlpattern()
  result.color = Color(1f, 1f, 1f)
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.kind = COLOR_RECT_NODE


method draw*(self: ColorRectRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if self.background.getColor().a == 0.0:
    glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
    glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)
  else:
    self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: ColorRectRef): ColorRectRef {.base.} =
  ## Duplicates ColorRect object and create a new ColorRect.
  self.deepCopy()
