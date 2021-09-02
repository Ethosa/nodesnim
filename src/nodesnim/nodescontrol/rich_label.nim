# author: Ethosa
## It provides convenient text rendering. With it, you can set color and underlie for specific chars.
import
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,
  ../core/color_text,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  RichLabelObj* = object of ControlRef
    font*: pointer          ## Glut font data.
    spacing*: float         ## Font spacing.
    size*: float            ## Font size.
    text*: ColorTextRef     ## RichLabel text.
    text_align*: AnchorRef  ## Text align.
  RichLabelRef* = ref RichLabelObj


proc RichLabel*(name: string = "Richlabel"): RichLabelRef =
  ## Creates a new RichLabel.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var text = RichLabel("RichLabel")
  nodepattern(RichLabelRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.text = clrtext""
  result.font = GLUT_BITMAP_HELVETICA_12
  result.size = 12
  result.spacing = 2
  result.text_align = Anchor(0, 0, 0, 0)
  result.kind = RICH_LABEL_NODE


method draw*(self: RichLabelRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  var th = 0f

  for line in self.text.splitLines():  # get text height
    th += self.spacing + self.size
  if th != 0:
    th -= self.spacing
  var ty = y - self.rect_size.y*self.text_align.y1 + th*self.text_align.y2 - self.size

  for line in self.text.splitLines():
    var tw = self.font.glutBitmapLength($line).float
    # Draw text:
    var tx = x + self.rect_size.x*self.text_align.x1 - tw * self.text_align.x2
    for c in line.chars:
      let
        cw = self.font.glutBitmapWidth(c.c.int).float
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
        glColor4f(c.color.r, c.color.g, c.color.b, c.color.a)
        glRasterPos2f(tx, ty)  # set char position
        self.font.glutBitmapCharacter(c.c.int)  # render char
        if c.underline:
          glRectf(tx, ty+self.size, tx+cw, 1)
      tx += cw
    ty -= self.spacing + self.size

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: RichLabelRef): RichLabelRef {.base.} =
  ## Duplicates Richlabel object and create a new RichLabel.
  self.deepCopy()

method setTextAlign*(self: RichLabelRef, align: AnchorRef) {.base.} =
  ## Changes text alignment.
  self.text_align = align

method setTextAlign*(self: RichLabelRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes text alignment.
  self.text_align = Anchor(x1, y1, x2, y2)

method setText*(self: RichLabelRef, value: ColorTextRef) {.base.} =
  ## Changes RichLabel text.
  self.text = value
