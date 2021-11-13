# author: Ethosa
## Provides TTF text rendering. Use SDL2_ttf.
import ../thirdparty/sdl2 except Color
import
  ../thirdparty/sdl2/ttf,
  ../thirdparty/opengl,

  image,
  vector2,
  anchor,
  color,
  themes,
  nodes_os,
  exceptions,
  unicode


type
  StyleUnicode* = ref object
    is_url*: bool
    style*: cint
    c*, url*: string
    color*: ColorRef
  StyleText* = ref object
    font*: FontPtr
    rendered*: bool
    spacing*: float
    max_lines*: int
    texture*: GlTextureObj
    chars*: seq[StyleUnicode]


proc schar*(c: string, color: ColorRef = nil,
            style: cint = TTF_STYLE_NORMAL, is_url: bool = false): StyleUnicode =
  StyleUnicode(
    c: c, style: style, is_url: is_url, url: "",
    color: if color.isNil():
             current_theme~foreground
           else:
             color)

proc stext*(text: string, color: ColorRef = nil,
            style: cint = TTF_STYLE_NORMAL): StyleText =
  result = StyleText(texture: GlTextureObj(size: Vector2()), spacing: 2, max_lines: -1)
  for i in text.utf8():
    result.chars.add(schar(i, color, style))
  result.font = standard_font
  result.rendered = false


# ------ Operators ------ #

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

proc `&`*(text: string, c: StyleUnicode | StyleText): string =
  text & $c

proc `&=`*(text: var StyleText, c: StyleUnicode | StyleText) =
  text &= c

proc `&=`*(text: var string, c: StyleUnicode | StyleText) =
  text &= $c

proc `&=`*(text: var StyleText, t: string) =
  text &= stext(t)

proc `[]`*(text: StyleText, index: int | BackwardsIndex): StyleUnicode =
  text.chars[index]

proc `[]`*[T, U](text: StyleText, slice: HSlice[T, U]): StyleText =
  result = stext""
  for i in text.chars[slice.a..slice.b]:
    result &= i


# ------ Funcs ------ #
proc applyStyle*(symbol: StyleUnicode, style: cint, enabled: bool = true) =
  if (symbol.style and style) == 0 and enabled:
    symbol.style = symbol.style or style
  elif (symbol.style and style) != 0 and not enabled:
    symbol.style = symbol.style xor style

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

template styleFunc(setter, style_type: untyped): untyped =
  proc `setter`*(c: StyleUnicode, val: bool = true) =
    c.applyStyle(`style_type`, val)
  proc `setter`*(text: StyleText, val: bool) =
    for i in text.chars:
      i.`setter`(val)
  proc `setter`*(text: StyleText, index: int, val: bool) =
    text.chars[index].`setter`(val)
  proc `setter`*(text: StyleText, s, e: int, val: bool) =
    for i in s..e:
      text.chars[i].`setter`(val)

styleFunc(setNormal, TTF_STYLE_NORMAL)
styleFunc(setBold, TTF_STYLE_BOLD)
styleFunc(setItalic, TTF_STYLE_ITALIC)
styleFunc(setUnderline, TTF_STYLE_UNDERLINE)
styleFunc(setStrikethrough, TTF_STYLE_STRIKETHROUGH)

proc setURL*(text: StyleText, s, e: int,
             url: string, color: ColorRef = current_theme~url_color) =
  for i in s..e:
    text.chars[i].is_url = true
    text.chars[i].url = url
    text.chars[i].color = current_theme~url_color

proc setFont*(text: StyleText, font: cstring, size: cint) =
  text.font = openFont(font, size)

proc setFont*(text: StyleText, font: FontPtr) =
  text.font = font

proc loadFont*(font: cstring, size: cint): FontPtr =
  openFont(font, size)


# ------ Utils ------ #

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

proc split*(text: StyleText, splitval: string): seq[StyleText] =
  result = @[stext""]
  let size = splitval.len
  var i = 0
  while i+size-1 < text.len:
    if $text[i..i+size-1] != splitval:
      result[^1].chars.add(text[i])
      inc i
    else:
      result.add(stext"")
      inc i, size

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

proc getPosUnderPoint*(text: StyleText, global_pos, text_pos: Vector2Obj,
                       text_align: AnchorObj = Anchor(0, 0, 0, 0)): uint32 =
  ## Returns caret position under mouse.
  if not text.font.isNil():
    let
      textsize = text.getTextSize()
      local_pos = global_pos - text_pos
      lines = text.splitLines()
    var
      w: cint
      h: cint
      x: float = 0f
      y: float = 0f
      position = Vector2(-1, -1)

    for line in lines:
      discard text.font.sizeUtf8(($line).cstring, addr w, addr h)
      if local_pos.y >= y and local_pos.y <= y + h.float:
        position.y = y
      x = textsize.x*text_align.x1 - w.Glfloat*text_align.x2
      for c in line.chars:
        discard text.font.sizeUtf8(($c).cstring, addr w, addr h)
        result += 1
        if local_pos.x >= x and local_pos.x <= x+w.float and position.y != -1f:
          position.x = x
          break
        x += w.float
      if position.x != -1f:
        break
      y += text.spacing + h.float
      result += 1
    if position.x == -1f:
      result = 0

proc getCharUnderPoint*(text: StyleText, global_pos, text_pos: Vector2Obj,
                        text_align: AnchorObj = Anchor(0, 0, 0, 0)): tuple[c: StyleUnicode, pos: uint32] =
  let pos = text.getPosUnderPoint(global_pos, text_pos, text_align)
  if pos > 0:
    return (c: text.chars[pos-1], pos: pos-1)
  elif text.chars.len > 0:
    return (c: text.chars[pos], pos: pos)


# ------ Render ------ #

proc renderSurface*(text: StyleText, align: AnchorObj): SurfacePtr =
  ## Renders the surface and returns it, if available.
  ##
  ## Arguments:
  ##   - `align` -- text align.
  if text.font.isNil():
    throwError(ResourceError, "Font isn't loaded!")

  if not text.font.isNil() and $text != "":
    let
      lines = text.splitLines()
      textsize = text.getTextSize()
    var
      surface = createRGBSurface(
        0, textsize.x.cint + 8, textsize.y.cint, 32,
        0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000u32)
      y: cint = 0
      w: cint
      h: cint

    for line in lines:
      discard text.font.sizeUtf8(($line).cstring, addr w, addr h)
      var x = (textsize.x * align.x1 - w.float * align.x2).cint
      for c in line.chars:
        text.font.setFontStyle(c.style)
        discard text.font.sizeUtf8(($c).cstring, addr w, addr h)
        var
          rendered = text.font.renderUtf8Blended(
            ($c).cstring,
            color(uint8(c.color.r * 255), uint8(c.color.g * 255), uint8(c.color.b * 255), uint8(c.color.a * 255)))
          r = rect(x, y, w, h)
        rendered.blitSurface(nil, surface, addr r)
        rendered.freeSurface()
        x += w
      y += h + text.spacing.cint
    return surface

proc render*(text: StyleText, size: Vector2Obj, align: AnchorObj) =
  ## Translates SDL2 surface to OpenGL texture and frees surface memory.
  var surface = renderSurface(text, align)

  if not surface.isNil():
    text.texture.size.x = surface.w.float
    text.texture.size.y = surface.h.float

    # OpenGL:
    if text.texture.texture == 0'u32:
      glGenTextures(1, text.texture.texture.addr)
    glBindTexture(GL_TEXTURE_2D, text.texture.texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA.GLint, surface.w, surface.h,
                 0, GL_RGBA, GL_UNSIGNED_BYTE, surface.pixels)

    # free memory
    surface.freeSurface()
  text.rendered = true

proc renderTo*(text: StyleText, pos, size: Vector2Obj, align: AnchorObj) =
    # Show text
    if not text.rendered:
      text.render(size, align)
    var
      pos1 = Vector2(pos)
      size1 = Vector2(size)
      texcord: array[4, Glfloat] = [1f, 1f, 0f, 0f]
    let
      textsize = text.getTextSize()

    if textsize.x < size1.x:
      size1.x = textsize.x
      pos1.x += size.x*align.x1 - textsize.x*align.x2
    if textsize.y < size1.y:
      size1.y = textsize.y
      pos1.y -= size.y*align.y1 - textsize.y*align.y2

    if textsize.x > size1.x:
      let
        x1 = (size1.x*align.x1 - textsize.x*align.x2) / textsize.x
        x2 =
          if x1 > 0.5:
            1f - ((size1.x*align.x1 - textsize.x*align.x2 + textsize.x) / textsize.x)
          else:
            x1 + (size1.x / textsize.x)
      texcord[0] = abs(x2)
      texcord[2] = abs(x1)
    if textsize.y > size1.y:
      let
        y1 = (size1.y*align.y1 - textsize.y*align.y2) / textsize.y
        y2 =
          if y1 > 0.5:
            1f - ((size1.y*align.y1 - textsize.y*align.y2 + textsize.y) / textsize.y)
          else:
            y1 + (size1.y / textsize.y)
      texcord[1] = abs(y2)
      texcord[3] = abs(y1)

    glColor4f(1, 1, 1, 1)
    glBindTexture(GL_TEXTURE_2D, text.texture.texture)
    glEnable(GL_TEXTURE_2D)
    glBegin(GL_QUADS)
    glTexCoord2f(texcord[0], texcord[3])
    glVertex2f(pos1.x + size1.x, pos1.y)
    glTexCoord2f(texcord[0], texcord[1])
    glVertex2f(pos1.x + size1.x, pos1.y - size1.y)
    glTexCoord2f(texcord[2], texcord[1])
    glVertex2f(pos1.x, pos1.y - size1.y)
    glTexCoord2f(texcord[2], texcord[3])
    glVertex2f(pos1.x, pos1.y)
    glEnd()
    glDisable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, 0)
