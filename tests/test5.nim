# --- Test 5. Handle Control node events. --- #
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


colorrect1.on_click =
  proc(self: ControlPtr, x, y: float) =  # This called when the user clicks on the Control node (ColorRect in this case).
    colorrect1.move(3, 3)

colorrect.on_press =
  proc(self: ControlPtr, x, y: float) =  # This called when the user holds on the mouse on the Control node.
    colorrect.color.r -= 0.001

colorrect.on_release =
  proc(self: ControlPtr, x, y: float) =  # This called when the user no more holds on the mouse.
    colorrect.color.r = 1

colorrect.on_focus =
  proc(self: ControlPtr) =  # This called when the Control node gets focus.
    echo "hello ^^."

colorrect.on_unfocus =
  proc(self: ControlPtr) =  # This called when the Control node loses focus.
    echo "bye :("

colorrect1.on_mouse_enter =
  proc(self: ControlPtr, x, y: float) =  # This called when the mouse enters the Control node.
    colorrect1.color = Color(1, 0.6, 1, 0.5)

colorrect1.on_mouse_exit =
  proc(self: ControlPtr, x, y: float) =  # This called when the mouse exit from the Control node.
    colorrect1.color = Color(1f, 1f, 1f)


addScene(main)
setMainScene("Main")
windowLaunch()
