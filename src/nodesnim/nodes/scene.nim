# author: Ethosa
## The Scene uses in the `window.nim`. It contains other nodes. Only one scene can work at a time.
import
  ../thirdparty/gl,
  ../thirdparty/opengl/glu,
  ../core/enums,
  ../core/input,
  ../core/vector2,
  ../core/vector3,
  ../core/themes,
  ../private/templates,
  ../nodes3d/node3d,
  ../nodes3d/camera3d,
  node,
  canvas


type
  SceneObj* {.final.} = object of CanvasObj
    data*: seq[tuple[k: string, v: string]]
  SceneRef* = ref SceneObj


proc Scene*(name: string = "Scene"): SceneRef =
  ## Creates a new Scene.
  ##
  ## Arguments:
  ## - `name` is a scene name.
  nodepattern(SceneRef)
  result.rect_size = Vector2()
  result.rect_min_size = Vector2()
  result.position = Vector2()
  result.global_position = Vector2()
  result.pausemode = PAUSE
  result.data = @[]


method drawScene*(scene: SceneRef, w, h: GLfloat, paused: bool) {.base.} =
  ## Draws scene
  ## This used in the window.nim.
  scene.on_process(scene)
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visibility != GONE:
      # load opengl
      if child.type_of_node != NODE_TYPE_DEFAULT:
        glLoadIdentity()
        glMatrixMode(GL_PROJECTION)
        glMatrixMode(GL_MODELVIEW)

      # when 2D
      if child.type_of_node == NODE_TYPE_CONTROL:
        child.CanvasRef.calcGlobalPosition()
        glOrtho(-w/2, w/2, -h/2, h/2, -w, w)
      elif child.type_of_node == NODE_TYPE_2D:
        glOrtho(-w/2, w/2, -h/2, h/2, -w, w)
      # when 3D
      elif child.type_of_node == NODE_TYPE_3D:
        child.Node3DRef.calcGlobalPosition3()
        gluPerspective(45.0, w/h, 1.0, 5000.0)
        if current_camera.isNil():
          gluLookAt(0, 0, -1, 0, 0, 1, 0, 1, 0)
        else:
          let
            pos = current_camera.global_translation
            front = current_camera.front + pos
            up = current_camera.up
          gluLookAt(pos.x, pos.y, pos.z, front.x, front.y, front.z, up.x, up.y, up.z)

      if not child.is_ready:
        child.on_ready(child)
        child.is_ready = true

      if theme_changed:
        child.on_theme_changed(child)
      child.on_process(child)
      child.draw(w, h)
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visibility != GONE:
      child.postdraw(w, h)
  if theme_changed:
    theme_changed = false
  scene.calcGlobalPosition()

method duplicate*(self: SceneRef): SceneRef {.base.} =
  ## Duplicates Scene object and create a new Scene.
  self.deepCopy()

method enter*(scene: SceneRef) {.base.} =
  ## This called when scene was changed.
  scene.on_enter(scene)
  for child in scene.getChildIter():
    child.on_enter(child)
    child.is_ready = false

method exit*(scene: SceneRef) {.base.} =
  ## This called when scene was changed.
  scene.on_exit(scene)
  for child in scene.getChildIter():
    child.on_enter(child)
    child.is_ready = false

method handleScene*(scene: SceneRef, event: InputEvent, mouse_on: var NodeRef, paused: bool) {.base.} =
  ## Handles user input. This called on any input.
  scene.on_input(scene, event)
  var childs = scene.getChildIter()
  for i in countdown(childs.len()-1, 0):
    if paused and childs[i].getPauseMode() != PROCESS:
      continue
    if childs[i].visibility != GONE:
      childs[i].handle(event, mouse_on)
      childs[i].on_input(childs[i], event)

method reAnchorScene*(scene: SceneRef, w, h: GLfloat, paused: bool) {.base.} =
  ## Recalculates node positions.
  scene.rect_size.x = w
  scene.rect_size.y = h
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.type_of_node == NODE_TYPE_CONTROL:
      child.CanvasRef.calcPositionAnchor()
