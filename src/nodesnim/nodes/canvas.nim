# author: Ethosa
import
  math,
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/color,
  ../core/anchor,

  node


type
  DrawCommandType* {.size: sizeof(int8).} = enum
    POINT, LINE, RECT, FILL, CIRCLE
  DrawCommand* = object
    x1*, y1*: GLfloat
    color*: ColorRef
    case kind*: DrawCommandType
    of LINE, RECT:
      x2*, y2*: GLfloat
    of CIRCLE:
      points*: seq[GLfloat]
    else:
      discard

  CanvasObj* = object of NodeObj
    commands*: seq[DrawCommand]
  CanvasPtr* = ptr CanvasObj


proc Canvas*(name: string, variable: var CanvasObj): CanvasPtr =
  ## Creates a new Canvas pointer.
  nodepattern(CanvasObj)
  variable.rect_size.x = 40
  variable.rect_size.y = 40

proc Canvas*(variable: var CanvasObj): CanvasPtr {.inline.} =
  Canvas("Canvas", variable)


proc calculateX(canvas: CanvasPtr, x, gx: GLfloat): GLfloat =
  if x > canvas.rect_size.x + gx:
    canvas.rect_size.x + gx
  elif x < gx:
    gx
  else:
    x
proc calculateY(canvas: CanvasPtr, y, gy: GLfloat): GLfloat =
  if y < gy - canvas.rect_size.y:
    gy - canvas.rect_size.y
  elif y > gy:
    gy
  else:
    y


method draw*(canvas: CanvasPtr, w, h: GLfloat) =
  canvas.calcGlobalPosition()
  let
    x = -w/2 + canvas.global_position.x
    y = h/2 - canvas.global_position.y
  for cmd in canvas.commands:
    case cmd.kind:
    of POINT:
      glBegin(GL_POINTS)
      glColor4f(cmd.color.r, cmd.color.g, cmd.color.b, cmd.color.a)
      glVertex2f(canvas.calculateX(x + cmd.x1, x), canvas.calculateY(y - cmd.y1, y))
      glEnd()
    of LINE:
      glBegin(GL_LINES)
      glColor4f(cmd.color.r, cmd.color.g, cmd.color.b, cmd.color.a)
      glVertex2f(canvas.calculateX(x + cmd.x1, x), canvas.calculateY(y - cmd.y1, y))
      glVertex2f(canvas.calculateX(x + cmd.x2, x), canvas.calculateY(y - cmd.y2, y))
      glEnd()
    of RECT:
      glColor4f(cmd.color.r, cmd.color.g, cmd.color.b, cmd.color.a)
      glRectf(
        canvas.calculateX(x + cmd.x1, x), canvas.calculateY(y - cmd.y1, y),
        canvas.calculateX(x + cmd.x2, x), canvas.calculateY(y - cmd.y2, y))
    of FILL:
      glColor4f(cmd.color.r, cmd.color.g, cmd.color.b, cmd.color.a)
      glRectf(x, y, x + canvas.rect_size.x, y - canvas.rect_size.y)
    of CIRCLE:
      glColor4f(cmd.color.r, cmd.color.g, cmd.color.b, cmd.color.a)
      glBegin(GL_TRIANGLE_FAN)
      glVertex2f(canvas.calculateX(x + cmd.x1, x), canvas.calculateY(y - cmd.y1, y))
      for i in countup(0, cmd.points.len()-1, 2):
        glVertex2f(
          canvas.calculateX(x + cmd.points[i] + cmd.x1, x),
          canvas.calculateY(y - cmd.y1 - cmd.points[i+1], y))
      glEnd()

method circle*(canvas: CanvasPtr, x, y, radius: GLfloat, color: ColorRef, quality: int = 100) {.base.} =
  ## Draws a circle in the canvas.
  ##
  ## Arguments:
  ## - `x` - circle center at X axis.
  ## - `y` - circle center at Y axis.
  ## - `radius` - circle radius.
  ## - `color` - Color object.
  ## - `quality` - circle quality.
  var pnts: seq[GLfloat]
  for i in 0..quality:
    let angle = 2*PI*i.float/quality.float
    pnts.add(radius*cos(angle))
    pnts.add(radius*sin(angle))
  canvas.commands.add(DrawCommand(kind: CIRCLE, x1: x, y1: y, color: color, points: pnts))

method point*(canvas: CanvasPtr, x, y: GLfloat, color: ColorRef) {.base.} =
  ## Draws a point in the canvas.
  ##
  ## Arguments:
  ## - `x` - point position at X axis.
  ## - `y` - point position at Y axis.
  ## - `color` - point color.
  canvas.commands.add(DrawCommand(kind: POINT, x1: x, y1: y, color: color))

method line*(canvas: CanvasPtr, x1, y1, x2, y2: GLfloat, color: ColorRef) {.base.} =
  ## Draws a line in the canvas.
  ##
  ## Arguments:
  ## - `x1` - first position at X axis.
  ## - `y1` - first position at Y axis.
  ## - `x2` - second position at X axis.
  ## - `y2` - second position at Y axis.
  ## - `color` - line color.
  canvas.commands.add(DrawCommand(kind: LINE, x1: x1, y1: y1, x2: x2, y2: y2, color: color))

method rect*(canvas: CanvasPtr, x1, y1, x2, y2: GLfloat, color: ColorRef) {.base.} =
  ## Draws a line in the canvas.
  ##
  ## Arguments:
  ## - `x1` - first position at X axis.
  ## - `y1` - first position at Y axis.
  ## - `x2` - second position at X axis.
  ## - `y2` - second position at Y axis.
  ## - `color` - rectangle color.
  canvas.commands.add(
    DrawCommand(kind: RECT, x1: x1, y1: y1, x2: x2, y2: y2, color: color)
  )

method fill*(canvas: CanvasPtr, color: ColorRef) {.base.} =
  ## Fills canvas.
  canvas.commands = @[DrawCommand(kind: FILL, x1: 0, y1: 0, color: color)]

method resize*(canvas: CanvasPtr, w, h: GLfloat) {.base.} =
  canvas.rect_size.x = w
  canvas.rect_size.y = h
