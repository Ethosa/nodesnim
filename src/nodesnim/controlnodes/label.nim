# author: Ethosa
import strutils
import ../core/sdl2
import ../core/sdl2/ttf
import ../core/sdl2/gfx
import control
import ../default/enums
import ../default/anchor
import ../default/vector2
import ../default/colornodes
import ../defaultnodes/canvas
import ../defaultnodes/node
{.used.}

ttfInit()


type
  LabelObj* = object of CanvasPtr
    line_spacing*: float
    text*: string
    color*, background_color*: ColorRef
    text_align*: AnchorRef
    fontdata*: FontPtr
  LabelPtr* = ptr LabelObj


proc Label*(name: string, variable: var LabelObj): LabelPtr =
  nodepattern(LabelObj)
  canvaspattern()
  variable.color = Color(0xffffffff'u32)
  variable.background_color = Color(0x212121ff'u32)
  variable.text = ""
  variable.fontdata = nil
  variable.line_spacing = 2.0
  variable.rect_size = Vector2(40.0, 40.0)
  variable.text_align = Anchor(0, 0, 0, 0)
  variable.surface = createRGBSurface(
    0, 40, 40, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )
  variable.renderer = variable.surface.createSoftwareRenderer()

proc Label*(variable: var LabelObj): LabelPtr {.inline.} =
  Label("Label", variable)

method getTextSize*(self: LabelPtr): Vector2Ref {.base.} =
  var width, height: cint
  let spacing = self.line_spacing.cint

  if self.fontdata == nil:
    var x: cint = 0
    for l in splitLines(self.text):
      for c in l:
        x += 8
      height += spacing + 8
      if x > width:
        width = x
      x = 0
  else:
    for l in splitLines(self.text):
      var x, y: cint
      discard self.fontdata.sizeUtf8(l, x.addr, y.addr)
      if x > width:
        width = x
      height += y + spacing
  Vector2(width.float, height.float)

proc renderText(self: LabelPtr) =
  let (r, g, b, a) = self.color.toUint32Tuple()
  if self.fontdata == nil:
    var
      size = self.getTextSize()
      x = (self.rect_size.x*self.text_align.x1 - size.x*self.text_align.x2).int16
      y = (self.rect_size.y*self.text_align.y1 - size.y*self.text_align.y2).int16
    self.surface.fillRect(nil, self.background_color.toUint32BE())
    self.renderer.mlStringRGBA(x, y, self.text, r.uint8, g.uint8, b.uint8, a.uint8, self.line_spacing.int16)
  else:
    self.surface.fillRect(nil, self.background_color.toUint32BE())
    var
      timed = renderUtf8Blended(self.fontdata, self.text.cstring, color(r, g, b, a))
      x = (self.rect_size.x*self.text_align.x1 - timed.w.float*self.text_align.x2).cint
      y = (self.rect_size.y*self.text_align.y1 - timed.h.float*self.text_align.y2).cint
      timed_rect = rect(x, y, timed.w, timed.h)
    timed.blitSurface(nil, self.surface, timed_rect.addr)
    timed.freeSurface()
    timed = nil

method draw*(self: LabelPtr, surface: SurfacePtr) =
  self.renderText()
  procCall self.CanvasPtr.draw(surface)
