# author: Ethosa
import
  ../thirdparty/opengl,
  strutils,
  re


type
  ColorObj* = object
    r*, g*, b*, a*: float
  ColorRef* = ref ColorObj

proc Color*(r, g, b, a: float): ColorRef =
  ## Creates a new Color from RGBA.
  ## `r`, `g`, `b` and `a` is a numbers ranges `0.0..1.0`.
  ColorRef(r: r, g: g, b: b, a: a)

proc Color*(r, g, b: float): ColorRef {.inline.} =
  ## Creates a new Color from RGB.
  ## `r`, `g` and `b` is a numbers ranges `0.0..1.0`.
  Color(r, g, b, 1.0)

proc Color*(r, g, b, a: uint8): ColorRef =
  ## Creates a new Color from RGBA.
  ## `r`, `g`, `b` and `a` is a numbers ranges `0..255`.
  ColorRef(r: r.int / 255, g: g.int / 255, b: b.int / 255, a: a.int / 255)

proc Color*(r, g, b: uint8, a: float): ColorRef =
  ## Creates a new Color from RGBA.
  ## `r`, `g`, `b` and `a` is a numbers ranges `0..255`.
  ColorRef(r: r.int / 255, g: g.int / 255, b: b.int / 255, a: a)

proc Color*(r, g, b: uint8): ColorRef {.inline.} =
  ## Creates a new Color from RGB.
  ## `r`, `g` and `b` is a numbers ranges `0..255`.
  Color(r, g, b, 255)

proc Color*(src: uint32): ColorRef =
  ## Translate AARRGGBB uint32 color to the Color object.
  ##
  ## 0xFF00FF00 -> Color(0, 1, 0, 1)
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

  let clr = src.int
  ColorRef(
    r: ((clr shr 24) and 255) / 255,
    g: ((clr shr 16) and 255) / 255,
    b: ((clr shr 8) and 255) / 255,
    a: (clr and 255) / 255
  )

proc Color*(src: string): ColorRef =
  ## Parses color from string.
  ## `src` should be a string, begins with "#", "0x" or "0X" and have a AARRGGBB color value.
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
  var
    target = src
    matched: array[20, string]

  # #FFFFFFFF, #FFF, #FFFFFF, #FFFF, etc
  if target.startsWith('#') or target.startsWith("0x") or target.startsWith("0X"):
    target = target[1..^1]
    if target[0] in {'x', 'X'}:
      target = target[1..^1]

    let length = target.len
    case length
    of 3:
      target = target[0] & target[0] & target[1] & target[1] & target[2] & target[2] & "ff"
    of 4:  # #1234 -> #11223344
      target = target[0] & target[0] & target[1] & target[1] & target[2] & target[2] & target[3] & target[3]
    of 6:  # #ffffff -> #ffffffff
      target &= "ff"
    else:
      discard

    return Color(parseHexInt(target).uint32)

  # rgba(255, 255, 255, 1.0)
  elif target.match(re"\A\s*rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+\.?\d*?)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]).uint8, parseInt(matched[1]).uint8, parseInt(matched[2]).uint8, parseFloat(matched[3]))

  # rgb(255, 255, 255)
  elif target.match(re"\A\s*rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]).uint8, parseInt(matched[1]).uint8, parseInt(matched[2]).uint8)

proc Color*(): ColorRef {.inline.} =
  ## Creates a new Color object with RGBA value (0, 0, 0, 0)
  ColorRef(r: 0, g: 0, b: 0, a: 0)

proc Color*(clr: ColorRef): ColorRef {.inline.} =
  ColorRef(r: clr.r, g: clr.g, b: clr.b, a: clr.a)

proc getBrightness*(self: ColorRef): float {.inline.} =
  (self.r + self.g + self.b) / 3f

proc normalize*(n: float): uint32 {.inline.} =
  ## Returns number in range `0..255`.
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


proc toUint32BE*(color: ColorRef): uint32 {.inline.} =
  ## Converts Color object to uint32 with ``big endian``.
  (
    (normalize(color.r) shl 24) or
    (normalize(color.g) shl 16) or
    (normalize(color.b) shl 8) or
    normalize(color.a)
  )
proc toUint32LE*(color: ColorRef): uint32 {.inline.} =
  ## Converts Color object to uint32 with ``little endian``.
  (
    normalize(color.r) or
    (normalize(color.g) shl 8) or
    (normalize(color.b) shl 16) or
    (normalize(color.a) shl 24)
  )

proc toFloatTuple*(color: ColorRef): tuple[r, g, b, a: float] {.inline.} =
  ## Converts Color object to the tuple.
  (color.r, color.g, color.b, color.a)

proc toUint32Tuple*(color: ColorRef): tuple[r, g, b, a: uint32] {.inline.} =
  ## Converts Color object to the tuple.
  (normalize(color.r), normalize(color.g), normalize(color.b), normalize(color.a))


proc toUint32BEWithoutAlpha*(color:ColorRef): uint32 {.inline.} =
  ## Converts Color object to uint32 without alpha-channel with ``big endian``.
  (
    (normalize(color.r) shl 16) or
    (normalize(color.g) shl 8) or
    normalize(color.b)
  )
proc toUint32LEWithoutAlpha*(color:ColorRef): uint32 {.inline.} =
  ## Converts Color object to uint32 without alpha-channel with ``little endian``.
  (
    normalize(color.r) or
    (normalize(color.g) shl 8) or
    (normalize(color.b) shl 16)
  )

proc lerp*(r1, g1, b1, a1, r2, g2, b2, a2: uint32, lerpv: float): uint32 =
  ## linear interpolate color.
  ##
  ## Arguments:
  ## - `self` and `other` - Color objects.
  ## - `lerpv` - linear interpolate value
  let
    p: float = 1.0 - lerpv
    r = normalizeColor(r1.float * p + r2.float * lerpv).uint32
    g = normalizeColor(g1.float * p + g2.float * lerpv).uint32
    b = normalizeColor(b1.float * p + b2.float * lerpv).uint32
    a = normalizeColor(a1.float * p + a2.float * lerpv).uint32
  r or (g shl 8) or (b shl 16) or (a shl 24)

proc lerp*(self, other: ColorRef, lerpv: float): uint32 =
  let
    (r1, g1, b1, a1) = self.toUint32Tuple()
    (r2, g2, b2, a2) = self.toUint32Tuple()
  lerp(r1, g1, b1, a1, r2, g2, b2, a2, lerpv)

proc copyColorTo*(dest, src: ColorRef) =
  src.r = dest.r
  src.g = dest.g
  src.b = dest.b
  src.a = dest.a


proc glColor*(clr: ColorRef) =
  glColor4f(clr.r, clr.g, clr.b, clr.a)


# --- Operators --- #
proc `$`*(color: ColorRef): string =
  "Color(" & $color.r & ", " & $color.g & ", " & $color.b & ", " & $color.a & ")"

proc `+`*(x, y: ColorRef): ColorRef =
  ColorRef(r: x.r + y.r, g: x.g + y.g, b: x.b + y.b, a: x.a + y.a)
proc `-`*(x, y: ColorRef): ColorRef =
  ColorRef(r: x.r - y.r, g: x.g - y.g, b: x.b - y.b, a: x.a - y.a)
proc `*`*(x, y: ColorRef): ColorRef =
  ColorRef(r: x.r * y.r, g: x.g * y.g, b: x.b * y.b, a: x.a * y.a)
proc `/`*(x, y: ColorRef): ColorRef =
  ColorRef(r: x.r / y.r, g: x.g / y.g, b: x.b / y.b, a: x.a / y.a)

proc `+=`*(x: var ColorRef, y: ColorRef) =
  x = x + y
proc `-=`*(x: var ColorRef, y: ColorRef) =
  x = x - y
proc `*=`*(x: var ColorRef, y: ColorRef) =
  x = x * y
proc `/=`*(x: var ColorRef, y: ColorRef) =
  x = x / y

proc `==`*(x, y: ColorRef): bool =
  x.r == y.r and x.g == y.g and x.b == y.b and x.a == y.a
