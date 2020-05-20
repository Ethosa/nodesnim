# author: Ethosa
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

    on_click*: proc(x, y: float): void  ## This called, when user clicks on button.
  ButtonPtr* = ptr ButtonObj


proc Button*(name: string, variable: var ButtonObj): ButtonPtr =
  nodepattern(ButtonObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.text = ""
  variable.font = GLUT_BITMAP_HELVETICA_12
  variable.size = 12
  variable.spacing = 2
  variable.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.color = Color(1f, 1f, 1f)
  variable.normal_color = Color(1f, 1f, 1f)
  variable.hover_color = Color(1f, 1f, 1f)
  variable.press_color = Color(1f, 1f, 1f)
  variable.button_mask = BUTTON_LEFT
  variable.action_mask = BUTTON_RELEASE
  variable.normal_background_color = Color(0x444444ff)
  variable.hover_background_color = Color(0x505050ff)
  variable.press_background_color = Color(0x595959ff)
  variable.on_click = proc(x, y: float) = discard

proc Button*(obj: var ButtonObj): ButtonPtr {.inline.} =
  Button("Button", obj)


method draw*(self: ButtonPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    color =
      if self.pressed:
        self.press_background_color
      elif self.hovered:
        self.hover_background_color
      else:
        self.normal_background_color
  self.color =
    if self.pressed:
      self.press_color
    elif self.hovered:
      self.hover_color
    else:
      self.normal_color
  glColor4f(color.r, color.g, color.b, color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)
  procCall self.LabelPtr.draw(w, h)

method dublicate*(self: ButtonPtr, obj: var ButtonObj): ButtonPtr {.base.} =
  obj = self[]
  obj.addr

method handle*(self: ButtonPtr, event: InputEvent, mouse_on: var NodePtr) =
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.hovered:
    if event.kind == MOUSE and self.action_mask == 1 and mouse_pressed and self.button_mask == event.button_index:
      self.on_click(event.x, event.y)
    elif event.kind == MOUSE and self.action_mask == 0 and not mouse_pressed and self.button_mask == event.button_index:
      self.on_click(event.x, event.y)
