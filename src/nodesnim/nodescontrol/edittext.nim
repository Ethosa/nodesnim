# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/font,
  ../core/color,
  ../core/anchor,
  ../core/vector2,
  ../core/enums,
  ../core/input,
  ../core/rect2,
  ../core/nodes_os,

  ../nodes/node,
  ../nodes/canvas,

  label,
  control


type
  EditTextRef* = ref object of LabelObj
    hint: StyleText
    caret_color: ColorRef
    caret_pos: uint32
    blink_time: uint8
    is_blink: bool
    caret: bool
    on_edit*: proc(pressed_key: string): void  ## This called when user press any key.

const
  BLINK_TIME: uint8 = 20
  BLINK_WIDTH: float = 2

proc EditText*(name: string = "EditText", hint: string = "Edit text ..."): EditTextRef =
  nodepattern(EditTextRef)
  controlpattern()
  result.caret = true
  result.caret_pos = 0
  result.caret_color = Color("#ffccddaa")
  result.is_blink = false
  result.blink_time = BLINK_TIME
  result.text = stext("")
  result.hint = stext(hint)
  result.hint.setColor(Color("#ccc"))
  result.text.setColor(Color(0xffffffff'u32))
  result.text_align = Anchor(0, 0, 0, 0)
  result.on_edit = proc(key: string) = discard
  result.kind = EDIT_TEXT_NODE
  if result.text.chars.len() > result.hint.chars.len():
    result.rect_min_size = result.text.getTextSize()
  else:
    result.rect_min_size = result.hint.getTextSize()
  result.resize(result.rect_size.x, result.rect_size.y)
  result.hint.render(result.rect_size, result.text_align)


method draw*(self: EditTextRef, w, h: Glfloat) =
  ## This method uses for redraw Label object.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    caret = self.text.getCaretPos(self.caret_pos)
    xalign = x + self.rect_size.x*self.text_align.x1 - self.rect_min_size.x*self.text_align.x2
    yalign = y - self.rect_size.y*self.text_align.y1 + self.rect_min_size.y*self.text_align.y2
  echo caret

  dec self.blink_time
  if self.blink_time == 0:
    self.blink_time = BLINK_TIME
    self.is_blink = not self.is_blink

  if self.text.chars.len() == 0:
    self.hint.renderTo(Vector2(x, y), self.rect_size, self.text_align)
  else:
    self.text.renderTo(Vector2(x, y), self.rect_size, self.text_align)

  if self.is_blink:
    glColor4f(self.caret_color.r, self.caret_color.g, self.caret_color.b, self.caret_color.a)
    glBegin(GL_QUADS)
    glVertex2f(
      xalign + caret[0].x,
      yalign - caret[0].y)
    glVertex2f(
      xalign + caret[0].x - BLINK_WIDTH,
      yalign - caret[0].y)
    glVertex2f(
      xalign + caret[0].x - BLINK_WIDTH,
      yalign - caret[0].y - caret[1].float)
    glVertex2f(
      xalign + caret[0].x,
      yalign - caret[0].y - caret[1].float)
    glEnd()

method setText*(self: EditTextRef, text: string, save_properties: bool = false) =
  ## Changes text.
  ##
  ## Arguments:
  ## - `text` is a new Label text.
  ## - `save_properties` - saves old text properties, if `true`.
  var st = stext(text)
  if self.text.font.isNil():
    self.text.font = standard_font
  st.font = self.text.font

  if save_properties:
    for i in 0..<st.chars.len():
      if i < self.text.len():
        st.chars[i].color = self.text.chars[i].color
        st.chars[i].underline = self.text.chars[i].underline
  self.text = st
  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y)
  self.text.render(self.rect_size, self.text_align)

method handle*(self: EditTextRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. Thi uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  when not defined(android) and not defined(ios):
    if self.hovered:  # Change cursor, if need
      glutSetCursor(GLUT_CURSOR_TEXT)
    else:
      glutSetCursor(GLUT_CURSOR_LEFT_ARROW)

  if self.focused:
    if event.kind == KEYBOARD:
      if event.key_cint == K_LEFT and self.caret_pos > 0 and event.key_cint in pressed_keys_cints:
        self.caret_pos -= 1
        echo self.caret_pos
      elif event.key_cint == K_RIGHT and self.caret_pos < self.text.len().uint32 and event.key_cint in pressed_keys_cints:
        self.caret_pos += 1
        echo self.caret_pos
      elif event.key in pressed_keys:  # Normal chars
        if event.key_int == 8:  # Backspace
          if self.caret_pos > 1 and self.caret_pos < self.text.len().uint32:
            self.setText(($self.text)[0..self.caret_pos-2] & ($self.text)[self.caret_pos..^1])
            self.caret_pos -= 1
          elif self.caret_pos == self.text.len().uint32 and self.caret_pos > 0:
            self.setText(($self.text)[0..^2])
            self.caret_pos -= 1
          elif self.caret_pos == 1:
            self.setText(($self.text)[1..^1])
            self.caret_pos -= 1
        elif event.key_int == 13:
          self.setText($self.text & "\n")
          self.caret_pos += 1

        # Other keys
        elif self.caret_pos > 0 and self.caret_pos < self.text.len().uint32:
          self.setText(($self.text)[0..self.caret_pos-1] & event.key & ($self.text)[self.caret_pos..^1])
          self.caret_pos += 1
          self.on_edit(event.key)
          echo event.key
        elif self.caret_pos == 0:
          self.setText(event.key & ($self.text))
          self.caret_pos += 1
          self.on_edit(event.key)
        elif self.caret_pos == self.text.len().uint32:
          self.setText(($self.text) & event.key)
          self.caret_pos += 1
          self.on_edit(event.key)
