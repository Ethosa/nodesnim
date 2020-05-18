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
  GridBoxObj* = object of BoxObj
    separator*: float
    raw*: int
  GridBoxPtr* = ptr GridBoxObj


proc GridBox*(name: string, variable: var GridBoxObj): GridBoxPtr =
  nodepattern(GridBoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.separator = 4f
  variable.raw = 2

proc GridBox*(obj: var GridBoxObj): GridBoxPtr {.inline.} =
  GridBox("GridBox", obj)


method getMaxChildSize*(self: GridBoxPtr): Vector2Ref {.base.} =
  result = Vector2()
  for child in self.children:
    if child.rect_size.x > result.x:
      result.x = child.rect_size.x
    if child.rect_size.y > result.y:
      result.y = child.rect_size.y

method getChildSize*(self: GridBoxPtr): Vector2Ref =
  var
    raw = 0
    maxsize = self.getMaxChildSize()
    y = maxsize.y
  for child in self.children:
    if raw < self.raw:
      inc raw
    else:
      if self.raw > 1:
        raw = 0
      y += self.separator + maxsize.y
  if y > maxsize.y:
    y -= self.separator
  Vector2(maxsize.x * self.raw.float + self.separator*self.raw.float, y)

method addChild*(self: GridBoxPtr, child: NodePtr) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.rect_size = self.getChildSize()


method draw*(self: GridBoxPtr, w, h: GLfloat) =
  var
    raw = 0
    fakesize = self.getChildSize()
    maxsize = self.getMaxChildSize()
    x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    if raw < self.raw:
      child.position.x = x + maxsize.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
      child.position.y = y + maxsize.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
      x += maxsize.x + self.separator
      inc raw
    else:
      if self.raw > 1:
        raw = 0
      x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
      y += maxsize.y + self.separator
      child.position.x = x + maxsize.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
      child.position.y = y + maxsize.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
  procCall self.ControlPtr.draw(w, h)

method resize*(self: GridBoxPtr, w, h: GLfloat) =
  var size = self.getChildSize()
  if size.x < w:
    size.x = w
  if size.y < h:
    size.y = h
  self.rect_size.x = size.x
  self.rect_size.y = size.y
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method setRaw*(self: GridBoxPtr, raw: int) {.base.} =
  self.raw = raw
  self.rect_size = self.getChildSize()
