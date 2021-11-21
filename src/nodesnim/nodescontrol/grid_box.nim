# author: Ethosa
## Contains children in grid.
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
  GridBoxObj* = object of BoxObj
    separator*: float
    row*: int
  GridBoxRef* = ref GridBoxObj


proc GridBox*(name: string = "GridBox"): GridBoxRef =
  ## Creates a new GridBox.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var grid = GridBox("GridBox")
  nodepattern(GridBoxRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  result.separator = 4f
  result.row = 2
  result.kind = GRID_BOX_NODE


method getMaxChildSize*(self: GridBoxRef): Vector2Obj {.base.} =
  result = Vector2()
  for child in self.children:
    if child.CanvasRef.rect_size.x > result.x:
      result.x = child.CanvasRef.rect_size.x
    if child.CanvasRef.rect_size.y > result.y:
      result.y = child.CanvasRef.rect_size.y

method getChildSize*(self: GridBoxRef): Vector2Obj =
  ## Returns size with all childs.
  var
    row = 0
    maxsize = self.getMaxChildSize()
    y = maxsize.y
    w = maxsize.x * self.row.float
  for child in self.children:
    if row < self.row:
      inc row
    else:
      if self.row > 1:
        row = 1
      y += self.separator + maxsize.y
  if y > maxsize.y:
    y -= self.separator
  if self.children.len() > 0:
    w += self.separator * (self.row.float - 1)
  Vector2(w, y)

method addChild*(self: GridBoxRef, child: NodeRef) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.resize(self.rect_size.x, self.rect_size.y, true)


method draw*(self: GridBoxRef, w, h: GLfloat) =
  ## This method uses in the `window.nim`.
  var
    row = 0
    fakesize = self.getChildSize()
    maxsize = self.getMaxChildSize()
    x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    if row < self.row:
      child.CanvasRef.position.x = x + maxsize.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2 + self.padding.x1
      child.CanvasRef.position.y = y + maxsize.y*self.child_anchor.y1 - child.CanvasRef.rect_size.y*self.child_anchor.y2 + self.padding.y1
      x += maxsize.x + self.separator
      inc row
    else:
      if self.row > 1:
        row = 1
      x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
      y += maxsize.y + self.separator
      child.CanvasRef.position.x = x + maxsize.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2 + self.padding.x1
      child.CanvasRef.position.y = y + maxsize.y*self.child_anchor.y1 - child.CanvasRef.rect_size.y*self.child_anchor.y2 + self.padding.y1
      x += maxsize.x + self.separator
  procCall self.ControlRef.draw(w, h)

method duplicate*(self: GridBoxRef): GridBoxRef {.base.} =
  ## Duplicates GridBox object and create a new GridBox.
  self.deepCopy()

method resize*(self: GridBoxRef, w, h: GLfloat, save_anchor: bool = false) =
  ## Resizes GridBox.
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

method setRow*(self: GridBoxRef, row: int) {.base.} =
  ## Changes gridBox row count.
  self.row = row
  self.rect_size = self.getChildSize()

method setSeparator*(self: GridBoxRef, separator: float) {.base.} =
  ## Changes separator between child nodes.
  self.separator = separator
  self.rect_size = self.getChildSize()
