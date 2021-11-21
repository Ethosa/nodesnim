# author: Ethosa
import
  ../thirdparty/gl,

  ../core/enums,
  ../core/color,
  ../core/input,
  ../core/vector2,
  ../core/font,
  ../core/themes,
  ../core/anchor,
  ../core/nodes_os,
  ../private/templates,

  ../graphics/drawable,

  ../nodes/node,
  ../nodes/canvas,

  control


type
  ToggleHandler* = proc(self: CheckBoxRef, toggled: bool)
  CheckBoxRef* = ref object of ControlRef
    enabled*: bool
    check_color*: ColorRef
    box: DrawableRef
    text*: StyleText
    text_align*: AnchorObj
    on_toggle*: ToggleHandler  ## This called when switch toggled.

let toggle_handler*: ToggleHandler = proc(self: CheckBoxRef, toggled: bool) = discard


proc CheckBox*(name: string = "CheckBox"): CheckBoxRef =
  ## Creates a new CheckBox.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var text = CheckBox("CheckBox")
  nodepattern(CheckBoxRef)
  controlpattern()
  result.enabled = false
  result.box = Drawable()
  result.text = stext""
  result.text_align = Anchor()
  result.kind = CHECKBOX_NODE

  result.box.setCornerRadius(8)
  result.box.setCornerDetail(8)
  result.box.setColor(current_theme~background_deep)
  result.box.setBorderColor(current_theme~foreground)
  result.check_color = current_theme~foreground
  result.box.setBorderWidth(1)
  result.on_toggle = toggle_handler


method disable*(self: CheckBoxRef) {.base.} =
  self.enabled = false
  self.on_toggle(self, self.enabled)

method draw*(self: CheckBoxRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.text.render(self.rect_size, self.text_align)
  self.text.renderTo(Vector2(x+36, y-4), self.rect_size, self.text_align)
  self.rect_min_size = self.text.getTextSize()
  self.rect_min_size.x += 36
  self.resize(self.rect_size.x, self.rect_size.y)
  self.text.freeMemory()

  self.box.draw(x+4, y-4, 24, 24)
  if self.enabled:
    glColor(self.check_color)
    glLineWidth(2)
    glBegin(GL_LINES)
    glVertex2f(x+10, y-10)
    glVertex2f(x+22, y-22)

    glVertex2f(x+22, y-10)
    glVertex2f(x+10, y-22)
    glEnd()
    glLineWidth(1)

method duplicate*(self: CheckBoxRef): CheckBoxRef {.base.} =
  ## Duplicates ChechBox object and create a new ChechBox.
  self.deepCopy()

method enable*(self: CheckBoxRef) {.base.} =
  self.enabled = true
  self.on_toggle(self, self.enabled)

method setText*(self: CheckBoxRef, value: string, save_properties: bool = false) {.base.} =
  var st = stext(value)
  if self.text.font.isNil():
    self.text.font = standard_font
  st.font = self.text.font

  if save_properties:
    for i in 0..<st.chars.len():
      if i < self.text.len():
        st.chars[i].color = self.text.chars[i].color
        st.chars[i].style = self.text.chars[i].style
  self.text = st
  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y, true)
  self.text.rendered = false

method toggle*(self: CheckBoxRef) {.base.} =
  self.enabled = not self.enabled
  self.on_toggle(self, self.enabled)

method handle*(self: CheckBoxRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.hovered and self.focused:
    if event.kind == MOUSE and mouse_pressed:
      self.toggle()
