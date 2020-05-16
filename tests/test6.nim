# --- Test 6. Anchor setting. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  colorrectobj: ColorRectObj
  colorrect = ColorRect(colorrectobj)

  colorrect1obj: ColorRectObj
  colorrect1 = ColorRect(colorrect1obj)

main.addChild(colorrect)
colorrect.addChild(colorrect1)


colorrect1.anchor = Anchor(  # Try to change it! ^^
  0.5,  # parent anchor at X axis.
  0.5,  # parent anchor at Y axis.
  0.5,  # anchor at X axis.
  0.5   # anchor at Y axis.
)
colorrect.anchor = Anchor(1, 1, 1, 1)

colorrect.resize(256, 128)
colorrect.move(128, 64)
colorrect.color = Color(0xaaccffff'u32)
colorrect1.color = Color(0xccaaffff'u32)


addScene(main)
setMainScene("Main")
windowLaunch()
