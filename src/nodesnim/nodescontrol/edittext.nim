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
  EditTextObj* = object of ControlPtr
    blit_caret*: bool
    blit_speed*: float
    blit_time*: float
    caret_position*: int
    font*: pointer          ## Glut font data.
    spacing*: float         ## Font spacing.
    size*: float            ## Font size.
    text*: string           ## EditText text.
    hint_text*: string
    color*: ColorRef        ## Text color.
    hint_color*: ColorRef   ## Hint color.
    caret_color*: ColorRef
    text_align*: AnchorRef  ## Text align.
  EditTextPtr* = ptr EditTextObj


proc EditText*(name: string, variable: var EditTextObj): EditTextPtr =
  nodepattern(EditTextObj)
  controlpattern()
  variable.rect_size.x = 64
  variable.rect_size.y = 32
  variable.text = ""
  variable.font = GLUT_BITMAP_HELVETICA_12
  variable.size = 12
  variable.spacing = 2
  variable.text_align = Anchor(0, 0, 0, 0)
  variable.color = Color(1f, 1f, 1f)
  variable.hint_color = Color(0.8, 0.8, 0.8)
  variable.hint_text = "Edit text ..."
  variable.caret_position = 0
  variable.blit_caret = true
  variable.caret_color = Color(1f, 1f, 1f, 0.5)
  variable.blit_speed = 0.002
  variable.blit_time = 0f

proc EditText*(obj: var EditTextObj): EditTextPtr {.inline.} =
  EditText("EditText", obj)


method draw*(self: EditTextPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    text =
      if self.text.len() > 0:
        self.text
      else:
        self.hint_text
    color =
      if self.text.len() > 0:
        self.color
      else:
        self.hint_color

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)
  var
    th = 0f
    char_num = 0

  for line in text.splitLines():  # get text height
    th += self.spacing + self.size
  if th != 0:
    th -= self.spacing
  var ty = y - self.rect_size.y*self.text_align.y1 + th*self.text_align.y2 - self.size

  for line in text.splitLines():
    var tw = self.font.glutBitmapLength(line).float
    # Draw text:
    var tx = x + self.rect_size.x*self.text_align.x1 - tw * self.text_align.x2
    for c in line:
      glColor4f(color.r, color.g, color.b, color.a)
      let cw = self.font.glutBitmapWidth(c.int).float
      if tx >= x and tx < x + self.rect_size.x - cw and ty <= y and ty > y - self.rect_size.y:
        glRasterPos2f(tx, ty)  # set char position
        self.font.glutBitmapCharacter(c.int)  # render char
        tx += cw

        inc char_num
        if char_num == self.caret_position and self.blit_caret and self.blit_time > 1f:
          glColor4f(self.caret_color.r, self.caret_color.g, self.caret_color.b, self.caret_color.a)
          glRectf(tx, ty, tx+2, ty+self.size)
          if self.blit_time > 2f:
            self.blit_time = 0f
    inc char_num
    ty -= self.spacing + self.size

  self.blit_time += self.blit_speed

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)


method handle*(self: EditTextPtr, event: InputEvent, mouse_on: var NodePtr) =
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.focused:
    if event.kind == KEYBOARD:
      if event.key_cint in pressed_keys_cints:  # Special chars
        if event.key_cint == K_LEFT and self.caret_position > 0:
          self.caret_position -= 1
        elif event.key_cint == K_RIGHT and self.caret_position < self.text.len():
          self.caret_position += 1
      elif event.key in pressed_keys:  # Normal chars
        if event.key_int == 8:  # Backspace
          if self.caret_position > 1 and self.caret_position < self.text.len():
            self.text = self.text[0..self.caret_position-2] & self.text[self.caret_position..^1]
            self.caret_position -= 1
          elif self.caret_position == self.text.len() and self.caret_position > 0:
            self.text = self.text[0..^2]
            self.caret_position -= 1
          elif self.caret_position == 1:
            self.text = self.text[1..^1]
            self.caret_position -= 1
        elif self.caret_position > 0 and self.caret_position < self.text.len():
          self.text = self.text[0..self.caret_position-1] & event.key & self.text[self.caret_position..^1]
          self.caret_position += 1
        elif self.caret_position == 0:
          self.text = event.key & self.text
          self.caret_position += 1
        elif self.caret_position == self.text.len():
          self.text &= event.key
          self.caret_position += 1

method setTextAlign*(self: EditTextPtr, align: AnchorRef) {.base.} =
  ## Changes text align.
  self.text_align = align

method setTextAlign*(self: EditTextPtr, x1, y1, x2, y2: float) {.base.} =
  ## Changes text align.
  self.text_align = Anchor(x1, y1, x2, y2)
