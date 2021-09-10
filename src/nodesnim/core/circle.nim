# author: Ethosa
## Provides Circle type.
import
  math,
  vector2
{.used.}


type
  CircleObj* = object
    x*, y*, r*: float
  CircleRef* = ref CircleObj


proc Circle*(x, y, r: float): CircleRef =
  ## Creates a new Circle object.
  ##
  ## Arguments:
  ## - `x` is a center circle point at X axis.
  ## - `y` is a center circle point at Y axis.
  ## - `r` is a circle radius.
  runnableExamples:
    var obj = Circle(10, 10, 5)
  CircleRef(x: x, y: y, r: r)

proc Circle*(vec: Vector2Obj, r: float): CircleRef =
  ## Creates a new Circle object.
  ##
  ## Arguments:
  ## - `vec` is a circle center position.
  ## - `r` is a circle radius.
  CircleRef(x: vec.x, y: vec.y, r: r)


proc contains*(self: CircleRef, x, y: float): bool =
  ## Returns true, if `x`,`y` in the circle.
  let
    dx = x - self.x
    dy = y - self.y
  dx*dx + dy*dy <= self.r*self.r

proc contains*(self: CircleRef, vec2: Vector2Obj): bool {.inline.} =
  ## Returns true, if `vec2` in the circle.
  self.contains(vec2.x, vec2.y)


proc contains*(self, other: CircleRef): bool =
  ## Returns true, if `self` intersects with `other` circle.
  let
    dx = other.x - self.x
    dy = other.y - self.y
    r = other.r + self.r
  dx*dx + dy*dy <= r*r

proc contains*(self: CircleRef, a, b: Vector2Obj): bool =
  let
    dx = b.x - a.x
    dy = b.y - a.y
    d = sqrt(dx*dx + dy*dy)
  if d == 0:
    return false

  let
    nx = dx/d
    ny = dy/d
    mx = a.x - self.x
    my = a.y - self.y
    b = mx*nx + my*ny
    c = mx*mx + my*my - self.r*self.r
  if c > 0 and b > 0:
    return false

  var discr = b*b - c
  if discr < 0:
    return false

  discr = sqrt(discr)
  let tmin = if -b - discr > 0: -b - discr else: 0
  if tmin > d:
    return false
  return true


# --- Operators --- #
proc `$`*(self: CircleRef): string {.inline.} =
  "Circle(x:" & $self.x & ", y:" & $self.y & ", r:" & $self.r & ")"
