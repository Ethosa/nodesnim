# author: Ethosa
import
  thirdparty/opengl,
  thirdparty/opengl/glut,

  core/color,
  core/exceptions,
  core/input,

  nodes/node,
  nodes/scene,

  environment


var
  cmdLine {.importc: "cmdLine".}: array[0..255, cstring]
  cmdCount {.importc: "cmdCount".}: cint
loadExtensions()  # Load OpenGL extensions.
glutInit(addr cmdCount, addr cmdLine) # Initializ glut lib.
glutInitDisplayMode(GLUT_DOUBLE)


var
  env*: EnvironmentRef = newEnvironment()
  width, height: cint
  main_scene*: ScenePtr = nil
  current_scene*: ScenePtr = nil
  scenes*: seq[ScenePtr] = @[]
  paused*: bool = false


# --- Callbacks --- #
var mouse_on: NodePtr = nil

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


proc reshape(w, h: cint) {.cdecl.} =
  ## This called when window resized.
  if w > 0 and h > 0:
    glViewport(0, 0, w, h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-w.GLdouble/2, w.GLdouble/2, -h.GLdouble/2, h.GLdouble/2, -1, 1)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
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

proc keyboardpress(c: int8, x, y: cint) {.cdecl.} =
  ## Called when press any key on keyboard.
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

proc motion(x, y: cint) {.cdecl.} =
  ## Called on any mouse motion.
  last_event.kind = MOTION
  last_event.xrel = last_event.x - x.float
  last_event.yrel = last_event.y - y.float
  last_event.x = x.float
  last_event.y = y.float

  current_scene.handleScene(last_event, mouse_on, paused)


# ---- Public ---- #
proc addScene*(scene: ScenePtr) =
  ## Adds a new scenes in app.
  ##
  ## Arguments:
  ## - `scene` - pointer to the Scene object.
  if scene notin scenes:
    scenes.add(scene)

proc changeScene*(name: string): bool {.discardable.} =
  ## Changes current scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  result = false
  for scene in scenes:
    if scene.name == name:
      if current_scene != nil:
        current_scene.exit()
      current_scene = nil
      current_scene = scene
      current_scene.enter()
      current_scene.reAnchorScene(width.GLfloat, height.GLfloat, paused)
      result = true
      break

proc setMainScene*(name: string) =
  ## Set up main scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  for scene in scenes:
    if scene.name == name:
      main_scene = scene
      break

proc Window*(title: cstring, w: cint = 640, h: cint = 360) {.cdecl.} =
  ## Creates a new window pointer
  ##
  ## Arguments:
  ## - `title` - window title.
  # Set up window.
  glutInitWindowSize(w, h)
  glutInitWindowPosition(100, 100)
  let success = glutCreateWindow(title)

  # Set up OpenGL
  let (r, g, b, a) = env.color.toFloatTuple()
  glClearColor(r, g, b, a)
  glShadeModel(GL_FLAT)
  glClear(GL_COLOR_BUFFER_BIT)

  reshape(w, h)


proc windowLaunch* =
  ## Start main window loop.
  glutDisplayFunc(display)
  glutIdleFunc(display)
  glutReshapeFunc(reshape)
  glutMouseFunc(mouse)
  glutKeyboardFunc(keyboardpress)
  glutKeyboardUpFunc(keyboardup)
  glutMotionFunc(motion)
  glutPassiveMotionFunc(motion)
  if main_scene == nil:
    raise newException(MainSceneNotLoadedError, "Main scene is not indicated!")
  changeScene(main_scene.name)
  glutMainLoop()
  current_scene.exit()
