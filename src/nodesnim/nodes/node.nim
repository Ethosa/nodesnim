# author: Ethosa
## Node is the root type of all other nodes.
import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/enums,
  ../core/anchor,
  ../core/input,

  ../private/templates,

  strutils
{.used.}


type
  NodeHandler* = proc(self: NodeRef)
  NodeEvHandler* = proc(self: NodeRef, event: InputEvent)
  NodeObj* = object of RootObj
    kind*: NodeKind
    type_of_node*: NodeTypes        ## default, gui, 2d or 3d.
    visibility*: Visibility         ## visible, invisible or gone.
    is_ready*: bool                 ## true, when scene is ready.
    pausemode*: PauseMode           ## Pause mode, by default is INHERIT.
    name*: string                   ## Node name.
    parent*: NodeRef                ## Node parent.
    children*: seq[NodeRef]         ## Node children.
    on_enter*: NodeHandler          ## This called when scene changed.
    on_exit*: NodeHandler           ## This called when exit from the scene.
    on_input*: NodeEvHandler        ## This called on user input.
    on_ready*: NodeHandler          ## This called when the scene changed and the `enter` was called.
    on_process*: NodeHandler        ## This called every frame.
    on_theme_changed*: NodeHandler  ## This called when current theme changed.
  NodeRef* = ref NodeObj


let
  handler_default* = proc(self: NodeRef) = discard
  event_handler_default* = proc(self: NodeRef, event: InputEvent) = discard

proc Node*(name: string = "Node"): NodeRef =
  ## Creates a new Node.
  nodepattern(NodeRef)
  result.kind = NODE_NODE


method addChild*(self: NodeRef, child: NodeRef) {.base.} =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  ##
  ## See also:
  ## - `addChildren method <#addChildren.e,NodeRef,varargs[NodeRef]>`_
  ## - `getChild method <#getChild.e,NodeRef,int>`_
  self.children.add(child)
  child.parent = self


method addChildren*(self: NodeRef, childs: varargs[NodeRef]) {.base.} =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  ##
  ## See also:
  ## - `addChild method <#addChild.e,NodeRef,NodeRef>`_
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
  ##
  ## See also:
  ## - `addChild method <#addChild.e,NodeRef,NodeRef>`_
  ## - `getChildCount method <#getChildCount.e,NodeRef>`_
  self.children[index]

method getChildCount*(self: NodeRef): int {.base, inline.} =
  ## Returns child count.
  ##
  ## See also:
  ## - `getChild method <#getChild.e,NodeRef,int>`_
  self.children.len()

method getChildIndex*(self: NodeRef, name: string): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  ##
  ## See also:
  ## - `getChildIndex method <#getChildIndex.e,NodeRef,NodeRef>`_
  var i = 0
  for node in self.children:
    if node.name == name:
      return i
    inc i
  -1

method getChildIndex*(self: NodeRef, child: NodeRef): int {.base.} =
  ## Returns `child` index or -1, if another node is not the child.
  ##
  ## See also:
  ## - `getChildIndex method <#getChildIndex.e,NodeRef,string>`_
  var i = 0
  for node in self.children:
    if child == node:
      return i
    inc i
  -1

method getChildIter*(self: NodeRef): seq[NodeRef] {.base.} =
  ## Returns all children iter.
  result = @[]
  for child in self.children:
    if child.visibility != VISIBLE:
      continue
    if child notin result:
      result.add(child)
    for node in child.getChildIter():
      if node notin result:
        result.add(node)

method getNode*(self: NodeRef, path: string): NodeRef {.base.} =
  ## Returns child by `path`
  var
    p = path.split("/")
    current: NodeRef = self

  for name in p:
    if current.isNil():
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
  while result == INHERIT and not current.parent.isNil():
    current = current.parent
    result = current.pausemode

method getRootNode*(self: NodeRef): NodeRef {.base.} =
  ## Gets root node.
  result = self
  while not result.parent.isNil():
    result = result.parent

method isChildOf*(self, other: NodeRef): bool {.base, inline.} =
  ## See also `<#isParentOf.e,NodeRef,NodeRef>`_
  self in other.children

method isEmpty*(self: NodeRef): bool {.base, inline.} =
  self.children.len() == 0

method isParentOf*(self, other: NodeRef): bool {.base, inline.} =
  ## See also `<#isChildOf.e,NodeRef,NodeRef>`_
  other in self.children

method insertChild*(self: NodeRef, index: int, node: NodeRef) {.base.} =
  ## Inserts child in node at `index` position.
  self.children.insert(node, index)

method handle*(self: NodeRef, event: InputEvent, mouse_on: var NodeRef) {.base.} =
  ## Handles user input.
  ## This used in the Window object.
  discard

method hasNode*(self: NodeRef, name: string): bool {.base, inline.} =
  ## Returns true, if a node with name `name` in children.
  ##
  ## Arguments:
  ## - `name`: node name.
  self.getChildIndex(name) != -1

method hasNode*(self: NodeRef, other: NodeRef): bool {.base, inline.} =
  ## Returns true, if `other` in self children.
  ##
  ## Arguments:
  ## - `other`: other node.
  self.getChildIndex(other) != -1

method hasParent*(self: NodeRef): bool {.base, inline.} =
  ## Returns true, when node has parent.
  not self.parent.isNil()

method hide*(self: NodeRef) {.base.} =
  self.visibility = INVISIBLE

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
  ##
  ## See also:
  ## - `addChild method <#addChild.e,NodeRef,NodeRef>`_
  self.children[index].parent = nil
  self.children.delete(index)

method removeChild*(self: NodeRef, other: NodeRef) {.base.} =
  ## Removes another node from `self`, if `other` in `self` children.
  ##
  ## Arguments:
  ## - `other`: other node.
  let index: int = self.getChildIndex(other)
  if index != -1:
    self.removeChild(index)

method removeChildren*(self: NodeRef) {.base.} =
  self.children = @[]

method show*(self: NodeRef) {.base.} =
  self.visibility = VISIBLE

method delete*(self: NodeRef) {.base.} =
  ## Deletes current node.
  if not self.parent.isNil():
    self.parent.removeChild(self)
  self.removeChildren()


method `[]`*(self: NodeRef, index: int): NodeRef {.base, inline.} =
  self.getChild(index)

method `[]`*(self: NodeRef, index: string): NodeRef {.base, inline.} =
  self.getNode(index)

method `~`*(self: NodeRef, path: string): NodeRef {.base, inline.} =
  self.getNode(path)


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
  of "onprocess", "onready", "onenter", "onexit", "onthemechanged":
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

  of "ontextchanged":
    var name = event_name[0]
    event_name.expectParams(@["self", "arg"])
    result = quote do:
      `node`.`name` =
        proc(`self`: LabelRef, `arg`: string) =
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
