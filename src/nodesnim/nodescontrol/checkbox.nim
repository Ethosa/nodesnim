# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/enums,
  ../core/color,
  ../core/input,
  ../core/vector2,
  ../core/font,

  ../graphics/drawable,

  ../nodes/node,
  ../nodes/canvas,

  label,
  control


type
  CheckBoxRef* = ref object of ControlRef
    enabled*: bool

    box: DrawableRef
    text: LabelRef

    on_toggle*: proc(self: CheckBoxRef, toggled: bool): void  ## This called when switch toggled.

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
  result.text = Label()
  result.kind = CHECKBOX_NODE

  result.box.setCornerRadius(8)
  result.box.setCornerDetail(8)
  result.box.setColor(Color("#444444"))
  result.box.setBorderColor(Color("#555555"))
  result.box.setBorderWidth(1)
  result.on_toggle = proc(self: CheckBoxRef, toggled: bool) = discard


method disable*(self: CheckBoxRef) {.base.} =
  self.enabled = false
  self.on_toggle(self, self.enabled)

method draw*(self: CheckBoxRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if not self.text.text.rendered:
    self.text.text.render(self.text.rect_size, self.text.text_align)
  self.text.text.renderTo(Vector2(x+36, y-4), self.text.rect_size, self.text.text_align)
  self.rect_min_size = self.text.text.getTextSize()
  self.rect_min_size.x += 36
  self.resize(self.rect_size.x, self.rect_size.y)

  self.box.draw(x+4, y-4, 24, 24)
  if self.enabled:
    glColor4f(1f, 1f, 1f, 1f)
    glBegin(GL_LINES)
    glVertex2f(x+10, y-10)
    glVertex2f(x+22, y-22)

    glVertex2f(x+22, y-10)
    glVertex2f(x+10, y-22)
    glEnd()

method duplicate*(self: CheckBoxRef): CheckBoxRef {.base.} =
  ## Duplicates ChechBox object and create a new ChechBox.
  self.deepCopy()

method enable*(self: CheckBoxRef) {.base.} =
  self.enabled = true
  self.on_toggle(self, self.enabled)

method setText*(self: CheckBoxRef, value: string, save_properties: bool = false) {.base.} =
  self.text.setText(value, save_properties)

method toggle*(self: CheckBoxRef) {.base.} =
  self.enabled = not self.enabled
  self.on_toggle(self, self.enabled)

method handle*(self: CheckBoxRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.hovered and self.focused:
    if event.kind == MOUSE and not mouse_pressed and event.button_index == 0:
      self.toggle()
