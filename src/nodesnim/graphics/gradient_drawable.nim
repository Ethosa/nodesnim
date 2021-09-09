# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/color,
  ../core/stylesheet,
  ../core/image,
  ../core/vector2,

  drawable,
  math

type
  GradientDrawableObj* = object of DrawableObj
    corners*: tuple[p0, p1, p2, p3: ColorRef]
  GradientDrawableRef* = ref GradientDrawableObj


proc GradientDrawable*: GradientDrawableRef =
  drawablepattern(GradientDrawableRef)
  result.corners = (Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0),
                    Color(1f, 1f, 1f, 1.0))

let shadow_color: ColorRef = Color(0f, 0f, 0f, 0.5f)


template draw_template*(drawtype, color, function, secondfunc: untyped, is_gradient: bool = true): untyped =
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)

  if is_gradient:
    for i in 0..vertex.high:
      let tmp = i/vertex.len()
      if tmp < 0.25:
        glColor4f(self.corners[0].r, self.corners[0].g, self.corners[0].b, self.corners[0].a)
      elif tmp < 0.5:
        glColor4f(self.corners[1].r, self.corners[1].g, self.corners[1].b, self.corners[1].a)
      elif tmp < 0.75:
        glColor4f(self.corners[2].r, self.corners[2].g, self.corners[2].b, self.corners[2].a)
      else:
        glColor4f(self.corners[3].r, self.corners[3].g, self.corners[3].b, self.corners[3].a)
      glVertex2f(vertex[i].x, vertex[i].y)
  else:
    for i in vertex:
      glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`

method draw*(self: GradientDrawableRef, x1, y1, width, height: float) =
  var
    vertex: seq[Vector2Ref] = @[]
    x = x1 + self.shadow_offset.x
    y = y1 - self.shadow_offset.y

  if self.shadow:
    recalc()
    if self.texture.texture > 0'u32:
      draw_texture_template(GL_POLYGON, shadow_color, vd(), vd())
    else:
      draw_template(GL_POLYGON, shadow_color, vd(), vd(), false)

  vertex = @[]
  x = x1
  y = y1
  recalc()

  if self.texture.texture > 0'u32:
    draw_texture_template(GL_POLYGON, self.background_color, vd(), vd())
  else:
    draw_template(GL_POLYGON, self.background_color, vd(), vd())
  if self.border_width > 0f:
    draw_template(GL_LINE_LOOP, self.border_color, glLineWidth(self.border_width), glLineWidth(1), false)

method setCornerColors*(self: GradientDrawableRef, corners: tuple[p0, p1, p2, p3: ColorRef]) {.base.} =
  self.corners = corners
