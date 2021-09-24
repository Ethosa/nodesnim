# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,

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
    hint*: StyleText
    caret_color: ColorRef
    caret_pos: uint32
    blink_time: uint8
    is_blink: bool
    caret*: bool
    on_edit*: proc(pressed_key: string): void  ## This called when user press any key.

const
  BLINK_TIME: uint8 = 15
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
    caret = self.text.getCaretPos(self.caret_pos)
    xalign = x + self.rect_size.x*self.text_align.x1 - self.rect_min_size.x*self.text_align.x2
    yalign = y - self.rect_size.y*self.text_align.y1 + self.rect_min_size.y*self.text_align.y2

  dec self.blink_time
  if self.blink_time == 0:
    self.blink_time = BLINK_TIME
    self.is_blink = not self.is_blink

  if self.text.chars.len() == 0:
    self.hint.renderTo(Vector2(x+self.padding.x1, y-self.padding.y1), self.rect_size, self.text_align)
  else:
    self.text.renderTo(Vector2(x+self.padding.x1, y-self.padding.y1), self.rect_size, self.text_align)

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


template changeText( self, `text`, `save_properties`, t: untyped): untyped =
  var st = stext(`text`)
  if `self`.`t`.font.isNil():
    `self`.`t`.font = standard_font
  st.font = `self`.`t`.font

  if `save_properties`:
    for i in 0..<st.chars.len():
      if i < `self`.`t`.len():
        st.chars[i].color = `self`.`t`.chars[i].color
        st.chars[i].underline = `self`.`t`.chars[i].underline
  `self`.`t` = st
  `self`.rect_min_size = `self`.`t`.getTextSize()
  `self`.resize(`self`.rect_size.x, `self`.rect_size.y)
  `self`.`t`.rendered = false

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

  if event.kind == MOUSE and event.pressed and self.hovered:
    self.caret_pos = self.text.getPosUnderPoint(
      self.getGlobalMousePosition(),
      self.global_position + self.rect_size/2 - self.text.getTextSize()/2)

  if self.focused:
    if event.kind == TEXT and not event.pressed:
      # Other keys
      if self.caret_pos > 0 and self.caret_pos < self.text.len().uint32:  # insert in caret pos
        self.setText(($self.text)[0..self.caret_pos-1] & event.key & ($self.text)[self.caret_pos..^1])
        self.caret_pos += 1
        self.on_edit(event.key)
      elif self.caret_pos == 0:  # insert in start of text.
        self.setText(event.key & ($self.text))
        self.caret_pos += 1
        self.on_edit(event.key)
      elif self.caret_pos == self.text.len().uint32:  # insert in end of text.
        self.setText(($self.text) & event.key)
        self.caret_pos += 1
        self.on_edit(event.key)
    elif event.kind == KEYBOARD and event.key in pressed_keys:
      # Arrows
      if event.key_int == K_LEFT and self.caret_pos > 0:
        self.caret_pos -= 1
      elif event.key_int == K_RIGHT and self.caret_pos < self.text.len().uint32:
        self.caret_pos += 1

      elif event.key_int == 8:  # Backspace
        if self.caret_pos > 1 and self.caret_pos < self.text.len().uint32:
          self.setText($self.text[0..self.caret_pos-2] & $self.text[self.caret_pos..^1])
          self.caret_pos -= 1
        elif self.caret_pos == self.text.len().uint32 and self.caret_pos > 0:
          self.setText($self.text[0..^2])
          self.caret_pos -= 1
        elif self.caret_pos == 1:
          self.setText($self.text[1..^1])
          self.caret_pos -= 1
      elif event.key_int == 13:  # Next line
        self.setText($self.text[0..self.caret_pos-1] & "\n" & $self.text[self.caret_pos..^1])
        self.caret_pos += 1
