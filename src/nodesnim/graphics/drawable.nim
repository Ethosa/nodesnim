# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/color,
  ../core/stylesheet,
  ../core/image,
  ../core/vector2,
  ../core/tools,

  strutils,
  re



type
  DrawableObj* = object of RootObj
    shadow*: bool
    border_width*: float
    border_detail_lefttop*: int
    border_detail_righttop*: int
    border_detail_leftbottom*: int
    border_detail_rightbottom*: int
    border_radius_lefttop*: float
    border_radius_righttop*: float
    border_radius_leftbottom*: float
    border_radius_rightbottom*: float
    shadow_offset*: Vector2Obj
    border_color*: ColorRef
    background_color*: ColorRef
    texture*: GlTextureObj
  DrawableRef* = ref DrawableObj


template drawablepattern*(`type`: untyped): untyped =
  result = `type`(
    texture: GlTextureObj(), border_width: 0,
    border_detail_lefttop: 20,
    border_detail_righttop: 20,
    border_detail_leftbottom: 20,
    border_detail_rightbottom: 20,
    border_radius_lefttop: 0,
    border_radius_righttop: 0,
    border_radius_leftbottom: 0,
    border_radius_rightbottom: 0,
    border_color: Color(0, 0, 0, 0),
    background_color: Color(0, 0, 0, 0),
    shadow_offset: Vector2(0, 0), shadow: false
  )

proc Drawable*: DrawableRef =
  drawablepattern(DrawableRef)

let shadow_color: ColorRef = Color(0f, 0f, 0f, 0.5f)


template vd* = discard

template recalc* =
  ## Calculates vertex positions.
  # left top
  for i in bezier_iter(1f/self.border_detail_lefttop.float, Vector2(0, -self.border_radius_lefttop),
                       Vector2(0, 0), Vector2(self.border_radius_lefttop, 0)):
    vertex.add(Vector2(x+i.x, y+i.y))

  # right top
  for i in bezier_iter(1f/self.border_detail_righttop.float, Vector2(-self.border_radius_righttop, 0),
                       Vector2(0, 0), Vector2(0, -self.border_radius_righttop)):
    vertex.add(Vector2(x+width+i.x, y+i.y))

  # right bottom
  for i in bezier_iter(1f/self.border_detail_rightbottom.float, Vector2(0, -self.border_radius_rightbottom),
                       Vector2(0, 0), Vector2(-self.border_radius_rightbottom, 0)):
    vertex.add(Vector2(x+width+i.x, y-height-i.y))

  # left bottom
  for i in bezier_iter(1f/self.border_detail_leftbottom.float, Vector2(self.border_radius_leftbottom, 0),
                       Vector2(0, 0), Vector2(0, self.border_radius_leftbottom)):
    vertex.add(Vector2(x+i.x, y-height+i.y))


template draw_template*(drawtype, color, function, secondfunc: untyped): untyped =
  ## Draws colorized vertexes
  ##
  ## Arguments:
  ## - `drawtype` - draw type, like `GL_POLYGON`
  ## - `color` - color for border drawing.
  ## - `function` - function called before `glBegin`
  ## - `secondfunc` - function called after `glEnd`
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)

  for i in vertex:
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`

template draw_texture_template*(drawtype, color, function, secondfunc: untyped): untyped =
  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, self.texture.texture)
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)
  var
    texture_size = self.texture.size
    h = height
    w = width
  if texture_size.x < width:
    let q = width / texture_size.x
    texture_size.x *= q
    texture_size.y *= q
  if texture_size.y < height:
    let q = height / texture_size.y
    texture_size.x *= q
    texture_size.y *= q

  # crop .. :eyes:
  let q = width / texture_size.x
  texture_size.x *= q
  texture_size.y *= q
  h /= height/width
  h -= texture_size.y/2

  for i in vertex:
    glTexCoord2f((-x + i.x - w + texture_size.x) / width, 1f - ((-y + i.y - h + texture_size.y) / texture_size.y))
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`
  glDisable(GL_TEXTURE_2D)


method enableShadow*(self: DrawableRef, val: bool) {.base.} =
  ## Enables shadow, when `val` is true.
  self.shadow = val

method draw*(self: DrawableRef, x1, y1, width, height: float) {.base.} =
  var
    vertex: seq[Vector2Obj] = @[]
    x = x1 + self.shadow_offset.x
    y = y1 - self.shadow_offset.y

  if self.shadow:
    recalc()
    if self.texture.texture > 0'u32:
      draw_texture_template(GL_POLYGON, shadow_color, vd(), vd())
    else:
      draw_template(GL_POLYGON, shadow_color, vd(), vd())

  vertex = @[]
  x = x1
  y = y1
  recalc()

  if self.texture.texture > 0'u32:
    draw_texture_template(GL_POLYGON, self.background_color, vd(), vd())
  else:
    draw_template(GL_POLYGON, self.background_color, vd(), vd())
  if self.border_width > 0f:
    draw_template(GL_LINE_LOOP, self.border_color, glLineWidth(self.border_width), glLineWidth(1))


method getColor*(self: DrawableRef): ColorRef {.base.} =
  ## Returns background color.
  self.background_color

method loadTexture*(self: DrawableRef, path: string) {.base.} =
  ## Loads texture from the file.
  ##
  ## Arguments:
  ## - `path` is an image path.
  self.texture = load(path)
  self.background_color = Color(1f, 1f, 1f, 1f)

method setBorderColor*(self: DrawableRef, color: ColorRef) {.base.} =
  ## Changes border color.
  self.border_color = color

method setBorderWidth*(self: DrawableRef, width: float) {.base.} =
  ## Changes border width.
  self.border_width = width

method setColor*(self: DrawableRef, color: ColorRef) {.base.} =
  ## Changes background color.
  self.background_color = color

method setCornerRadius*(self: DrawableRef, radius: float) {.base.} =
  ## Changes corner radius.
  ##
  ## Arguments:
  ## - `radius` is a new corner radius.
  self.border_radius_lefttop = radius
  self.border_radius_righttop = radius
  self.border_radius_leftbottom = radius
  self.border_radius_rightbottom = radius

method setCornerRadius*(self: DrawableRef, r1, r2, r3, r4: float) {.base.} =
  ## Changes corner radius.
  ##
  ## Arguments:
  ## - `r1` is a new left-top radius.
  ## - `r2` is a new right-top radius.
  ## - `r3` is a new right-bottm radius.
  ## - `r4` is a new left-bottm radius.
  self.border_radius_lefttop = r1
  self.border_radius_righttop = r2
  self.border_radius_rightbottom = r3
  self.border_radius_leftbottom = r4

method setCornerDetail*(self: DrawableRef, detail: int) {.base.} =
  ## Changes corner detail.
  ##
  ## Arguments:
  ## - `detail` is a new corner detail.
  self.border_detail_lefttop = detail
  self.border_detail_righttop = detail
  self.border_detail_leftbottom = detail
  self.border_detail_rightbottom = detail

method setCornerDetail*(self: DrawableRef, d1, d2, d3, d4: int) {.base.} =
  ## Changes corner detail.
  ##
  ## Arguments:
  ## - `d1` is a new left-top detail.
  ## - `d2` is a new right-top detail.
  ## - `d3` is a new right-bottm detail.
  ## - `d4` is a new left-bottm detail.
  self.border_detail_lefttop = d1
  self.border_detail_righttop = d2
  self.border_detail_leftbottom = d4
  self.border_detail_rightbottom = d3

method setTexture*(self: DrawableRef, texture: GlTextureObj) {.base.} =
  ## Changes drawable texture.
  self.texture = texture
  self.background_color = Color(1f, 1f, 1f, 1f)

method setShadowOffset*(self: DrawableRef, offset: Vector2Obj) {.base.} =
  ## Changes shadow offset.
  self.shadow_offset = offset

method setStyle*(self: DrawableRef, s: StyleSheetRef) {.base.} =
  ## Sets a new stylesheet.
  for i in s.dict:
    var matches: array[20, string]
    case i.key
    # background-color: rgb(51, 100, 255)
    of "background-color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setColor(clr)
    # background-image: "assets/img.jpg"
    of "background-image":
      self.loadTexture(i.value)
    # background: "path/to/img.jpg"
    # background: rgb(125, 82, 196)
    # background: "img.jpg" #f6f
    of "background":
      if i.value.match(re"\A\s*(rgba?\([^\)]+\)\s*|#[a-f0-9]{3,8})\s*\Z", matches):
        let tmpclr = Color(matches[0])
        if not tmpclr.isNil():
          self.setColor(tmpclr)
      elif i.value.match(re"\A\s*url\(([^\)]+)\)\s*\Z", matches):
        self.loadTexture(matches[0])
      elif i.value.match(re"\A\s*url\(([^\)]+)\)\s+(rgba?\([^\)]+\)\s*|#[a-f0-9]{3,8})\s*\Z", matches):
        self.loadTexture(matches[0])
        let tmpclr = Color(matches[1])
        if not tmpclr.isNil():
          self.setColor(tmpclr)
    # border-color: rgba(55, 255, 177, 0.1)
    of "border-color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setBorderColor(clr)
    # border-radius: 5
    # border-radius: 2 4 8 16
    of "border-radius":
      let tmp = i.value.split(" ")
      if tmp.len() == 1:
        self.setCornerRadius(parseFloat(tmp[0]))
      elif tmp.len() == 4:
        self.setCornerRadius(parseFloat(tmp[0]), parseFloat(tmp[1]), parseFloat(tmp[2]), parseFloat(tmp[3]))
    # border-detail: 5
    # border-detail: 5 50 64 128
    of "border-detail":
      let tmp = i.value.split(" ")
      if tmp.len() == 1:
        self.setCornerDetail(parseInt(tmp[0]))
      elif tmp.len() == 4:
        self.setCornerDetail(parseInt(tmp[0]), parseInt(tmp[1]), parseInt(tmp[2]), parseInt(tmp[3]))
    # border-width: 5
    of "border-width":
      self.setBorderWidth(parseFloat(i.value))
    # border: 2 turquoise
    of "border":
      let tmp = i.value.rsplit(Whitespace, 1)
      self.setCornerRadius(parseFloat(tmp[0]))
      self.setBorderColor(Color(tmp[1]))
    # shadow: true
    of "shadow":
      self.enableShadow(parseBool(i.value))
    # shadow-offset: 3 3
    of "shadow-offset":
      let tmp = i.value.split(Whitespace, 1)
      if tmp.len() == 1:
        self.setShadowOffset(Vector2(parseFloat(tmp[0])))
      elif tmp.len() == 2:
        self.setShadowOffset(Vector2(parseFloat(tmp[0]), parseFloat(tmp[1])))
    else:
      discard