# --- Test 39. Use LineEdit node. --- #
import nodesnim


Window("smth here")


var
  scene = Scene()
  line = LineEdit()

line.setAnchor(0.5, 0.5, 0.5, 0.5)

scene.addChild(line)
addMainScene(scene)
windowLaunch()
