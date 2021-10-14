# author: Ethosa
import ../thirdparty/sdl2 except Color
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2/ttf,

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
    is_blink, is_select: bool
    caret*, selectable: bool
    blink_time: uint8
    caret_color: ColorRef
    hint*: StyleText
    caret_pos: array[2, uint32]
    on_edit*: proc(pressed_key: string): void  ## This called when user press any key.

const
  BLINK_TIME: uint8 = 15
  BLINK_WIDTH: float = 2

proc EditText*(name: string = "EditText", hint: string = "Edit text ..."): EditTextRef =
  nodepattern(EditTextRef)
  controlpattern()
  result.is_blink = false
  result.is_select = false
  result.caret = true
  result.selectable = true
  result.caret_pos = [0u32, 0u32]
  result.caret_color = Color("#ffccddaa")
  result.blink_time = BLINK_TIME
  result.text = stext("")
  result.hint = stext(hint)
  result.hint.setColor(Color("#ccc"))
  result.text.setColor(Color("#555"))
  result.text_align = Anchor(0, 0, 0, 0)
  result.on_edit = proc(key: string) = discard
  result.kind = EDIT_TEXT_NODE
  if result.text.chars.len() > result.hint.chars.len():
    result.rect_min_size = result.text.getTextSize()
  else:
    result.rect_min_size = result.hint.getTextSize()
  result.resize(result.rect_size.x, result.rect_size.y)


method draw*(self: EditTextRef, w, h: Glfloat) =
  ## This method uses for redraw Label object.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    xalign = x + self.rect_size.x*self.text_align.x1 - self.rect_min_size.x*self.text_align.x2
    yalign = y - self.rect_size.y*self.text_align.y1 + self.rect_min_size.y*self.text_align.y2
  var
    lines = self.text.splitLines()
    w: cint
    h: cint
    x1 = 0f
    y1 = 0f
    i = 0u32

  dec self.blink_time
  if self.blink_time == 0:
    self.blink_time = BLINK_TIME
    self.is_blink = not self.is_blink

  if self.text.chars.len() == 0:
    self.hint.renderTo(Vector2(x+self.padding.x1, y-self.padding.y1), self.rect_size, self.text_align)
  else:
    self.text.renderTo(Vector2(x+self.padding.x1, y-self.padding.y1), self.rect_size, self.text_align)

  for line in lines:
    discard self.text.font.sizeUtf8(($line).cstring, addr w, addr h)
    x1 = self.rect_min_size.x*self.text_align.x1 - w.Glfloat*self.text_align.x2
    for c in line.chars:
      discard self.text.font.sizeUtf8(($c).cstring, addr w, addr h)
      if self.is_select and (i >= self.caret_pos[0] and i < self.caret_pos[1]) or (i >= self.caret_pos[1] and i < self.caret_pos[0]):
        glColor4f(0.4, 0.4, 0.7, 0.5)
        glBegin(GL_QUADS)
        glVertex2f(xalign+x1, yalign-y1)
        glVertex2f(xalign+x1+w.Glfloat, yalign-y1)
        glVertex2f(xalign+x1+w.Glfloat, yalign-y1-h.Glfloat)
        glVertex2f(xalign+x1, yalign-y1-h.Glfloat)
        glEnd()
      if self.is_blink and i == self.caret_pos[0]:
        glColor4f(self.caret_color.r, self.caret_color.g, self.caret_color.b, self.caret_color.a)
        glBegin(GL_QUADS)
        glVertex2f(xalign+x1, yalign-y1)
        glVertex2f(xalign+x1+BLINK_WIDTH, yalign-y1)
        glVertex2f(xalign+x1+BLINK_WIDTH, yalign-y1-h.Glfloat)
        glVertex2f(xalign+x1, yalign-y1-h.Glfloat)
        glEnd()
      x1 += w.float
      inc i
    y1 += self.text.spacing
    y1 += h.float
    inc i


template changeText(self, `text`, `save_properties`, t: untyped): untyped =
  var st = stext(`text`)
  if `self`.`t`.font.isNil():
    `self`.`t`.font = standard_font
  st.font = `self`.`t`.font

  if `save_properties`:
    for i in 0..<st.chars.len():
      if i < `self`.`t`.len():
        st.chars[i].color = `self`.`t`.chars[i].color
        st.chars[i].style = `self`.`t`.chars[i].style
  `self`.`t` = st
  `self`.rect_min_size = `self`.`t`.getTextSize()
  `self`.resize(`self`.rect_size.x, `self`.rect_size.y)
  `self`.`t`.rendered = false

method moveCursorBy*(self: EditTextRef, value: int) {.base.} =
  if value > 0:
    self.caret_pos[0] += value.uint32
  else:
    self.caret_pos[0] -= (-value).uint32
  self.caret_pos[1] = self.caret_pos[0]

method insert*(self: EditTextRef, position: uint32, value: string) {.base.} =
  let strtext = $self.text
  if position > 0 and position < self.text.len().uint32:  # insert in caret pos
    self.setText(strtext[0..position-1] & value & strtext[position..^1])
    self.moveCursorBy(1)
    self.on_edit(value)
  elif position == 0:  # insert in start of text.
    self.setText(value & strtext)
    self.moveCursorBy(1)
    self.on_edit(value)
  elif position == self.text.len().uint32:  # insert in end of text.
    self.setText(strtext & value)
    self.moveCursorBy(1)
    self.on_edit(value)

method setText*(self: EditTextRef, t: string, save_properties: bool = false) =
  ## Changes text.
  ##
  ## Arguments:
  ## - `text` is a new Label text.
  ## - `save_properties` - saves old text properties, if `true`.
  changeText(self, t, save_properties, text)

method setHint*(self: EditTextRef, t: string, save_properties: bool = false) {.base.} =
  changeText(self, t, save_properties, hint)

method setHintColor*(self: EditTextRef, color: ColorRef) {.base.} =
  self.hint.setColor(color)
  self.hint.rendered = false

method handle*(self: EditTextRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. Thi uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  when not defined(android) and not defined(ios):
    if self.hovered:  # Change cursor, if need
      setCursor(createSystemCursor(SDL_SYSTEM_CURSOR_IBEAM))
    else:
      setCursor(createSystemCursor(SDL_SYSTEM_CURSOR_ARROW))

  if event.kind == MOUSE and self.hovered:
    if event.pressed:
      self.caret_pos[0] = self.text.getPosUnderPoint(
        self.getGlobalMousePosition(),
        self.global_position + self.rect_size/2 - self.text.getTextSize()/2, self.text_align)
      if self.selectable:
        self.is_select = true
        self.caret_pos[1] = self.caret_pos[0]
  elif event.kind == MOTION:
    if self.is_select and event.pressed:
      self.caret_pos[1] = self.text.getPosUnderPoint(
        self.getGlobalMousePosition(),
        self.global_position + self.rect_size/2 - self.text.getTextSize()/2, self.text_align)

  if self.focused:
    if event.kind == TEXT and not event.pressed:
      # Other keys
      self.insert(self.caret_pos[0], event.key)
    elif event.kind == KEYBOARD and event.key in pressed_keys:
      # Arrows
      if event.key_int == K_LEFT and self.caret_pos[0] > 0:
        self.moveCursorBy(-1)
      elif event.key_int == K_RIGHT and self.caret_pos[0] < self.text.len().uint32:
        self.moveCursorBy(1)

      elif event.key_int == 8:  # Backspace
        if self.caret_pos[0] > 1 and self.caret_pos[0] < self.text.len().uint32:
          self.setText($self.text[0..self.caret_pos[0]-2] & $self.text[self.caret_pos[0]..^1])
          self.moveCursorBy(-1)
        elif self.caret_pos[0] == self.text.len().uint32 and self.caret_pos[0] > 0:
          self.setText($self.text[0..^2])
          self.moveCursorBy(-1)
        elif self.caret_pos[0] == 1:
          self.setText($self.text[1..^1])
          self.moveCursorBy(-1)
      elif event.key_int == 13:  # Next line
        self.insert(self.caret_pos[0], "\n")
