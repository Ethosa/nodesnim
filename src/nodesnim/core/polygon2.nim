# author: Ethosa
## Provides primitive 2d polygon.
import
  vector2
{.used.}


type
  Polygon2Obj* = object
    positions*: seq[Vector2Ref]
  Polygon2Ref* = ref Polygon2Obj


proc Polygon2*(pnts: varargs[Vector2Ref]): Polygon2Ref =
  ## Creates a new Polygon2 object.
  ##
  ## Arguments:
  ## - `pnts` is a points for the Polygon. points count should be more than 2.
  if pnts.len() < 3:
    return
  result = Polygon2Ref(positions: @[])
  for i in pnts:
    result.positions.add(i)

proc Polygon2*(pnts: seq[Vector2Ref]): Polygon2Ref =
  ## Creates a new Polygon2 object.
  ##
  ## Arguments:
  ## - `pnts` is a points for the Polygon. points count should be more than 2.
  if pnts.len() < 3:
    return
  result = Polygon2Ref(positions: pnts)


proc contains*(self: Polygon2Ref, x, y: float): bool =
  ## Returns true, if point `x`, `y` in the Polygon2.
  result = false
  var next = 1
  let length = self.positions.len()

  for i in 0..<length:
    inc next
    if next == length: next = 0
    let
      a = self.positions[i]
      b = self.positions[next]
    if ((a.y >= y and b.y < y) or (a.y < y and b.y >= y)) and (x < (b.x-a.x)*(y-a.y) / (b.y-a.y)+a.x):
      result = not result

proc contains*(self: Polygon2Ref, vec2: Vector2Ref): bool {.inline.} =
  ## Returns true, if point `vec2` in the Polygon2.
  self.contains(vec2.x, vec2.y)


proc intersects*(self, other: Polygon2Ref): bool =
  ## Returns true, if two polygons intersect.
  let
    length = self.positions.len()
    otherlength = other.positions.len()
  var next = 0

  for i in 0..<length:
    inc next
    if next == length: next = 0
    let
      a = self.positions[i]
      b = self.positions[next]

    var othernext = 0
    for i in 0..<otherlength:
      inc othernext
      if othernext == otherlength: othernext = 0
      let
        c = other.positions[i]
        d = other.positions[othernext]
      if intersects(a, b, c, d):
        return true
