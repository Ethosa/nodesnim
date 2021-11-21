# author: Ethosa
import
  re,
  math,
  vector2

proc cubic_bezier*(t, p0, p1, p2, p3: float): float {.inline.} =
  pow(1f - t, 3f)*p0 + 3f*t*pow(1f-t, 2f)*p1 +
    3*pow(t, 2f)*(1f-t)*p2 + pow(t, 3f)*p3

proc bezier*(t, p0, p1, p2: float): float {.inline.} =
  pow((1f-t), 2f)*p0 + 2f*t*(1f-t)*p1 + pow(t, 2f)*p2


iterator bezier_iter*(step: float, p0, p1, p2: Vector2Obj): Vector2Obj =
  var t = 0f
  let s = abs(step)

  while t <= 1f:
    yield Vector2(bezier(t, p0.x, p1.x, p2.x), bezier(t, p0.y, p1.y, p2.y))
    t += s

iterator cubic_bezier_iter*(step: float, p0, p1, p2, p3: Vector2Obj): Vector2Obj =
  var t = 0f
  let s = abs(step)

  while t <= 1f:
    yield Vector2(cubic_bezier(t, p0.x, p1.x, p2.x, p3.x), cubic_bezier(t, p0.y, p1.y, p2.y, p3.y))
    t += s

proc matchBackgroundImage*(source: string, matches: var array[20, string]): bool =
  source.match(re"\A\s*url\(([^\)]+)\)\s*\Z", matches)

proc matchColor*(source: string): bool =
  source.match(re"\A\s*rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+\.?\d*?)\s*\)\s*\Z") or
  source.match(re"\A\s*rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*\Z") or
  source.match(re"\A(#|0x|0X)[0-9a-fA-F]{3,8}\Z")
