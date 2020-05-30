# author: Ethosa
## The Scene uses in the `window.nim`. It contains other nodes. Only one scene can work at a time.
import
  node,
  ../thirdparty/opengl,
  ../core/enums,
  ../core/input


type
  SceneObj* {.final.} = object of NodeObj
  ScenePtr* = ptr SceneObj


var scenes: seq[SceneObj] = @[]

proc Scene*(name: string = "Scene"): ScenePtr =
  ## Creates a new Scene pointer.
  ##
  ## Arguments:
  ## - `name` is a scene name.
  var variable: SceneObj
  nodepattern(SceneObj)
  variable.pausemode = PAUSE
  scenes.add(variable)
  return addr scenes[^1]


method drawScene*(scene: ScenePtr, w, h: GLfloat, paused: bool) {.base.} =
  ## Draws scene
  ## This used in the window.nim.
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visible:
      if not child.is_ready:
        child.ready()
        child.is_ready = true
      child.process()
      child.draw(w, h)
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    if child.visible:
      child.draw2stage(w, h)

method duplicate*(self: ScenePtr): ScenePtr {.base.} =
  ## Duplicates Scene object and create a new Scene pointer.
  var obj = self[]
  scenes.add(obj)
  return addr scenes[^1]

method enter*(scene: ScenePtr) {.base.} =
  ## This called when scene was changed.
  for child in scene.getChildIter():
    child.enter()
    child.is_ready = false

method exit*(scene: ScenePtr) {.base.} =
  ## This called when scene was changed.
  for child in scene.getChildIter():
    child.enter()
    child.is_ready = false

method handleScene*(scene: ScenePtr, event: InputEvent, mouse_on: var NodePtr, paused: bool) {.base.} =
  ## Handles user input. This called on any input.
  var childs = scene.getChildIter()
  for i in countdown(childs.len()-1, 0):
    if paused and childs[i].getPauseMode() != PROCESS:
      continue
    if childs[i].visible:
      childs[i].handle(event, mouse_on)
      childs[i].input(event)

method reAnchorScene*(scene: ScenePtr, w, h: GLfloat, paused: bool) {.base.} =
  ## Recalculates node positions.
  scene.rect_size.x = w
  scene.rect_size.y = h
  for child in scene.getChildIter():
    if paused and child.getPauseMode() != PROCESS:
      continue
    child.calcPositionAnchor()
