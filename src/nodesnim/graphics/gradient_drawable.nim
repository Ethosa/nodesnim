# author: Ethosa
import
  ../thirdparty/gl,

  ../core/color,
  ../core/stylesheet,
  ../core/image,
  ../core/vector2,
  ../core/tools,

  ../private/templates,

  drawable,
  strutils

type
  GradientDrawableObj* = object of DrawableObj
    corners*: array[4, ColorRef]
  GradientDrawableRef* = ref GradientDrawableObj


proc GradientDrawable*: GradientDrawableRef =
  drawablepattern(GradientDrawableRef)
  result.corners = [Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0)]

method draw*(self: GradientDrawableRef, x1, y1, width, height: float) =
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
    drawTemplate(GL_POLYGON, self.background_color, voidTemplate(), voidTemplate(), true)
  if self.border_width > 0f:
    drawTemplate(GL_LINE_LOOP, self.border_color, glLineWidth(self.border_width), glLineWidth(1), false)

method setCornerColors*(self: GradientDrawableRef, c0, c1, c2, c3: ColorRef) {.base.} =
  ## Changes corners colors
  ##
  ## Arguments:
  ## -  `c0` is left-top color.
  ## -  `c1` is right-top color.
  ## -  `c2` is right-bottom color.
  ## -  `c3` is left-bottom color.
  self.corners = [c0, c1, c2, c3]

method setCornerColors*(self: GradientDrawableRef, corners: array[4, ColorRef]) {.base.} =
  ## Changes corners colors
  ##
  ## See also:
  ## * `setCornerColors method <#setCornerColors.e,GradientDrawableRef,ColorRef,ColorRef,ColorRef,ColorRef>`_
  ## * `setCornerColors(GradientDrawableRef, ColorRef) method <#setCornerColors.e,GradientDrawableRef,ColorRef>`_
  self.corners = corners

method setCornerColors*(self: GradientDrawableRef, clr: ColorRef) {.base.} =
  ## Changes corners colors
  ##
  ## See also:
  ## * `setCornerColors method <#setCornerColors.e,GradientDrawableRef,ColorRef,ColorRef,ColorRef,ColorRef>`_
  ## * `setCornerColors(GradientDrawableRef, array[4, ColorRef]) method <#setCornerColors.e,GradientDrawableRef,array[,ColorRef]>`_
  self.corners = [Color(clr), Color(clr), Color(clr), Color(clr)]

method setStyle*(self: GradientDrawableRef, s: StyleSheetRef) =
  ## Sets a new stylesheet.
  procCall self.DrawableRef.setStyle(s)
  for i in s.dict:
    case i.key
    # corner-color: "#fff"
    # corner-color: "#fff #f7f #7f7 #ff7"
    of "corner-color":
      let tmp = i.value.split(" ")
      if tmp.len() == 1:
        self.setCornerColors(Color(tmp[0]))
      elif tmp.len() == 4:
        self.setCornerColors(Color(tmp[0]), Color(tmp[1]), Color(tmp[2]), Color(tmp[3]))
    else:
      discard
