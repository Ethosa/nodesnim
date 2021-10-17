# author: Ethosa
## It provides collision shapes.
import
  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/circle,
  ../core/polygon2,

  ../nodes/node,
  ../nodes/canvas,
  node2d


when defined(debug):
  import
    math,
    ../thirdparty/opengl
  const PI2 = PI*2


type
  CollisionShape2DObj* = object of Node2DObj
    disable*: bool
    x1*, y1*, radius*: float
    polygon*: seq[Vector2Obj]
    shape_type*: CollisionShape2DType
  CollisionShape2DRef* = ref CollisionShape2DObj



proc CollisionShape2D*(name: string = "CollisionShape2D"): CollisionShape2DRef =
  ## Creates a new CollisionShape2D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = CollisionShape2D("CollisionShape2D")
  nodepattern(CollisionShape2DRef)
  node2dpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.disable = false
  result.x1 = 0
  result.y1 = 0
  result.radius = 20
  result.polygon = @[]
  result.centered = false
  result.kind = COLLISION_SHAPE_2D_NODE


method setShapeTypeRect*(self: CollisionShape2DRef) {.base.} =
  ## Changes shape type to `circle`.
  self.shape_type = COLLISION_SHAPE_2D_RECTANGLE


method setShapeTypeCircle*(self: CollisionShape2DRef, cx, cy, radius: float) {.base.} =
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


method setShapeTypePolygon*(self: CollisionShape2DRef, positions: varargs[Vector2Obj]) {.base.} =
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


when defined(debug):
  method draw*(self: CollisionShape2DRef, w, h: GLfloat) =
    ## this method uses in the `window.nim`.
    {.warning[LockLevel]: off.}
    procCall self.Node2DRef.draw(w, h)
    let
      x = -w/2 + self.global_position.x
      y = h/2 - self.global_position.y
    if self.disable:
      glColor4f(0.5, 0.5, 0.5, 0.7)
    else:
      glColor4f(0.5, 0.6, 0.9, 0.7)
    glEnable(GL_DEPTH_TEST)

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
    glColor4f(1, 1, 1, 1)
    glDisable(GL_DEPTH_TEST)


method duplicate*(self: CollisionShape2DRef): CollisionShape2DRef {.base.} =
  ## Duplicates CollisionShape2D object and create a new CollisionShape2D.
  self.deepCopy()

method isCollide*(self: CollisionShape2DRef, x, y: float): bool {.base.} =
  ## Checks collision with point.
  ##
  ## Arguments:
  ## - `x` is a point position at X axis.
  ## - `y` is a point position at Y axis.
  self.CanvasRef.calcGlobalPosition()
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

method isCollide*(self: CollisionShape2DRef, vec2: Vector2Obj): bool {.base.} =
  ## Checks collision with point.
  self.isCollide(vec2.x, vec2.y)


method isCollide*(self, other: CollisionShape2DRef): bool {.base.} =
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
        return Rect2(other.global_position, other.rect_size).intersects(Rect2(self.global_position, self.rect_size)) or
               Rect2(self.global_position, self.rect_size).intersects(Rect2(other.global_position, other.rect_size))
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
          circle = Circle(self.global_position.x + self.x1, self.global_position.y + self.y1, self.radius)
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
          circle = Circle(other.global_position.x + other.x1, other.global_position.y + other.y1, other.radius)
          a = Polygon2(self.polygon)
        a.move(self.global_position)
        return a.intersects(circle)
