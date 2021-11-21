# author: Ethosa
import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../private/templates,

  ../nodes/node,
  ../nodes/canvas,
  node2d


type
  Camera2DObj* = object of Node2DObj
    smooth*: bool
    smooth_speed*: float
    target*: NodeRef
    limit*: AnchorObj  ## left, top, right, bottom
  Camera2DRef* = ref Camera2DObj


var current_camera: Camera2DRef = nil


proc Camera2D*(name: string = "Camera2D"): Camera2DRef =
  ## Creates a new Camera2D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = Camera2D("Camera2D")
  nodepattern(Camera2DRef)
  node2dpattern()
  result.limit = Anchor(-100000, -100000, 100000, 100000)
  result.smooth = false
  result.smooth_speed = 0.1
  result.kind = CAMERA_2D_NODE


method changeTarget*(self: Camera2DRef, target: NodeRef) {.base.} =
  ## Changes camera target (without camera position.)
  self.target = target


method changeSmoothSpeed*(self: Camera2DRef, speed: float) {.base.} =
  ## Changes camera smooth speed.
  ##
  ## Arguments:
  ## - `speed` is a smooth speed. The closer to 0, the smoother the camera. The default is 0.1.
  self.smooth_speed = speed


method disableSmooth*(self: Camera2DRef) {.base.} =
  ## Disables smooth mode.
  ##
  ## See also:
  ## - `enableSmooth method <#enableSmooth.e,Camera2DRef,float>`_
  self.smooth = false


method draw*(self: Camera2DRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  procCall self.Node2DRef.draw(w, h)

  if self.target != nil and self == current_camera:
    var root = self.getRootNode().CanvasRef
    let
      x = self.target.CanvasRef.position.x
      y = self.target.CanvasRef.position.y

    if self.smooth:
      if x-w/2 > self.limit.x1 and x+w/2 < self.limit.x2:
        let dx = (root.position.x - w/2) + x
        root.position.x -= dx*self.smooth_speed
      if y-h/2 > self.limit.y1 and y+h/2 < self.limit.y2:
        let dy = (root.position.y - h/2) + y
        root.position.y -= dy*self.smooth_speed
    else:
      root.position.x = if x-w/2 < self.limit.x1: root.position.x elif x+w/2 > self.limit.x2: root.position.x else: -(x - w/2)
      root.position.y = if y+h/2 < self.limit.y1: root.position.y elif y+h/2 > self.limit.y2: root.position.y else: -(y - h/2)


method duplicate*(self: Camera2DRef): Camera2DRef {.base.} =
  ## Duplicates Camera2D and create a new Camera2D object.
  self.deepCopy()


method enableSmooth*(self: Camera2DRef, speed: float = 0.1) {.base.} =
  ## Enables camera smooth mode.
  ##
  ## Arguments:
  ## - `speed` is a smooth speed. The closer to 0, the smoother the camera. The default is 0.1.
  ##
  ## See also:
  ## - `disableSmooth method <#disableSmooth.e,Camera2DRef>`_
  self.smooth = true
  self.smooth_speed = speed


method isCurrent*(self: Camera2DRef): bool {.base.} =
  self == current_camera


method setCurrent*(self: Camera2DRef) {.base.} =
  ## Changes the current camera. It also automatically disable other cameras.
  current_camera = self


method setLimit*(self: Camera2DRef, x1, y1, x2, y2: float) {.base.} =
  ## Change camera limit.
  self.limit = Anchor(x1, y1, x2, y2)


method setLimit*(self: Camera2DRef, limit: AnchorObj) {.base.} =
  ## Changes camera limit.
  self.limit = limit


method setTarget*(self: Camera2DRef, target: NodeRef) {.base.} =
  ## Changes camera target node.
  self.target = target
  var root = self.getRootNode().CanvasRef
  self.CanvasRef.position = target.CanvasRef.global_position
  self.CanvasRef.position -= root.rect_size / 2
