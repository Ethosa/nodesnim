# --- Test 4. Use ColorRect node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  colorrectobj: ColorRectObj
  colorrect = ColorRect(colorrectobj)

main.addChild(colorrect)

colorrect.color = Color(1f, 1f, 1f)  # default ColorRect color.


addScene(main)
setMainScene("Main")
windowLaunch()
