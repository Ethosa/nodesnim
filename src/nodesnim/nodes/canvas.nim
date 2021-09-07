# author: Ethosa
## Canvas is the root type of all 2D and Control nodes.
## 
## Canvas used for drawing primitive geometry.
import
  math,
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/color,
  ../core/anchor,
  ../core/enums,

  node


const TAU = PI + PI


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

    position*: Vector2Ref            ## Node position, by default is Vector2(0, 0).
    global_position*: Vector2Ref     ## Node global position.
    rect_size*: Vector2Ref           ## Node size.
    rect_min_size*: Vector2Ref
    size_anchor*: Vector2Ref         ## Node size anchor.
    anchor*: AnchorRef               ## Node anchor.
    can_use_anchor*: bool
    can_use_size_anchor*: bool
  CanvasRef* = ref CanvasObj


proc Canvas*(name: string = "Canvas"): CanvasRef =
  ## Creates a new Canvas.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var canvas1 = Canvas("Canvas")
  nodepattern(CanvasRef)
  result.rect_size = Vector2(40, 40)
  result.rect_min_size = Vector2()
  result.position = Vector2()
  result.global_position = Vector2()
  result.anchor = Anchor(0, 0, 0, 0)
  result.size_anchor = Vector2()
  result.can_use_anchor = false
  result.can_use_size_anchor = false
  result.kind = CANVAS_NODE
  result.type_of_node = NODE_TYPE_CONTROL


method calcGlobalPosition*(self: CanvasRef) {.base.} =
  ## Returns global node position.
  self.global_position = self.position
  var current: CanvasRef = self
  while current.parent != nil:
    current = current.parent.CanvasRef
    self.global_position += current.position

method calcPositionAnchor*(self: CanvasRef) {.base.} =
  ## Calculates node position with anchor.
  ## This used in the Window object.
  discard

proc calculateX(canvas: CanvasRef, x, gx: GLfloat): GLfloat =
  if x > canvas.rect_size.x + gx:
    canvas.rect_size.x + gx
  elif x < gx:
    gx
  else:
    x
proc calculateY(canvas: CanvasRef, y, gy: GLfloat): GLfloat =
  if y < gy - canvas.rect_size.y:
    gy - canvas.rect_size.y
  elif y > gy:
    gy
  else:
    y


method draw*(canvas: CanvasRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
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

method duplicate*(self: CanvasRef): CanvasRef {.base.} =
  ## Duplicates Canvas object and create a new Canvas.
  self.deepCopy()

method move*(self: CanvasRef, vec2: Vector2Ref) {.base, inline.} =
  ## Adds `vec2` to the node position.
  ##
  ## Arguments:
  ## - `vec2`: how much to add to the position on the X,Y axes.
  self.position += vec2
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method move*(self: CanvasRef, x, y: float) {.base, inline.} =
  ## Adds `x` and` y` to the node position.
  ##
  ## Arguments:
  ## - `x`: how much to add to the position on the X axis.
  ## - `y`: how much to add to the position on the Y axis.
  self.position += Vector2(x, y)
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method circle*(canvas: CanvasRef, x, y, radius: GLfloat, color: ColorRef, quality: int = 100) {.base.} =
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
    let angle = TAU*i.float/quality.float
    pnts.add(radius*cos(angle))
    pnts.add(radius*sin(angle))
  canvas.commands.add(DrawCommand(kind: CIRCLE, x1: x, y1: y, color: color, points: pnts))

method point*(canvas: CanvasRef, x, y: GLfloat, color: ColorRef) {.base.} =
  ## Draws a point in the canvas.
  ##
  ## Arguments:
  ## - `x` - point position at X axis.
  ## - `y` - point position at Y axis.
  ## - `color` - point color.
  canvas.commands.add(DrawCommand(kind: POINT, x1: x, y1: y, color: color))

method line*(canvas: CanvasRef, x1, y1, x2, y2: GLfloat, color: ColorRef) {.base.} =
  ## Draws a line in the canvas.
  ##
  ## Arguments:
  ## - `x1` - first position at X axis.
  ## - `y1` - first position at Y axis.
  ## - `x2` - second position at X axis.
  ## - `y2` - second position at Y axis.
  ## - `color` - line color.
  canvas.commands.add(DrawCommand(kind: LINE, x1: x1, y1: y1, x2: x2, y2: y2, color: color))

method rect*(canvas: CanvasRef, x1, y1, x2, y2: GLfloat, color: ColorRef) {.base.} =
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

method fill*(canvas: CanvasRef, color: ColorRef) {.base.} =
  ## Fills canvas.
  canvas.commands = @[DrawCommand(kind: FILL, x1: 0, y1: 0, color: color)]

method resize*(self: CanvasRef, w, h: GLfloat) {.base.} =
  ## Resizes canvas.
  ##
  ## Arguments:
  ## - `w` is a new width.
  ## - `h` is a new height.
  if w > self.rect_min_size.x:
    self.rect_size.x = w
    self.size_anchor = nil
  else:
    self.rect_size.x = self.rect_min_size.x
  if h > self.rect_min_size.y:
    self.rect_size.y = h
    self.size_anchor = nil
  else:
    self.rect_size.y = self.rect_min_size.y
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method setAnchor*(self: CanvasRef, anchor: AnchorRef) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `anchor` - AnchorRef object.
  self.anchor = anchor
  self.can_use_anchor = true

method setAnchor*(self: CanvasRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `x1` and `y1` - anchor relative to the parent node.
  ## - `x2` and `y2` - anchor relative to this node.
  self.anchor = Anchor(x1, y1, x2, y2)
  self.can_use_anchor = true

method setSizeAnchor*(self: CanvasRef, anchor: Vector2Ref) {.base.} =
  self.size_anchor = anchor
  self.can_use_size_anchor = true

method setSizeAnchor*(self: CanvasRef, x, y: float) {.base.} =
  self.size_anchor = Vector2(x, y)
  self.can_use_size_anchor = true
