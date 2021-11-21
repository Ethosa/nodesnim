# author: Ethosa
## The base of other 2D nodes.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../private/templates,

  ../nodes/node,
  ../nodes/canvas


type
  Node2DObj* = object of CanvasObj
    centered*: bool
    rotation*: float
    scale*: Vector2Obj
    timed_position*: Vector2Obj
    relative_z_index*: bool
    z_index*, z_index_global*: float
  Node2DRef* = ref Node2DObj


proc Node2D*(name: string = "Node2D"): Node2DRef =
  ## Creates a new Node2D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = Node2D("Node2D")
  nodepattern(Node2DRef)
  node2dpattern()
  result.scale = Vector2(1, 1)
  result.rotation = 0f
  result.kind = NODE2D_NODE


method calcGlobalPosition*(self: Node2DRef) =
  ## Returns global node position.
  self.global_position = self.position
  var current: CanvasRef = self
  self.z_index_global = self.z_index
  while current.parent != nil:
    current = current.parent.CanvasRef
    self.global_position += current.position
    if self.relative_z_index and current.type_of_node == NODE_TYPE_2D:
      self.z_index_global += current.Node2DRef.z_index

method draw*(self: Node2DRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.position = self.timed_position
  self.calcGlobalPosition()
  if self.centered:
    self.position -= self.rect_size/2


method move*(self: Node2DRef, x, y: float) =
  ## Moves Node2D object by `x` and `y`.
  self.timed_position.x += x
  self.timed_position.y += y
  self.position = self.timed_position


method move*(self: Node2DRef, vec2: Vector2Obj) =
  ## Moves Node2D object by `vec2`.
  self.timed_position += vec2
  self.position = self.timed_position


method duplicate*(self: Node2DRef): Node2DRef {.base.} =
  ## Duplicates Node2D object and create a new Node2D.
  self.deepCopy()


method getGlobalMousePosition*(self: Node2DRef): Vector2Obj {.base, inline.} =
  ## Returns mouse position.
  Vector2Obj(x: last_event.x, y: last_event.y)


method setZIndex*(self: Node2DRef, z_index: int) {.base.} =
  ## Changes Z index.
  self.z_index = z_index.float
