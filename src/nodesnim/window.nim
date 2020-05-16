# author: Ethosa
import
  thirdparty/opengl,
  thirdparty/opengl/glut,

  core/color,
  core/exceptions,

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


proc display {.cdecl.} =
  ## Displays window.
  let (r, g, b, a) = env.color.toFloatTuple()
  glClearColor(r, g, b, a)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

  # Draw current scene.
  current_scene.drawScene(width.GLfloat, height.GLfloat, paused)

  # Update window.
  glFlush()
  glutSwapBuffers()

proc mouse(button, state, x, y: cint) {.cdecl.} =
  ## Handle mouse input.
  discard

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


# ---- Public ---- #
proc addScene*(scene: ScenePtr) =
  ## Adds a new scenes in app.
  if scene notin scenes:
    scenes.add(scene)

proc changeScene*(name: string): bool {.discardable.} =
  ## Changes current scene.
  result = false
  for scene in scenes:
    if scene.name == name:
      if current_scene != nil:
        current_scene.exit()
      current_scene = nil
      current_scene = scene
      current_scene.enter()
      result = true
      break

proc setMainScene*(name: string) =
  ## Set up main scene.
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


proc windowLauch* =
  glutDisplayFunc(display)
  glutReshapeFunc(reshape)
  glutMouseFunc(mouse)
  if main_scene == nil:
    raise newException(MainSceneNotLoadedError, "Main scene is not indicated!")
  changeScene(main_scene.name)
  glutMainLoop()
