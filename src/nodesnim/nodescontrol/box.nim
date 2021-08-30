# author: Ethosa
## Moves all child nodes at the center of the box.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  ../nodes/canvas,
  control


type
  BoxObj* = object of ControlRef
    child_anchor*: AnchorRef
  BoxRef* = ref BoxObj


proc Box*(name: string = "Box"): BoxRef =
  ## Creates a new Box.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var box1 = Box("My box")
  nodepattern(BoxRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  result.kind = BOX_NODE


method getChildSize*(self: BoxRef): Vector2Ref {.base.} =
  ## Returns Vector2 of the minimal size of the box pointer.
  var
    x = 0f
    y = 0f
  for child in self.children:
    x += child.CanvasRef.rect_size.x
    y += child.CanvasRef.rect_size.y
  Vector2(x, y)

method addChild*(self: BoxRef, child: NodeRef) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  if child.CanvasRef.rect_size.x > self.rect_size.x:
    self.rect_size.x = child.CanvasRef.rect_size.x
  if child.CanvasRef.rect_size.y > self.rect_size.y:
    self.rect_size.y = child.CanvasRef.rect_size.y


method draw*(self: BoxRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)

  for child in self.children:
    child.CanvasRef.position.x = self.rect_size.x*self.child_anchor.x1 - child.CanvasRef.rect_size.x*self.child_anchor.x2
    child.CanvasRef.position.y = self.rect_size.y*self.child_anchor.y1 - child.CanvasRef.rect_size.y*self.child_anchor.y2
  procCall self.ControlRef.draw(w, h)

method duplicate*(self: BoxRef): BoxRef {.base.} =
  ## Duplicates Box.
  self.deepCopy()

method resize*(self: BoxRef, w, h: GLfloat) =
  ## Resizes Box node.
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

method setChildAnchor*(self: BoxRef, anchor: AnchorRef) {.base.} =
  ## Changes child anchor.
  ##
  ## Arguments:
  ## - `anchor` - Anchor object.
  self.child_anchor = anchor

method setChildAnchor*(self: BoxRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes child anchor.
  ##
  ## Arguments:
  ## - `x1` and `y1` is an anchor relative to Box size.
  ## - `x2` and `y2` is an anchor relative to child size.
  self.child_anchor = Anchor(x1, y1, x2, y2)
