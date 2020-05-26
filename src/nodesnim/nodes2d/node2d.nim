# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  ../nodes/canvas


type
  Node2DObj* = object of CanvasObj
    centered*: bool
    timed_position*: Vector2Ref
  Node2DPtr* = ptr Node2DObj


template node2dpattern*: untyped =
  variable.centered = true
  variable.timed_position = Vector2()

proc Node2D*(name: string, variable: var Node2DObj): Node2DPtr =
  ## Creates a new Node2D pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a Node2DObj variable.
  runnableExamples:
    var
      node_obj: Node2DObj
      node = Node2D("Node2D", node_obj)
  nodepattern(Node2DObj)
  node2dpattern()

proc Node2D*(obj: var Node2DObj): Node2DPtr {.inline.} =
  ## Creates a new Node2D pointer with deffault node name "Node2D".
  ##
  ## Arguments:
  ## - `variable` is a Node2DObj variable.
  runnableExamples:
    var
      node_obj: Node2DObj
      node = Node2D(node_obj)
  Node2D("Node2D", obj)

method draw*(self: Node2DPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()

  self.position = self.timed_position

  if self.centered:
    self.position = self.timed_position - self.rect_size*2
  else:
    self.position = self.timed_position

method move*(self: Node2DPtr, x, y: GLfloat) =
  ## Moves Node2D object by `x` and `y`.
  self.position.x += x
  self.position.y += y
  self.timed_position = self.position

method move*(self: Node2DPtr, vec2: Vector2Ref) =
  ## Moves Node2D object by `vec2`.
  self.position += vec2
  self.timed_position = self.position

method duplicate*(self: Node2DPtr, obj: var Node2DObj): Node2DPtr {.base.} =
  ## Duplicates Node2D object and create a new Node2D pointer.
  obj = self[]
  obj.addr

method getGlobalMousePosition*(self: Node2DPtr): Vector2Ref {.base, inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)
