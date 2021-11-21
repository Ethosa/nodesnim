# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/color,
  ../core/stylesheet,
  ../core/image,
  ../core/vector2,
  ../core/tools,

  ../private/templates,

  strutils,
  re



type
  DrawableObj* = object of RootObj
    shadow*: bool
    border_width*: float
    border_detail*: array[4, int]    ## left-top, right-top, right-bottom, left-bottom
    border_radius*: array[4, float]  ## left-top, right-top, right-bottom, left-bottom
    shadow_offset*: Vector2Obj
    border_color*: ColorRef
    shadow_color*: ColorRef
    background_color*: ColorRef
    texture*: GlTextureObj
  DrawableRef* = ref DrawableObj


let standard_shadow_color*: ColorRef = Color(0f, 0f, 0f, 0.5f)

proc Drawable*: DrawableRef =
  drawablepattern(DrawableRef)


method enableShadow*(self: DrawableRef, val: bool = true) {.base.} =
  ## Enables shadow, when `val` is true.
  self.shadow = val

method draw*(self: DrawableRef, x1, y1, width, height: float) {.base.} =
  var
    vertex: seq[Vector2Obj] = @[]
    x = x1
    y = y1

  if self.shadow:
    calculateDrawableCorners(true)
  calculateDrawableCorners()

  if self.texture.texture > 0'u32:
    drawTextureTemplate(GL_POLYGON, self.background_color, voidTemplate(), voidTemplate())
  else:
    drawTemplate(GL_POLYGON, self.background_color, voidTemplate(), voidTemplate())
  if self.border_width > 0f:
    drawTemplate(GL_LINE_LOOP, self.border_color, glLineWidth(self.border_width), glLineWidth(1))


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
  ## Changes corners radius.
  ##
  ## Arguments:
  ## - `radius` is a new corner radius.
  self.border_radius = [radius, radius, radius, radius]

method setCornerRadius*(self: DrawableRef, r1, r2, r3, r4: float) {.base.} =
  ## Changes corners radius.
  ##
  ## Arguments:
  ## - `r1` is a new left-top radius.
  ## - `r2` is a new right-top radius.
  ## - `r3` is a new right-bottm radius.
  ## - `r4` is a new left-bottm radius.
  self.border_radius = [r1, r2, r3, r4]

method setCornerDetail*(self: DrawableRef, detail: int) {.base.} =
  ## Changes corners details.
  ##
  ## Arguments:
  ## - `detail` is a new corner detail.
  self.border_detail = [detail, detail, detail, detail]

method setCornerDetail*(self: DrawableRef, d1, d2, d3, d4: int) {.base.} =
  ## Changes corners details.
  ##
  ## Arguments:
  ## - `d1` is a new left-top detail.
  ## - `d2` is a new right-top detail.
  ## - `d3` is a new right-bottm detail.
  ## - `d4` is a new left-bottm detail.
  self.border_detail = [d1, d2, d3, d4]

method setTexture*(self: DrawableRef, texture: GlTextureObj) {.base.} =
  ## Changes drawable texture.
  self.texture = texture
  self.background_color = Color(1f, 1f, 1f, 1f)

method setShadowColor*(self: DrawableRef, clr: ColorRef) {.base.} =
  self.shadow_color = clr

method setShadowOffset*(self: DrawableRef, offset: Vector2Obj) {.base.} =
  ## Changes shadow offset.
  self.shadow_offset = offset


method setStyle*(self: DrawableRef, s: StyleSheetRef) {.base.} =
  ## Sets new stylesheet.
  ##
  ## Styles:
  ## - `background-color` - `rgb(1, 1, 1)`; `rgba(1, 1, 1, 1)`; `#ffef`.
  ## - `background-image` - `"assets/image.jpg".
  ## - `background` - the same as `background-image` and `background-color`.
  ## - `border-color` - the same as `background-color`.
  ## - `border-width` - `0`; `8`.
  ## - `border-detail` - corners details. `8`; `8 8 8 8`.
  ## - `border-radius` - corners radius. same as `border-detail`.
  ## - `border` - corners radius and border color. `8 #ffef`.
  ## - `shadow` - enables shadow. `true`; `yes`; `on`; `off`; `no`; `false`.
  ## - `shadow-offset` - XY shadow offset. `3`; `5 10`.
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
    # background: "url(path/to/img.jpg)"
    # background: "rgb(125, 82, 196)"
    # background: "url(img.jpg) #f6f"
    of "background":
      # #fff | rgba(1, 1, 1)
      if i.value.matchColor():
        let tmpclr = Color(matches[0])
        if not tmpclr.isNil():
          self.setColor(tmpclr)
      # url(path/to/image)
      elif i.value.matchBackgroundImage(matches):
        self.loadTexture(matches[0])
      # url(path to image) #fff | rgba(1, 1, 1)
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
    of "shadow-color":
      let clr = Color(i.value)
      if not clr.isNil():
        self.setShadowColor(clr)
    else:
      discard
