# author: Ethosa
## It provides a primitive display vertical progress.
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
  VProgressBarObj* = object of ControlRef
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb_color*: ColorRef
  VProgressBarRef* = ref VProgressBarObj


proc VProgressBar*(name: string = "VProgressBar"): VProgressBarRef =
  ## Creates a new VProgressBar.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var progress = VProgressBar("VProgressBar")
  nodepattern(VProgressBarRef)
  controlpattern()
  result.background_color = Color(1f, 1f, 1f)
  result.rect_size.x = 40
  result.rect_size.y = 120
  result.progress_color = Color(0.5, 0.5, 0.5)
  result.thumb_color = Color(0.7, 0.7, 0.7)
  result.max_value = 100
  result.value = 0
  result.kind = VPROGRESS_BAR_NODE


method draw*(self: VProgressBarRef, w, h: GLfloat) =
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

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: VProgressBarRef): VProgressBarRef {.base.} =
  ## Duplicates VProgressBar object and create a new VProgressBar.
  self.deepCopy()

method setMaxValue*(self: VProgressBarRef, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: VProgressBarRef, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: VProgressBarRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color
