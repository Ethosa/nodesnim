# author: Ethosa
import sdl2
import ../default/vector2
import ../defaultnodes/canvas
import ../defaultnodes/node
{.used.}


type
  ControlObj* = object of CanvasObj
  ControlPtr* = ptr ControlObj


proc Control*(name: string, variable: var ControlObj): ControlPtr =
  ## Creates a new Control pointer.
  nodepattern(ControlObj)
  canvaspattern()

proc Control*(variable: var ControlObj): ControlPtr {.inline.} =
  Control("Control", variable)


method resize*(self: ControlPtr, width, height: float) =
  self.rect_size = Vector2(width, height)
