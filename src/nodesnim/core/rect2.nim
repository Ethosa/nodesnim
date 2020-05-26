# author: Ethosa
import vector2
{.used.}


type
  Rect2Obj* = object
    x*, y*, w*, h*: float
  Rect2Ref* = ref Rect2Obj


proc Rect2*(x, y, w, h: float): Rect2Ref =
  Rect2Ref(x: x, y: y, w: w, h: h)

proc Rect2*(left_top, width_height: Vector2Ref): Rect2Ref =
  Rect2Ref(
    x: left_top.x,
    y: left_top.y,
    w: width_height.x,
    h: width_height.y
  )


proc hasPoint*(self: Rect2Ref, x, y: float): bool {.inline.} =
  self.x <= x and self.x+self.w >= x and self.y <= y and self.y+self.h >= y

proc hasPoint*(self: Rect2Ref, vector: Vector2Ref): bool {.inline.} =
  self.hasPoint(vector.x, vector.y)

proc intersects*(self, other: Rect2Ref): bool =
  (self.hasPoint(other.x, other.y) or
   self.hasPoint(other.x+other.w, other.y) or
   self.hasPoint(other.x, other.y+other.h) or
   self.hasPoint(other.x+other.w, other.y+other.h))

proc contains*(self, other: Rect2Ref): bool =
  (self.hasPoint(other.x, other.y) and
   self.hasPoint(other.x+other.w, other.y) and
   self.hasPoint(other.x, other.y+other.h) and
   self.hasPoint(other.x+other.w, other.y+other.h))


# --- Operators --- #
proc `$`*(x: Rect2Ref): string =
  "Rect2(x: " & $x.x & ", y: " & $x.y & ", w: " & $x.w & ", h: " & $x.h & ")"
