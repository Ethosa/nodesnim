# --- Test 4. Use ColorRect node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  colorrect = ColorRect()

main.addChild(colorrect)

colorrect.color = Color(1f, 1f, 1f)  # default ColorRect color.


addScene(main)
setMainScene("Main")
windowLaunch()
