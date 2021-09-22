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
    type_of_node*: NodeTypes
    visible*: Visibility
    is_ready*: bool
    pausemode*: PauseMode            ## Pause mode, by default is INHERIT.
    name*: string                    ## Node name.
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
    name: name, children: @[],
    on_ready: proc(self: NodeRef) = discard,
    on_process: proc(self: NodeRef) = discard,
    on_input: proc(self: NodeRef, event: InputEvent) = discard,
    on_enter: proc(self: NodeRef) = discard,
    on_exit: proc(self: NodeRef) = discard,
    is_ready: false, pausemode: INHERIT, visible: VISIBLE
  )
  result.type_of_node = NODE_TYPE_DEFAULT

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

method draw*(self: NodeRef, w, h: GLfloat) {.base.} =
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
  self.visible = INVISIBLE

method postdraw*(self: NodeRef, w, h: GLfloat) {.base.} =
  ## Draws node.
  ## This used in the Window object.
  discard

method rename*(self: NodeRef, new_name: string) {.base.} =
  self.name = new_name

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

method show*(self: NodeRef) {.base.} =
  self.visible = VISIBLE

method delete*(self: NodeRef) {.base.} =
  ## Deletes current node.
  if self.parent != nil:
    self.parent.removeChild(self)


# --- Macros --- #
import
  macros

macro expectParams(params_src: NimNode, params: static[seq[string]]): untyped =
  ## Gets values from the NimNode params_src which comes after the `@` when using the `@` macro.
  ## Also checks that the number of parameters lines up
  ## Arguments:
  ## - `params_src` The node that contains the parameters
  ## - `params` List of param variables to get from params_src
  result = newStmtList()
  result.add quote do:
    # This is done so params is only injected once
    let params = `params`
    let src_length = `params_src`.len - 1 # - 1 for name
    if src_length != params.len:
      # Tell the user that there was an unexpected number of params
      let error_msg = block:
        "Expected " & $params.len & " parameters (" & params.join(", ") & ")  but got " & $src_length
      error_msg.error(`params_src`)
  # Convert all the passed parameters into variables with corresponding
  # value from the parameters source
  for i, param in params:
    let varName = ident param
    result.add quote do:
      var `varName` = `params_src`[`i` + 1] # + 1 since name is at the 0 index

when not declared(nimIdentNormalize):
  proc nimIdentNormalize(s: string): string =
    ## Backported from https://github.com/nim-lang/Nim/blob/version-1-4/lib/pure/strutils.nim#L284
    result = newString(s.len)
    if s.len > 0:
      result[0] = s[0]
    var j = 1
    for i in 1..len(s) - 1:
      if s[i] in {'A'..'Z'}:
        result[j] = chr(ord(s[i]) + (ord('a') - ord('A')))
        inc j
      elif s[i] != '_':
        result[j] = s[i]
        inc j
    if j != s.len: setLen(result, j)

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
  ##    smth_node@on_ready(self):
  ##      echo "node is ready!"
  ##
  ##    smth_node@on_input(self, event):
  ##      if event.isInputEventMouseButton():
  ##        echo event
  var ename: string
  # Gets event name.
  # TODO, event_name[0] is used in all the case block so add a better error message for when it isn't called this way
  if event_name.kind == nnkIdent:
    ename = $event_name
  elif event_name.kind == nnkCall:
    ename = $event_name[0]
  # Do style insensitive comparision
  case nimIdentNormalize(ename)
  of "onprocess", "onready", "onenter", "onexit":
    var name = event_name[0]
    event_name.expectParams(@["self"])
    result = quote do:
      `node`.`name` =
        proc(`self`: NodeRef): void =
          `code`

  of "onfocus", "onunfocus":
    var name = event_name[0]
    event_name.expectParams(@["self"])
    result = quote do:
      `node`.`name` =
        proc(`self`: ControlRef): void =
          `code`

  of "ontouch":
    var name = event_name[0]
    event_name.expectParams(@["self", "x", "y"])

    result = quote do:
      `node`.`name` =
        proc(`self`: ButtonRef, `x`, `y`: float) =
          `code`

  of "onmouseexit", "onmouseenter", "onclick", "onrelease", "onpress":
    var name = event_name[0]
    event_name.expectParams(@["self", "x", "y"])
    result = quote do:
      `node`.`name` =
        proc(`self`: ControlRef, `x`, `y`: float) =
          `code`

  of "oninput":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: NodeRef, `arg`: InputEvent) =
          `code`

  of "onswitch":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: SwitchRef, `arg`: bool) =
          `code`

  of "ontoggle":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: CheckBoxRef, `arg`: bool) =
          `code`

  of "onchanged":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: SliderRef, `arg`: uint) =
          `code`

  of "onedit":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: EditTextRef, `arg`: string) =
          `code`
  else:
    error("Invalid event: " & ename, node)
