# author: Ethosa
import
  node,
  ../thirdparty/opengl,
  ../core/enums


type
  SceneObj* {.final.} = object of NodeObj
  ScenePtr* = ptr SceneObj


proc Scene*(name: string, variable: var SceneObj): ScenePtr =
  ## Creates a new Scene pointer.
  nodepattern(SceneObj)
  variable.pausemode = PAUSE

proc Scene*(variable: var SceneObj): ScenePtr {.inline.} =
  Scene("Scene", variable)


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

method enter*(scene: ScenePtr) {.base.} =
  for child in scene.getChildIter():
    child.enter()
    child.is_ready = false

method exit*(scene: ScenePtr) {.base.} =
  for child in scene.getChildIter():
    child.enter()
    child.is_ready = false

method handleScene*(scene: ScenePtr, mouse_on: var NodePtr, paused: bool) {.base.} =
  for child in scene.getChildIter():
    if child.visible:
      child.handle(mouse_on)
    child.input()
