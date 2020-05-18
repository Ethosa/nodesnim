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
  for child in self.children:
    child.position.x = self.rect_size.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
    child.position.y = self.rect_size.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
  procCall self.ControlPtr.draw(w, h)
