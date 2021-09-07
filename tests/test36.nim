# --- Test 36. Use Node3D. --- #
import nodesnim

Window("smth here")

var
  scene = Scene("Main")
  node = Node3D()

scene.addChild(node)


addMainScene(scene)
windowLaunch()
