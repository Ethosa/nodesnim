# author: Ethosa
import ../thirdparty/sdl2 except Color, glBindTexture
import
  vector2,
  rect2

{.used.}


type
  InputEventType* {.pure, size: sizeof(int8).} = enum
    MOUSE,     ## Mouse button.
    TOUCH,     ## Touch screen.
    MOTION,    ## Mouse motion.
    WHEEL,     ## Mouse wheel.
    KEYBOARD,  ## Keyboard input
    TEXT,      ## Text input.
    UNKNOWN    ## Unknown event.

  InputAction* = object
    kind*: InputEventType
    key_int*: cint
    button_index*: cint
    name*, key*: string

  InputEvent* = ref object
    kind*: InputEventType
    pressed*: bool
    key_int*: cint
    button_index*: cint
    x*, y*, xrel*, yrel*: float
    key*: string

  InputEventVoid* = distinct int8
  InputEventMouseButton* = distinct int8
  InputEventMouseMotion* = distinct int8
  InputEventMouseWheel* = distinct int8
  InputEventTouchScreen* = distinct int8
  InputEventKeyboard* = distinct int8


const
  BUTTON_RELEASE* = 0
  BUTTON_CLICK* = 1


var
  last_key_state*: bool = false
  key_state*: bool = false
  mouse_pressed*: bool = false
  press_state*: int = 0
  last_event*: InputEvent = InputEvent()
  pressed_keys_cint*: seq[cint] = @[]
  actionlist*: seq[InputAction] = @[]


proc isInputEventVoid*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is an UNKNOWN.
  a.kind == UNKNOWN

proc isInputEventMouseButton*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a MOUSE.
  a.kind == MOUSE

proc isInputEventMouseMotion*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a MOTION.
  a.kind == MOTION

proc isInputEventMouseWheel*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a WHEEL.
  a.kind == WHEEL

proc isInputEventTouchScreen*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a TOUCH.
  a.kind == TOUCH

proc isInputEventKeyboard*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a KEYBOARD.
  a.kind == KEYBOARD

proc isInputEventText*(a: InputEvent): bool {.inline.} =
  ## Returns true, when `a` kind is a KEYBOARD.
  a.kind == TEXT


proc addButtonAction*(name: string, button: uint8 | cint) {.inline.} =
  ## Adds a new action on button.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `button` - button index, e.g.: BUTTON_LEFT, BUTTON_RIGHT or BUTTON_MIDDLE.
  actionlist.add(InputAction(kind: MOUSE, name: name, button_index: button.cint))

proc addKeyAction*(name, key: string) {.inline.} =
  ## Adds a new action on keyboard.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `key` - key, e.g.: "w", "1", etc.
  actionlist.add(InputAction(kind: KEYBOARD, name: name, key_int: ord(key[0]).cint))

proc addKeyAction*(name: string, key: cint) {.inline.} =
  ## Adds a new action on keyboard.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `key` - key, e.g.: K_ESCAPE, K_0, etc.
  actionlist.add(InputAction(kind: KEYBOARD, name: name, key_int: key))

proc addTouchAction*(name: string) {.inline.} =
  ## Adds a new action on touch screen.
  ##
  ## Arguments:
  ## - `name` - action name.
  actionlist.add(InputAction(kind: TOUCH, name: name))


proc isActionJustPressed*(name: string): bool =
  ## Returns true, when action active one times.
  ##
  ## Arguments:
  ## - `name` - action name.
  result = false
  for action in actionlist:
    if action.name == name:
      if action.kind == MOUSE and last_event.kind in [MOUSE, MOTION]:
        if action.button_index == last_event.button_index and mouse_pressed:
          if press_state == 0:
            result = true
      elif action.kind == TOUCH and last_event.kind == TOUCH:
        if press_state == 0:
          result = true
      elif action.kind == KEYBOARD and last_event.kind == KEYBOARD:
        if last_event.key_int > 255:
          continue
        if action.key == $chr(last_event.key_int) or action.key_int == last_event.key_int:
          if press_state == 0:
            result = true

proc isActionPressed*(name: string): bool =
  ## Returns true, when action active one or more times.
  ##
  ## Arguments:
  ## - `name` - action name.
  result = false
  for action in actionlist:
    if action.name == name:
      if action.kind == MOUSE:
        if action.button_index == last_event.button_index and mouse_pressed:
          result = true
      elif action.kind == TOUCH and last_event.kind == TOUCH:
        if press_state > 0:
          result = true
      elif action.kind == KEYBOARD:
        if action.key_int in pressed_keys_cint:
          result = true

proc isActionReleased*(name: string): bool =
  ## Returns true, when action no more active.
  ##
  ## Arguments:
  ## - `name` - action name.
  result = false
  for action in actionlist:
    if action.name == name:
      if action.kind == MOUSE and last_event.kind in [MOUSE, MOTION]:
        if action.button_index == last_event.button_index and not mouse_pressed:
          if press_state == 0:
            result = true
      elif action.kind == KEYBOARD and last_event.kind == KEYBOARD:
        if last_event.key_int > 255:
          continue
        if action.key == $chr(last_event.key_int) or action.key_int == last_event.key_int:
          if press_state == 0:
            result = true

proc `$`*(event: InputEvent): string =
  case event.kind
  of UNKNOWN:
    "Unknown event."
  of MOUSE:
    var button =
      if event.button_index == BUTTON_RIGHT.cint:
        "right"
      elif event.button_index == BUTTON_LEFT.cint:
        "left"
      else:
        "middle"
    "InputEventMouseButton(x: " & $event.x & ", y: " & $event.y & ", pressed:" & $event.pressed & ", button: " & button & ")"
  of MOTION:
    "InputEventMotionButton(x: " & $event.x & ", y: " & $event.y & ", xrel:" & $event.xrel & ", yrel:" & $event.yrel & ")"
  of WHEEL:
    "InputEventMouseWheel(x: " & $event.x & ", y: " & $event.y & ", button:" & $event.button_index & ", yrel:" & $event.yrel & ")"
  of TOUCH:
    "InputEventTouchScreen(x: " & $event.x & ", y: " & $event.y & ")"
  of KEYBOARD:
    "InputEventKeyboard(key: " & event.key & ", pressed:" & $event.pressed & ")"
  of TEXT:
    "InputEventText(key: " & event.key & ", pressed:" & $event.pressed & ")"


proc `$`*(action: InputAction): string =
  case action.kind
  of MOUSE:
    "InputAction[Mouse](button: " & $action.button_index & ")"
  of KEYBOARD:
    "InputAction[Keyboard](key: " & $action.key_int & ")"
  of TOUCH:
    "InputAction[Touch]()"
  else:
    ""
