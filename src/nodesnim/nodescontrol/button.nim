# author: Ethosa
## Handles mouse clicks.
import ../thirdparty/sdl2 except Color
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,
  ../core/font,
  ../core/themes,
  ../private/templates,

  ../nodes/node,
  ../graphics/drawable,
  control,
  label


type
  ButtonTouchHandler* = proc(self: ButtonRef, x, y: float)
  ButtonObj* = object of LabelObj
    button_mask*: cint  ## Mask for handle clicks
    action_mask*: cint  ## BUTTON_RELEASE or BUTTON_CLICK.

    normal_background*: DrawableRef  ## color, when button is not pressed and not hovered.
    hover_background*: DrawableRef   ## color, when button hovered.
    press_background*: DrawableRef   ## color, when button pressed.

    on_touch*: ButtonTouchHandler ## This called, when user clicks on button.
  ButtonRef* = ref ButtonObj

let touch_handler = proc(self: ButtonRef, x, y: float) = discard


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
  result.text = stext""
  result.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  result.button_mask = BUTTON_LEFT.cint
  result.action_mask = BUTTON_RELEASE
  result.normal_background = Drawable()
  result.hover_background = Drawable()
  result.press_background = Drawable()
  result.normal_background.setColor(current_theme~background_deep)
  result.hover_background.setColor(current_theme~accent)
  result.press_background.setColor(current_theme~accent_dark)
  result.on_touch = touch_handler
  result.on_text_changed = text_changed_handler
  result.kind = BUTTON_NODE


method draw*(self: ButtonRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  self.background =
      if self.pressed and self.focused:
        self.press_background
      elif self.hovered and not mouse_pressed:
        self.hover_background
      else:
        self.normal_background

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
