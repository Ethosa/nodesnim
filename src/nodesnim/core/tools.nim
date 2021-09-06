# author: Ethosa
import math

proc cubic_bezier*(t, p0, p1, p2, p3: float): float =
  pow(1f - t, 3f)*p0 + 3*t*pow(1f-t, 2f)*p1 +
    3*pow(t, 2f)*(1f-t)*p2 + pow(t, 3f)*p3
