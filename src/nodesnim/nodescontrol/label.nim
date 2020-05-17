# author: Ethosa
import
  strutils,
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  control


type
  LabelObj* = object of ControlPtr
    font*: pointer          ## Glut font data.
    spacing*: float         ## Font spacing.
    size*: float            ## Font size.
    text*: string           ## Label text.
    color*: ColorRef        ## Text color.
    text_align*: AnchorRef  ## Text align.
  LabelPtr* = ptr LabelObj


proc Label*(name: string, variable: var LabelObj): LabelPtr =
  nodepattern(LabelObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.text = ""
  variable.font = GLUT_BITMAP_HELVETICA_12
  variable.size = 12
  variable.spacing = 2
  variable.text_align = Anchor(0, 0, 0, 0)
  variable.color = Color(1f, 1f, 1f)

proc Label*(obj: var LabelObj): LabelPtr {.inline.} =
  Label("Label", obj)


method draw*(self: LabelPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
  var
    th = 0f
    ty = 0f

  for line in self.text.splitLines():  # get text height
    th += self.spacing + self.size
  ty = y - self.rect_size.y*self.text_align.y1 + th * self.text_align.y2

  for line in self.text.splitLines():
    var tw = self.font.glutBitmapLength(line).float
    # Draw text:
    var tx = x + self.rect_size.x*self.text_align.x1 - tw * self.text_align.x2
    for c in line:
      glRasterPos2f(tx, ty)  # set char position
      self.font.glutBitmapCharacter(c.int)  # render char
      tx += self.font.glutBitmapWidth(c.int).float
    ty -= self.spacing + self.size

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)
