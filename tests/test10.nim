# --- Test 10. Use Button node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  button = Button()

main.addChild(button)

button.setText("Press me!")
button.resize(256, 64)
button.setAnchor(0.5, 0.5, 0.5, 0.5)

button.on_touch =
  proc(self: ButtonRef, x, y: float) =  # This called when user clicks on the button
    button.setText("Clicked in " & $x & ", " & $y & " position.")


addScene(main)
setMainScene("Main")
windowLaunch()
