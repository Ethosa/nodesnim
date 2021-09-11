# author: Ethosa
import vector2
{.used.}


type
  Rect2Obj* = object
    x*, y*, w*, h*: float


proc Rect2*(x, y, w, h: float): Rect2Obj =
  Rect2Obj(x: x, y: y, w: w, h: h)

proc Rect2*(pos, size: Vector2Obj): Rect2Obj =
  Rect2Obj(
    x: pos.x, y: pos.y,
    w: size.x, h: size.y
  )


proc contains*(self: Rect2Obj, x, y: float): bool {.inline.} =
  self.x <= x and self.x+self.w >= x and self.y <= y and self.y+self.h >= y

proc contains*(self: Rect2Obj, vector: Vector2Obj): bool {.inline.} =
  self.contains(vector.x, vector.y)

proc contains*(self, other: Rect2Obj): bool =
  (self.contains(other.x, other.y) and
   self.contains(other.x+other.w, other.y) and
   self.contains(other.x, other.y+other.h) and
   self.contains(other.x+other.w, other.y+other.h))

proc intersects*(self, other: Rect2Obj): bool =
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

proc contains*(self: Rect2Obj, a, b: Vector2Obj): bool =
  let
    left = intersects(a, b, Vector2(self.x, self.y), Vector2(self.x, self.y+self.h))
    right = intersects(a, b, Vector2(self.x+self.w, self.y), Vector2(self.x+self.w, self.y+self.h))
    top = intersects(a, b, Vector2(self.x, self.y), Vector2(self.x+self.w, self.y))
    bottom = intersects(a, b, Vector2(self.x, self.y+self.h), Vector2(self.x+self.w, self.y+self.h))
  left or right or bottom or top

proc clamp*(a, b, c: float): float =
  if a < b:
    b
  elif a > c:
    c
  else:
    a

proc isCollideWithCircle*(self: Rect2Obj, x, y, r: float): bool =
  let
    dx = clamp(x, self.x, self.x+self.w) - x
    dy = clamp(y, self.y, self.y+self.h) - y
  dx*dx + dy*dy <= r*r


# --- Operators --- #
proc `$`*(x: Rect2Obj): string {.inline.} =
  "Rect2(x: " & $x.x & ", y: " & $x.y & ", w: " & $x.w & ", h: " & $x.h & ")"
