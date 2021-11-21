# author: Ethosa
import math


type
  Vector3Obj* = object
    x*, y*, z*: float


let
  NULL_VECTOR3* = Vector3Obj(x: 0, y: 0, z: 0)

proc Vector3*(x, y, z: float): Vector3Obj =
  ## Creates a new Vector3 object.
  runnableExamples:
    var vec3 = Vector3(1, 2, 3)
  Vector3Obj(x: x, y: y, z: z)

proc Vector3*(xyz: float): Vector3Obj {.inline.} =
  runnableExamples:
    var vec3 = Vector3(2)
  Vector3(xyz, xyz, xyz)

proc Vector3*(other: Vector3Obj): Vector3Obj {.inline.} =
  runnableExamples:
    var vec3 = Vector3(Vector3(11, 9812, 91))
  Vector3(other.x, other.y, other.z)

proc Vector3*(): Vector3Obj {.inline.} =
  runnableExamples:
    var vec3 = Vector3()
  Vector3(0, 0, 0)


proc abs*(a: Vector3Obj): Vector3Obj =
  runnableExamples:
    var vec3 = abs(Vector3(-1, -2, -3))
    assert vec3.x == 1
    assert vec3.y == 2
    assert vec3.z == 3
  Vector3Obj(x: abs(a.x), y: abs(a.y), z: abs(a.z))

proc cross*(a, b: Vector3Obj): Vector3Obj {.inline.} =
  Vector3(a.y*b.z-b.y*a.z,
          a.z*b.x-b.z*a.x,
          a.x*b.y-b.x*a.y)

proc cross*(a: Vector3Obj, x, y, z: float): float {.inline.} =
  a.x*x - a.y*y - a.z*z

proc dot*(a, b: Vector3Obj): float {.inline.} =
  a.x*b.x + a.y*b.y + a.z*b.z

proc dot*(a: Vector3Obj, x, y, z: float): float {.inline.} =
  a.x*x + a.y*y + a.z*z

proc angleTo*(a, b: Vector3Obj): float {.inline.} =
  arccos(a.dot(b))

proc normalize*(a: var Vector3Obj) =
  var l = a.x*a.x + a.y*a.y + a.z*a.z
  if l != 0:
    l = sqrt(l)
    a.x /= l
    a.y /= l
    a.z /= l

proc normalized*(a: Vector3Obj): Vector3Obj =
  result = Vector3(a)
  result.normalize()

proc directionTo*(a, b: Vector3Obj): Vector3Obj =
  result = Vector3(b.x - a.x, b.y - a.y, b.z - a.z)
  result.normalize()

proc len*(a: Vector3Obj): float {.inline.} =
  runnableExamples:
    var vec3 = Vector3(1, 5, 7)
    echo vec3.len()
  sqrt(a.x*a.x + a.y*a.y + a.z*a.z)


# --- Operators --- #
proc `$`*(a: Vector3Obj): string {.inline.} =
  "Vector3(x: " & $a.x & ", y: " & $a.y & ", z: " & $a.z & ")"


proc `+`*(a, b: Vector3Obj): Vector3Obj =
  Vector3Obj(x: a.x+b.x, y: a.y+b.y, z: a.z+b.z)
proc `-`*(a, b: Vector3Obj): Vector3Obj =
  Vector3Obj(x: a.x-b.x, y: a.y-b.y, z: a.z-b.z)
proc `*`*(a, b: Vector3Obj): Vector3Obj =
  Vector3Obj(x: a.x*b.x, y: a.y*b.y, z: a.z*b.z)
proc `/`*(a, b: Vector3Obj): Vector3Obj =
  Vector3Obj(x: a.x/b.x, y: a.y/b.y, z: a.z/b.z)

proc `+`*(a: Vector3Obj, b: float): Vector3Obj =
  Vector3Obj(x: a.x+b, y: a.y+b, z: a.z+b)
proc `-`*(a: Vector3Obj, b: float): Vector3Obj =
  Vector3Obj(x: a.x-b, y: a.y-b, z: a.z-b)
proc `*`*(a: Vector3Obj, b: float): Vector3Obj =
  Vector3Obj(x: a.x*b, y: a.y*b, z: a.z*b)
proc `/`*(a: Vector3Obj, b: float): Vector3Obj =
  Vector3Obj(x: a.x/b, y: a.y/b, z: a.z/b)

proc `+=`*(a: var Vector3Obj, b: Vector3Obj) =
  a = a + b
proc `-=`*(a: var Vector3Obj, b: Vector3Obj) =
  a = a - b
proc `*=`*(a: var Vector3Obj, b: Vector3Obj) =
  a = a * b
proc `/=`*(a: var Vector3Obj, b: Vector3Obj) =
  a = a / b

proc `+=`*(a: var Vector3Obj, b: float) =
  a = a + b
proc `-=`*(a: var Vector3Obj, b: float) =
  a = a - b
proc `*=`*(a: var Vector3Obj, b: float) =
  a = a * b
proc `/=`*(a: var Vector3Obj, b: float) =
  a = a / b

proc `==`*(a, b: Vector3Obj): bool =
  a.x == b.x and a.y == b.y and a.z == b.z
proc `>`*(a, b: Vector3Obj): bool =
  a.x > b.x and a.y > b.y and a.z > b.z
proc `>=`*(a, b: Vector3Obj): bool =
  a.x >= b.x and a.y >= b.y and a.z >= b.z
proc `<=`*(a, b: Vector3Obj): bool =
  a.x <= b.x and a.y <= b.y and a.z <= b.z
