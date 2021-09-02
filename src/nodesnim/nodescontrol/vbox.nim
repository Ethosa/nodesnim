# author: Ethosa
## Contains children in the vertical box.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  ../nodes/canvas,
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
  result.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  result.separator = 4f
  result.kind = VBOX_NODE


method getChildSize*(self: VBoxRef): Vector2Ref =
  ## Returns size of all children.
  var
    x = 0f
    y = 0f
  for child in self.children:
    if child.CanvasRef.rect_size.x > x:
      x = child.CanvasRef.rect_size.x
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


method draw*(self: VBoxRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  var
    fakesize = self.getChildSize()
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    child.CanvasRef.position.x = self.rect_size.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2
    child.CanvasRef.position.y = y
    y += child.CanvasRef.rect_size.y + self.separator
  procCall self.ControlRef.draw(w, h)

method duplicate*(self: VBoxRef): VBoxRef {.base.} =
  ## Duplicate VBox object and create a new VBox.
  self.deepCopy()

method resize*(self: VBoxRef, w, h: GLfloat) =
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
  self.can_use_anchor = false
  self.can_use_size_anchor = false
