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
  VSliderObj* = object of ControlPtr
    max_value*, value*: uint
    progress_color*: ColorRef
    thumb_color*: ColorRef
  VSliderPtr* = ptr VSliderObj


proc VSlider*(name: string, variable: var VSliderObj): VSliderPtr =
  nodepattern(VSliderObj)
  controlpattern()
  variable.background_color = Color(1f, 1f, 1f)
  variable.rect_size.x = 40
  variable.rect_size.y = 120
  variable.progress_color = Color(0.5, 0.5, 0.5)
  variable.thumb_color = Color(0.7, 0.7, 0.7)
  variable.max_value = 100
  variable.value = 0

proc VSlider*(obj: var VSliderObj): VSliderPtr {.inline.} =
  VSlider("VSlider", obj)


method draw*(self: VSliderPtr, w, h: GLfloat) =
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

  # Thumb
  glColor4f(self.thumb_color.r, self.thumb_color.g, self.thumb_color.b, self.thumb_color.a)
  glRectf(x, y - self.rect_size.y + progress + 10, x + self.rect_size.x, y - self.rect_size.y + progress - 10)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method dublicate*(self: VSliderPtr, obj: var VSliderObj): VSliderPtr {.base.} =
  obj = self[]
  obj.addr

method setMaxValue*(self: VSliderPtr, value: uint) {.base.} =
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: VSliderPtr, value: uint) {.base.} =
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: VSliderPtr, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color

method handle*(self: VSliderPtr, event: InputEvent, mouse_on: var NodePtr) =
  procCall self.ControlPtr.handle(event, mouse_on)
  
  let
    mouse_in = Rect2(
      self.global_position,
      Vector2(self.rect_size.x, self.rect_size.y)
    ).hasPoint(event.x, event.y)
  if self.pressed:
    let
      value = normalize(((self.global_position.y + self.rect_size.y - event.y) / self.rect_size.y), 0, 1)
      progress_value = (value * self.max_value.float).uint32
    self.setProgress(progress_value)
