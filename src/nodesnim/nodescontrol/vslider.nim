# author: Ethosa
## It provides a primitive vertical slider.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,
  ../core/enums,

  ../nodes/node,
  control


type
  VSliderObj* = object of ControlRef
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb_color*: ColorRef

    on_changed*: proc(self: VSliderRef, new_value: uint): void
  VSliderRef* = ref VSliderObj


proc VSlider*(name: string = "VSlider"): VSliderRef =
  ## Creates a new VSlider.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var slider = VSlider("VSlider")
  nodepattern(VSliderRef)
  controlpattern()
  result.background_color = Color(1f, 1f, 1f)
  result.rect_size.x = 40
  result.rect_size.y = 120
  result.progress_color = Color(0.5, 0.5, 0.5)
  result.thumb_color = Color(0.7, 0.7, 0.7)
  result.max_value = 100
  result.value = 0
  result.on_changed = proc(self: VSliderRef, v: uint) = discard
  result.kind = VSLIDER_NODE


method draw*(self: VSliderRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Background
  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Progress
  let progress = self.rect_size.y * (self.value.float / self.max_value.float)
  glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)
  glRectf(x, y - self.rect_size.y + progress, x + self.rect_size.x, y - self.rect_size.y)

  # Thumb
  glColor4f(self.thumb_color.r, self.thumb_color.g, self.thumb_color.b, self.thumb_color.a)
  glRectf(x, y - self.rect_size.y + progress + 10, x + self.rect_size.x, y - self.rect_size.y + progress - 10)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: VSliderRef): VSliderRef {.base.} =
  ## Duplicates VSlider object and create a new VSlider.
  self.deepCopy()

method setMaxValue*(self: VSliderRef, value: uint) {.base.} =
  ## Changes max value, if it not less than progress.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: VSliderRef, value: uint) {.base.} =
  ## Changes progress, if it not more than max value.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: VSliderRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color

method handle*(self: VSliderRef, event: InputEvent, mouse_on: var NodeRef) =
  ## handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.focused and self.pressed:
    let
      value = normalize(((self.global_position.y + self.rect_size.y - event.y) / self.rect_size.y), 0, 1)
      progress_value = (value * self.max_value.float).uint
    if progress_value != self.value:
      self.on_changed(self, progress_value)
    self.setProgress(progress_value)
