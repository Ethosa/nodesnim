# --- Test 11. Environment setting. --- #
import nodesnim


Window("hello world")

var main = Scene("Main")

env.color = Color(1, 0.6, 1)  # window background color.
env.brightness = 0.5
env.delay = 1000 div 30  # 30 frames per second.


addScene(main)
setMainScene("Main")
windowLaunch()
