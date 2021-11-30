# author: Ethosa
## Contains children in horizontal box.
import ../thirdparty/sdl2 except Color, glBindTexture
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
  ../graphics/drawable,
  control,
  box


type
  HBoxObj* = object of BoxObj
    separator*: float
  HBoxRef* = ref HBoxObj


proc HBox*(name: string = "HBox"): HBoxRef =
  ## Creates a new HBox.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var grid = HBox("HBox")
  nodepattern(HBoxRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.separator = 4f
  result.kind = HBOX_NODE


method getChildSize*(self: HBoxRef): Vector2Obj =
  var
    x = 0f
    y = 0f
  for child in self.children:
    if child.type_of_node == NODE_TYPE_CONTROL:
      x += child.ControlRef.margin.x1 + child.ControlRef.margin.x2
      let y_sizem = child.ControlRef.margin.y1 + child.ControlRef.margin.y2 + child.ControlRef.rect_size.y
      if y < y_sizem:
        y = y_sizem
    x += child.CanvasRef.rect_size.x + self.separator
    if child.CanvasRef.rect_size.y > y:
      y = child.CanvasRef.rect_size.y
  if x > 0f:
    x -= self.separator
  Vector2(x, y)

method addChild*(self: HBoxRef, child: NodeRef) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.resize(self.rect_size.x, self.rect_size.y, true)


method draw*(self: HBoxRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.draw(w, h)
  var
    fakesize = self.getChildSize()
    x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
  for child in self.children:
    if child.type_of_node == NODE_TYPE_CONTROL:
      x += child.ControlRef.margin.x1
      child.CanvasRef.position.x = x + self.padding.x1
      child.CanvasRef.position.y = self.rect_size.y*self.child_anchor.y1 - child.CanvasRef.rect_size.y*self.child_anchor.y2 + self.padding.y1 + child.ControlRef.margin.y1
      x += child.ControlRef.margin.x2
    else:
      child.CanvasRef.position.x = x + self.padding.x1
      child.CanvasRef.position.y = self.rect_size.y*self.child_anchor.y1 - child.CanvasRef.rect_size.y*self.child_anchor.y2 + self.padding.y1
    x += child.CanvasRef.rect_size.x + self.separator

method duplicate*(self: HBoxRef): HBoxRef {.base.} =
  ## Duplicates HBox object and create a new HBox.
  self.deepCopy()

method resize*(self: HBoxRef, w, h: GLfloat, save_anchor: bool = false) =
  ## Resizes HBox, if `w` and `h` not less than child size.
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
