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
    x: left_top.x, y: left_top.y,
    w: width_height.x, h: width_height.y
  )


proc contains*(self: Rect2Ref, x, y: float): bool {.inline.} =
  self.x <= x and self.x+self.w >= x and self.y <= y and self.y+self.h >= y

proc contains*(self: Rect2Ref, vector: Vector2Ref): bool {.inline.} =
  self.contains(vector.x, vector.y)

proc contains*(self, other: Rect2Ref): bool =
  (self.contains(other.x, other.y) and
   self.contains(other.x+other.w, other.y) and
   self.contains(other.x, other.y+other.h) and
   self.contains(other.x+other.w, other.y+other.h))

proc intersects*(self, other: Rect2Ref): bool =
  if self.w > other.w and self.h > other.h:
    (self.contains(other.x, other.y) or
     self.contains(other.x, other.y+other.h) or
     self.contains(other.x+other.w, other.y) or
     self.contains(other.x+other.w, other.y+other.h))
  else:
    (other.contains(self.x, self.y) or
     other.contains(self.x, self.y+self.h) or
     other.contains(self.x+other.w, self.y) or
     other.contains(self.x+other.w, self.y+self.h))

proc contains*(self: Rect2Ref, a, b: Vector2Ref): bool =
  let
    left = intersects(a, b, Vector2(self.x, self.y), Vector2(self.x, self.y+self.h))
    right = intersects(a, b, Vector2(self.x+self.w, self.y), Vector2(self.x+self.w, self.y+self.h))
    top = intersects(a, b, Vector2(self.x, self.y), Vector2(self.x+self.w, self.y))
    bottom = intersects(a, b, Vector2(self.x, self.y+self.h), Vector2(self.x+self.w, self.y+self.h))
  return left or right or bottom or top

proc clamp*(a, b, c: float): float =
  if a < b:
    b
  elif a > c:
    c
  else:
    a

proc isCollideWithCircle*(self: Rect2Ref, x, y, r: float): bool =
  let
    dx = clamp(x, self.x, self.x+self.w) - x
    dy = clamp(y, self.y, self.y+self.h) - y
  dx*dx + dy*dy <= r*r


# --- Operators --- #
proc `$`*(x: Rect2Ref): string =
  "Rect2(x: " & $x.x & ", y: " & $x.y & ", w: " & $x.w & ", h: " & $x.h & ")"
