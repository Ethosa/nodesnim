# author: Ethosa
import
  strutils,

  ../thirdparty/opengl,

  ../core/vector2,
  ../core/enums,
  ../core/anchor,
  ../core/input
{.used.}


type
  NodeObj* = object of RootObj
    visible*: bool
    is_ready*: bool
    pausemode*: PauseMode            ## Pause mode, by default is INHERIT.
    name*: string                    ## Node name.
    position*: Vector2Ref            ## Node position, by default is Vector2(0, 0).
    global_position*: Vector2Ref     ## Node global position.
    rect_size*: Vector2Ref           ## Node size.
    anchor*: AnchorRef               ## Node anchor.
    parent*: NodePtr                 ## Node parent.
    children*: seq[NodePtr]          ## Node children.
    enter*: proc()                   ## This called when scene changed.
    exit*: proc()                    ## This called when exit from the scene.
    input*: proc(event: InputEvent)  ## This called on user input.
    ready*: proc()                   ## This called when the scene changed and the `enter` was called.
    process*: proc()                 ## This called every frame.
  NodePtr* = ptr NodeObj


template nodepattern*(nodetype: untyped): untyped =
  variable = `nodetype`(
    name: name, position: Vector2(0.0, 0.0), children: @[],
    global_position: Vector2(0.0, 0.0),
    rect_size: Vector2(0, 0),
    ready: proc() = discard,
    process: proc() = discard,
    input: proc(event: InputEvent) = discard,
    enter: proc() = discard,
    exit: proc() = discard,
    is_ready: false, pausemode: INHERIT, visible: true,
    anchor: Anchor(0, 0, 0, 0)
  )
  result = variable.addr

proc Node*(name: string, variable: var NodeObj): NodePtr =
  ## Creates a new Node pointer.
  nodepattern(NodeObj)

proc Node*(variable: var NodeObj): NodePtr {.inline.} =
  Node("Node", variable)


method addChild*(self: NodePtr, child: NodePtr) {.base.} =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self

method calcGlobalPosition*(self: NodePtr) {.base.} =
  ## Returns global node position.
  self.global_position = self.position
  var current: NodePtr = self
  while current.parent != nil:
    current = current.parent
    self.global_position += current.position

method calcPositionAnchor*(self: NodePtr) {.base.} =
  ## Calculates node position with anchor.
  ## This used in the Window object.
  discard

method draw*(self: NodePtr, w, h: GLfloat) {.base.} =
  ## Draws node.
  ## This used in the Window object.
  discard

method getChild*(self: NodePtr, index: int): NodePtr {.base.} =
  ## Returns child at `index` position, if available.
  ##
  ## Arguments:
  ## - `index`: child index.
  self.children[index]

method getChildCount*(self: NodePtr): int {.base, inline.} =
  ## Returns child count.
  self.children.len()

method getChildIndex*(self: NodePtr, name: string): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  var i = 0
  for node in self.children:
    if node.name == name:
      return i
    inc i
  return -1

method getChildIndex*(self: NodePtr, child: NodePtr): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  var i = 0
  for node in self.children:
    if child == node:
      return i
    inc i
  return -1

method getChildIter*(self: NodePtr): seq[NodePtr] {.base.} =
  ## Returns all children iter.
  result = @[]
  for child in self.children:
    if child notin result:
      result.add(child)
    if child.children.len() > 0:
      for node in child.getChildIter():
        if node notin result:
          result.add(node)

method getNode*(self: NodePtr, path: string): NodePtr {.base.} =
  ## Returns child by `path`
  var
    p = path.split("/")
    current: NodePtr = self

  for name in p:
    if current == nil:
      break

    case name
    of "..":
      current = current.parent
    of "":
      continue
    else:
      for child in current.children:
        if child.name == name:
          current = child
          break
  return current

method getPath*(self: NodePtr): string {.base.} =
  ## Returns node path.
  var current = self
  result = current.name
  while current.parent != nil:
    current = current.parent
    result = current.name & "/" & result

method getParent*(self: NodePtr): NodePtr {.base.} =
  ## Returns node parent.
  self.parent

method getPauseMode*(self: NodePtr): PauseMode {.base.} =
  ## Calculates pause mode
  result = self.pausemode
  var current = self
  while result == INHERIT and current.parent != nil:
    current = current.parent
    result = current.pausemode

method isParentOf*(self, other: NodePtr): bool {.base, inline.} =
  other in self.children

method handle*(self: NodePtr, event: InputEvent, mouse_on: var NodePtr) {.base.} =
  ## Handles user input.
  ## This used in the Window object.
  discard

method hasNode*(self: NodePtr, name: string): bool {.base.} =
  ## Returns true, if a node with name `name` in children.
  ##
  ## Arguments:
  ## - `name`: node name.
  self.getChildIndex(name) != -1

method hasNode*(self: NodePtr, other: NodePtr): bool {.base.} =
  ## Returns true, if `other` in self children.
  ##
  ## Arguments:
  ## - `other`: other node.
  self.getChildIndex(other) != -1

method hasParent*(self: NodePtr): bool {.base, inline.} =
  self.parent != nil

method move*(self: NodePtr, x, y: float) {.base, inline.} =
  ## Adds `x` and` y` to the node position.
  ##
  ## Arguments:
  ## - `x`: how much to add to the position on the X axis.
  ## - `y`: how much to add to the position on the Y axis.
  self.position += Vector2(x, y)

method move*(self: NodePtr, vec2: Vector2Ref) {.base, inline.} =
  ## Adds `vec2` to the node position.
  ##
  ## Arguments:
  ## - `vec2`: how much to add to the position on the X,Y axes.
  self.position += vec2
  self.anchor.x1 = 0
  self.anchor.x2 = 0
  self.anchor.y1 = 0
  self.anchor.y2 = 0

method removeChild*(self: NodePtr, index: int) {.base.} =
  ## Removes node child at a specific position.
  ##
  ## Arguments:
  ## - `index`: child index.
  self.children[index].parent = nil
  self.children.delete(index)

method removeChild*(self: NodePtr, other: NodePtr) {.base.} =
  ## Removes another node from `self`, if `other` in `self` children.
  ##
  ## Arguments:
  ## - `other`: other node.
  var index: int = self.getChildIndex(other)
  if index != -1:
    self.removeChild(index)

method setAnchor*(self: NodePtr, anchor: AnchorRef) {.base.} =
  self.anchor = anchor

method delete*(self: NodePtr) {.base.} =
  ## Deletes current node.
  if self.parent != nil:
    self.parent.removeChild(self)
