# author: Ethosa
import ../core/sdl2
import control
import ../default/enums
import ../default/vector2
import ../default/colornodes
import ../defaultnodes/canvas
import ../defaultnodes/node
{.used.}


type
  ColorRectObj* = object of ControlObj
    color*: ColorRef
  ColorRectPtr* = ptr ColorRectObj


proc ColorRect*(name: string, variable: var ColorRectObj): ColorRectPtr =
  nodepattern(ColorRectObj)
  canvaspattern()
  variable.color = Color(0xffffffff'u32)
  variable.rect_size = Vector2(40.0, 40.0)
  variable.surface = createRGBSurface(
    0, 40, 40, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )

proc ColorRect*(variable: var ColorRectObj): ColorRectPtr {.inline.} =
  ColorRect("ColorRect", variable)


method draw*(self: ColorRectPtr, surface: SurfacePtr) =
  self.surface.fillRect(nil, self.color.toUint32BE())
  procCall self.ControlPtr.draw(surface)

method resize*(self: ColorRectPtr, width, height: float) =
  ## Resizes ColorRect by `width` and `height`
  if width < 0.0 or height < 0.0:
    raise newException(ValueError, "width or height less than 0.0")

  self.surface.freeSurface()
  self.surface = nil
  self.surface = createRGBSurface(
    0, width.cint, height.cint, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )
  self.rect_size = Vector2(width, height)

method setColor*(self: ColorRectPtr, color: uint32) {.base.} =
  ## Changes ColorRect color.
  self.color = Color(color)

method setColor*(self: ColorRectPtr, color: ColorRef) {.base.} =
  ## Changes ColorRect color.
  self.color = color
