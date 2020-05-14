# author: Ethosa
import ../core/sdl2


type
  InputType* {.size: sizeof(int8).} = enum
    BUTTON, MOTION, TOUCH , KEYBOARD

  Input* = object of RootObj

  InputAction* = object
    event_type*: InputType
    button_index*: uint8
    key*: cint
    name*: string

  InputEvent* = object of Input
    event_type*: InputType
    pressed*: bool
    button_index*: uint8
    x*, y*, xrel*, yrel*: cint

  InputEventVoid* = object of InputEvent
  InputEventMouseButton* = object of InputEvent
  InputEventMouseMotion* = object of InputEvent
  InputEventKeyboard* = object of InputEvent


# --- Private --- #
var pressed_state: int8 = 0
var actions: seq[InputAction] = @[]
var pressed_keys: seq[cint]

template checkState(event: untyped): untyped =
  pressed_state = 1
  if last_event.event_type == `event`:
    pressed_state = 2

template checkaction(condition1: untyped, condition2: untyped) =
  if a.event_type == BUTTON and (last_event.event_type == BUTTON or last_event.event_type == MOTION):
    if `condition1` and `condition2`:
      return true
    return false
  elif a.event_type == KEYBOARD:
    if a.key in pressed_keys and `condition1` and `condition2`:
      return true
    return false
  elif a.event_type == TOUCH and last_event.event_type == TOUCH:
    if `condition1` and `condition2`:
      return true
    return false


# --- Public --- #
const
  MOUSE_MODE_CAPTURED*: int8 = 1  ## Mouse always hidden and centered in the window.
  MOUSE_MODE_HIDDEN*:   int8 = 2  ## Mouse always hidden, while in the focus of the window.
  MOUSE_MODE_VISIBLE*:  int8 = 4  ## Mouse always visible, while in the focus of the window.

var last_event*: InputEvent
var is_show_cursor*: bool = true
var is_mouse_captured*: Bool32 = False32


proc updateEvent*(event: Event) =
  case event.kind
    of MouseButtonDown, MouseButtonUp:
      checkState(BUTTON)
      let e = button(event)
      last_event = InputEventMouseButton(
        x: e.x, y: e.y, pressed: event.kind == MouseButtonDown,
        button_index: e.button, event_type: BUTTON)
    of MouseMotion:
      checkState(MOTION)
      let e = motion(event)
      let p = if last_event.pressed: true else: false
      last_event = InputEventMouseMotion(
        x: e.x, y: e.y, xrel: e.xrel, yrel: e.yrel, event_type: MOTION,
        pressed: p)
    of KeyDown, KeyUp:
      checkState(KEYBOARD)
      let
        e = key(event)
        pressed = event.kind == KeyDown
        key = e.keysym.sym
      if pressed:
        if key notin pressed_keys:
          pressed_keys.add(key)
      else:
        for i in 0..pressed_keys.len():
          if key == pressed_keys[i]:
            pressed_keys.delete(i)
            break
      last_event = InputEventKeyboard(pressed: pressed, event_type: KEYBOARD)
    else:
      last_event = InputEventVoid()
      pressed_state = 0


# --- Actions --- #
proc addMouseButtonAction*(inp: type Input, name: string, button_index: uint8) =
  ## Adds a new action for mouse button
  ##
  ## Arguments:
  ## - `name`: action name.
  ## - `button_index`: button index, e.g.: BUTTON_LEFT, BUTTON_RIGHT, BUTTON_MIDDLE
  runnableExamples:
    const BUTTON_LEFT = 0
    Input.addMouseButtonAction("click", BUTTON_LEFT)

  actions.add(InputAction(name: name, button_index: button_index, event_type: BUTTON))

proc addTouchAction*(inp: type Input, name: string) =
  ## Adds a new action for touch
  ##
  ## Arguments:
  ## - `name`: action name.
  runnableExamples:
    Input.addTouchAction("touch")

  actions.add(InputAction(name: name, event_type: TOUCH))

proc addKeyboardAction*(inp: type Input, name: string, key: cint) =
  ## Adds a new action for keyboard input
  ##
  ## Arguments:
  ## - `name`: action name.
  ## - `key`: keyboard key, e.g.: K_SPACE, K_ESCAPE, K_w, K_a, K_s, K_d, K_W, K_F1, K_PRINTSCREEN, etc.
  runnableExamples:
    const K_SPACE = 0
    Input.addKeyboardAction("keyboard_action", K_SPACE)

  actions.add(InputAction(name: name, event_type: KEYBOARD, key: key))


proc isActionJustPressed*(inp: type Input, name: string): bool =
  ## Returns true, when action pressed one time.
  ##
  ## Arguments:
  ## - `name`: action name.
  for a in actions:
    if a.name == name:
      checkaction(pressed_state == 1, last_event.pressed)
  return false

proc isActionPressed*(inp: type Input, name: string): bool =
  ## Returns true, when action pressed more times.
  ##
  ## Arguments:
  ## - `name`: action name.
  for a in actions:
    if a.name == name:
      checkaction(pressed_state > 0, last_event.pressed)
  return false

proc isActionReleased*(inp: type Input, name: string): bool =
  ## Returns true, when action pressed more times.
  ##
  ## Arguments:
  ## - `name`: action name.
  for a in actions:
    if a.name == name:
      checkaction(pressed_state > -1, not last_event.pressed)
  return false


proc setMouseMode*(inp: type Input, mode: int8) =
  ## Changes mouse mode
  ##
  ## Arguments:
  ## - `mode`: can be ``MOUSE_MODE_CAPTURED``, ``MOUSE_MODE_VISIBLE``, ``MOUSE_MODE_NOT_CAPTURED`` or ``MOUSE_MODE_HIDDEN``
  var m: int8 = mode

  if (m - MOUSE_MODE_CAPTURED) > -1:
    is_mouse_captured = True32
  m -= MOUSE_MODE_CAPTURED

  if (m - MOUSE_MODE_HIDDEN) > -1:
    is_show_cursor = false
  m -= MOUSE_MODE_HIDDEN

  if (m - MOUSE_MODE_VISIBLE) > -1:
    is_show_cursor = true
    is_mouse_captured = False32
  m -= MOUSE_MODE_VISIBLE
