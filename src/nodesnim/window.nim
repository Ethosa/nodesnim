# author: Ethosa
import thirdparty/sdl2 except Color, glBindTexture
import
  thirdparty/gl,
  thirdparty/sdl2/image,
  core/exceptions,
  core/vector2,
  core/enums,
  nodes/node,
  nodes/scene,
  private/window_events,
  environment
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
  if not windowptr.isNil():
    windowptr.setTitle(title)
  else:
    throwError(WindowError, "Window not launched!")

proc setIcon*(icon_path: cstring) =
  ## Changes window title.
  if not windowptr.isNil():
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

  width = w
  height = h
  reshape(current_scene, width, height, paused)


proc onReshape(userdata: pointer; event: ptr Event): Bool32 {.cdecl.} =
  if event.kind == WindowEvent:
    case evWindow(event[]).event
    of WindowEvent_Resized, WindowEvent_SizeChanged, WindowEvent_Minimized, WindowEvent_Maximized, WindowEvent_Restored:
      windowptr.getSize(width, height)
      if env.screen_mode == SCREEN_MODE_NONE:
        reshape(current_scene, width, height, paused)
        display(env, current_scene, width, height, paused, windowptr)
    else:
      discard
  False32

proc runApp* =
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
        keyboardpress(current_scene, e.keysym.sym, paused)
      of KeyUp:
        let e = evKeyboard(event)
        keyboardup(current_scene, e.keysym.sym, paused)
      of TextInput:
        let e = text(event)
        textinput(current_scene, e, paused)
      of MouseMotion:
        let e = evMouseMotion(event)
        motion(current_scene, e.x, e.y, e.xrel, e.yrel, paused)
      of MouseButtonDown:
        let e = evMouseButton(event)
        mouse(current_scene, e.button.cint, e.x, e.y, true, paused)
      of MouseButtonUp:
        let e = evMouseButton(event)
        mouse(current_scene, e.button.cint, e.x, e.y, false, paused)
      of MouseWheel:
        let e = evMouseWheel(event)
        wheel(current_scene, e.x, e.y, paused)
      else:
        discard
    display(env, current_scene, width, height, paused, windowptr)

  current_scene.exit()
  sdl2.glDeleteContext(glcontext)
  sdl2.destroy(windowptr)
  sdl2.quit()

proc windowLaunch* =
  {.warning: "`windowLaunch` is deprecated. Use `runApp` instead.".}
  runApp()
