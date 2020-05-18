# --- Test 6. Anchor setting. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  colorrectobj: ColorRectObj
  lightblue = ColorRect(colorrectobj)

  colorrect1obj: ColorRectObj
  violet = ColorRect(colorrect1obj)

main.addChild(lightblue)
lightblue.addChild(violet)


lightblue.resize(256, 128)
lightblue.move(128, 64)

violet.setAnchor(  # Try to change it! ^^
  0.5,  # parent anchor at X-axis.
  0.5,  # parent anchor at Y-axis.
  0.5,  # anchor at X-axis.
  0.5   # anchor at Y-axis.
)
lightblue.setAnchor(1, 1, 1, 1)
lightblue.setSizeAnchor(
  0,  # size anchor at X-axis. If 0 then not used.
  1   # size anchor at Y-axis. If 0 then not used.
)

lightblue.color = Color(0xaaccffff'u32)
violet.color = Color(0xccaaffff'u32)


addScene(main)
setMainScene("Main")
windowLaunch()
