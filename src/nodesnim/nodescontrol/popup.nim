# author: Ethosa
## By default popup visible is false. Popup, unlike other nodes, changes children visible when calling show() and hide().
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  control


type
  PopupObj* = object of ControlPtr
  PopupPtr* = ptr PopupObj

var popups: seq[PopupObj] = @[]

proc Popup*(name: string = "Popup"): PopupPtr =
  ## Creates a new Popup pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var p = Popup("Popup")
  var variable: PopupObj
  nodepattern(PopupObj)
  controlpattern()
  variable.background_color = Color(0x212121ff)
  variable.rect_size.x = 160
  variable.rect_size.y = 160
  variable.visible = false
  variable.kind = POPUP_NODE
  popups.add(variable)
  return addr popups[^1]


template recalc =
  for child in self.getChildIter():
    if child.visible and not self.visible:
      child.visible = false
    elif not child.visible and self.visible:
      child.visible = true


method hide*(self: PopupPtr) =
  ## Hides popup.
  {.warning[LockLevel]: off.}
  self.visible = false
  recalc()

method show*(self: PopupPtr) =
  ## Shws popup.
  {.warning[LockLevel]: off.}
  self.visible = true
  recalc()

method calcPositionAnchor*(self: PopupPtr) =
  ## This uses in the `scene.nim`.
  {.warning[LockLevel]: off.}
  procCall self.ControlPtr.calcPositionAnchor()
  recalc()

method draw*(self: PopupPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method duplicate*(self: PopupPtr): PopupPtr {.base.} =
  ## Duplicates Popup object and create a new Popup pointer.
  var obj = self[]
  popups.add(obj)
  return addr popups[^1]
