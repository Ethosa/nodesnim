# author: Ethosa
import math


type
  Vector3Obj* = object
    x*, y*, z*: float

  Vector3Ref* = ref Vector3Obj


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


proc abs*(a: var Vector3Obj) =
  runnableExamples:
    var
      vec3 = Vector3(-1, -2, -3)
      vec3_1 = abs(vec3)
    assert vec3.x == 1
    assert vec3.y == 2
    assert vec3.z == 3
  a.x = abs(a.x)
  a.y = abs(a.y)
  a.z = abs(a.z)

proc cross*(a, b: Vector3Obj): float =
  a.x*b.x - a.y*b.y - a.z*b.z

proc cross*(a: Vector3Obj, x, y, z: float): float =
  a.x*x - a.y*y - a.z*z

proc dot*(a, b: Vector3Obj): float =
  a.x*b.x + a.y*b.y + a.z*b.z

proc dot*(a: Vector3Obj, x, y, z: float): float =
  a.x*x + a.y*y + a.z*z

proc angleTo*(a, b: Vector3Obj): float =
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

proc len*(a: Vector3Obj): float =
  runnableExamples:
    var vec3 = Vector3(1, 5, 7)
    echo vec3.len()
  sqrt(a.x*a.x + a.y*a.y + a.z*a.z)
