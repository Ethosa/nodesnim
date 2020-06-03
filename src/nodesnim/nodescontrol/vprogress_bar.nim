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
  VProgressBarObj* = object of ControlPtr
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb_color*: ColorRef
  VProgressBarPtr* = ptr VProgressBarObj


proc VProgressBar*(name: string, variable: var VProgressBarObj): VProgressBarPtr =
  ## Creates a new VProgressBar pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a VProgressBarObj variable.
  runnableExamples:
    var
      progressobj: VProgressBarObj
      progress = VProgressBar("VProgressBar", progressobj)
  nodepattern(VProgressBarObj)
  controlpattern()
  variable.background_color = Color(1f, 1f, 1f)
  variable.rect_size.x = 40
  variable.rect_size.y = 120
  variable.progress_color = Color(0.5, 0.5, 0.5)
  variable.thumb_color = Color(0.7, 0.7, 0.7)
  variable.max_value = 100
  variable.value = 0
  variable.kind = VPROGRESS_BAR_NODE

proc VProgressBar*(obj: var VProgressBarObj): VProgressBarPtr {.inline.} =
  ## Creates a new VProgressBar pointer with default node name "VProgressBar".
  ##
  ## Arguments:
  ## - `variable` is a VProgressBarObj variable.
  runnableExamples:
    var
      progressobj: VProgressBarObj
      progress = VProgressBar(progressobj)
  VProgressBar("VProgressBar", obj)


method draw*(self: VProgressBarPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  self.calcGlobalPosition()
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

method duplicate*(self: VProgressBarPtr, obj: var VProgressBarObj): VProgressBarPtr {.base.} =
  ## Duplicates VProgressBar object and create a new VProgressBar pointer.
  obj = self[]
  obj.addr

method setMaxValue*(self: VProgressBarPtr, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: VProgressBarPtr, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: VProgressBarPtr, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color
