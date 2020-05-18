# author: Ethosa
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


proc VBox*(name: string, variable: var VBoxObj): VBoxPtr =
  nodepattern(VBoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.separator = 4f

proc VBox*(obj: var VBoxObj): VBoxPtr {.inline.} =
  VBox("VBox", obj)


method getChildSize*(self: VBoxPtr): Vector2Ref =
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
  var
    fakesize = self.getChildSize()
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    child.position.x = self.rect_size.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
    child.position.y = y
    y += child.rect_size.y + self.separator
  procCall self.ControlPtr.draw(w, h)

method resize*(self: VBoxPtr, w, h: GLfloat) =
  var size = self.getChildSize()
  if size.x < w:
    size.x = w
  if size.y < h:
    size.y = h
  self.rect_size.x = size.x
  self.rect_size.y = size.y
  self.can_use_anchor = false
  self.can_use_size_anchor = false
