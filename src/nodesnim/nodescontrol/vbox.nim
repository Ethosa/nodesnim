# author: Ethosa
## Contains children in the vertical box.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../private/templates,

  ../nodes/node,
  ../nodes/canvas,
  ../graphics/drawable,
  control,
  box


type
  VBoxObj* = object of BoxObj
    separator*: float
  VBoxRef* = ref VBoxObj


proc VBox*(name: string = "VBox"): VBoxRef =
  ## Creates a new VBox.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var box = VBox("VBox")
  nodepattern(VBoxRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.separator = 4f
  result.kind = VBOX_NODE


method getChildSize*(self: VBoxRef): Vector2Obj =
  ## Returns size of all children.
  var
    x = 0f
    y = 0f
  for child in self.children:
    if child.CanvasRef.rect_size.x > x:
      x = child.CanvasRef.rect_size.x
    if child.type_of_node == NODE_TYPE_CONTROL:
      y += child.ControlRef.margin.y1 + child.ControlRef.margin.y2
      let x_sizem = child.ControlRef.margin.x1 + child.ControlRef.margin.x2 + child.ControlRef.rect_size.x
      if x < x_sizem:
        x = x_sizem
    y += child.CanvasRef.rect_size.y + self.separator
  if y > 0f:
    y -= self.separator
  Vector2(x, y)

method addChild*(self: VBoxRef, child: NodeRef) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.resize(self.rect_size.x, self.rect_size.y, true)


method draw*(self: VBoxRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.draw(w, h)
  var
    fakesize = self.getChildSize()
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    if child.type_of_node == NODE_TYPE_CONTROL:
      y += child.ControlRef.margin.y1
      child.CanvasRef.position.y = y + self.padding.y1
      child.CanvasRef.position.x = self.rect_size.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2 + self.padding.x1 + child.ControlRef.margin.x1
      y += child.ControlRef.margin.y2
    else:
      child.CanvasRef.position.y = y + self.padding.y1
      child.CanvasRef.position.x = self.rect_size.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2 + self.padding.x1
    y += child.CanvasRef.rect_size.y + self.separator

method duplicate*(self: VBoxRef): VBoxRef {.base.} =
  ## Duplicate VBox object and create a new VBox.
  self.deepCopy()

method resize*(self: VBoxRef, w, h: GLfloat, save_anchor: bool = false) =
  ## Resizes VBox, if available.
  ##
  ## Arguments:
  ## - `w` is a new width.
  ## - `h` is a new height.
  var size = self.getChildSize()
  if size.x < w:
    size.x = w
  if size.y < h:
    size.y = h
  self.rect_size.x = size.x
  self.rect_size.y = size.y
  if not save_anchor:
    self.size_anchor.clear()
