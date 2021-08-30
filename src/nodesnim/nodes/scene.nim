# author: Ethosa
## The Scene uses in the `window.nim`. It contains other nodes. Only one scene can work at a time.
import
  node,
  canvas,
  ../thirdparty/opengl,
  ../core/enums,
  ../core/input,
  ../core/vector2


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
  result.position = Vector2()
  result.global_position = Vector2()
  result.pausemode = PAUSE
  result.data = @[]


method drawScene*(scene: SceneRef, w, h: GLfloat, paused: bool) {.base.} =
  ## Draws scene
  ## This used in the window.nim.
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visible:
      if child.type_of_node == NODE_TYPE_CONTROL:
        child.CanvasRef.calcGlobalPosition()
      child.calcGlobalPosition3()
      if not child.is_ready:
        child.on_ready(child)
        child.is_ready = true
      child.on_process(child)
      child.draw(w, h)
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visible:
      child.draw2stage(w, h)

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
  var childs = scene.getChildIter()
  for i in countdown(childs.len()-1, 0):
    if paused and childs[i].getPauseMode() != PROCESS:
      continue
    if childs[i].visible:
      childs[i].handle(event, mouse_on)
      childs[i].on_input(childs[i], event)

method reAnchorScene*(scene: SceneRef, w, h: GLfloat, paused: bool) {.base.} =
  ## Recalculates node positions.
  scene.rect_size.x = w
  scene.rect_size.y = h
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    child.calcPositionAnchor()
