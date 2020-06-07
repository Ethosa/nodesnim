# author: Ethosa
## It provides primitive text rendering.
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
  LabelObj* = object of ControlRef
    font*: pointer          ## Glut font data.
    spacing*: float         ## Font spacing.
    size*: float            ## Font size.
    text*: string           ## Label text.
    color*: ColorRef        ## Text color.
    text_align*: AnchorRef  ## Text align.
  LabelRef* = ref LabelObj


proc Label*(name: string = "Label"): LabelRef =
  ## Creates a new Label.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var text = Label("Label")
  nodepattern(LabelRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.text = ""
  result.font = GLUT_BITMAP_HELVETICA_12
  result.size = 12
  result.spacing = 2
  result.text_align = Anchor(0, 0, 0, 0)
  result.color = Color(1f, 1f, 1f)
  result.kind = LABEL_NODE


method draw*(self: LabelRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)


  glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
  var th = 0f

  for line in self.text.splitLines():  # get text height
    th += self.spacing + self.size
  if th != 0:
    th -= self.spacing
  var ty = y - self.rect_size.y*self.text_align.y1 + th*self.text_align.y2 - self.size

  for line in self.text.splitLines():
    var tw = self.font.glutBitmapLength(line).float
    # Draw text:
    var tx = x + self.rect_size.x*self.text_align.x1 - tw * self.text_align.x2
    for c in line:
      let
        cw = self.font.glutBitmapWidth(c.int).float
        right =
          if self.text_align.x2 > 0.9 and self.text_align.x1 > 0.9:
            1f
          else:
            0f
        bottom =
          if self.text_align.y2 > 0.9 and self.text_align.y1 > 0.9:
            1f
          else:
            0f
      if tx >= x and tx < x + self.rect_size.x+right and ty <= y and ty > y - self.rect_size.y+bottom:
        glRasterPos2f(tx, ty)  # set char position
        self.font.glutBitmapCharacter(c.int)  # render char
      tx += cw
    ty -= self.spacing + self.size

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: LabelRef): LabelRef {.base.} =
  ## Duplicates Label object and create a new Label.
  self.deepCopy()

method setTextAlign*(self: LabelRef, align: AnchorRef) {.base.} =
  ## Changes text alignment.
  self.text_align = align

method setTextAlign*(self: LabelRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes text alignment.
  self.text_align = Anchor(x1, y1, x2, y2)

method setText*(self: LabelRef, value: string) {.base.} =
  ## Changes Label text.
  self.text = value
