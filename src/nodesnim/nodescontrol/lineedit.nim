# author: Ethosa
## It provides primitive text input.
import
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  LineEditObj* = object of ControlRef
    blit_caret*: bool
    blit_speed*: float
    blit_time*: float
    caret_position*: int
    font*: pointer          ## Glut font data.
    spacing*: float         ## Font spacing.
    size*: float            ## Font size.
    text*: string           ## LineEdit text.
    hint_text*: string
    color*: ColorRef        ## Text color.
    hint_color*: ColorRef   ## Hint color.
    caret_color*: ColorRef
    text_align*: AnchorObj  ## Text align.
    on_edit*: proc(pressed_key: string): void  ## This called when user press any key.
  LineEditRef* = ref LineEditObj


proc LineEdit*(name: string = "LineEdit"): LineEditRef =
  ## Creates a new LineEdit.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var edit = LineEdit("LineEdit")
  nodepattern(LineEditRef)
  controlpattern()
  result.rect_size.x = 120
  result.rect_size.y = 32
  result.text = ""
  result.font = GLUT_BITMAP_HELVETICA_12
  result.size = 12
  result.spacing = 2
  result.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  result.color = Color(1f, 1f, 1f)
  result.background.setColor(Color(0x454545ff))
  result.hint_color = Color(0.8, 0.8, 0.8)
  result.hint_text = "Edit text ..."
  result.caret_position = 0
  result.blit_caret = true
  result.caret_color = Color(1f, 1f, 1f, 0.7)
  result.blit_speed = 0.05
  result.blit_time = 0f
  result.on_edit = proc(key: string) = discard
  result.kind = LINE_EDIT_NODE


method getTextSize*(self: LineEditRef): Vector2Obj {.base.} =
  ## Returns text size.
  result = Vector2(0, self.size)
  for c in self.text:
    result.x += self.font.glutBitmapWidth(c.int).float


method getCharPositionUnderMouse*(self: LineEditRef): int {.base.} =
  ## Returns char position under mouse.
  let
    size = self.getTextSize()
    textlen = self.text.len()
    pos = Vector2Obj(x: last_event.x, y: last_event.y) - self.global_position
  if pos.y > size.y:
    return textlen
  else:
    var
      res = Vector2()
      caret_pos = 0
      current_pos = 0
      x: float = 0f
    current_pos = 0
    res.y += self.spacing + self.size
    for c in self.text:
      x += self.font.glutBitmapWidth(c.int).float
      inc caret_pos
      inc current_pos
      if res.y >= pos.y:
        if current_pos < textlen and x <= pos.x:
          continue
        return caret_pos


method draw*(self: LineEditRef, w, h: GLfloat) =
  ## This method uses in the `window.nim`
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
    tw = self.font.glutBitmapLength(text).float

  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  var
    char_num = 0
    tx = x + self.rect_size.x*self.text_align.x1 - tw * self.text_align.x2
    ty = y - self.rect_size.y*self.text_align.y1 + self.size * self.text_align.y2 - self.size
  for c in text:
    glColor4f(color.r, color.g, color.b, color.a)
    let
      cw = self.font.glutBitmapWidth(c.int).float
      right = if self.text_align.x2 > 0.9 and self.text_align.x1 > 0.9: 1f else: 0f
    if tx >= x and tx < x + self.rect_size.x+right:
      glRasterPos2f(tx, ty)  # set char position
      self.font.glutBitmapCharacter(c.int)  # render char

      inc char_num
      if char_num == self.caret_position and self.blit_caret and self.blit_time > 0.8 and self.focused:
        glColor4f(self.caret_color.r, self.caret_color.g, self.caret_color.b, self.caret_color.a)
        glRectf(tx+cw, ty, tx+cw+1.5, ty+self.size-2)
        if self.blit_time > 2f:
          self.blit_time = 0f
    tx += cw
  self.blit_time += self.blit_speed

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)


method duplicate*(self: LineEditRef): LineEditRef {.base.} =
  ## Duplicates LineEdit object and create a new LineEdit.
  self.deepCopy()


method handle*(self: LineEditRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. Thi uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  when not defined(android) and not defined(ios):
    if self.hovered:  # Change cursor, if need
      glutSetCursor(GLUT_CURSOR_TEXT)
    else:
      glutSetCursor(GLUT_CURSOR_LEFT_ARROW)

  if event.kind == MOUSE and event.pressed:
    self.caret_position = self.getCharPositionUnderMouse()

  if self.focused:
    if event.kind == KEYBOARD:
      if event.key_cint == K_LEFT and event.key_cint in pressed_keys_cints and self.caret_position > 0:
        self.caret_position -= 1
      elif event.key_cint == K_RIGHT and event.key_cint in pressed_keys_cints and self.caret_position < self.text.len():
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

        # Other keys
        elif self.caret_position > 0 and self.caret_position < self.text.len():
          self.text = self.text[0..self.caret_position-1] & event.key & self.text[self.caret_position..^1]
          self.caret_position += 1
          self.on_edit(event.key)
        elif self.caret_position == 0:
          self.text = event.key & self.text
          self.caret_position += 1
          self.on_edit(event.key)
        elif self.caret_position == self.text.len():
          self.text &= event.key
          self.caret_position += 1
          self.on_edit(event.key)


method setText*(self: LineEditRef, value: string) {.base.} =
  ## Changes LineEdit text.
  self.text = value
