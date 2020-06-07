# --- Test 25. Use Node2D node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  node = Node2D()


main.addChild(node)


addScene(main)
setMainScene("Main")
windowLaunch()
