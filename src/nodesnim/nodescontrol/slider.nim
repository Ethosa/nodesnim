# author: Ethosa
## It provides primitive horizontal slider.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,

  ../nodes/node,
  control


type
  SliderObj* = object of ControlPtr
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb_color*: ColorRef
  SliderPtr* = ptr SliderObj


proc Slider*(name: string, variable: var SliderObj): SliderPtr =
  ## Creates a new Slider pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a SliderObj variable.
  runnableExamples:
    var
      scobj: SliderObj
      sc = Slider("Slider", scobj)
  nodepattern(SliderObj)
  controlpattern()
  variable.background_color = Color(1f, 1f, 1f)
  variable.rect_size.x = 120
  variable.rect_size.y = 40
  variable.progress_color = Color(0.5, 0.5, 0.5)
  variable.thumb_color = Color(0.7, 0.7, 0.7)
  variable.max_value = 100
  variable.value = 0
  variable.kind = SLIDER_NODE

proc Slider*(obj: var SliderObj): SliderPtr {.inline.} =
  ## Creates a new Slider pointer with default node name "Slider".
  ##
  ## Arguments:
  ## - `variable` is a SliderObj variable.
  runnableExamples:
    var
      scobj: SliderObj
      sc = Slider(scobj)
  Slider("Slider", obj)


method draw*(self: SliderPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Background
  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Progress
  let progress = self.rect_size.x * (self.value.float / self.max_value.float)
  glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)
  glRectf(x, y, x + progress, y - self.rect_size.y)

  # Thumb
  glColor4f(self.thumb_color.r, self.thumb_color.g, self.thumb_color.b, self.thumb_color.a)
  glRectf(x + progress - 10, y, x + progress + 10, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method duplicate*(self: SliderPtr, obj: var SliderObj): SliderPtr {.base.} =
  ## Duplicates Sider object and create a new Slider pointer.
  obj = self[]
  obj.addr

method setMaxValue*(self: SliderPtr, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: SliderPtr, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: SliderPtr, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color

method handle*(self: SliderPtr, event: InputEvent, mouse_on: var NodePtr) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.pressed:
    let
      value = normalize(1f - ((self.global_position.x + self.rect_size.x - event.x) / self.rect_size.x), 0, 1)
      progress_value = (value * self.max_value.float).uint32
    self.setProgress(progress_value)
