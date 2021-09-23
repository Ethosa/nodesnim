# author: Ethosa
## Provides TTF text rendering. Use SDL2_ttf.
import
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/ttf,
  ../thirdparty/opengl,

  image,
  vector2,
  anchor,
  color,
  nodes_os,
  unicode

when defined(debug):
  import logging


type
  StyleUnicode* = ref object
    underline*: bool
    c*: string
    color*: ColorRef
  StyleText* = ref object
    font*: FontPtr
    rendered*: bool
    spacing*: float
    max_lines*: int
    texture*: GlTextureObj
    chars*: seq[StyleUnicode]


proc schar*(c: string, color: ColorRef = Color(1f, 1f, 1f), underline: bool = false): StyleUnicode =
  StyleUnicode(c: c, color: color, underline: underline)

proc stext*(text: string, color: ColorRef = Color(1f, 1f, 1f), underline: bool = false): StyleText =
  result = StyleText(texture: GlTextureObj(size: Vector2()), spacing: 2, max_lines: -1)
  for i in text.utf8():
    result.chars.add(schar(i, color, underline))
  result.font = standard_font
  result.rendered = false


proc toUpper*(text: StyleText): StyleText =
  result = text.deepCopy()
  for i in result.chars:
    i.c = i.c.toUpper()

proc toLower*(text: StyleText): StyleText =
  for i in text.chars:
    i.c = i.c.toLower()

proc setColor*(c: StyleUnicode, color: ColorRef) =
  c.color = color

proc setColor*(text: StyleText, color: ColorRef) =
  for i in text.chars:
    i.color = color

proc setColor*(text: StyleText, index: int, color: ColorRef) =
  text.chars[index].color = color

proc setColor*(text: StyleText, s, e: int, color: ColorRef) =
  for i in s..e:
    text.chars[i].color = color


proc setUnderline*(c: StyleUnicode, val: bool) =
  c.underline = val

proc setUnderline*(text: StyleText, val: bool) =
  for i in text.chars:
    i.underline = val

proc setUnderline*(text: StyleText, index: int, val: bool) =
  text.chars[index].underline = val

proc setUnderline*(text: StyleText, s, e: int, val: bool) =
  for i in s..e:
    text.chars[i].underline = val

proc setFont*(text: StyleText, font: cstring, size: cint) =
  text.font = openFont(font, size)

proc setFont*(text: StyleText, font: FontPtr) =
  text.font = font

proc loadFont*(font: cstring, size: cint): FontPtr =
  openFont(font, size)


proc len*(text: StyleText): int =
  text.chars.len()

proc `$`*(c: StyleUnicode): string =
  c.c

proc `$`*(text: StyleText): string =
  for i in text.chars:
    result &= $i

proc `&`*(text: StyleText, c: StyleUnicode): StyleText =
  result = text
  result.chars.add(c)

proc `&`*(text, t: StyleText): StyleText =
  result = text
  for c in t.chars:
    result.chars.add(c)

proc `&`*(text: StyleText, t: string): StyleText =
  text & stext(t)

proc `&`*(text: string, c: StyleUnicode): string =
  text & $c

proc `&`*(text: string, t: StyleText): string =
  text & $t

proc `&=`*(text: var StyleText, c: StyleUnicode) =
  text = text & c

proc `&=`*(text: var StyleText, t: StyleText) =
  text = text & t

proc `&=`*(text: var string, c: StyleUnicode) =
  text = text & $c

proc `&=`*(text: var string, t: StyleText) =
  text = text & $t

proc `&=`*(text: var StyleText, t: string) =
  text &= stext(t)


proc splitLines*(text: StyleText): seq[StyleText] =
  result = @[stext""]
  var line = 0
  for i in text.chars:
    if i.c != "\n":
      result[^1].chars.add(i)
    else:
      if text.max_lines == -1 or text.max_lines < line:
        result.add(stext"")
        inc line


proc getTextSize*(text: StyleText): Vector2Obj =
  result = Vector2()
  if not text.font.isNil():
    var
      lines = text.splitLines()
      w: cint
      h: cint

    for line in lines:
      discard text.font.sizeUtf8(($line).cstring, addr w, addr h)
      if result.x < w.float:
        result.x = w.float
      result.y += text.spacing
      result.y += h.float
    result.y -= text.spacing

proc getCaretPos*(text: StyleText, pos: uint32): tuple[a: Vector2Obj, b: uint16] =
  result = (a: Vector2(), b: 0'u16)
  var tmp = 0'u32
  if not text.font.isNil():
    var
      lines = text.splitLines()
      w: cint
      h: cint

    for line in lines:
      result[0].x = 0f
      result[0].y += text.spacing
      result[0].y += h.float
      for c in $line:
        discard text.font.sizeUtf8(($c).cstring, addr w, addr h)
        result[0].x += w.float
        if result[1] == 0'u16:
          result[1] = h.uint16
        if tmp >= pos:
          result[0].x -= w.float
          return result
        inc tmp
      inc tmp
      if tmp >= pos:
        result[0].y -= text.spacing
        return result
    result[0].y -= text.spacing

proc renderSurface*(text: StyleText, anchor: AnchorObj): SurfacePtr =
  when defined(debug):
    if text.font.isNil():
      error("Font is not loaded!")
      text.rendered = true
      return

  if not text.font.isNil() and $text != "":
    let
      lines = text.splitLines()
      textsize = text.getTextSize()
    var
      surface = createRGBSurface(
        0, textsize.x.cint, textsize.y.cint, 32,
        0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000'u32)
      y: cint = 0
      w: cint
      h: cint

    for line in lines:
      discard text.font.sizeUtf8(($line).cstring, addr w, addr h)
      var x = (textsize.x * anchor.x1 - w.float * anchor.x2).cint
      for c in line.chars:
        discard text.font.sizeUtf8(($c).cstring, addr w, addr h)
        var
          rendered = text.font.renderUtf8Blended(
            ($c).cstring,
            color(uint8(c.color.r * 255), uint8(c.color.g * 255), uint8(c.color.b * 255), uint8(c.color.a * 255)))
          r = rect(x, y, w, h)
        rendered.blitSurface(nil, surface, addr r)
        freeSurface(rendered)
        x += w
      y += h + text.spacing.cint
    return surface

proc render*(text: StyleText, size: Vector2Obj, anchor: AnchorObj) =
  var surface = renderSurface(text, anchor)

  if not surface.isNil():
    text.texture.size.x = surface.w.float
    text.texture.size.y = surface.h.float

    # OpenGL:
    if text.texture.texture == 0'u32:
      glGenTextures(1, text.texture.texture.addr)
    glBindTexture(GL_TEXTURE_2D, text.texture.texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA.GLint, surface.w,  surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, surface.pixels)

    # free memory
    surface.freeSurface()
    surface = nil
  text.rendered = true

proc renderTo*(text: StyleText, pos, size: Vector2Obj, anchor: AnchorObj) =
    # Show text
    if not text.rendered:
      text.render(size, anchor)
    var
      pos1 = Vector2(pos)
      size1 = Vector2(size)
      texcord: array[4, Glfloat] = [1f, 1f, 0f, 0f]
    let
      textsize = text.getTextSize()

    if textsize.x < size1.x:
      size1.x = textsize.x
      pos1.x += size.x*anchor.x1 - textsize.x*anchor.x2
    if textsize.y < size1.y:
      size1.y = textsize.y
      pos1.y -= size.y*anchor.y1 - textsize.y*anchor.y2

    if textsize.x > size1.x:
      let
        x1 = (size1.x*anchor.x1 - textsize.x*anchor.x2) / textsize.x
        x2 =
          if x1 > 0.5:
            1f - ((size1.x*anchor.x1 - textsize.x*anchor.x2 + textsize.x) / textsize.x)
          else:
            x1 + (size1.x / textsize.x)
      texcord[0] = abs(x2)
      texcord[2] = abs(x1)
    if textsize.y > size1.y:
      let
        y1 = (size1.y*anchor.y1 - textsize.y*anchor.y2) / textsize.y
        y2 =
          if y1 > 0.5:
            1f - ((size1.y*anchor.y1 - textsize.y*anchor.y2 + textsize.y) / textsize.y)
          else:
            y1 + (size1.y / textsize.y)
      texcord[1] = abs(y2)
      texcord[3] = abs(y1)

    glColor4f(1, 1, 1, 1)
    glBindTexture(GL_TEXTURE_2D, text.texture.texture)
    glEnable(GL_TEXTURE_2D)
    glBegin(GL_QUADS)
    glVertex2f(pos1.x + size1.x, pos1.y)
    glTexCoord2f(texcord[0], texcord[1])
    glVertex2f(pos1.x + size1.x, pos1.y - size1.y)
    glTexCoord2f(texcord[2], texcord[1])
    glVertex2f(pos1.x, pos1.y - size1.y)
    glTexCoord2f(texcord[2], texcord[3])
    glVertex2f(pos1.x, pos1.y)
    glTexCoord2f(texcord[0], texcord[3])
    glEnd()
    glDisable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, 0)
