# author: Ethosa
import
  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,

  ../nodes/node,
  ../nodes/canvas


type
  ControlObj* = object of CanvasObj
    hovered*: bool
    pressed*: bool

    mouse_enter*: proc(x, y: float): void
    mouse_exit*: proc(x, y: float): void
    click*: proc(x, y: float): void
    press*: proc(x, y: float): void
    release*: proc(x, y: float): void
  ControlPtr* = ptr ControlObj
