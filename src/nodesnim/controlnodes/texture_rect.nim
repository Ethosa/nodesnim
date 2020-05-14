# author: Ethosa
import sdl2
import sdl2/gfx
import control
import ../default/enums
import ../default/anchor
import ../default/vector2
import ../default/imagenodes
import ../defaultnodes/canvas
import ../defaultnodes/node
{.used.}



type
  TextureRectObj* = object of ControlObj
    keep_in*: bool
    texture_mode*: TextureMode
    texture_anchor*: AnchorRef
    texture*: SurfacePtr
  TextureRectPtr* = ptr TextureRectObj


proc TextureRect*(name: string, variable: var TextureRectObj): TextureRectPtr =
  ## Creates a new TextureRect pointer.
  nodepattern(TextureRectObj)
  canvaspattern()
  variable.rect_size = Vector2(40.0, 40.0)
  variable.texture_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.texture_mode = TEXTURE_KEEP_ASPECT_RATIO
  variable.texture = nil
  variable.keep_in = true
  variable.surface = createRGBSurface(
    0, 40, 40, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )
  variable.renderer = variable.surface.createSoftwareRenderer()

proc TextureRect*(variable: var TextureRectObj): TextureRectPtr {.inline.} =
  TextureRect("TextureRect", variable)


proc calcRect(pos, size: Vector2Ref, anchor: AnchorRef, w, h: cint): Rect {.inline.} =
  ## Calculates rectangle for blit texture.
  result.x = pos.x.cint + (size.x*anchor.x1 - w.float*anchor.x2).cint
  result.y = pos.y.cint + (size.y*anchor.y1 - h.float*anchor.y2).cint
  result.w = w
  result.h = h

method draw*(self: TextureRectPtr, surface: SurfacePtr) =
  ## Draws node on the surface
  {.warning[LockLevel]: off.}
  if self.visible and self.surface != nil:
    self.resize(self.rect_size.x, self.rect_size.y)
    self.calcGlobalPosition()

    # -- Draw texture -- #
    if self.texture != nil:
      let pos = if self.keep_in: Vector2() else: self.global_position
      var target = if self.keep_in: self.surface else: surface

      case self.texture_mode
      of TEXTURE_CROP:
        var texture_rect = calcRect(pos, self.rect_size, self.texture_anchor, self.texture.w, self.texture.h)
        self.texture.blitSurface(nil, target, texture_rect.addr)
      of TEXTURE_FULL_SIZE:
        var
          w = self.rect_size.x / self.texture.w.float
          h = self.rect_size.y / self.texture.h.float
          timed = self.texture.rotozoomSurfaceXY(0, w.cdouble, h.cdouble, 1)
          texture_rect = calcRect(pos, self.rect_size, self.texture_anchor, timed.w, timed.h)
        timed.blitSurface(nil, target, texture_rect.addr)
        timed.freeSurface()
        timed = nil
      of TEXTURE_KEEP_ASPECT_RATIO:
        var
          w = self.rect_size.x / self.texture.w.float
          h = self.rect_size.y / self.texture.h.float
          q = if w < h: w else: h
          timed = self.texture.rotozoomSurfaceXY(0, q.cdouble, q.cdouble, 1)
          texture_rect = calcRect(pos, self.rect_size, self.texture_anchor, timed.w, timed.h)
        timed.blitSurface(nil, target, texture_rect.addr)
        timed.freeSurface()
        timed = nil

    # -- Draw surface -- #
    var self_rect = rect(
      self.global_position.x.cint, self.global_position.y.cint,
      self.surface.w, self.surface.h
    )
    self.surface.blitSurface(nil, surface, self_rect.addr)
    if self.pressed:
      var x, y: cint
      discard getMouseState(x, y)
      self.press(x.float, y.float)

method resize*(self: TextureRectPtr, width, height: float) =
  self.rect_size = Vector2Ref(x: width, y: height)
  var timed_surface = createRGBSurface(
    0, width.cint, height.cint, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )
  sdl2.destroy(self.renderer)
  self.surface.blitSurface(nil, timed_surface, nil)
  self.surface.freeSurface()
  self.surface = nil
  self.surface = timed_surface
  self.renderer = self.surface.createSoftwareRenderer()
