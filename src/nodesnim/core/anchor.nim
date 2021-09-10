# author: Ethosa
import vector2
{.used.}


type
  AnchorObj* = object
    x1*, y1*, x2*, y2*: float


proc Anchor*(x1, y1, x2, y2: float): AnchorObj {.inline.} =
  AnchorObj(x1: x1, y1: y1, x2: x2, y2: y2)

proc Anchor*(vec1, vec2: Vector2Obj): AnchorObj {.inline.} =
  AnchorObj(x1: vec1.x, y1: vec1.y, x2: vec2.x, y2: vec2.y)

proc clear*(a: var AnchorObj) =
  a.x1 = 0
  a.x2 = 0
  a.y1 = 0
  a.y2 = 0

proc isEmpty*(a: AnchorObj): bool {.inline.} =
  ## Returns true, if a is Anchor(0, 0, 0, 0)
  a.x1 == 0 and a.x2 == 0 and a.y1 == 0 and a.y2 == 0


proc `$`*(x: AnchorObj): string {.inline.} =
  "Anchor(x1: " & $x.x1 & ", y1: " & $x.y1 & ", x2: " & $x.x2 & ", y2: " & $x.y2 & ")"
