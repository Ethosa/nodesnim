# --- Test 29. Use Counter node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  counter = Counter()

main.addChild(counter)
counter.move(128, 64)


addScene(main)
setMainScene("Main")
windowLaunch()
