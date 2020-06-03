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


proc ColorRect*(name: string, variable: var ColorRectObj): ColorRectPtr =
  ## Creates a new ColorRect pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a ColorRectObj variable
  runnableExamples:
    var
      colorrect1_obj: ColorRectObj
      colorrect1 = ColorRect("ColorRect", colorrect1_obj)
  nodepattern(ColorRectObj)
  controlpattern()
  variable.color = Color(1f, 1f, 1f)
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.kind = COLOR_RECT_NODE

proc ColorRect*(obj: var ColorRectObj): ColorRectPtr {.inline.} =
  ## Creates a new ColorRect pointer with default node name "ColorRect".
  ##
  ## Arguments:
  ## - `variable` is a ColorRectObj variable
  runnableExamples:
    var
      colorrect1_obj: ColorRectObj
      colorrect1 = ColorRect(colorrect1_obj)
  ColorRect("ColorRect", obj)


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

method duplicate*(self: ColorRectPtr, obj: var ColorRectObj): ColorRectPtr {.base.} =
  ## Duplicates ColorRect object and create a new ColorRect pointer.
  obj = self[]
  obj.addr
