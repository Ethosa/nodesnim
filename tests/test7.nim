# --- Test 7. Change scenes. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")
  second = Scene("Second scene")

  lightblue = ColorRect()

  violet = ColorRect()


Input.addKeyAction("change_scene", K_SPACE)

main.addChild(violet)
second.addChild(lightblue)

violet.color = Color(0xccaaffff'u32)
lightblue.color = Color(0xaaccffff'u32)
lightblue.setAnchor(0.5, 0.5, 0.5, 0.5)

violet.on_process =
  proc(self: NodeRef) =
    if Input.isActionJustPressed("change_scene"):
      echo "bye from main scene :("
      changeScene("Second scene")  # This function changes current scene.

lightblue.on_process =
  proc(self: NodeRef) =
    if Input.isActionJustPressed("change_scene"):
      echo "bye from second scene :("
      changeScene("Main")


addScene(main)
addScene(second)
setMainScene("Main")
windowLaunch()
