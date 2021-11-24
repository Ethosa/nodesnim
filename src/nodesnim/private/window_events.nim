# author: Ethosa
import ../thirdparty/sdl2 except Color, glBindTexture
import
  ../thirdparty/gl,
  ../thirdparty/opengl/glu,
  ../core/input,
  ../nodes/node,
  ../nodes/scene,
  ../environment,
  templates,
  strutils,
  unicode,
  os

var mouse_on: NodeRef = nil


{.push optimization: speed.}
proc display*(env: EnvironmentRef, current_scene: SceneRef, width, height: cint, paused: bool, windowptr: WindowPtr) =
  ## Displays window.
  glClearColor(env.background_color.r, env.background_color.g, env.background_color.b, env.background_color.a)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  # Draw current scene.
  current_scene.drawScene(width.GLfloat, height.GLfloat, paused)
  press_state = -1
  mouse_on = nil

  # Update window.
  glFlush()
  windowptr.glSwapWindow()
  os.sleep(env.delay)


proc reshape*(current_scene: SceneRef, w, h: var cint, paused: bool) =
  ## This called when window resized.
  if w > 0 and h > 0:
    glViewport(0, 0, w, h)
    glLoadIdentity()
    glMatrixMode(GL_PROJECTION)
    glMatrixMode(GL_MODELVIEW)
    glOrtho(-w.GLdouble/2, w.GLdouble/2, -h.GLdouble/2, h.GLdouble/2, -w.GLdouble, w.GLdouble)
    gluPerspective(45.0, w/h, 1.0, 200.0)

    if current_scene != nil:
      current_scene.reAnchorScene(w.GLfloat, h.GLfloat, paused)

proc mouse*(current_scene: SceneRef, button, x, y: cint, pressed, paused: bool) =
  ## Handle mouse input.
  checkWindowCallback(InputEventMouseButton, last_event.pressed and pressed, pressed)
  last_event.button_index = button
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = MOUSE
  mouse_pressed = pressed
  last_event.pressed = pressed

  current_scene.handleScene(last_event, mouse_on, paused)

proc wheel*(current_scene: SceneRef, x, y: cint, paused: bool) =
  ## Handle mouse wheel input.
  checkWindowCallback(InputEventMouseWheel, false, false)
  last_event.kind = WHEEL
  last_event.xrel = x.float
  last_event.yrel = y.float

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardpress*(current_scene: SceneRef, c: cint, paused: bool) =
  ## Called when press any key on keyboard.
  if c < 0:
    return
  checkWindowCallback(InputEventKeyboard, last_event.pressed, true)
  last_event.key_int = c
  if c notin pressed_keys_cint:
    pressed_keys_cint.add(c)
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc textinput*(current_scene: SceneRef, c: TextInputEventPtr, paused: bool) =
  ## Called when start text input
  last_event.key = toRunes(join(c.text[0..<32]))[0].toUtf8()
  last_event.kind = TEXT
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardup*(current_scene: SceneRef, c: cint, paused: bool) =
  ## Called when any key no more pressed.
  if c < 0:
    return
  checkWindowCallback(InputEventKeyboard, false, false)
  last_event.key_int = c
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = false
  for i in pressed_keys_cint.low..pressed_keys_cint.high:
    if pressed_keys_cint[i] == c:
      pressed_keys_cint.delete(i)
      break

  current_scene.handleScene(last_event, mouse_on, paused)

proc motion*(current_scene: SceneRef, x, y, xrel, yrel: cint, paused: bool) =
  ## Called on any mouse motion.
  last_event.kind = MOTION
  last_event.xrel = xrel.float
  last_event.yrel = yrel.float
  last_event.x = x.float
  last_event.y = y.float

  current_scene.handleScene(last_event, mouse_on, paused)
{.pop.}
