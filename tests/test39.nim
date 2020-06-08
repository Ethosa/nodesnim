# --- Test 39. Use GeometryInstance node. --- #
import nodesnim


Window("smth")

var
  scene = Scene("Main")
  geometry = GeometryInstance("Cube")


scene.addChild(geometry)

geometry.translateX(-50)
geometry.transformX(1)

geometry@on_input(self, event):
  if event.isInputEventMouseMotion() and event.pressed:
    geometry.rotateX(-event.yrel)
    geometry.rotateY(-event.xrel)

addMainScene(scene)
windowLaunch()
