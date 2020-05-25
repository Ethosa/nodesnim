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
    row*: int
  GridBoxPtr* = ptr GridBoxObj


proc GridBox*(name: string, variable: var GridBoxObj): GridBoxPtr =
  ## Creates a new GridBox pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a GridBoxObj variable.
  runnableExamples:
    var
      gridobj: GridBoxObj
      grid = GridBox("GridBox", gridobj)
  nodepattern(GridBoxObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.child_anchor = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.separator = 4f
  variable.row = 2

proc GridBox*(obj: var GridBoxObj): GridBoxPtr {.inline.} =
  ## Creates a new GridBox pointer with defalut node name "GridBox".
  ##
  ## Arguments:
  ## - `variable` is a GridBoxObj variable.
  runnableExamples:
    var
      gridobj: GridBoxObj
      grid = GridBox("GridBox", gridobj)
  GridBox("GridBox", obj)


method getMaxChildSize*(self: GridBoxPtr): Vector2Ref {.base.} =
  result = Vector2()
  for child in self.children:
    if child.rect_size.x > result.x:
      result.x = child.rect_size.x
    if child.rect_size.y > result.y:
      result.y = child.rect_size.y

method getChildSize*(self: GridBoxPtr): Vector2Ref =
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

method addChild*(self: GridBoxPtr, child: NodePtr) =
  ## Adds new child in current node.
  ##
  ## Arguments:
  ## - `child`: other node.
  self.children.add(child)
  child.parent = self
  self.rect_size = self.getChildSize()


method draw*(self: GridBoxPtr, w, h: GLfloat) =
  ## This method uses in the `window.nim`.
  let
    x1 = -w/2 + self.global_position.x
    y1 = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x1, y1, x1+self.rect_size.x, y1-self.rect_size.y)

  var
    row = 0
    fakesize = self.getChildSize()
    maxsize = self.getMaxChildSize()
    x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
    y = self.rect_size.y*self.child_anchor.y1 - fakesize.y*self.child_anchor.y2
  for child in self.children:
    if row < self.row:
      child.position.x = x + maxsize.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
      child.position.y = y + maxsize.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
      x += maxsize.x + self.separator
      inc row
    else:
      if self.row > 1:
        row = 1
      x = self.rect_size.x*self.child_anchor.x1 - fakesize.x*self.child_anchor.x2
      y += maxsize.y + self.separator
      child.position.x = x + maxsize.x*self.child_anchor.x1 - child.rect_size.x*self.child_anchor.x2
      child.position.y = y + maxsize.y*self.child_anchor.y1 - child.rect_size.y*self.child_anchor.y2
      x += maxsize.x + self.separator
  procCall self.ControlPtr.draw(w, h)

method duplicate*(self: GridBoxPtr, obj: var GridBoxObj): GridBoxPtr {.base.} =
  ## Duplicates GridBox object and create a new GridBox pointer.
  obj = self[]
  obj.addr

method resize*(self: GridBoxPtr, w, h: GLfloat) =
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
  self.can_use_anchor = false
  self.can_use_size_anchor = false

method setRow*(self: GridBoxPtr, row: int) {.base.} =
  ## Changes gridBox row count.
  self.row = row
  self.rect_size = self.getChildSize()

method setSeparator*(self: GridBoxPtr, separator: float) {.base.} =
  ## Changes separator between child nodes.
  self.separator = separator
  self.rect_size = self.getChildSize()
