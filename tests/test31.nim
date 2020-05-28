# --- Test 31. Use Counter node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  counterobj: CounterObj
  counter = Counter(counterobj)

main.addChild(counter)
counter.move(128, 64)


addScene(main)
setMainScene("Main")
windowLaunch()
