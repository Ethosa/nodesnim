# author: Ethosa
## Node is the root type of all other nodes.
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
    kind*: NodeKind
    visible*: bool
    is_ready*: bool
    can_use_anchor*: bool
    can_use_size_anchor*: bool
    relative_z_index*: bool           ## Uses in the Node2D
    z_index*, z_index_global*: float  ## Uses in the Node2D
    pausemode*: PauseMode            ## Pause mode, by default is INHERIT.
    name*: string                    ## Node name.
    position*: Vector2Ref            ## Node position, by default is Vector2(0, 0).
    global_position*: Vector2Ref     ## Node global position.
    rect_size*: Vector2Ref           ## Node size.
    size_anchor*: Vector2Ref         ## Node size anchor.
    anchor*: AnchorRef               ## Node anchor.
    parent*: NodeRef                 ## Node parent.
    children*: seq[NodeRef]          ## Node children.
    on_enter*: proc(self: NodeRef)                   ## This called when scene changed.
    on_exit*: proc(self: NodeRef)                    ## This called when exit from the scene.
    on_input*: proc(self: NodeRef, event: InputEvent)  ## This called on user input.
    on_ready*: proc(self: NodeRef)                   ## This called when the scene changed and the `enter` was called.
    on_process*: proc(self: NodeRef)                 ## This called every frame.
  NodeRef* = ref NodeObj


template nodepattern*(nodetype: untyped): untyped =
  ## This used in childs of the NodeObj.
  result = `nodetype`(
    name: name, position: Vector2(), children: @[],
    global_position: Vector2(),
    rect_size: Vector2(),
    on_ready: proc(self: NodeRef) = discard,
    on_process: proc(self: NodeRef) = discard,
    on_input: proc(self: NodeRef, event: InputEvent) = discard,
    on_enter: proc(self: NodeRef) = discard,
    on_exit: proc(self: NodeRef) = discard,
    is_ready: false, pausemode: INHERIT, visible: true,
    anchor: Anchor(0, 0, 0, 0), size_anchor: Vector2(), can_use_anchor: false,
    can_use_size_anchor: false, z_index: 0f, z_index_global: 0f, relative_z_index: true
  )

proc Node*(name: string = "Node"): NodeRef =
  ## Creates a new Node.
  nodepattern(NodeRef)
  result.kind = NODE_NODE


method addChild*(self: NodeRef, child: NodeRef) {.base.} =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self


method addChilds*(self: NodeRef, childs: varargs[NodeRef]) {.base.} =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  for node in childs:
    self.addChild(node)

method calcGlobalPosition*(self: NodeRef) {.base.} =
  ## Returns global node position.
  self.global_position = self.position
  var current: NodeRef = self
  self.z_index_global = self.z_index
  while current.parent != nil:
    current = current.parent
    self.global_position += current.position
    if self.relative_z_index:
      self.z_index_global += current.z_index

method calcPositionAnchor*(self: NodeRef) {.base.} =
  ## Calculates node position with anchor.
  ## This used in the Window object.
  discard

method draw*(self: NodeRef, w, h: GLfloat) {.base.} =
  ## Draws node.
  ## This used in the Window object.
  discard

method draw2stage*(self: NodeRef, w, h: GLfloat) {.base.} =
  ## Draws node.
  ## This used in the Window object.
  discard

method duplicate*(self: NodeRef): NodeRef {.base.} =
  ## Duplicates Node object and create a new Node.
  self.deepCopy()

method getChild*(self: NodeRef, index: int): NodeRef {.base.} =
  ## Returns child at `index` position, if available.
  ##
  ## Arguments:
  ## - `index`: child index.
  self.children[index]

method getChildCount*(self: NodeRef): int {.base, inline.} =
  ## Returns child count.
  self.children.len()

method getChildIndex*(self: NodeRef, name: string): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  var i = 0
  for node in self.children:
    if node.name == name:
      return i
    inc i
  return -1

method getChildIndex*(self: NodeRef, child: NodeRef): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  var i = 0
  for node in self.children:
    if child == node:
      return i
    inc i
  return -1

method getChildIter*(self: NodeRef): seq[NodeRef] {.base.} =
  ## Returns all children iter.
  result = @[]
  for child in self.children:
    if child notin result:
      result.add(child)
    if child.children.len() > 0:
      for node in child.getChildIter():
        if node notin result:
          result.add(node)

method getNode*(self: NodeRef, path: string): NodeRef {.base.} =
  ## Returns child by `path`
  var
    p = path.split("/")
    current: NodeRef = self

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

method getPath*(self: NodeRef): string {.base.} =
  ## Returns node path.
  var current = self
  result = current.name
  while current.parent != nil:
    current = current.parent
    result = current.name & "/" & result

method getParent*(self: NodeRef): NodeRef {.base.} =
  ## Returns node parent.
  self.parent

method getPauseMode*(self: NodeRef): PauseMode {.base.} =
  ## Calculates pause mode
  result = self.pausemode
  var current = self
  while result == INHERIT and current.parent != nil:
    current = current.parent
    result = current.pausemode

method getRootNode*(self: NodeRef): NodeRef {.base.} =
  ## Gets root node.
  result = self
  while result.parent != nil:
    result = result.parent

method isCollide*(self: NodeRef, x, y: float): bool {.base.} =
  false

method isCollide*(self: NodeRef, vec2: Vector2Ref): bool {.base.} =
  false

method isCollide*(self, other: NodeRef): bool {.base.} =
  false

method isParentOf*(self, other: NodeRef): bool {.base, inline.} =
  other in self.children

method handle*(self: NodeRef, event: InputEvent, mouse_on: var NodeRef) {.base.} =
  ## Handles user input.
  ## This used in the Window object.
  discard

method hasNode*(self: NodeRef, name: string): bool {.base.} =
  ## Returns true, if a node with name `name` in children.
  ##
  ## Arguments:
  ## - `name`: node name.
  self.getChildIndex(name) != -1

method hasNode*(self: NodeRef, other: NodeRef): bool {.base.} =
  ## Returns true, if `other` in self children.
  ##
  ## Arguments:
  ## - `other`: other node.
  self.getChildIndex(other) != -1

method hasParent*(self: NodeRef): bool {.base, inline.} =
  ## Returns true, when node has parent.
  self.parent != nil

method hide*(self: NodeRef) {.base.} =
  self.visible = false

method move*(self: NodeRef, x, y: float) {.base, inline.} =
  ## Adds `x` and` y` to the node position.
  ##
  ## Arguments:
  ## - `x`: how much to add to the position on the X axis.
  ## - `y`: how much to add to the position on the Y axis.
  self.position += Vector2(x, y)
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method move*(self: NodeRef, vec2: Vector2Ref) {.base, inline.} =
  ## Adds `vec2` to the node position.
  ##
  ## Arguments:
  ## - `vec2`: how much to add to the position on the X,Y axes.
  self.position += vec2
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method removeChild*(self: NodeRef, index: int) {.base.} =
  ## Removes node child at a specific position.
  ##
  ## Arguments:
  ## - `index`: child index.
  self.children[index].parent = nil
  self.children.delete(index)

method removeChild*(self: NodeRef, other: NodeRef) {.base.} =
  ## Removes another node from `self`, if `other` in `self` children.
  ##
  ## Arguments:
  ## - `other`: other node.
  var index: int = self.getChildIndex(other)
  if index != -1:
    self.removeChild(index)

method setAnchor*(self: NodeRef, anchor: AnchorRef) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `anchor` - AnchorRef object.
  self.anchor = anchor
  self.can_use_anchor = true

method setAnchor*(self: NodeRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes node anchor.
  ##
  ## Arguments:
  ## - `x1` and `y1` - anchor relative to the parent node.
  ## - `x2` and `y2` - anchor relative to this node.
  self.anchor = Anchor(x1, y1, x2, y2)
  self.can_use_anchor = true

method setSizeAnchor*(self: NodeRef, anchor: Vector2Ref) {.base.} =
  self.size_anchor = anchor
  self.can_use_size_anchor = true

method setSizeAnchor*(self: NodeRef, x, y: float) {.base.} =
  self.size_anchor = Vector2(x, y)
  self.can_use_size_anchor = true

method show*(self: NodeRef) {.base.} =
  self.visible = true

method delete*(self: NodeRef) {.base.} =
  ## Deletes current node.
  if self.parent != nil:
    self.parent.removeChild(self)


# --- Macros --- #
import
  macros

macro `@`*(node: NodeRef, event_name, code: untyped): untyped =
  ## It provides a convenient wrapper for the event handler.
  ##
  ## Arguments:
  ## - `node` is an any node pointer.
  ## - `event_name` is an event name, e.g.: process.
  ## - `code` is the proc code.
  ##
  ## ## Examples
  ## .. code-block:: nim
  ##
  ##    var
  ##      smth_node = Node("Simple node")
  ##
  ##    smth_node@ready:
  ##      echo "node is ready!"
  ##
  ##    smth_node@input(event):
  ##      if event.isInputEventMouseButton():
  ##        echo event
  var ename: string
  # Gets event name.
  if event_name.kind == nnkIdent:
    ename = $event_name
  elif event_name.kind == nnkCall:
    ename = $event_name[0]

  case ename
  of "on_process", "on_ready", "on_enter", "on_exit":
    var
      name = event_name[0]
      self = event_name[1]
    result = quote do:
      `node`.`name` =
        proc(`self`: NodeRef): void =
          `code`

  of "on_focus", "on_unfocus":
    var
      name = event_name[0]
      self = event_name[1]
    result = quote do:
      `node`.`name` =
        proc(`self`: ControlRef): void =
          `code`

  of "on_touch":
    var
      name = event_name[0]
      self = event_name[1]
      x = event_name[2]
      y = event_name[3]

    result = quote do:
      `node`.`name` =
        proc(`self`: ButtonRef, `x`, `y`: float) =
          `code`

  of "on_mouse_exit", "on_mouse_enter", "on_click", "on_release", "on_press":
    var
      name = event_name[0]
      self = event_name[1]
      x = event_name[2]
      y = event_name[3]

    result = quote do:
      `node`.`name` =
        proc(`self`: ControlRef, `x`, `y`: float) =
          `code`

  of "on_input":
    var
      name = event_name[0]
      self = event_name[1]
      arg = event_name[2]

    result = quote do:
      `node`.`name` =
        proc(`self`: NodeRef, `arg`: InputEvent) =
          `code`

  of "on_toggle":
    var
      name = event_name[0]
      self = event_name[1]
      arg = event_name[2]

    result = quote do:
      `node`.`name` =
        proc(`self`: SwitchRef, `arg`: bool) =
          `code`

  of "on_changed":
    var
      name = event_name[0]
      self = event_name[1]
      arg = event_name[2]

    result = quote do:
      `node`.`name` =
        proc(`self`: SliderRef, `arg`: uint) =
          `code`
  else:
    discard
