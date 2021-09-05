# author: Ethosa
import
  thirdparty/opengl,
  thirdparty/opengl/glut,
  thirdparty/opengl/glu,

  core/color,
  core/exceptions,
  core/input,

  nodes/node,
  nodes/scene,

  environment,
  os

when defined(debug):
  import logging

var
  cmdLine {.importc: "cmdLine".}: array[0..255, cstring]
  cmdCount {.importc: "cmdCount".}: cint


when not defined(ios) and not defined(android) and not defined(useGlew):
  when defined(debug):
    debug("Try to load OpenGL ...")
  loadExtensions()  # Load OpenGL extensions.

when defined(debug):
  debug("Try to load freeGLUT ...")
glutInit(addr cmdCount, addr cmdLine) # Initializ glut lib.
glutInitDisplayMode(GLUT_DOUBLE)


var
  env*: EnvironmentRef = newEnvironment()
  width, height: cint
  max_distance*: GLdouble = int64.high.GLdouble
  main_scene*: SceneRef = nil
  current_scene*: SceneRef = nil
  scenes*: seq[SceneRef] = @[]
  paused*: bool = false


# --- Callbacks --- #
var
  mouse_on: NodeRef = nil
  window_created: bool = false

proc display {.cdecl.} =
  ## Displays window.
  let (r, g, b, a) = env.color.toFloatTuple()
  glClearColor(r*env.brightness, g*env.brightness, b*env.brightness, a*env.brightness)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  # Draw current scene.
  current_scene.drawScene(width.GLfloat, height.GLfloat, paused)
  press_state = -1
  mouse_on = nil

  # Update window.
  glFlush()
  glutSwapBuffers()
  os.sleep(env.delay)


proc reshape(w, h: cint) {.cdecl.} =
  ## This called when window resized.
  if w > 0 and h > 0:
    glViewport(0, 0, w, h)
    glLoadIdentity()
    glMatrixMode(GL_PROJECTION)
    glMatrixMode(GL_MODELVIEW)
    glOrtho(-w.GLdouble/2, w.GLdouble/2, -h.GLdouble/2, h.GLdouble/2, -w.GLdouble, w.GLdouble)
    gluPerspective(45.0, w/h, 1.0, 200.0)
    width = w
    height = h

    if current_scene != nil:
      current_scene.reAnchorScene(w.GLfloat, h.GLfloat, paused)

template check(event, condition, conditionelif: untyped): untyped =
  if last_event is `event` and `condition`:
    press_state = 2
  elif `conditionelif`:
    press_state = 1
  else:
    press_state = 0

proc mouse(button, state, x, y: cint) {.cdecl.} =
  ## Handle mouse input.
  check(InputEventMouseButton, last_event.pressed and state == GLUT_DOWN, state == GLUT_DOWN)
  last_event.button_index = button
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = MOUSE
  mouse_pressed = state == GLUT_DOWN
  last_event.pressed = state == GLUT_DOWN

  current_scene.handleScene(last_event, mouse_on, paused)

proc wheel(button, dir, x, y: cint) {.cdecl.} =
  ## Handle mouse wheel input.
  check(InputEventMouseWheel, false, false)
  last_event.button_index = button
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = WHEEL
  last_event.yrel = dir.float

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardpress(c: int8, x, y: cint) {.cdecl.} =
  ## Called when press any key on keyboard.
  if c < 0:
    return
  let key = $c.char
  check(InputEventKeyboard, last_event.pressed, true)
  last_event.key = key
  last_event.key_int = c
  last_event.x = x.float
  last_event.y = y.float
  if key notin pressed_keys:
    pressed_keys.add(key)
    pressed_keys_ints.add(c)
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardup(c: int8, x, y: cint) {.cdecl.} =
  ## Called when any key no more pressed.
  if c < 0:
    return
  let key = $c.char
  check(InputEventKeyboard, false, false)
  last_event.key = key
  last_event.key_int = c
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = false
  var i = 0
  for k in pressed_keys:
    if k == key:
      pressed_keys.delete(i)
      pressed_keys_ints.delete(i)
      break
    inc i

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardspecialpress(c: cint, x, y: cint) {.cdecl.} =
  ## Called when press any key on keyboard.
  if c < 0:
    return
  check(InputEventKeyboard, last_event.pressed, true)
  last_event.key = $c
  last_event.key_cint = c
  last_event.x = x.float
  last_event.y = y.float
  if c notin pressed_keys_cints:
    pressed_keys_cints.add(c)
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardspecialup(c: cint, x, y: cint) {.cdecl.} =
  ## Called when any key no more pressed.
  if c < 0:
    return
  check(InputEventKeyboard, false, false)
  last_event.key_cint = c
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = false
  var i = 0
  for k in pressed_keys_cints:
    if k == c:
      pressed_keys_cints.delete(i)
      break
    inc i

  current_scene.handleScene(last_event, mouse_on, paused)

proc motion(x, y: cint) {.cdecl.} =
  ## Called on any mouse motion.
  last_event.kind = MOTION
  last_event.xrel = last_event.x - x.float
  last_event.yrel = last_event.y - y.float
  last_event.x = x.float
  last_event.y = y.float

  current_scene.handleScene(last_event, mouse_on, paused)


# ---- Public ---- #
proc addScene*(scene: SceneRef) =
  ## Adds a new scenes in app.
  ##
  ## Arguments:
  ## - `scene` - pointer to the Scene object.
  if scene notin scenes:
    scenes.add(scene)
  scene.rect_size.x = width.float
  scene.rect_size.y = height.float

proc addMainScene*(scene: SceneRef) =
  ## Adds a new scene in the app and set it mark it as main scene.
  ##
  ## Arguents:
  ## - `scene` - pointer to the Scene object.
  if scene notin scenes:
    scenes.add(scene)
  main_scene = scene

proc changeScene*(name: string, extra: seq[tuple[k: string, v: string]] = @[]): bool {.discardable.} =
  ## Changes current scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  result = false
  for scene in scenes:
    if scene.name == name:
      if current_scene != nil:
        current_scene.exit()
        current_scene.data = @[]
      current_scene = nil
      current_scene = scene
      current_scene.data = extra
      current_scene.enter()
      current_scene.reAnchorScene(width.GLfloat, height.GLfloat, paused)
      result = true
      break
  when defined(debug):
    debug("result of `changeScene` is ", result)

proc setMainScene*(name: string) =
  ## Set up main scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  for scene in scenes:
    if scene.name == name:
      main_scene = scene
      break

proc setTitle*(title: cstring) =
  ## Changes window title.
  if not window_created:
    raise newException(WindowNotCreatedError, "Window not created!")
  glutSetWindowTitle(title)

proc setMaxDistance*(distance: GLdouble) =
  max_distance = distance

proc Window*(title: cstring, w: cint = 640, h: cint = 360) {.cdecl.} =
  ## Creates a new window pointer
  ##
  ## Arguments:
  ## - `title` - window title.
  # Set up window.
  glutInitWindowSize(w, h)
  glutInitWindowPosition(100, 100)
  when defined(debug):
    debug("result of `glutCreateWindow` is ", glutCreateWindow(title))
  else:
    discard glutCreateWindow(title)

  # Set up OpenGL
  let (r, g, b, a) = env.color.toFloatTuple()
  glClearColor(r, g, b, a)
  glShadeModel(GL_FLAT)
  glClear(GL_COLOR_BUFFER_BIT)
  glEnable(GL_COLOR_MATERIAL)
  glMaterialf(GL_FRONT, GL_SHININESS, 15)

  reshape(w, h)
  window_created = true


proc windowLaunch* =
  ## Start main window loop.
  when defined(debug):
    info("launch window ...")
  glutDisplayFunc(display)
  glutIdleFunc(display)
  when not defined(android) and not defined(ios):
    glutReshapeFunc(reshape)
    glutMouseWheelFunc(wheel)
  glutMouseFunc(mouse)
  glutKeyboardFunc(keyboardpress)
  glutKeyboardUpFunc(keyboardup)
  glutSpecialFunc(keyboardspecialpress)
  glutSpecialUpFunc(keyboardspecialup)
  glutMotionFunc(motion)
  glutPassiveMotionFunc(motion)
  if main_scene == nil:
    raise newException(MainSceneNotLoadedError, "Main scene is not indicated!")
  changeScene(main_scene.name)
  when defined(debug):
    info("window launched")
  glutMainLoop()
  current_scene.exit()
