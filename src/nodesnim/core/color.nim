# author: Ethosa
import strutils


type
  ColorObj* = object
    r*: float
    g*: float
    b*: float
    a*: float
  ColorRef* = ref ColorObj

proc Color*(r, g, b, a: float): ColorRef =
  ## Creates a new Color from RGBA.
  ## `r`, `g`, `b` and `a` is a numbers ranges `0.0..1.0`.
  result = ColorRef(r: r, g: g, b: b, a: a)

proc Color*(r, g, b: float): ColorRef {.inline.} =
  ## Creates a new Color from RGB.
  ## `r`, `g` and `b` is a numbers ranges `0.0..1.0`.
  Color(r, g, b, 1.0)

proc Color*(r, g, b, a: uint8): ColorRef =
  ## Creates a new Color from RGBA.
  ## `r`, `g`, `b` and `a` is a numbers ranges `0..255`.
  result = ColorRef(r: r.int / 255, g: g.int / 255, b: b.int / 255, a: a.int / 255)

proc Color*(r, g, b: uint8): ColorRef {.inline.} =
  ## Creates a new Color from RGB.
  ## `r`, `g` and `b` is a numbers ranges `0..255`.
  Color(r, g, b, 255)

proc Color*(src: string): ColorRef =
  ## Parses color from string.
  ## `src` should be a string, begins with "#", "0x" or "0X" and have a RRGGBBAA color value.
  runnableExamples:
    var
      clr1 = Color("#FFCCAAFF")
      clr2 = Color("0xFFAACCFF")
      clr3 = Color("0XAACCFFFF")
      clr4 = Color("#AAFFCCFF")
    echo clr1
    echo clr2
    echo clr3
    echo clr4

  let color = parseHexInt(src).uint32
  result = ColorRef(
    r: ((color shr 24) and 255).int / 255,
    g: ((color shr 16) and 255).int / 255,
    b: ((color shr 8) and 255).int / 255,
    a: (color and 255).int / 255
  )

proc Color*(src: uint32): ColorRef =
  ## Translate uint32 color to the Color object.
  runnableExamples:
    var
      clr1 = Color(0xFFCCAAFF'u32)
      clr2 = Color(0xFFAACCFF'u32)
      clr3 = Color(0xAACCFFFF'u32)
      clr4 = Color(0xAAFFCCFF'u32)
    echo clr1
    echo clr2
    echo clr3
    echo clr4

  result = ColorRef(
    r: ((src shr 24) and 255).int / 255,
    g: ((src shr 16) and 255).int / 255,
    b: ((src shr 8) and 255).int / 255,
    a: (src and 255).int / 255
  )

proc Color*(): ColorRef {.inline.} =
  ## Creates a new Color object with RGBA value (0, 0, 0, 0)
  ColorRef(r: 0, g: 0, b: 0, a: 0)


proc normalize*(n: float): uint32 {.inline.} =
  if n > 1.0:
    255'u32
  elif n < 0.0:
    0'u32
  else:
    (255.0 * n).uint32

proc normalize*(n, min, max: float): float {.inline.} =
  ## Returns number in range `0.0..1.0`.
  if n > max:
    1.0
  elif n < min:
    0.0
  else:
    n / max

proc normalizeColor*(color: float): float {.inline.} =
  ## Returns number in range `0..255`.
  if color <= 0.0:
    return 0.0
  elif color >= 255.0:
    return 255.0
  else:
    return color


proc toUint32BE*(color: ColorRef): uint32 =
  ## Converts Color object to uint32 with ``big endian``.
  (
    (normalize(color.r) shl 24) or
    (normalize(color.g) shl 16) or
    (normalize(color.b) shl 8) or
    normalize(color.a)
  )
proc toUint32LE*(color: ColorRef): uint32 =
  ## Converts Color object to uint32 with ``little endian``.
  (
    normalize(color.r) or
    (normalize(color.g) shl 8) or
    (normalize(color.b) shl 16) or
    (normalize(color.a) shl 24)
  )

proc toFloatTuple*(color: ColorRef): tuple[r, g, b, a: float] =
  ## Converts Color object to the tuple.
  (color.r, color.g, color.b, color.a)

proc toUint32Tuple*(color: ColorRef): tuple[r, g, b, a: uint32] =
  ## Converts Color object to the tuple.
  (normalize(color.r), normalize(color.g), normalize(color.b), normalize(color.a))


proc toUint32BEWithoutAlpha*(color:ColorRef): uint32 =
  ## Converts Color object to uint32 without alpha-channel with ``big endian``.
  (
    (normalize(color.r) shl 16) or
    (normalize(color.g) shl 8) or
    normalize(color.b)
  )
proc toUint32LEWithoutAlpha*(color:ColorRef): uint32 =
  ## Converts Color object to uint32 without alpha-channel with ``little endian``.
  (
    normalize(color.r) or
    (normalize(color.g) shl 8) or
    (normalize(color.b) shl 16)
  )

proc lerp*(self, other: ColorRef, lerpv: float): uint32 =
  ## linear interpolate color.
  ##
  ## Arguments:
  ## - `self` and `other` - Color objects.
  ## - `lerpv` - linear interpolate value
  let
    (r1, g1, b1, a1) = self.toUint32Tuple()
    (r2, g2, b2, a2) = self.toUint32Tuple()

    p: float = 1.0 - lerpv
    r = normalizeColor(r1.float * p + r2.float * lerpv).uint32
    g = normalizeColor(g1.float * p + g2.float * lerpv).uint32
    b = normalizeColor(b1.float * p + b2.float * lerpv).uint32
    a = normalizeColor(a1.float * p + a2.float * lerpv).uint32
  r or (g shl 8) or (b shl 16) or (a shl 24)

proc lerp*(r1, g1, b1, a1, r2, g2, b2, a2: uint32, lerpv: float): uint32 =
  let
    p: float = 1.0 - lerpv
    r = normalizeColor(r1.float * p + r2.float * lerpv).uint32
    g = normalizeColor(g1.float * p + g2.float * lerpv).uint32
    b = normalizeColor(b1.float * p + b2.float * lerpv).uint32
    a = normalizeColor(a1.float * p + a2.float * lerpv).uint32
  r or (g shl 8) or (b shl 16) or (a shl 24)


proc `$`*(color: ColorRef): string =
  "Color(" & $color.r & ", " & $color.g & ", " & $color.b & ", " & $color.a & ")"

proc `==`*(x, y: ColorRef): bool =
  x.r == y.r and x.g == y.g and x.b == y.b and x.a == y.a
