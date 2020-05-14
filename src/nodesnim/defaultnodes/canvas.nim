# author: Ethosa
import math
import ../core/sdl2
import ../core/sdl2/gfx
import ../default/vector2
import ../default/rect2
import ../default/anchor
import ../default/colornodes
import ../default/enums
import node
{.used.}


gfx.gfxPrimitivesSetFont(nil, 0, 0)


type
  CanvasObj* = object of NodeObj
    visible*: bool          ## true if control node is visible.
    hovered*: bool          ## true when mouse in control node.
    focus*: bool            ## true when control node focused.
    pressed*: bool          ## true when mouse holds on the control node.
    mousemode*: MouseMode   ## mouse mode, by default is MOUSEMODE_SEE
    surface*: SurfacePtr
    renderer*: RendererPtr
    mouse_enter*: proc(x, y: float): void  ## This called when a mouse enters the node.
    mouse_exit*: proc(): void              ## This called when a mouse exits from the node.
    focused*: proc(): void                 ## This called when the node gets focus.
    unfocused*: proc(): void               ## This called when the node loses focus.
    click*: proc(x, y: float): void        ## This called when the mouse clicks on the node.
    press*: proc(x, y: float): void        ## This called when the mouse holds on.
    release*: proc(): void                 ## This called when the mouse more not is pressed.
  CanvasPtr* = ptr CanvasObj


template canvaspattern*: untyped =
  variable.visible = true
  variable.mousemode = MOUSEMODE_SEE
  variable.mouse_enter = proc(x, y: float): void = discard
  variable.click = proc(x, y: float): void = discard
  variable.press = proc(x, y: float): void = discard
  variable.mouse_exit = proc(): void = discard
  variable.release = proc(): void = discard
  variable.unfocused = proc(): void = discard
  variable.focused = proc(): void = discard
  variable.surface = createRGBSurface(
    0, 0, 0, 32, 0xFF000000'u32, 0x00FF0000,
    0x0000FF00, 0x000000FF
  )
  variable.renderer = variable.surface.createSoftwareRenderer()


proc Canvas*(name: string, variable: var CanvasObj): CanvasPtr =
  ## Creates a new Canvas pointer.
  nodepattern(CanvasObj)
  canvaspattern()

proc Canvas*(variable: var CanvasObj): CanvasPtr {.inline.} =
  Canvas("Canvas", variable)


method calcPositionAnchor*(self: CanvasPtr) =
  if self.parent != nil and not isEmpty(self.anchor):
    self.position.x = self.parent.rect_size.x * self.anchor.x1
    self.position.y = self.parent.rect_size.y * self.anchor.y1

    self.position.x -= self.rect_size.x * self.anchor.x2
    self.position.y -= self.rect_size.y * self.anchor.y2

method draw*(self: CanvasPtr, surface: SurfacePtr): void =
  ## Draws node on the surface
  {.warning[LockLevel]: off.}
  if self.visible and self.surface != nil:
    self.calcGlobalPosition()
    var self_rect = rect(
      self.global_position.x.cint, self.global_position.y.cint,
      self.surface.w, self.surface.h
    )
    discard self.surface.blitSurface(nil, surface, self_rect.addr)
    if self.pressed:
      var x, y: cint
      discard getMouseState(x, y)
      self.press(x.float, y.float)

method getGlobalMousePosition*(self: CanvasPtr): Vector2Ref {.base.} =
  var x, y: cint
  discard getMouseState(x, y)
  Vector2Ref(x: x.float, y: y.float)

method isVisible*(self: CanvasPtr): bool {.base.} =
  ## Returns true, if node is visible.
  self.visible

method handle*(self: CanvasPtr, event: Event, mouse_on: var NodePtr) =
  {.warning[LockLevel]: off.}
  if self.visible and self.mousemode == MOUSEMODE_SEE:
    if event.kind == MouseMotion and mouse_on == nil:  # Mouse in/out
      let
        e = motion(event)
        vec2 = Vector2(e.x.float, e.y.float)
        hasmouse = Rect2(self.global_position, self.rect_size).hasPoint(vec2)
      if hasmouse:
        mouse_on = self[].addr
        if not self.hovered:
          self.hovered = true
          self.mouse_enter(vec2.x, vec2.y)
      elif self.hovered:
        self.hovered = false
        self.mouse_exit()
    elif event.kind == MouseButtonDown:  # Mouse click, press, focus/unfocus
      let
        e = button(event)
        vec2 = Vector2(e.x.float, e.y.float)
        hasmouse = Rect2(self.global_position, self.rect_size).hasPoint(vec2)
      if hasmouse and mouse_on == nil:
        mouse_on = self[].addr
        if not self.focus:
          self.focused()
          self.focus = true
        if not self.pressed:
          self.click(vec2.x, vec2.y)
          self.pressed = true
      elif self.focus:
        self.focus = false
        self.unfocused()
    elif event.kind == MouseButtonUp: # Mouse release
      let
        e = button(event)
      if self.pressed:
        self.pressed = false
        self.release()

method hide*(self: CanvasPtr) {.base.} =
  ## Hides node.
  self.visible = false

method resize*(self: CanvasPtr, width, height: float) {.base.} =
  ## Resizes Canvas by `width` and `height`
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

method show*(self: CanvasPtr) {.base.} =
  ## Shows node.
  self.visible = true


# --- GFX --- #
method pixel*(self: CanvasPtr, x, y: int16, color: ColorRef) {.base.} =
  self.renderer.pixelColor(x, y, color.toUint32LE())

# -- Lines -- #
method hline*(self: CanvasPtr, x1, x2, y: int16, color: ColorRef) {.base.} =
  self.renderer.hlineColor(x1, x2, y, color.toUint32LE())
method vline*(self: CanvasPtr, x, y1, y2: int16, color: ColorRef) {.base.} =
  self.renderer.vlineColor(x, y1, y2, color.toUint32LE())
method line*(self: CanvasPtr, x1, x2, y1, y2: float, color: ColorRef) {.base.} =
  self.renderer.lineColor(x1.int16, x2.int16, y1.int16, y2.int16, color.toUint32LE())
method aaline*(self: CanvasPtr, x1, x2, y1, y2: float, color: ColorRef) {.base.} =
  self.renderer.aaLineColor(x1.int16, x2.int16, y1.int16, y2.int16, color.toUint32LE())
method thickLine*(self: CanvasPtr, x1, x2, y1, y2: float, width: uint8, color: ColorRef) {.base.} =
  self.renderer.thickLineColor(x1.int16, x2.int16, y1.int16, y2.int16, width, color.toUint32LE())

# -- Rects -- #
method rect*(self: CanvasPtr, x1, y1, x2, y2: float, color: ColorRef) {.base.} =
  self.renderer.rectangleColor(x1.int16, y1.int16, x2.int16, y2.int16, color.toUint32LE())
method roundedRect*(self: CanvasPtr, x1, y1, x2, y2, radius: float, color: ColorRef) {.base.} =
  self.renderer.roundedRectangleColor(x1.int16, y1.int16, x2.int16, y2.int16, radius.int16, color.toUint32LE())
method box*(self: CanvasPtr, x1, y1, x2, y2: float, color: ColorRef) {.base.} =
  self.renderer.boxColor(x1.int16, y1.int16, x2.int16, y2.int16, color.toUint32LE())
method roundedBox*(self: CanvasPtr, x1, y1, x2, y2, radius: float, color: ColorRef) {.base.} =
  self.renderer.roundedBoxColor(x1.int16, y1.int16, x2.int16, y2.int16, radius.int16, color.toUint32LE())

# -- Circles -- #
method arc*(self: CanvasPtr, x, y, radius, start, finish: float, color: ColorRef) {.base.} =
  self.renderer.arcColor(x.int16, y.int16, radius.int16, start.int16, finish.int16, color.toUint32LE())
method circle*(self: CanvasPtr, x, y, radius: float, color: ColorRef) {.base.} =
  self.renderer.circleColor(x.int16, y.int16, radius.int16, color.toUint32LE())
method aacircle*(self: CanvasPtr, x, y, radius: float, color: ColorRef) {.base.} =
  self.renderer.aacircleColor(x.int16, y.int16, radius.int16, color.toUint32LE())
method filledCircle*(self: CanvasPtr, x, y, radius: float, color: ColorRef) {.base.} =
  self.renderer.filledCircleColor(x.int16, y.int16, radius.int16, color.toUint32LE())
method ellipse*(self: CanvasPtr, x, y, rx, ry: float, color: ColorRef) {.base.} =
  self.renderer.ellipseColor(x.int16, y.int16, rx.int16, ry.int16, color.toUint32LE())
method aaellipse*(self: CanvasPtr, x, y, rx, ry: float, color: ColorRef) {.base.} =
  self.renderer.aaellipseColor(x.int16, y.int16, rx.int16, ry.int16, color.toUint32LE())
method filledElipse*(self: CanvasPtr, x, y, rx, ry: float, color: ColorRef) {.base.} =
  self.renderer.filledEllipseColor(x.int16, y.int16, rx.int16, ry.int16, color.toUint32LE())
method pie*(self: CanvasPtr, x, y, radius, start, finish: float, color: ColorRef) {.base.} =
  self.renderer.pieColor(x.int16, y.int16, radius.int16, start.int16, finish.int16, color.toUint32LE())
method filledPie*(self: CanvasPtr, x, y, radius, start, finish: float, color: ColorRef) {.base.} =
  self.renderer.filledPieColor(x.int16, y.int16, radius.int16, start.int16, finish.int16, color.toUint32LE())

# -- Trigons -- #
method trigon*(self: CanvasPtr, x1,y1,x2,y2,x3,y3: float, color: ColorRef) {.base.} =
  self.renderer.trigonColor(x1.int16, y1.int16, x2.int16, y2.int16, x3.int16, y3.int16, color.toUint32LE())
method aatrigon*(self: CanvasPtr, x1,y1,x2,y2,x3,y3: float, color: ColorRef) {.base.} =
  self.renderer.aaTrigonColor(x1.int16, y1.int16, x2.int16, y2.int16, x3.int16, y3.int16, color.toUint32LE())
method filledTrigon*(self: CanvasPtr, x1,y1,x2,y2,x3,y3: float, color: ColorRef) {.base.} =
  self.renderer.filledTrigonColor(x1.int16, y1.int16, x2.int16, y2.int16, x3.int16, y3.int16, color.toUint32LE())

proc text*(canvas: CanvasPtr, x, y: float, src: string, color: ColorRef, lineSpacing: float = 2.0) =
  ## Draws multiline text at `x`, `y` position.
  ##
  ## Aguments:
  ## - `src` - source text.
  ## - `color` - text color.
  ## - `lineSpacing` - line spacing.
  let (r, g, b, a) = color.toUint32Tuple()
  canvas.renderer.mlStringRGBA(x.int16, y.int16, src, r.uint8, g.uint8, b.uint8, a.uint8, lineSpacing.int16)


# --- Custom --- #
proc lineardistance(x, y, pos1, pos2, pos3, dist: float): float {.inline.} =
  (pos1*x + pos2*y + pos3) * dist

proc fill*(self: CanvasPtr, color: ColorRef) =
  ## Fills canvas.
  ##
  ## Arguments:
  ## - `color` - fill color.
  self.surface.fillRect(nil, color.toUint32BE())

proc radialGradient*(canvas: CanvasPtr, cx, cy, radius, inside_radius: float, color1, color2: ColorRef) =
  ## Draws the radial gradient on the canvas.
  ##
  ## Arguments:
  ## - `cx`, `cy` - center position.
  ## - `radius` - gradient radius.
  ## - `inside_radius` - gradient inside radius.
  ## - `color1` - inside color.
  ## - `color2` - outside color.
  let
    (r1, g1, b1, a1) = color1.toUint32Tuple()
    (r2, g2, b2, a2) = color2.toUint32Tuple()
  var vec = Vector2(cx, cy)
  for y in 0..<canvas.rect_size.x.int:
    for x in 0..<canvas.rect_size.y.int:
      let
        xt = x.float
        yt = y.float
        dist = vec.distance(xt, yt) - inside_radius
        norm = normalize(dist, 0.0, radius)
        color = lerp(r1, g1, b1, a1, r2, g2, b2, a2, norm)
      canvas.renderer.pixelColor(xt.int16, yt.int16, color)

proc horizontalRefectedGradient*(canvas: CanvasPtr, xpos: float, color1, color2: ColorRef) =
  ## Draws the horizontal reflected gradient on the canvas.
  ##
  ## Arguments:
  ## - `xpos` - border.
  ## - `color1` - first color.
  ## - `color2` - second color.
  let
    (r1, g1, b1, a1) = color1.toUint32Tuple()
    (r2, g2, b2, a2) = color2.toUint32Tuple()
  for y in 0..<canvas.rect_size.y.int:
    for x in 0..<canvas.rect_size.x.int:
      let
        xt = x.float
        yt = y.float
        dist = Vector2(xpos, yt).distance(xt, yt)
        norm = normalize(dist, 0.0, canvas.rect_size.x)
        color = lerp(r1, g1, b1, a1, r2, g2, b2, a2, norm)
      canvas.renderer.pixelColor(xt.int16, yt.int16, color)

proc horizontalGradient*(canvas: CanvasPtr, color1, color2: ColorRef) {.inline.} =
  ## Draws the horizontal gradient on the canvas.
  ##
  ## Arguments:
  ## - `color1` - left color.
  ## - `color2` - right color.
  canvas.horizontalRefectedGradient(canvas.rect_size.x, color1, color2)

proc verticalRefectedGradient*(canvas: CanvasPtr, ypos: float, color1, color2: ColorRef) =
  ## Draws the vertical reflected gradient on the canvas.
  ##
  ## Arguments:
  ## - `ypos` - border.
  ## - `color1` - first color.
  ## - `color2` - second color.
  let
    (r1, g1, b1, a1) = color1.toUint32Tuple()
    (r2, g2, b2, a2) = color2.toUint32Tuple()
  for y in 0..<canvas.rect_size.y.int:
    for x in 0..<canvas.rect_size.x.int:
      let
        xt = x.float
        yt = y.float
        dist = Vector2(xt, ypos).distance(xt, yt)
        norm = normalize(dist, 0.0, canvas.rect_size.y)
        color = lerp(r1, g1, b1, a1, r2, g2, b2, a2, norm)
      canvas.renderer.pixelColor(xt.int16, yt.int16, color)

proc verticalGradient*(canvas: CanvasPtr, color1, color2: ColorRef) {.inline.} =
  ## Draws the vertical gradient on the canvas.
  ##
  ## Arguments:
  ## - `color1` - top color.
  ## - `color2` - bottom color.
  canvas.verticalRefectedGradient(canvas.rect_size.y, color1, color2)

proc linearGradient*(canvas: CanvasPtr, x1, y1, x2, y2: float, color1, color2: ColorRef) =
  ## Draws the linear gradient on the canvas.
  ##
  ## Arguments:
  ## - `x1`, `y1` is first position.
  ## - `x1`, `y1` is second position.
  let
    (r1, g1, b1, a1) = color1.toUint32Tuple()
    (r2, g2, b2, a2) = color2.toUint32Tuple()
    pos1 = y2 - y1
    pos2 = x2 - x1
    pos3 = x2*y1 - y2*x1
    dist = 1.0 / math.sqrt(pos1*pos1 + pos2*pos2)
    ul = lineardistance(0, 0, pos1, pos2, pos3, dist)
    ur = lineardistance((canvas.rect_size.x), 0, pos1, pos2, pos3, dist)
  for y in 0..<canvas.rect_size.y.int:
    for x in 0..<canvas.rect_size.x.int:
      let
        d = lineardistance(x.float, y.float, pos1, pos2, pos3, dist)
        ratio = 0.3 + 0.5 * d / canvas.rect_size.x
        norm =
          if ul > ur:
            normalize(1.0 - ratio, 0.0, 1.0)
          else:
            normalize(ratio, 0.0, 1.0)
        newcolor = lerp(r1, g1, b1, a1, r2, g2, b2, a2, norm)
      canvas.renderer.pixelColor(x.int16, y.int16, newcolor)
