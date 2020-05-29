# author: Ethosa
## Provides Circle2 type.
import
  math,
  vector2
{.used.}


type
  Circle2Obj* = object
    x*, y*, r*: float
  Circle2Ref* = ref Circle2Obj


proc Circle2*(x, y, r: float): Circle2Ref =
  ## Creates a new Circle2 object.
  ##
  ## Arguments:
  ## - `x` is a center circle point at X axis.
  ## - `y` is a center circle point at Y axis.
  ## - `r` is a circle radius.
  runnableExamples:
    var circle = Circle2(10, 10, 5)
  Circle2Ref(x: x, y: y, r: r)

proc Circle2*(vec: Vector2Ref, r: float): Circle2Ref =
  ## Creates a new Circle2 object.
  ##
  ## Arguments:
  ## - `vec` is a circle center position.
  ## - `r` is a circle radius.
  Circle2Ref(x: vec.x, y: vec.y, r: r)


proc contains*(self: Circle2Ref, x, y: float): bool =
  ## Returns true, if `x`,`y` in the circle.
  let
    dx = x - self.x
    dy = y - self.y
  dx*dx + dy*dy <= self.r*self.r

proc contains*(self: Circle2Ref, vec2: Vector2Ref): bool {.inline.} =
  ## Returns true, if `vec2` in the circle.
  self.contains(vec2.x, vec2.y)


proc contains*(self, other: Circle2Ref): bool =
  ## Returns true, if `self` intersects with `other` circle.
  let
    dx = other.x - self.x
    dy = other.y - self.y
    r = other.r + self.r
  dx*dx + dy*dy <= r*r

proc contains*(self: Circle2Ref, a, b: Vector2Ref): bool =
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
proc `$`*(self: Circle2Ref): string =
  "Circle2(x:" & $self.x & ", y:" & $self.y & ", r:" & $self.r & ")"
