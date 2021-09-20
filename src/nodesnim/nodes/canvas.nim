# author: Ethosa
## Canvas is the root type of all 2D and Control nodes.
## 
## Canvas used for drawing primitive geometry.
import
  math,
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image,

  ../core/vector2,
  ../core/color,
  ../core/anchor,
  ../core/enums,
  ../core/font,
  ../core/tools,

  node


const TAU = PI + PI


type
  CanvasObj* = object of NodeObj
    surface: SurfacePtr
    renderer: RendererPtr
    canvas_texture: Gluint

    position*: Vector2Obj            ## Node position, by default is Vector2(0, 0).
    global_position*: Vector2Obj     ## Node global position.
    rect_size*: Vector2Obj           ## Node size.
    rect_min_size*: Vector2Obj
    size_anchor*: Vector2Obj         ## Node size anchor.
    anchor*: AnchorObj               ## Node anchor.
  CanvasRef* = ref CanvasObj


proc Canvas*(name: string = "Canvas"): CanvasRef =
  ## Creates a new Canvas.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var canvas1 = Canvas("Canvas")
  nodepattern(CanvasRef)
  result.rect_size = Vector2(40, 40)
  result.rect_min_size = Vector2()
  result.position = Vector2()
  result.global_position = Vector2()
  result.anchor = Anchor(0, 0, 0, 0)
  result.size_anchor = Vector2()
  result.canvas_texture = 0
  result.surface = createRGBSurface(
      0, 40, 40, 32,
      0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000'u32)
  result.renderer = result.surface.createSoftwareRenderer()
  result.kind = CANVAS_NODE
  result.type_of_node = NODE_TYPE_CONTROL


# --- Private --- #
template loadColor(color_argument_name: untyped): untyped =
  let clr = toUint32Tuple(`color_argument_name`)
  canvas.renderer.setDrawColor(clr.r.uint8, clr.g.uint8, clr.b.uint8, clr.a.uint8)

template loadGL(canvas: untyped): untyped =
  `canvas`.renderer.present()
  discard `canvas`.renderer.readPixels(nil, 0, `canvas`.surface.pixels, 0)
  if `canvas`.canvas_texture == 0:
    glGenTextures(1, `canvas`.canvas_texture.addr)
  glBindTexture(GL_TEXTURE_2D, `canvas`.canvas_texture)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA.GLint, `canvas`.surface.w,  `canvas`.surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, `canvas`.surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)


# --- Public --- #
method calcGlobalPosition*(self: CanvasRef) {.base.} =
  ## Returns global node position.
  self.global_position = self.position
  var current: CanvasRef = self
  while current.parent != nil:
    current = current.parent.CanvasRef
    self.global_position += current.position

method calcPositionAnchor*(self: CanvasRef) {.base.} =
  ## Calculates node position with anchor.
  ## This used in the Window object.
  discard

method draw*(canvas: CanvasRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + canvas.global_position.x
    y = h/2 - canvas.global_position.y
  glColor4f(1, 1, 1, 1)
  glBindTexture(GL_TEXTURE_2D, canvas.canvas_texture)
  glEnable(GL_TEXTURE_2D)
  glBegin(GL_QUADS)
  glTexCoord2f(0, 0)
  glVertex2f(x, y)
  glTexCoord2f(1, 0)
  glVertex2f(x + canvas.rect_size.x, y)
  glTexCoord2f(1, 1)
  glVertex2f(x + canvas.rect_size.x, y - canvas.rect_size.y)
  glTexCoord2f(0, 1)
  glVertex2f(x, y - canvas.rect_size.y)
  glEnd()
  glDisable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, 0)

method duplicate*(self: CanvasRef): CanvasRef {.base.} =
  ## Duplicates Canvas object and create a new Canvas.
  self.deepCopy()

method move*(self: CanvasRef, vec2: Vector2Obj) {.base, inline.} =
  ## Adds `vec2` to the node position.
  ##
  ## Arguments:
  ## - `vec2`: how much to add to the position on the X,Y axes.
  self.position += vec2
  self.anchor.clear()

method move*(self: CanvasRef, x, y: float) {.base, inline.} =
  ## Adds `x` and` y` to the node position.
  ##
  ## Arguments:
  ## - `x`: how much to add to the position on the X axis.
  ## - `y`: how much to add to the position on the Y axis.
  self.position += Vector2(x, y)
  self.anchor.clear()

method resize*(self: CanvasRef, w, h: GLfloat, save_anchor: bool = false) {.base.} =
  ## Resizes canvas.
  ##
  ## Arguments:
  ## - `w` is a new width.
  ## - `h` is a new height.
  if w > self.rect_min_size.x:
    self.rect_size.x = w
    if not save_anchor:
      self.size_anchor.x = 0.0
  else:
    self.rect_size.x = self.rect_min_size.x
  if h > self.rect_min_size.y:
    self.rect_size.y = h
    if not save_anchor:
      self.size_anchor.y = 0.0
  else:
    self.rect_size.y = self.rect_min_size.y
  if self.kind == CANVAS_NODE:
    var new_surface = createRGBSurface(
      0, w.cint, h.cint, 32,
      0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000'u32)
    self.surface.blitSurface(nil, new_surface, nil)
    self.renderer.destroy()
    self.surface.freeSurface()
    self.surface = new_surface
    self.renderer = self.surface.createSoftwareRenderer()
    loadGL(self)

method setAnchor*(self: CanvasRef, anchor: AnchorObj) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `anchor` - AnchorObj object.
  self.anchor = anchor

method setAnchor*(self: CanvasRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `x1` and `y1` - anchor relative to the parent node.
  ## - `x2` and `y2` - anchor relative to this node.
  self.anchor = Anchor(x1, y1, x2, y2)


method setSizeAnchor*(self: CanvasRef, anchor: Vector2Obj) {.base.} =
  self.size_anchor = anchor

method setSizeAnchor*(self: CanvasRef, x, y: float) {.base.} =
  self.size_anchor = Vector2(x, y)


# --- Draw functions --- #
proc bezier*(canvas: CanvasRef, x1, y1, x2, y2, x3, y3: GLfloat, color: ColorRef) =
  ## Draws a quadric bezier curve at 3 points.
  loadColor(color)
  for pnt in bezier_iter(0.001, Vector2(x1, y1), Vector2(x2, y2), Vector2(x3, y3)):
    canvas.renderer.drawPoint(pnt.x.cint, pnt.y.cint)
  loadGL(canvas)

proc circle*(canvas: CanvasRef, x, y, radius: GLfloat, color: ColorRef, quality: int = 100) =
  ## Draws a circle in the canvas.
  ##
  ## Arguments:
  ## - `x` - circle center at X axis.
  ## - `y` - circle center at Y axis.
  ## - `radius` - circle radius.
  ## - `color` - Color object.
  ## - `quality` - circle quality.
  loadColor(color)
  for i in 0..quality:
    let angle = TAU*i.float/quality.float
    canvas.renderer.drawPoint((x + radius*cos(angle)).cint, (y + radius*sin(angle)).cint)
  loadGL(canvas)

proc cubic_bezier*(canvas: CanvasRef, x1, y1, x2, y2, x3, y3, x4, y4: GLfloat, color: ColorRef) =
  ## Draws a quadric bezier curve at 3 points.
  loadColor(color)
  for pnt in cubic_bezier_iter(0.001, Vector2(x1, y1), Vector2(x2, y2), Vector2(x3, y3), Vector2(x4, y4)):
    canvas.renderer.drawPoint(pnt.x.cint, pnt.y.cint)
  loadGL(canvas)

proc fill*(canvas: CanvasRef, color: ColorRef) =
  ## Fills canvas.
  loadColor(color)
  canvas.renderer.clear()
  loadGL(canvas)

proc line*(canvas: CanvasRef, x1, y1, x2, y2: GLfloat, color: ColorRef) =
  ## Draws a line in the canvas.
  ##
  ## Arguments:
  ## - `x1` - first position at X axis.
  ## - `y1` - first position at Y axis.
  ## - `x2` - second position at X axis.
  ## - `y2` - second position at Y axis.
  ## - `color` - line color.
  loadColor(color)
  canvas.renderer.drawLine(x1.cint, y1.cint, x2.cint, y2.cint)
  loadGL(canvas)

proc rect*(canvas: CanvasRef, x1, y1, x2, y2: GLfloat, color: ColorRef) =
  ## Draws a line in the canvas.
  ##
  ## Arguments:
  ## - `x1` - first position at X axis.
  ## - `y1` - first position at Y axis.
  ## - `x2` - second position at X axis.
  ## - `y2` - second position at Y axis.
  ## - `color` - rectangle color.
  loadColor(color)
  var rectangle = rect(x1.cint, y1.cint, x2.cint, y2.cint)
  canvas.renderer.drawRect(rectangle)
  loadGL(canvas)

proc point*(canvas: CanvasRef, x, y: GLfloat, color: ColorRef) =
  ## Draws a point in the canvas.
  ##
  ## Arguments:
  ## - `x` - point position at X axis.
  ## - `y` - point position at Y axis.
  ## - `color` - point color.
  loadColor(color)
  canvas.renderer.drawPoint(x.cint, y.cint)
  loadGL(canvas)

proc text*(canvas: CanvasRef, text: StyleText | string, x, y: Glfloat, align: Vector2Obj = Vector2()) =
  ## Draws multiline text.
  ##
  ## Arguments:
  ## - `text` - multiline colored text.
  ## - `align` - horizontal text alignment.
  when text is StyleText:
    var
      surface = text.renderSurface(Anchor(align.x, 0, align.y, 0))
      rectangle = rect(x.cint, y.cint, x.cint+surface.w, y.cint+surface.h)
  else:
    var
      surface = stext(text).renderSurface(Anchor(align.x, 0, align.y, 0))
      rectangle = rect(x.cint, y.cint, x.cint+surface.w, y.cint+surface.h)
  surface.blitSurface(nil, canvas.surface, rectangle.addr)
  loadGL(canvas)

proc saveAs*(self: CanvasRef, filename: cstring) =
  ## Saves canvas as image file.
  discard self.surface.savePNG(filename)
