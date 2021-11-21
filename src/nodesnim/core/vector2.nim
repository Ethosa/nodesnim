# author: Ethosa
import math
{.used.}


type
  Vector2Obj* = object
    x*, y*: float

let
  NULL_VECTOR2* = Vector2Obj(x: 0, y: 0)

proc Vector2*(x, y: float): Vector2Obj {.inline.} =
  Vector2Obj(x: x, y: y)

proc Vector2*(b: Vector2Obj): Vector2Obj {.inline.} =
  Vector2Obj(x: b.x, y: b.y)

proc Vector2*(x: float): Vector2Obj {.inline.} =
  Vector2Obj(x: x, y: x)

proc Vector2*(): Vector2Obj {.inline.} =
  Vector2Obj(x: 0, y: 0)


proc newVector2*(vec2: Vector2Obj): ref Vector2Obj =
  new result
  result[] = vec2

proc newVector2*(x, y: float): ref Vector2Obj =
  new result
  result.x = x
  result.y = y


proc abs*(a: Vector2Obj): Vector2Obj =
  Vector2(abs(a.x), abs(a.y))

proc angle*(a: Vector2Obj): float {.inline.} =
  arctan2(a.y, a.x)

proc clear*(a: var Vector2Obj) =
  a.x = 0
  a.y = 0

proc cross*(a, b: Vector2Obj): float {.inline.} =
  a.x*b.x - a.y*b.y

proc cross*(a: Vector2Obj, x, y: float): float {.inline.} =
  a.x*x - a.y*y

proc dot*(a, b: Vector2Obj): float {.inline.} =
  a.x*b.x + a.y*b.y

proc dot*(a: Vector2Obj, x, y: float): float {.inline.} =
  a.x*x + a.y*y

proc angleTo*(a, b: Vector2Obj): float {.inline.} =
  arctan2(a.cross(b), a.dot(b))

proc angleTo*(a: Vector2Obj, x, y: float): float {.inline.} =
  arctan2(a.cross(x, y), a.dot(x, y))

proc angleToPoint*(a, b: Vector2Obj): float {.inline.} =
  arctan2(a.y - b.y, a.x - b.x)

proc angleToPoint*(a: Vector2Obj, x, y: float): float {.inline.} =
  arctan2(a.y - y, a.x - x)

proc length*(a: Vector2Obj): float {.inline.} =
  sqrt(a.x*a.x + a.y*a.y)

proc normalize*(a: var Vector2Obj) =
  var l: float = a.x*a.x + a.y*a.y
  if l != 0:
    l = sqrt(l)
    a.x /= l
    a.y /= l

proc normalized*(a: Vector2Obj): Vector2Obj =
  result = Vector2(a)
  result.normalize()

proc distance*(a, b: Vector2Obj): float {.inline.} =
  sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))

proc distance*(a: Vector2Obj, x, y: float): float {.inline.} =
  sqrt((x - a.x)*(x - a.x) + (y - a.y)*(y - a.y))

proc directionTo*(a, b: Vector2Obj): Vector2Obj =
  result = Vector2(b.x - a.x, b.y - a.y)
  result.normalize()

proc directionTo*(a: Vector2Obj, x, y: float): Vector2Obj =
  result = Vector2(x - a.x, y - a.y)
  result.normalize()

proc intersects*(a, b, c, d: Vector2Obj): bool =
  let
    uA = ((d.x-c.x)*(a.y-c.y) - (d.y-c.y)*(a.x-c.x)) / ((d.y-c.y)*(b.x-a.x) - (d.x-c.x)*(b.y-a.y))
    uB = ((b.x-a.x)*(a.y-c.y) - (b.y-a.y)*(a.x-c.x)) / ((d.y-c.y)*(b.x-a.x) - (d.x-c.x)*(b.y-a.y))
  return uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1

proc isEmpty*(a: Vector2Obj): bool =
  a.x == 0f and a.y == 0f


# --- Operators --- #
proc `$`*(a: Vector2Obj): string {.inline.} =
  "Vector2(" & $a.x & ", " & $a.y & ")"

proc `+`*(a, b: Vector2Obj): Vector2Obj =
  Vector2(a.x + b.x, a.y + b.y)
proc `-`*(a, b: Vector2Obj): Vector2Obj =
  Vector2(a.x - b.x, a.y - b.y)
proc `/`*(a, b: Vector2Obj): Vector2Obj =
  Vector2(a.x / b.x, a.y / b.y)
proc `*`*(a, b: Vector2Obj): Vector2Obj =
  Vector2(a.x * b.x, a.y * b.y)

proc `*`*(x: Vector2Obj, y: float): Vector2Obj =
  Vector2(x.x * y, x.y * y)
proc `+`*(x: Vector2Obj, y: float): Vector2Obj =
  Vector2(x.x + y, x.y + y)
proc `-`*(x: Vector2Obj, y: float): Vector2Obj =
  Vector2(x.x - y, x.y - y)
proc `/`*(x: Vector2Obj, y: float): Vector2Obj =
  Vector2(x.x / y, x.y / y)

proc `*=`*(x: var Vector2Obj, y: Vector2Obj) =
  x = x * y
proc `+=`*(x: var Vector2Obj, y: Vector2Obj) =
  x = x + y
proc `-=`*(x: var Vector2Obj, y: Vector2Obj) =
  x = x - y
proc `/=`*(x: var Vector2Obj, y: Vector2Obj) =
  x = x / y

proc `>`*(x, y: Vector2Obj): bool =
  x.x > y.x and x.y > y.y
proc `<`*(x, y: Vector2Obj): bool =
  x.x < y.x and x.y < y.y
proc `>=`*(x, y: Vector2Obj): bool =
  x.x >= y.x and x.y >= y.y
proc `<=`*(x, y: Vector2Obj): bool =
  x.x <= y.x and x.y <= y.y
proc `==`*(x, y: Vector2Obj): bool =
  x.x == y.x and x.y == y.y
proc `!=`*(x, y: Vector2Obj): bool =
  x.x != y.x and x.y != y.y
