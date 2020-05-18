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
  HBoxObj* = object of BoxObj
    separator*: float
  HBoxPtr* = ptr HBoxObj


proc HBox*(name: string, variable: var HBoxObj): HBoxPtr =
  nodepattern(HBoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.separator = 4f

proc HBox*(obj: var HBoxObj): HBoxPtr {.inline.} =
  HBox("HBox", obj)


method getChildSize*(self: HBoxPtr): Vector2Ref =
  var
    x = 0f
    y = 0f
  for child in self.children:
    x += child.rect_size.x + self.separator
    if child.rect_size.y > y:
      y = child.rect_size.y
  if x > 0f:
    x -= self.separator
  Vector2(x, y)

method addChild*(self: HBoxPtr, child: NodePtr) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.rect_size = self.getChildSize()


method draw*(self: HBoxPtr, w, h: GLfloat) =
  var
    fakesize = self.getChildSize()
    x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
  for child in self.children:
    child.position.x = x
    child.position.y = self.rect_size.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
    x += child.rect_size.x + self.separator
  procCall self.ControlPtr.draw(w, h)

method resize*(self: HBoxPtr, w, h: GLfloat) =
  var size = self.getChildSize()
  if size.x < w:
    size.x = w
  if size.y < h:
    size.y = h
  self.rect_size.x = size.x
  self.rect_size.y = size.y
  self.can_use_anchor = false
  self.can_use_size_anchor = false
