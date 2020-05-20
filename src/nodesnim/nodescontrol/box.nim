# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  control


type
  BoxObj* = object of ControlPtr
    child_anchor*: AnchorRef
  BoxPtr* = ptr BoxObj


proc Box*(name: string, variable: var BoxObj): BoxPtr =
  nodepattern(BoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)

proc Box*(obj: var BoxObj): BoxPtr {.inline.} =
  Box("Box", obj)


method getChildSize*(self: BoxPtr): Vector2Ref {.base.} =
  var
    x = 0f
    y = 0f
  for child in self.children:
    x += child.rect_size.x
    y += child.rect_size.y
  Vector2(x, y)

method addChild*(self: BoxPtr, child: NodePtr) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  if child.rect_size.x > self.rect_size.x:
    self.rect_size.x = child.rect_size.x
  if child.rect_size.y > self.rect_size.y:
    self.rect_size.y = child.rect_size.y


method draw*(self: BoxPtr, w, h: GLfloat) =
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x+self.rect_size.x, y-self.rect_size.y)

  for child in self.children:
    child.position.x = self.rect_size.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
    child.position.y = self.rect_size.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
  procCall self.ControlPtr.draw(w, h)

method dublicate*(self: BoxPtr, obj: var BoxObj): BoxPtr {.base.} =
  obj = self[]
  obj.addr

method resize*(self: BoxPtr, w, h: GLfloat) =
  var size = self.getChildSize()
  if size.x < w:
    size.x = w
  if size.y < h:
    size.y = h
  self.rect_size.x = size.x
  self.rect_size.y = size.y
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method setChildAnchor*(self: BoxPtr, anchor: AnchorRef) {.base.} =
  self.child_anchor = anchor

method setChildAnchor*(self: BoxPtr, x1, y1, x2, y2: float) {.base.} =
  self.child_anchor = Anchor(x1, y1, x2, y2)
