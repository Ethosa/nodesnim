# author: Ethosa
import color


type
  ColorCharRef* = ref object
    c*: char
    color*: ColorRef
  ColorTextRef* = ref object
    chars*: seq[ColorCharRef]


func clrtext*(text: string, color: ColorRef = Color(1f, 1f, 1f)): ColorTextRef =
  ## Creates a new ColorText ref object.
  runnableExamples:
    import color
    var
      text = clrtext"hello"
      text1 = clrtext("hello", Color(1, 0.6, 1))
  var chars: seq[ColorCharRef] = @[]
  for c in text:
    chars.add(ColorCharRef(c: c, color: color))
  result = ColorTextRef(chars: chars)


func clrchar*(c: char, color: ColorRef = Color(1f, 1f, 1f)): ColorCharRef =
  ## Creates a new ColorChar ref object.
  runnableExamples:
    import color
    var
      c = clrchar's'
      c1 = clrchar('s', Color(1f, 1f, 1f))
  result = ColorCharRef(c: c, color: color)


proc setColor*(self: ColorTextRef, fromc, toc: int, value: ColorRef) =
  runnableExamples:
    import color
    var
      text = clrtext"hello world"
      clr = Color(1, 0.6, 1)
    text.setColor(5, text.chars.len()-1, clr)
  for i in fromc..toc:
    self.chars[i].color = value


proc setColor*(self: ColorTextRef, value: ColorRef) =
  runnableExamples:
    import color
    var
      text = clrtext"hello world"
      clr = Color(1, 0.6, 0.8)
    text.setColor(clr)
  for i in 0..self.chars.high:
    self.chars[i].color = value


proc setColor*(self: ColorTextRef, index: int, value: ColorRef) =
  runnableExamples:
    import color
    var
      text = clrtext"hello world"
      clr = Color(1, 0.6, 1)
    text.setColor(0, clr)
  self.chars[index].color = value

# --- Operators --- #
proc `$`*(text: ColorTextRef): string =
  result = ""
  for c in text.chars:
    result &= $c.c

proc `$`*(c: ColorCharRef): string =
  result = $c.c

proc `==`*(x, y: ColorTextRef): bool =
  result = true
  if x.chars.len() == y.chars.len():
    for i in 0..x.chars.high:
      if x.chars[i].c != y.chars[i].c and x.chars[i].color != y.chars[i].color:
        result = false
  else:
    result = false

proc `&`*(x, y: ColorCharRef): ColorTextRef =
  runnableExamples:
    var
      a = clrchar'a'
      b = clrchar'b'
    assert a & b == clrtext"ab"
  result = clrtext("")
  result.chars.add(x)
  result.chars.add(y)

proc `&`*(x: ColorTextRef, y: ColorCharRef): ColorTextRef =
  result = x
  result.chars.add(y)

proc `&`*(x: ColorCharRef, y: ColorTextRef): ColorTextRef =
  result = y
  result.chars.add(x)

proc `&`*(x, y: ColorTextRef): ColorTextRef =
  result = x
  for c in y.chars:
    result.chars.add(c)

proc contains*(x: ColorTextRef, y: ColorCharRef): bool =
  runnableExamples:
    var
      text = clrtext"hello"
      c = clrchar'o'
    assert c in text
  for c in x.chars:
    if c.c == y.c and c.color == y.color:
      return true

converter toChar*(x: ColorCharRef): char =
  x.c

proc len*(x: ColorTextRef): int =
  x.chars.len()

proc splitLines*(x: ColorTextRef): seq[ColorTextRef] =
  result = @[clrtext("")]
  for c in x.chars:
    if c.c.int != 13:
      result[^1].chars.add(c)
    else:
      result.add(clrtext(""))
  if result[^1].len() == 0:
    discard result.pop()

proc `[]`*[U, V](self: ColorTextRef, i: HSlice[U, V]): ColorTextRef =
  ColorTextRef(chars: self.chars[i])

proc `[]`*(self: ColorTextRef, i: BackwardsIndex): ColorCharRef =
  self.chars[i]

proc `[]`*(self: ColorTextRef, i: int): ColorCharRef =
  self.chars[i]

proc add*(self: var ColorTextRef, other: ColorTextRef) =
  self = self & other

proc add*(self: var ColorTextRef, other: ColorCharRef) =
  self = self & other
