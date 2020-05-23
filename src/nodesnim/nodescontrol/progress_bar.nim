# author: Ethosa
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
  ProgressBarObj* = object of ControlPtr
    max_value*, value*: uint
    progress_color*: ColorRef
  ProgressBarPtr* = ptr ProgressBarObj


proc ProgressBar*(name: string, variable: var ProgressBarObj): ProgressBarPtr =
  nodepattern(ProgressBarObj)
  controlpattern()
  variable.background_color = Color(1f, 1f, 1f)
  variable.rect_size.x = 120
  variable.rect_size.y = 40
  variable.progress_color = Color(0.5, 0.5, 0.5)
  variable.max_value = 100
  variable.value = 0

proc ProgressBar*(obj: var ProgressBarObj): ProgressBarPtr {.inline.} =
  ProgressBar("ProgressBar", obj)


method draw*(self: ProgressBarPtr, w, h: GLfloat) =
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

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method dublicate*(self: ProgressBarPtr, obj: var ProgressBarObj): ProgressBarPtr {.base.} =
  obj = self[]
  obj.addr

method setMaxValue*(self: ProgressBarPtr, value: uint) {.base.} =
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: ProgressBarPtr, value: uint) {.base.} =
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: ProgressBarPtr, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color
