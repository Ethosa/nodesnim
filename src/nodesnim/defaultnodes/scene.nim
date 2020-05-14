# author: Ethosa
import node
import ../default/enums
import ../default/vector2


type
  SceneObj* = object of NodeObj
  ScenePtr* = ptr SceneObj


proc Scene*(name: string, variable: var SceneObj): ScenePtr =
  ## Creates a new Scene pointer.
  nodepattern(SceneObj)
  variable.pausemode = PAUSE
