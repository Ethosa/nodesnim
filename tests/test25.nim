# --- Test 25. Use Node2D node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  nodeobj: Node2DObj
  node = Node2D(nodeobj)


main.addChild(node)


addScene(main)
setMainScene("Main")
windowLaunch()
