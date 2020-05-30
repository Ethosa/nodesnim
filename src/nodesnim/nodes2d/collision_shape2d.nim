# author: Ethosa
## It provides collision shapes.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/circle2,
  ../core/polygon2,

  ../nodes/node,
  node2d


when defined(debug):
  import math
  const PI2 = PI*2


type
  CollisionShape2DType* {.size: sizeof(int8), pure.} = enum
    COLLISION_SHAPE_2D_RECTANGLE,
    COLLISION_SHAPE_2D_CIRCLE,
    COLLISION_SHAPE_2D_POLYGON
  CollisionShape2DObj* = object of Node2DObj
    disable*: bool
    x1*, y1*, radius*: float
    polygon*: seq[Vector2Ref]
    shape_type*: CollisionShape2DType
  CollisionShape2DPtr* = ptr CollisionShape2DObj


var shapes: seq[CollisionShape2DObj] = @[]


proc CollisionShape2D*(name: string = "CollisionShape2D"): CollisionShape2DPtr =
  ## Creates a new CollisionShape2D pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = CollisionShape2D("CollisionShape2D")
  var variable: CollisionShape2DObj
  nodepattern(CollisionShape2DObj)
  node2dpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.disable = false
  variable.x1 = 0
  variable.y1 = 0
  variable.radius = 20
  variable.polygon = @[]
  variable.kind = COLLISION_SHAPE_2D_NODE
  shapes.add(variable)
  return addr shapes[^1]


method setShapeTypeRect*(self: CollisionShape2DPtr) {.base.} =
  ## Changes shape type to `circle`.
  self.shape_type = COLLISION_SHAPE_2D_RECTANGLE


method setShapeTypeCircle*(self: CollisionShape2DPtr, cx, cy, radius: float) {.base.} =
  ## Changes shape type to `rectangle`.
  ##
  ## Arguments:
  ## - `cx` is a center circle position at X axis.
  ## - `cy` is a center circle position at Y axis.
  ## - `radius` is a circle radius.
  self.shape_type = COLLISION_SHAPE_2D_CIRCLE
  self.x1 = cx
  self.y1 = cy
  self.radius = radius


method setShapeTypePolygon*(self: CollisionShape2DPtr, positions: varargs[Vector2Ref]) {.base.} =
  ## Changes shape type to `polygon`.
  ##
  ## Arguments:
  ## - `positions` is a varargs of polygon positions. Should be more than 2.
  self.shape_type = COLLISION_SHAPE_2D_POLYGON
  if positions.len() < 3:
    return

  self.polygon = @[]
  for i in positions:
    self.polygon.add(i)


method draw*(self: CollisionShape2DPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  # Recalculate position.
  self.position = self.timed_position
  if self.centered:
    self.position = self.timed_position - self.rect_size/2
  else:
    self.position = self.timed_position

  self.calcGlobalPosition()

  # debug draw
  when defined(debug):
    let
      x = -w/2 + self.global_position.x
      y = h/2 - self.global_position.y
    if self.disable:
      glColor4f(0.5, 0.5, 0.5, 0.7)
    else:
      glColor4f(0.5, 0.6, 0.9, 0.7)

    case self.shape_type
    of COLLISION_SHAPE_2D_RECTANGLE:
      glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)
    of COLLISION_SHAPE_2D_CIRCLE:
      glBegin(GL_TRIANGLE_FAN)
      glVertex3f(x + self.x1, y - self.y1, self.z_index_global)
      for i in 0..180:
        let angle = PI2*i.float/180f
        glVertex3f(x + self.x1 + self.radius*cos(angle), y - self.y1 - self.radius*sin(angle), self.z_index_global)
      glEnd()
    of COLLISION_SHAPE_2D_POLYGON:
      glBegin(GL_POLYGON)
      for vec2 in self.polygon:
        glVertex3f(x + vec2.x, y - vec2.y, self.z_index_global)
      glEnd()


method duplicate*(self: CollisionShape2DPtr): CollisionShape2DPtr {.base.} =
  ## Duplicates CollisionShape2D object and create a new CollisionShape2D pointer.
  var obj = self[]
  shapes.add(obj)
  return addr shapes[^1]


method getGlobalMousePosition*(self: CollisionShape2DPtr): Vector2Ref {.inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)


method isCollide*(self: CollisionShape2DPtr, x, y: float): bool =
  ## Checks collision with point.
  ##
  ## Arguments:
  ## - `x` is a point position at X axis.
  ## - `y` is a point position at Y axis.
  self.calcGlobalPosition()
  if self.disable:
    return false
  case self.shape_type
  of COLLISION_SHAPE_2D_RECTANGLE:
    return Rect2(self.global_position, self.rect_size).contains(x, y)
  of COLLISION_SHAPE_2D_CIRCLE:
    let
      dx = x - self.x1
      dy = y - self.y1
    return dx*dx + dy*dy <= self.radius*self.radius
  of COLLISION_SHAPE_2D_POLYGON:
    result = false
    var next = 1
    let length = self.polygon.len()

    for i in 0..<length:
      inc next
      if next == length: next = 0
      let
        a = self.polygon[i] + self.global_position
        b = self.polygon[next] + self.global_position
      if ((a.y >= y and b.y < y) or (a.y < y and b.y >= y)) and (x < (b.x-a.x)*(y-a.y) / (b.y-a.y)+a.x):
        result = not result

method isCollide*(self: CollisionShape2DPtr, vec2: Vector2Ref): bool =
  ## Checks collision with point.
  self.calcGlobalPosition()
  if self.disable:
    return false
  case self.shape_type
  of COLLISION_SHAPE_2D_RECTANGLE:
    return Rect2(self.global_position, self.rect_size).contains(vec2)
  of COLLISION_SHAPE_2D_CIRCLE:
    let
      dx = vec2.x - self.x1
      dy = vec2.y - self.y1
    return dx*dx + dy*dy <= self.radius*self.radius
  of COLLISION_SHAPE_2D_POLYGON:
    result = false
    var next = 1
    let length = self.polygon.len()

    for i in 0..<length:
      inc next
      if next == length: next = 0
      let
        a = self.polygon[i] + self.global_position
        b = self.polygon[next] + self.global_position
      if ((a.y >= vec2.y and b.y < vec2.y) or (a.y < vec2.y and b.y >= vec2.y)) and (vec2.x < (b.x-a.x)*(vec2.y-a.y) / (b.y-a.y)+a.x):
        result = not result


method isCollide*(self, other: CollisionShape2DPtr): bool {.base.} =
  ## Checks collision with other CollisionShape2D object.
  self.calcGlobalPosition()
  other.calcGlobalPosition()

  # Return false, if collision shape is disabled.
  if self.disable:
    return false
  elif other.disable:
    return false

  case self.shape_type
  of COLLISION_SHAPE_2D_RECTANGLE:
    case other.shape_type:
      of COLLISION_SHAPE_2D_RECTANGLE:
        return Rect2(other.global_position, other.rect_size).intersects(Rect2(self.global_position, self.rect_size))
      of COLLISION_SHAPE_2D_CIRCLE:
        return Rect2(self.global_position, self.rect_size).isCollideWithCircle(
          other.global_position.x + other.x1,
          other.global_position.y + other.y1, other.radius)
      of COLLISION_SHAPE_2D_POLYGON:
        var
          rect = Rect2(self.global_position, self.rect_size)
          a = Polygon2(other.polygon)
        a.move(other.global_position)
        return a.intersects(rect)
  of COLLISION_SHAPE_2D_CIRCLE:
    case other.shape_type:
      of COLLISION_SHAPE_2D_CIRCLE:
        let
          sradii = self.radius + other.radius
          dx = (other.global_position.x + other.x1) - (self.global_position.x + self.x1)
          dy = (other.global_position.y + other.y1) - (self.global_position.y + self.y1)
        return dx*dx + dy*dy <= sradii*sradii
      of COLLISION_SHAPE_2D_RECTANGLE:
        return Rect2(other.global_position, other.rect_size).isCollideWithCircle(
          self.global_position.x + self.x1,
          self.global_position.y + self.y1, self.radius)
      of COLLISION_SHAPE_2D_POLYGON:
        var
          circle = Circle2(self.global_position.x + self.x1, self.global_position.y + self.y1, self.radius)
          a = Polygon2(other.polygon)
        a.move(other.global_position)
        return a.intersects(circle)
  of COLLISION_SHAPE_2D_POLYGON:
    case other.shape_type:
      of COLLISION_SHAPE_2D_RECTANGLE:
        var
          rect = Rect2(other.global_position, other.rect_size)
          a = Polygon2(self.polygon)
        a.move(self.global_position)
        return a.intersects(rect)
      of COLLISION_SHAPE_2D_POLYGON:
        var
          a = Polygon2(self.polygon)
          b = Polygon2(other.polygon)
        a.move(self.global_position)
        b.move(other.global_position)
        return a.intersects(b)
      of COLLISION_SHAPE_2D_CIRCLE:
        var
          circle = Circle2(other.global_position.x + other.x1, other.global_position.y + other.y1, other.radius)
          a = Polygon2(self.polygon)
        a.move(self.global_position)
        return a.intersects(circle)
