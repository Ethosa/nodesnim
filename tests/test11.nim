# --- Test 11. Environment setting. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

env.color = Color(1, 0.6, 1)  # window background color.
env.brightness = 0.5


addScene(main)
setMainScene("Main")
windowLaunch()
