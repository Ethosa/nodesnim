# author: Ethosa
## It provides primitive display progress.
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
  ProgressBarObj* = object of ControlRef
    max_value*, value*: uint
    progress_color*: ColorRef
  ProgressBarRef* = ref ProgressBarObj


proc ProgressBar*(name: string = "ProgressBar"): ProgressBarRef =
  ## Creates a new ProgressBar.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var p = ProgressBar("ProgressBar")
  nodepattern(ProgressBarRef)
  controlpattern()
  result.background_color = Color(1f, 1f, 1f)
  result.rect_size.x = 120
  result.rect_size.y = 40
  result.progress_color = Color(0.5, 0.5, 0.5)
  result.max_value = 100
  result.value = 0
  result.kind = PROGRESS_BAR_NODE


method draw*(self: ProgressBarRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
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

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: ProgressBarRef): ProgressBarRef {.base.} =
  ## Duplicates ProgressBar object and create a new ProgressBar.
  self.deepCopy()

method setMaxValue*(self: ProgressBarRef, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: ProgressBarRef, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: ProgressBarRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color
