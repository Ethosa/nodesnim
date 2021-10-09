# author: Ethosa
## By default popup visible is false. Popup, unlike other nodes, changes children visible when calling show() and hide().
import
  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  PopupObj* = object of ControlObj
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
  result.background.setColor(Color(0x212121ff))
  result.rect_size.x = 160
  result.rect_size.y = 160
  result.visible = GONE
  result.kind = POPUP_NODE


template recalc =
  for child in self.getChildIter():
    if child.visible != GONE and self.visible == GONE:
      child.visible = GONE
    elif child.visible != VISIBLE and self.visible == VISIBLE:
      child.visible = VISIBLE


method hide*(self: PopupRef) =
  ## Hides popup.
  {.warning[LockLevel]: off.}
  self.visible = GONE
  recalc()

method show*(self: PopupRef) =
  ## Shws popup.
  {.warning[LockLevel]: off.}
  self.visible = VISIBLE
  recalc()

method toggle*(self: PopupRef) {.base.} =
  if self.visible == GONE:
    self.show()
  else:
    self.hide()

method calcPositionAnchor*(self: PopupRef) =
  ## This uses in the `scene.nim`.
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.calcPositionAnchor()
  recalc()

method duplicate*(self: PopupRef): PopupRef {.base.} =
  ## Duplicates Popup object and create a new Popup.
  self.deepCopy()
