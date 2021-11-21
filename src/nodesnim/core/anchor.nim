# author: Ethosa
import vector2
{.used.}


type
  AnchorObj* = object
    x1*, y1*, x2*, y2*: float


let
  START_ANCHOR*     = AnchorObj(x1: 0, y1: 0, x2: 0, y2: 0)
  CENTER_ANCHOR*    = AnchorObj(x1: 0.5, y1: 0.5, x2: 0.5, y2: 0.5)
  END_ANCHOR*       = AnchorObj(x1: 1, y1: 1, x2: 1, y2: 1)
  START_END_ANCHOR* = AnchorObj(x1: 0, y1: 1, x2: 0, y2: 1)
  END_START_ANCHOR* = AnchorObj(x1: 1, y1: 0, x2: 1, y2: 0)


proc Anchor*(x1, y1, x2, y2: float): AnchorObj {.inline.} =
  ## Creates a new anchor object.
  ##
  ## Arguments:
  ## - x1, y1 -- usually anchor to the parent node.
  ## - x2, y2 -- usually anchor to the current node.
  ##
  ## See also:
  ## - `Anchor proc <#Anchor,Vector2Obj,Vector2Obj>`_
  ## - `Anchor proc <#Anchor>`_
  AnchorObj(x1: x1, y1: y1, x2: x2, y2: y2)

proc Anchor*(vec1, vec2: Vector2Obj): AnchorObj {.inline.} =
  ## Creates a new anchor object.
  ##
  ## Arguments:
  ## - vec1 -- usually anchor to the parent node.
  ## - vec2 -- usually anchor to the current node.
  ##
  ## See also:
  ## - `Anchor proc <#Anchor,float,float,float,float>`_
  ## - `Anchor proc <#Anchor>`_
  AnchorObj(x1: vec1.x, y1: vec1.y, x2: vec2.x, y2: vec2.y)

proc Anchor*(): AnchorObj {.inline.} =
  ## Creates empty Anchor object.
  AnchorObj(x1: 0, y1: 0, x2: 0, y2: 0)

proc clear*(a: var AnchorObj) =
  ## Cleares current anchor object.
  a.x1 = 0
  a.x2 = 0
  a.y1 = 0
  a.y2 = 0

proc isEmpty*(a: AnchorObj): bool {.inline.} =
  ## Returns true, if `a` is Anchor(0, 0, 0, 0)
  a.x1 == 0 and a.x2 == 0 and a.y1 == 0 and a.y2 == 0


proc `$`*(x: AnchorObj): string {.inline.} =
  "Anchor(x1: " & $x.x1 & ", y1: " & $x.y1 & ", x2: " & $x.x2 & ", y2: " & $x.y2 & ")"

proc `==`*(x, y: AnchorObj): bool {.inline.} =
  x.x1 == y.x1 and x.y1 == y.y1 and x.x2 == y.x2 and x.y2 == y.y2
