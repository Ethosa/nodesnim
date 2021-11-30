# author: Ethosa
## It provides primitive display progress.
import ../thirdparty/sdl2 except Color, glBindTexture
import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,
  ../core/enums,
  ../core/nodes_os,
  ../core/themes,
  ../private/templates,

  ../nodes/node,
  ../nodes/canvas,
  ../graphics/drawable,
  control,
  math

const CIRCLE_STEP: float = TAU * 0.01

type
  ProgressBarObj* = object of ControlRef
    max_value*, value*: float
    progress_color*: ColorRef
    indeterminate_val*: float
    indeterminate*: bool
    progress_type*: ProgressBarType
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
  result.value = 0
  result.max_value = 100
  result.progress_color = current_theme~accent
  result.rect_size.x = 120
  result.rect_size.y = 20
  result.indeterminate = false
  result.indeterminate_val = 0
  result.progress_type = PROGRESS_BAR_HORIZONTAL
  result.kind = PROGRESS_BAR_NODE


method draw*(self: ProgressBarRef, w, h: GLfloat) =
  ## It uses for redraw ProgressBar.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # draw progress
  let progress_percent = self.value / self.max_value

  case self.progress_type
  of PROGRESS_BAR_HORIZONTAL:
    procCall self.ControlRef.draw(w, h)
    glColor(self.progress_color)
    let progress_width = progress_percent * self.rect_size.x
    if self.indeterminate:
      if self.indeterminate_val - progress_width < self.rect_size.x:
        self.indeterminate_val += self.rect_size.x * 0.01
      else:
        self.indeterminate_val = -progress_width
      glRectf(
        norm(x, x + self.rect_size.x, x + self.indeterminate_val), y,
        norm(x, x + self.rect_size.x, x + self.indeterminate_val + progress_width), y - self.rect_size.y)
    else:
      glRectf(x, y, x + progress_width, y - self.rect_size.y)

  of PROGRESS_BAR_VERTICAL:
    procCall self.ControlRef.draw(w, h)
    glColor(self.progress_color)
    let progress_width = progress_percent * self.rect_size.y
    if self.indeterminate:
      if self.indeterminate_val - progress_width < self.rect_size.y:
        self.indeterminate_val += self.rect_size.y * 0.01
      else:
        self.indeterminate_val = -progress_width
      glRectf(
        x, norm(y - self.rect_size.y, y, y - self.indeterminate_val),
        x + self.rect_size.x, norm(y - self.rect_size.y, y, y - self.indeterminate_val - progress_width))
    else:
      glRectf(x, y, x + self.rect_size.x, y - progress_width)

  of PROGRESS_BAR_CIRCLE:
    self.CanvasRef.calcGlobalPosition()
    let
      progress_width = progress_percent * TAU
      cx = x + (self.rect_size.x / 2)
      cy = y - (self.rect_size.y / 2)
      orad = min(self.rect_size.x, self.rect_size.y) / 2
      irad = (min(self.rect_size.x, self.rect_size.y) / 2) - 5f
    # background:
    glColor(self.background.getColor())
    glBegin(GL_TRIANGLE_STRIP)
    for i in 0..90:
      let angle = TAU * (i/90)
      glVertex2f(cx + orad*cos(angle), cy - orad*sin(angle))
      glVertex2f(cx + irad*cos(angle), cy - irad*sin(angle))
    glEnd()

    # progress:
    glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)
    if self.indeterminate:
      if self.indeterminate_val - progress_width < TAU:
        self.indeterminate_val += CIRCLE_STEP
      else:
        self.indeterminate_val = -progress_width
      glBegin(GL_TRIANGLE_STRIP)
      for i in 0..90:
        let angle = TAU * (i/90)
        if angle > self.indeterminate_val and angle < progress_width + self.indeterminate_val:
          glVertex2f(cx + orad*cos(angle), cy - orad*sin(angle))
          glVertex2f(cx + irad*cos(angle), cy - irad*sin(angle))
      glEnd()
    else:
      glBegin(GL_TRIANGLE_STRIP)
      for i in 0..90:
        let angle = TAU * (i/90)
        if angle < progress_width:
          glVertex2f(cx + orad*cos(angle), cy - orad*sin(angle))
          glVertex2f(cx + irad*cos(angle), cy - irad*sin(angle))
      glEnd()

method duplicate*(self: ProgressBarRef): ProgressBarRef {.base.} =
  ## Duplicates ProgressBar object and create a new ProgressBar.
  self.deepCopy()

method setMaxValue*(self: ProgressBarRef, value: float) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: ProgressBarRef, value: float) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressColor*(self: ProgressBarRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  ## For change background color use `setBackgroundColor` method.
  self.progress_color = color
