# author: Ethosa
import
  vector2,
  rect2

{.used.}


type
  InputEventType* {.size: sizeof(int8).} = enum
    MOUSE,     ## Mouse button.
    TOUCH,     ## Touch screen.
    MOTION,    ## Mouse motion.
    KEYBOARD,  ## Keyboard input
    UNKNOWN    ## Unknown event.

  InputAction* = object
    kind*: InputEventType
    key_int*: int8
    key_cint*: cint
    button_index*: cint
    name*, key*: string

  Input* = object

  InputEvent* = ref object
    kind*: InputEventType
    pressed*: bool
    key_int*: int8
    key_cint*: cint
    button_index*: cint
    x*, y*, xrel*, yrel*: float
    key*: string

  InputEventVoid* = distinct int8
  InputEventMouseButton* = distinct int8
  InputEventMouseMotion* = distinct int8
  InputEventTouchScreen* = distinct int8
  InputEventKeyboard* = distinct int8


const
  BUTTON_LEFT* = 0
  BUTTON_MIDDLE* = 1
  BUTTON_RIGHT* = 2

  BUTTON_RELEASE* = 0
  BUTTON_CLICK* = 1

  K_F1* = 1
  K_F2* = 2
  K_F3* = 3
  K_F4* = 4
  K_F5* = 5
  K_F6* = 6
  K_F7* = 7
  K_F8* = 8
  K_F9* = 9
  K_TAB* = 9
  K_F10* = 10
  K_F11* = 11
  K_F12* = 12
  K_ENTER* = 13
  K_ESCAPE* = 27
  K_SPACE* = 32
  K_NUM_MUL* = 42
  K_NUM_SUB* = 45
  K_NUM_ADD* = 43
  K_NUM_POINT* = 46
  K_NUM_DIV* = 47
  K_0* = 48
  K_1* = 49
  K_2* = 50
  K_3* = 51
  K_4* = 52
  K_5* = 53
  K_6* = 54
  K_7* = 55
  K_8* = 56
  K_9* = 57
  K_LEFT* = 100
  K_UP* = 101
  K_RIGHT* = 102
  K_DOWN* = 103
  K_PAGE_UP* = 104
  K_PAGE_DOWN* = 105
  K_HOME* = 106
  K_END* = 107
  K_INSERT* = 108
  K_DELETE* = 127


var
  pressed_keys*: seq[string] = @[]
  pressed_keys_ints*: seq[int8] = @[]
  pressed_keys_cints*: seq[cint] = @[]
  last_event*: InputEvent = InputEvent()
  last_key_state*: bool = false
  key_state*: bool = false
  press_state*: int = 0
  actionlist*: seq[InputAction] = @[]
  mouse_pressed*: bool = false


proc isInputEventVoid*(a: InputEvent): bool =
  ## Returns true, when `a` kind is an UNKNOWN.
  a.kind == UNKNOWN

proc isInputEventMouseButton*(a: InputEvent): bool =
  ## Returns true, when `a` kind is a MOUSE.
  a.kind == MOUSE

proc isInputEventMouseMotion*(a: InputEvent): bool =
  ## Returns true, when `a` kind is a MOTION.
  a.kind == MOTION

proc isInputEventTouchScreen*(a: InputEvent): bool =
  ## Returns true, when `a` kind is a TOUCH.
  a.kind == TOUCH

proc isInputEventKeyboard*(a: InputEvent): bool =
  ## Returns true, when `a` kind is a KEYBOARD.
  a.kind == KEYBOARD


proc addButtonAction*(a: type Input, name: string, button: cint) =
  ## Adds a new action on button.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `button` - button index, e.g.: BUTTON_LEFT, BUTTON_RIGHT or BUTTON_MIDDLE.
  actionlist.add(InputAction(kind: MOUSE, name: name, button_index: button))

proc addKeyAction*(a: type Input, name, key: string) =
  ## Adds a new action on keyboard.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `key` - key, e.g.: "w", "1", etc.
  actionlist.add(InputAction(kind: KEYBOARD, name: name, key: key))

proc addKeyAction*(a: type Input, name: string, key: int8) =
  ## Adds a new action on keyboard.
  ##
  ## Arguments:
  ## - `name` - action name.
  ## - `key` - key, e.g.: K_ESCAPE, K_0, etc.
  actionlist.add(InputAction(kind: KEYBOARD, name: name, key_int: key))

proc addTouchAction*(a: type Input, name: string) =
  ## Adds a new action on touch screen.
  ##
  ## Arguments:
  ## - `name` - action name.
  actionlist.add(InputAction(kind: TOUCH, name: name))


proc isActionJustPressed*(a: type Input, name: string): bool =
  ## Returns true, when action active one times.
  ##
  ## Arguments:
  ## - `name` - action name.
  result = false
  for action in actionlist:
    if action.name == name:
      if action.kind == MOUSE and (last_event.kind == MOUSE or last_event.kind == MOTION):
        if action.button_index == last_event.button_index and mouse_pressed:
          if press_state == 1:
            result = true
      elif action.kind == TOUCH and last_event.kind == TOUCH:
        if press_state == 1:
          result = true
      elif action.kind == KEYBOARD and last_event.kind == KEYBOARD:
        if (action.key == last_event.key or action.key_int == last_event.key_int) and last_key_state == false:
          if press_state == 1:
            result = true

proc isActionPressed*(a: type Input, name: string): bool =
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
      elif action.kind == KEYBOARD and last_event.kind == KEYBOARD:
        if action.key in pressed_keys or action.key_int in pressed_keys_ints:
          if press_state > 0:
            result = true

proc isActionReleased*(a: type Input, name: string): bool =
  ## Returns true, when action no more active.
  ##
  ## Arguments:
  ## - `name` - action name.
  result = false
  for action in actionlist:
    if action.name == name:
      if action.kind == MOUSE and (last_event.kind == MOUSE or last_event.kind == MOTION):
        if action.button_index == last_event.button_index and not mouse_pressed:
          if press_state == 0:
            result = true
      elif action.kind == KEYBOARD and last_event.kind == KEYBOARD:
        if action.key notin pressed_keys or action.key_int notin pressed_keys_ints:
          if press_state == 0:
            result = true

proc `$`*(event: InputEvent): string =
  case event.kind
  of UNKNOWN:
    "Unknown event."
  of MOUSE:
    var button =
      if event.button_index == BUTTON_RIGHT:
        "right"
      elif event.button_index == BUTTON_LEFT:
        "left"
      else:
        "middle"
    "InputEventMouseButton(x: " & $event.x & ", y: " & $event.y & ", pressed:" & $event.pressed & ", button: " & button & ")"
  of MOTION:
    "InputEventMotionButton(x: " & $event.x & ", y: " & $event.y & ", xrel:" & $event.xrel & ", yrel:" & $event.yrel & ")"
  of TOUCH:
    "InputEventTouchScreen(x: " & $event.x & ", y: " & $event.y & ")"
  of KEYBOARD:
    "InputEventKeyboard(key: " & event.key & ", pressed:" & $event.pressed & ")"
