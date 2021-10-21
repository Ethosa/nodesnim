# author: Ethosa
## It provides primitive horizontal slider.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,
  ../core/enums,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  SliderChangedHandler* = proc(self: SliderRef, new_value: uint)
  SliderObj* = object of ControlRef
    slider_type*: SliderType
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb*: DrawableRef

    on_changed*: SliderChangedHandler
  SliderRef* = ref SliderObj

let slider_changed_handler*: SliderChangedHandler =
    proc(self: SliderRef, new_value: uint) = discard

proc Slider*(name: string = "Slider"): SliderRef =
  ## Creates a new Slider.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var sc = Slider("Slider")
  nodepattern(SliderRef)
  controlpattern()
  result.slider_type = SLIDER_HORIZONTAL
  result.thumb = Drawable()
  result.background.setColor(Color(1f, 1f, 1f))
  result.thumb.setColor(Color(0.7, 0.7, 0.7))
  result.rect_size.x = 120
  result.rect_size.y = 40
  result.progress_color = Color(0.5, 0.5, 0.5)
  result.max_value = 100
  result.value = 0
  result.on_changed = slider_changed_handler
  result.kind = SLIDER_NODE


method draw*(self: SliderRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Background
  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  # Progress
  case self.slider_type
  of SLIDER_HORIZONTAL:
    let progress = self.rect_size.x * (self.value.float / self.max_value.float)
    glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)
    glRectf(x, y, x + progress, y - self.rect_size.y)

    # Thumb
    self.thumb.draw(x + progress, y, 10, self.rect_size.y)

  of SLIDER_VERTICAL:
    let progress = self.rect_size.y * (self.value.float / self.max_value.float)
    glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)
    glRectf(x, y - self.rect_size.y + progress, x + self.rect_size.x, y - self.rect_size.y)

    # Thumb
    self.thumb.draw(x, y-self.rect_size.y+progress, self.rect_size.x, 10)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: SliderRef): SliderRef {.base.} =
  ## Duplicates Sider object and create a new Slider.
  self.deepCopy()

method setMaxValue*(self: SliderRef, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: SliderRef, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: SliderRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color

method handle*(self: SliderRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.focused and self.pressed:
    let
      value =
        case self.slider_type
        of SLIDER_HORIZONTAL:
          normalize(1f - ((self.global_position.x + self.rect_size.x - event.x) / self.rect_size.x), 0, 1)
        of SLIDER_VERTICAL:
          normalize(((self.global_position.y + self.rect_size.y - event.y) / self.rect_size.y), 0, 1)
      progress_value = (value * self.max_value.float).uint
    if progress_value != self.value:
      self.on_changed(self, progress_value)
    self.setProgress(progress_value)
