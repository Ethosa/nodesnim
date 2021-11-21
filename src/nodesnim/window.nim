# author: Ethosa
import thirdparty/sdl2 except Color, glBindTexture
import
  thirdparty/gl,
  thirdparty/opengl/glu,
  thirdparty/sdl2/image,

  core/color,
  core/input,
  core/exceptions,
  core/vector2,
  core/enums,

  nodes/node,
  nodes/scene,

  environment,
  strutils,
  unicode,
  os
when defined(debug):
  import logging


once:
  discard sdl2.init(INIT_EVERYTHING)

  discard glSetAttribute(SDL_GL_DOUBLEBUFFER, 1)
  discard glSetAttribute(SDL_GL_RED_SIZE, 5)
  discard glSetAttribute(SDL_GL_GREEN_SIZE, 6)
  discard glSetAttribute(SDL_GL_BLUE_SIZE, 5)


var
  env*: EnvironmentRef = newEnvironment()
  width, height: cint
  main_scene*: SceneRef = nil
  current_scene*: SceneRef = nil
  windowptr: WindowPtr
  glcontext: GlContextPtr = windowptr.glCreateContext()
  scenes*: seq[SceneRef] = @[]
  paused*: bool = false
  running*: bool = true
  event = sdl2.defaultEvent


# --- Callbacks --- #
var
  mouse_on: NodeRef = nil
  window_created: bool = false

proc display {.cdecl.} =
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

proc mouse(button, x, y: cint, pressed: bool) {.cdecl.} =
  ## Handle mouse input.
  check(InputEventMouseButton, last_event.pressed and pressed, pressed)
  last_event.button_index = button
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = MOUSE
  mouse_pressed = pressed
  last_event.pressed = pressed

  current_scene.handleScene(last_event, mouse_on, paused)

proc wheel(x, y: cint) {.cdecl.} =
  ## Handle mouse wheel input.
  check(InputEventMouseWheel, false, false)
  last_event.kind = WHEEL
  last_event.xrel = x.float
  last_event.yrel = y.float

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardpress(c: cint) {.cdecl.} =
  ## Called when press any key on keyboard.
  if c < 0:
    return
  check(InputEventKeyboard, last_event.pressed, true)
  last_event.key_int = c
  if c notin pressed_keys_cint:
    pressed_keys_cint.add(c)
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc textinput(c: TextInputEventPtr) {.cdecl.} =
  ## Called when start text input
  last_event.key = toRunes(join(c.text[0..<32]))[0].toUtf8()
  last_event.kind = TEXT
  last_key_state = key_state
  key_state = true

  current_scene.handleScene(last_event, mouse_on, paused)

proc keyboardup(c: cint) {.cdecl.} =
  ## Called when any key no more pressed.
  if c < 0:
    return
  check(InputEventKeyboard, false, false)
  last_event.key_int = c
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = false
  for i in pressed_keys_cint.low..pressed_keys_cint.high:
    if pressed_keys_cint[i] == c:
      pressed_keys_cint.delete(i)
      break

  current_scene.handleScene(last_event, mouse_on, paused)

proc motion(x, y, xrel, yrel: cint) {.cdecl.} =
  ## Called on any mouse motion.
  last_event.kind = MOTION
  last_event.xrel = xrel.float
  last_event.yrel = yrel.float
  last_event.x = x.float
  last_event.y = y.float

  current_scene.handleScene(last_event, mouse_on, paused)



# -------------------- Public -------------------- #

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

proc centeredWindow* =
  ## Moves window to the display center.
  var dm: DisplayMode
  discard getCurrentDisplayMode(0, dm)
  windowptr.setPosition((dm.w/2 - width/2).cint, (dm.h/2 - height/2).cint)

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

proc getSceneByName*(name: string): SceneRef =
  for scene in scenes:
    if scene.name == name:
      return scene

proc getWindowSize*(): Vector2Obj =
  Vector2(width.float, height.float)

proc resizeWindow*(x, y: cint) =
  ## Resizes window.
  width = x
  height = y
  windowptr.setSize(x, y)

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
  if window_created:
    windowptr.setTitle(title)
  else:
    throwError(WindowError, "Window not launched!")

proc setIcon*(icon_path: cstring) =
  ## Changes window title.
  if window_created:
    windowptr.setIcon(image.load(icon_path))
  else:
    throwError(WindowError, "Window not launched!")

proc Window*(title: cstring, w: cint = 640, h: cint = 360) {.cdecl.} =
  ## Creates a new window pointer
  ##
  ## Arguments:
  ## - `title` - window title.
  # Set up window.
  windowptr = createWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, w, h,
    SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL or SDL_WINDOW_RESIZABLE or
    SDL_WINDOW_ALLOW_HIGHDPI or SDL_WINDOW_FOREIGN or
    SDL_WINDOW_INPUT_FOCUS or SDL_WINDOW_MOUSE_FOCUS)
  glcontext = windowptr.glCreateContext()
  env.windowptr = windowptr
  once:
    when not defined(android) and not defined(ios) and not defined(useGlew):
      if not gladLoadGL(glGetProcAddress):  # Load OpenGL extensions.
        throwError(GLLoadError, "OpenGL couldn't load.")
      discard captureMouse(True32)

  # Set up OpenGL
  glShadeModel(GL_SMOOTH)
  glClear(GL_COLOR_BUFFER_BIT)
  glEnable(GL_COLOR_MATERIAL)
  glMaterialf(GL_FRONT, GL_SHININESS, 15)

  reshape(w, h)
  window_created = true


proc onReshape(userdata: pointer; event: ptr Event): Bool32 {.cdecl.} =
  if event.kind == WindowEvent:
    case evWindow(event[]).event
    of WindowEvent_Resized, WindowEvent_SizeChanged, WindowEvent_Minimized, WindowEvent_Maximized, WindowEvent_Restored:
      windowptr.getSize(width, height)
      if env.screen_mode == SCREEN_MODE_NONE:
        reshape(width, height)
        display()
    else:
      discard
  False32

proc windowLaunch* =
  if main_scene.isNil():
    throwError(SceneError, "Main scene is not indicated!")
  changeScene(main_scene.name)
  when defined(debug):
    info("window launched")

  addEventWatch(onReshape, windowptr)

  while running:
    while sdl2.pollEvent(event):
      case event.kind
      of QuitEvent:
        running = false
      of KeyDown:
        let e = evKeyboard(event)
        keyboardpress(e.keysym.sym)
      of KeyUp:
        let e = evKeyboard(event)
        keyboardup(e.keysym.sym)
      of TextInput:
        let e = text(event)
        textinput(e)
      of MouseMotion:
        let e = evMouseMotion(event)
        motion(e.x, e.y, e.xrel, e.yrel)
      of MouseButtonDown:
        let e = evMouseButton(event)
        mouse(e.button.cint, e.x, e.y, true)
      of MouseButtonUp:
        let e = evMouseButton(event)
        mouse(e.button.cint, e.x, e.y, false)
      of MouseWheel:
        let e = evMouseWheel(event)
        wheel(e.x, e.y)
      else:
        discard
    display()

  current_scene.exit()
  sdl2.glDeleteContext(glcontext)
  sdl2.destroy(windowptr)
  sdl2.quit()
