# author: Ethosa
import math
{.used.}


type
  Vector2Obj* = object
    x*, y*: float
  Vector2Ref* = ref Vector2Obj


proc Vector2*(x, y: float): Vector2Ref {.inline.} =
  Vector2Ref(x: x, y: y)

proc Vector2*(b: Vector2Ref): Vector2Ref {.inline.} =
  Vector2Ref(x: b.x, y: b.y)

proc Vector2*(): Vector2Ref {.inline.} =
  Vector2Ref(x: 0, y: 0)



proc abs*(a: Vector2Ref): Vector2Ref =
  Vector2(abs(a.x), abs(a.y))

proc angle*(a: Vector2Ref): float =
  arctan2(a.y, a.x)

proc cross*(a, b: Vector2Ref): float =
  a.x*b.x - a.y*b.y

proc cross*(a: Vector2Ref, x, y: float): float =
  a.x*x - a.y*y

proc dot*(a, b: Vector2Ref): float =
  a.x*b.x + a.y*b.y

proc dot*(a: Vector2Ref, x, y: float): float =
  a.x*x + a.y*y

proc angleTo*(a, b: Vector2Ref): float =
  arctan2(a.cross(b), a.dot(b))

proc angleTo*(a: Vector2Ref, x, y: float): float =
  arctan2(a.cross(x, y), a.dot(x, y))

proc angleToPoint*(a, b: Vector2Ref): float =
  arctan2(a.y - b.y, a.x - b.x)

proc angleToPoint*(a: Vector2Ref, x, y: float): float =
  arctan2(a.y - y, a.x - x)

proc length*(a: Vector2Ref): float =
  sqrt(a.x*a.x + a.y*a.y)

proc normalize*(a: Vector2Ref) =
  var l: float = a.x*a.x + a.y*a.y
  if l != 0:
    l = sqrt(l)
    a.x /= l
    a.y /= l

proc normalized*(a: Vector2Ref): Vector2Ref =
  result = Vector2(a)
  result.normalize()

proc distance*(a, b: Vector2Ref): float =
  sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))

proc distance*(a: Vector2Ref, x, y: float): float =
  sqrt((x - a.x)*(x - a.x) + (y - a.y)*(y - a.y))

proc directionTo*(a, b: Vector2Ref): Vector2Ref =
  result = Vector2(b.x - a.x, b.y - a.y)
  result.normalize()

proc directionTo*(a: Vector2Ref, x, y: float): Vector2Ref =
  result = Vector2(x - a.x, y - a.y)
  result.normalize()


# --- Operators --- #
proc `+`*(a, b: Vector2Ref): Vector2Ref =
  Vector2(a.x + b.x, a.y + b.y)
proc `-`*(a, b: Vector2Ref): Vector2Ref =
  Vector2(a.x - b.x, a.y - b.y)
proc `/`*(a, b: Vector2Ref): Vector2Ref =
  Vector2(a.x / b.x, a.y / b.y)
proc `*`*(a, b: Vector2Ref): Vector2Ref =
  Vector2(a.x * b.x, a.y * b.y)

proc `*`*(x: Vector2Ref, y: float): Vector2Ref =
  Vector2(x.x * y, x.y * y)
proc `+`*(x: Vector2Ref, y: float): Vector2Ref =
  Vector2(x.x + y, x.y + y)
proc `-`*(x: Vector2Ref, y: float): Vector2Ref =
  Vector2(x.x - y, x.y - y)
proc `/`*(x: Vector2Ref, y: float): Vector2Ref =
  Vector2(x.x / y, x.y / y)

proc `*=`*(x: var Vector2Ref, y: Vector2Ref) =
  x = x * y
proc `+=`*(x: var Vector2Ref, y: Vector2Ref) =
  x = x + y
proc `-=`*(x: var Vector2Ref, y: Vector2Ref) =
  x = x - y
proc `/=`*(x: var Vector2Ref, y: Vector2Ref) =
  x = x / y

proc `$`*(a: Vector2Ref): string =
  "Vector2(" & $a.x & ", " & $a.y & ")"
