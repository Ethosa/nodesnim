# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/font,
  ../core/enums,
  ../core/color,
  ../core/anchor,

  ../nodes/node,
  ../nodes/canvas,

  ../graphics/drawable,

  ../window,

  control


type
  ToolTipObj* = object of ControlObj
    text*: StyleText
  ToolTipRef* = ref ToolTipObj

const TOOLTIP_SPACE: float = 32f


proc ToolTip*(name: string = "ToolTip",
             tooltip: string = "Tooltip"): ToolTipRef =
  nodepattern(ToolTipRef)
  controlpattern()
  result.text = stext(tooltip)
  result.background.setColor(Color("#444"))
  result.background.setBorderColor(Color("#555"))
  result.background.setBorderWidth(0.5)
  result.background.setCornerRadius(4)
  result.background.setCornerDetail(4)
  result.background.enableShadow(true)
  result.background.setShadowOffset(Vector2(0, 5))
  result.mousemode = MOUSEMODE_IGNORE
  result.hide()


method postdraw*(self: ToolTipRef, w, h: GLfloat) =
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  self.text.renderTo(Vector2(x, y), self.rect_size, Anchor(0, 0, 0, 0))

method showAt*(self: ToolTipRef, x, y: float) {.base.} =
  self.moveTo(x, y)
  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y, true)
  self.show()

method showAtMouse*(self: ToolTipRef) {.base.} =
  let
    pos = self.getGlobalMousePosition()
    textsize = self.text.getTextSize()
    windowsize = getWindowSize()
  self.moveTo(pos)

  if pos.x + TOOLTIP_SPACE + textsize.x > windowsize.x:
    self.move(-TOOLTIP_SPACE - textsize.x, 0)

  if pos.y - TOOLTIP_SPACE - textsize.y < 0:
    self.move(0, TOOLTIP_SPACE)
  else:
    self.move(0, -TOOLTIP_SPACE)

  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y, true)
  self.show()
