# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/color,

  ../nodes/node,
  control


type
  PopupObj* = object of ControlPtr
  PopupPtr* = ptr PopupObj


proc Popup*(name: string, variable: var PopupObj): PopupPtr =
  nodepattern(PopupObj)
  controlpattern()
  variable.background_color = Color(0x212121ff)
  variable.rect_size.x = 160
  variable.rect_size.y = 160
  variable.visible = false

proc Popup*(obj: var PopupObj): PopupPtr {.inline.} =
  Popup("Popup", obj)


template recalc =
  for child in self.getChildIter():
    if child.visible and not self.visible:
      child.visible = false
    elif not child.visible and self.visible:
      child.visible = true


method hide*(self: PopupPtr) =
  {.warning[LockLevel]: off.}
  self.visible = false
  recalc()

method show*(self: PopupPtr) =
  {.warning[LockLevel]: off.}
  self.visible = true
  recalc()

method calcPositionAnchor*(self: PopupPtr) =
  {.warning[LockLevel]: off.}
  procCall self.ControlPtr.calcPositionAnchor()
  recalc()

method draw*(self: PopupPtr, w, h: GLfloat) =
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method dublicate*(self: PopupPtr, obj: var PopupObj): PopupPtr {.base.} =
  obj = self[]
  obj.addr
