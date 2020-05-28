# author: Ethosa
## It provides collision shapes.
import
  math,
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  node2d


when defined(debug):
  const PI2 = PI*2


type
  CollisionShape2DType* {.size: sizeof(int8), pure.} = enum
    COLLISION_SHAPE_2D_RECTANGLE,
    COLLISION_SHAPE_2D_CIRCLE
  CollisionShape2DObj* = object of Node2DObj
    disable*: bool
    x1*, y1*, radius*: float
    shape_type*: CollisionShape2DType
  CollisionShape2DPtr* = ptr CollisionShape2DObj



proc CollisionShape2D*(name: string, variable: var CollisionShape2DObj): CollisionShape2DPtr =
  ## Creates a new CollisionShape2D pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a CollisionShape2DObj variable.
  runnableExamples:
    var
      node_obj: CollisionShape2DObj
      node = CollisionShape2D("CollisionShape2D", node_obj)
  nodepattern(CollisionShape2DObj)
  node2dpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.disable = false
  variable.x1 = 0
  variable.y1 = 0
  variable.radius = 20

proc CollisionShape2D*(obj: var CollisionShape2DObj): CollisionShape2DPtr {.inline.} =
  ## Creates a new CollisionShape2D pointer with deffault node name "CollisionShape2D".
  ##
  ## Arguments:
  ## - `variable` is a CollisionShape2DObj variable.
  runnableExamples:
    var
      node_obj: CollisionShape2DObj
      node = CollisionShape2D(node_obj)
  CollisionShape2D("CollisionShape2D", obj)


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
      glVertex2f(x + self.x1, y - self.y1)
      for i in 0..180:
        let angle = PI2*i.float/180f
        glVertex2f(x + self.x1 + self.radius*cos(angle), y - self.y1 - self.radius*sin(angle))
      glEnd()

method duplicate*(self: CollisionShape2DPtr, obj: var CollisionShape2DObj): CollisionShape2DPtr {.base.} =
  ## Duplicates CollisionShape2D object and create a new CollisionShape2D pointer.
  obj = self[]
  obj.addr

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
    Rect2(self.global_position, self.rect_size).contains(x, y)
  of COLLISION_SHAPE_2D_CIRCLE:
    let
      dx = x - self.x1
      dy = y - self.y1
    return dx*dx + dy*dy <= self.radius*self.radius

method isCollide*(self: CollisionShape2DPtr, vec2: Vector2Ref): bool =
  ## Checks collision with point.
  self.calcGlobalPosition()
  if self.disable:
    return false
  case self.shape_type
  of COLLISION_SHAPE_2D_RECTANGLE:
    Rect2(self.global_position, self.rect_size).contains(vec2)
  of COLLISION_SHAPE_2D_CIRCLE:
    let
      dx = vec2.x - self.x1
      dy = vec2.y - self.y1
    return dx*dx + dy*dy <= self.radius*self.radius

method isCollide*(self, other: CollisionShape2DPtr): bool {.base.} =
  ## Checks collision with other CollisionShape2D object.
  self.calcGlobalPosition()
  other.calcGlobalPosition()
  if self.disable:
    return false
  elif other.disable:
    return false
  case self.shape_type
  of COLLISION_SHAPE_2D_RECTANGLE:
    case other.shape_type:
      of COLLISION_SHAPE_2D_RECTANGLE:
        return Rect2(self.global_position, self.rect_size).intersects(Rect2(other.global_position, other.rect_size))
      of COLLISION_SHAPE_2D_CIRCLE:
        return Rect2(self.global_position, self.rect_size).isCollideWithCircle(
          other.global_position.x + other.x1,
          other.global_position.y + other.y1, other.radius)
  of COLLISION_SHAPE_2D_CIRCLE:
    case other.shape_type:
      of COLLISION_SHAPE_2D_CIRCLE:
        let
          sradii = self.radius + other.radius
          dx = other.x1 - self.x1
          dy = other.y1 - self.y1
        return dx*dx + dy*dy <= sradii*sradii
      of COLLISION_SHAPE_2D_RECTANGLE:
        return Rect2(other.global_position, other.rect_size).isCollideWithCircle(
          self.global_position.x + self.x1,
          self.global_position.y + self.y1, self.radius)
