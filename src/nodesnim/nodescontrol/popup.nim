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
  PopupObj* = object of ControlRef
  PopupRef* = ref PopupObj


proc Popup*(name: string = "Popup"): PopupRef =
  ## Creates a new Popup.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var p = Popup("Popup")
  nodepattern(PopupRef)
  controlpattern()
  result.background_color = Color(0x212121ff)
  result.rect_size.x = 160
  result.rect_size.y = 160
  result.visible = false
  result.kind = POPUP_NODE


template recalc =
  for child in self.getChildIter():
    if child.visible and not self.visible:
      child.visible = false
    elif not child.visible and self.visible:
      child.visible = true


method hide*(self: PopupRef) =
  ## Hides popup.
  {.warning[LockLevel]: off.}
  self.visible = false
  recalc()

method show*(self: PopupRef) =
  ## Shws popup.
  {.warning[LockLevel]: off.}
  self.visible = true
  recalc()

method calcPositionAnchor*(self: PopupRef) =
  ## This uses in the `scene.nim`.
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.calcPositionAnchor()
  recalc()

method draw*(self: PopupRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: PopupRef): PopupRef {.base.} =
  ## Duplicates Popup object and create a new Popup.
  self.deepCopy()
