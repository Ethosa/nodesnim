# --- Test 1. Create a window and set up the main scene. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)


addScene(main)
setMainScene("Main")
windowLauch()
