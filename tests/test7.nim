# --- Test 7. Change scenes. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  secondobj: SceneObj

  main = Scene("Main", mainobj)
  second = Scene("Second scene", secondobj)

  colorrectobj: ColorRectObj
  lightblue = ColorRect(colorrectobj)

  colorrect1obj: ColorRectObj
  violet = ColorRect(colorrect1obj)


Input.addKeyAction("change_scene", K_SPACE)

main.addChild(violet)
second.addChild(lightblue)

violet.color = Color(0xccaaffff'u32)
lightblue.color = Color(0xaaccffff'u32)
lightblue.anchor = Anchor(0.5, 0.5, 0.5, 0.5)

violet.process =
  proc() =
    if Input.isActionJustPressed("change_scene"):
      echo "bye from main scene :("
      changeScene("Second scene")  # This function changes current scene.

lightblue.process =
  proc() =
    if Input.isActionJustPressed("change_scene"):
      echo "bye from second scene :("
      changeScene("Main")


addScene(main)
addScene(second)
setMainScene("Main")
windowLaunch()
