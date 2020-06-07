# author: Ethosa
## Handles mouse clicks.
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
  control,
  label


type
  ButtonObj* = object of LabelObj
    button_mask*: cint  ## Mask for handle clicks
    action_mask*: cint  ## BUTTON_RELEASE or BUTTON_CLICK.

    normal_background_color*: ColorRef  ## color, when button is not pressed and not hovered.
    hover_background_color*: ColorRef   ## color, when button hovered.
    press_background_color*: ColorRef   ## color, when button pressed.

    normal_color*: ColorRef  ## text color, whenwhen button is not pressed and not hovered.
    hover_color*: ColorRef   ## text color, when button hovered.
    press_color*: ColorRef   ## text color, when button pressed.

    on_touch*: proc(self: ButtonRef, x, y: float): void  ## This called, when user clicks on button.
  ButtonRef* = ref ButtonObj


proc Button*(name: string = "Button"): ButtonRef =
  ## Creates a new Button node.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var my_button = Button("Button")
  nodepattern(ButtonRef)
  controlpattern()
  result.rect_size.x = 160
  result.rect_size.y = 40
  result.text = ""
  result.font = GLUT_BITMAP_HELVETICA_12
  result.size = 12
  result.spacing = 2
  result.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  result.color = Color(1f, 1f, 1f)
  result.normal_color = Color(1f, 1f, 1f)
  result.hover_color = Color(1f, 1f, 1f)
  result.press_color = Color(1f, 1f, 1f)
  result.button_mask = BUTTON_LEFT
  result.action_mask = BUTTON_RELEASE
  result.normal_background_color = Color(0x444444ff)
  result.hover_background_color = Color(0x505050ff)
  result.press_background_color = Color(0x595959ff)
  result.on_touch = proc(self: ButtonRef, x, y: float) = discard
  result.kind = BUTTON_NODE


method draw*(self: ButtonRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    color =
      if self.pressed and self.focused:
        self.press_background_color
      elif self.hovered and not mouse_pressed:
        self.hover_background_color
      else:
        self.normal_background_color
  self.color =
    if self.pressed and self.focused:
      self.press_color
    elif self.hovered and not mouse_pressed:
      self.hover_color
    else:
      self.normal_color
  glColor4f(color.r, color.g, color.b, color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)
  procCall self.LabelRef.draw(w, h)

method duplicate*(self: ButtonRef, obj: var ButtonObj): ButtonRef {.base.} =
  ## Duplicates Button object and creates a new Button node pointer.
  self.deepCopy()

method handle*(self: ButtonRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.hovered and self.focused:
    if event.kind == MOUSE and self.action_mask == 1 and mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)
    elif event.kind == MOUSE and self.action_mask == 0 and not mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)
