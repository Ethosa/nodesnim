# author: Ethosa
import sdl2
import environment
import defaultnodes/node
import defaultnodes/scene
import default/exceptions
import default/colornodes
import default/input
import default/enums


sdl2.init(INIT_EVERYTHING)


type
  WindowObj* = object
    is_work: bool  ## window is running
    paused*: bool  ## window paused
    window: WindowPtr
    renderer: RendererPtr
    environment*: EnvironmentRef  ## Environment object.
    event: Event
    scenes: seq[ScenePtr]
    current_scene: ScenePtr
    main_scene: ScenePtr
  WindowRef* = ref WindowObj


# --- Private --- #
var mouse_on: NodePtr = nil  # to check the node that is under the mouse.

proc draw(window: WindowRef): void =
  ## Draws the window.
  var surface = window.window.getSurface()
  # draw background environment color.
  surface.fillRect(nil, window.environment.color.toUint32BEWithoutAlpha())

  for child in window.current_scene.getChildIter():
    # skip, if pause mode is not PROCESS.
    if window.paused and child.getPauseMode() != PROCESS:
      continue
    # ready(), if node is not ready.
    if not child.is_ready:
      child.ready()
      child.is_ready = true
    child.process()
    child.draw(surface)

  discard window.window.updateSurface()


proc handle_input(window: WindowRef): void =
  ## Handles user input.
  while window.event.pollEvent():
    if window.event.kind == QuitEvent:
      window.is_work = false
    mouse_on = nil

    input.updateEvent(window.event)
    discard sdl2.captureMouse(True32)
    discard sdl2.setRelativeMouseMode(input.is_mouse_captured)
    discard sdl2.showCursor(input.is_show_cursor)

    var nodes = window.current_scene.getChildIter()
    for i in countdown(nodes.len()-1, 0):
      var child = nodes[i]
      if window.paused and child.getPauseMode() != PROCESS:
        continue
      child.handle(window.event, mouse_on)
      child.input(input.last_event)

    if window.event.kind == KeyDown or window.event.kind == KeyUp:
      window.draw()
      sdl2.delay(window.environment.delay)


# --- Public --- #
proc newWindow*(name: cstring, width, height: int, flags: uint32 = 0): WindowRef =
  ## Creates a new Window object.
  ##
  ## Arguments:
  ## - `name`: window title.
  ## - `width`: window width.
  ## - `height`: window height.
  ##
  ## Keyword Arguments:
  ## - `debug_mode`: debug output.
  ## - `flags`: SDL flags.
  var
    window = createWindow(
      name, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      width.cint, height.cint, flags)
    renderer = createRenderer(window, -1, Renderer_Software or Renderer_Accelerated)
  WindowRef(
    window: window, renderer: renderer, is_work: true,
    event: sdl2.defaultEvent, environment: newEnvironment(),
    scenes: @[], paused: false
  )


proc addNewScene*(window: WindowRef, scene: ScenePtr): void =
  ## Adds a new scene.
  ##
  ## Arguments:
  ## - `scene`: a scene pointer
  window.scenes.add(scene)

proc setMainScene*(window: WindowRef, scene: ScenePtr): void =
  ## Sets a main scene.
  ##
  ## Arguments:
  ## - `scene`: a scene pointer
  window.main_scene = scene
  window.current_scene = scene


proc changeScene*(window: WindowRef, name: string): bool {.discardable.} =
  ## Returns true, if scene changed
  ##
  ## Arguments:
  ## - `name`: scene name.
  var is_changed: bool = false
  for scene in window.scenes:
    if scene.name == name:
      if window.current_scene != nil:
        # Exit from current scene.
        for child in window.current_scene.getChildIter():
          if window.paused and child.getPauseMode() != PROCESS:
            continue
          child.exit()
          child.is_ready = false
      window.current_scene = nil
      window.current_scene = scene
      is_changed = true
      break
  # Enter in scene
  for child in window.current_scene.getChildIter():
    if window.paused and child.getPauseMode() != PROCESS:
      continue
    child.calcPositionAnchor()
    child.enter()
  return is_changed


proc launch*(window: WindowRef) =
  ## Start main loop.
  if window.main_scene == nil:
    raise newException(MainSceneNotLoadedError, "The main scene has not been indicated!")
  window.changeScene(window.main_scene.name)

  # Game loop
  while window.is_work:
    window.handle_input()
    window.draw()
    sdl2.delay(window.environment.delay)

  # Exit from current scene
  for child in window.current_scene.getChildIter():
    if window.paused and child.getPauseMode() != PROCESS:
      continue
    child.exit()
    child.is_ready = false

  # Exit from SDL
  sdl2.destroy(window.window)
  sdl2.destroy(window.renderer)
  sdl2.quit()
