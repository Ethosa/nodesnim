# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  node2d


type
  Camera2DObj* = object of Node2DObj
    current*, smooth*: bool
    smooth_speed*: float
    target*: NodePtr
    limit*: AnchorRef
  Camera2DPtr* = ptr Camera2DObj


var nodes: seq[Camera2DPtr] = @[]


proc Camera2D*(name: string, variable: var Camera2DObj): Camera2DPtr =
  ## Creates a new Camera2D pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a Camera2DObj variable.
  runnableExamples:
    var
      node_obj: Camera2DObj
      node = Camera2D("Camera2D", node_obj)
  nodepattern(Camera2DObj)
  node2dpattern()
  variable.limit = Anchor(-100000, -100000, 100000, 100000)
  variable.current = false
  variable.smooth = false
  variable.smooth_speed = 0.1
  variable.kind = CAMERA_2D_NODE
  nodes.add(result)

proc Camera2D*(obj: var Camera2DObj): Camera2DPtr {.inline.} =
  ## Creates a new Camera2D pointer with deffault node name "Camera2D".
  ##
  ## Arguments:
  ## - `variable` is a Camera2DObj variable.
  runnableExamples:
    var
      node_obj: Camera2DObj
      node = Camera2D(node_obj)
  Camera2D("Camera2D", obj)


method changeTarget*(self: Camera2DPtr, target: NodePtr) {.base.} =
  ## Changes camera target (without camera position.)
  self.target = target


method changeSmoothSpeed*(self: Camera2DPtr, speed: float) {.base.} =
  ## Changes camera smooth speed.
  ##
  ## Arguments:
  ## - `speed` is a smooth speed. The closer to 0, the smoother the camera. The default is 0.1.
  self.smooth_speed = speed


method disableSmooth*(self: Camera2DPtr) {.base.} =
  ## Disables smooth mode.
  self.smooth = false


method draw*(self: Camera2DPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.position = self.timed_position

  if self.centered:
    self.position = self.timed_position - self.rect_size*2
  else:
    self.position = self.timed_position

  if self.target != nil and self.current:
    var root = self.getRootNode()
    let
      x = self.target.position.x
      y = self.target.position.y

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


method enableSmooth*(self: Camera2DPtr, speed: float = 0.1) {.base.} =
  ## Enables camera smooth mode.
  ##
  ## Arguments:
  ## - `speed` is a smooth speed. The closer to 0, the smoother the camera. The default is 0.1.
  self.smooth = true
  self.smooth_speed = speed


method setCurrent*(self: Camera2DPtr) {.base.} =
  ## Changes the current camera. It also automatically disable other cameras.
  for c in nodes:
    c.current = false
  self.current = true


method setLimit*(self: Camera2DPtr, x1, y1, x2, y2: float) {.base.} =
  ## Change camera limit.
  self.limit = Anchor(x1, y1, x2, y2)


method setLimit*(self: Camera2DPtr, limit: AnchorRef) {.base.} =
  ## Changes camera limit.
  self.limit = limit


method setTarget*(self: Camera2DPtr, target: NodePtr) {.base.} =
  ## Changes camera target node.
  self.target = target
  var root = self.getRootNode()
  self.position = target.global_position
  self.position -= root.rect_size / 2
