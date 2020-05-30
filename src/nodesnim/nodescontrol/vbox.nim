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
  control,
  box


type
  VBoxObj* = object of BoxObj
    separator*: float
  VBoxPtr* = ptr VBoxObj

var boxes: seq[VBoxObj]

proc VBox*(name: string = "VBox"): VBoxPtr =
  ## Creates a new VBox pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var box = VBox("VBox")
  var variable: VBoxObj
  nodepattern(VBoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.separator = 4f
  variable.kind = VBOX_NODE
  boxes.add(variable)
  return addr boxes[^1]


method getChildSize*(self: VBoxPtr): Vector2Ref =
  ## Returns size of all children.
  var
    x = 0f
    y = 0f
  for child in self.children:
    if child.rect_size.x > x:
      x = child.rect_size.x
    y += child.rect_size.y + self.separator
  if y > 0f:
    y -= self.separator
  Vector2(x, y)

method addChild*(self: VBoxPtr, child: NodePtr) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.rect_size = self.getChildSize()


method draw*(self: VBoxPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y1 = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y1, x+self.rect_size.x, y1-self.rect_size.y)

  var
    fakesize = self.getChildSize()
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    child.position.x = self.rect_size.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
    child.position.y = y
    y += child.rect_size.y + self.separator
  procCall self.ControlPtr.draw(w, h)

method duplicate*(self: VBoxPtr): VBoxPtr {.base.} =
  ## Duplicate VBox object and create a new VBox pointer.
  var obj = self[]
  boxes.add(obj)
  return addr boxes[^1]

method resize*(self: VBoxPtr, w, h: GLfloat) =
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
