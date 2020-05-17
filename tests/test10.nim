# --- Test 10. Use Button node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  buttonobj: ButtonObj
  button = Button(buttonobj)

main.addChild(button)

button.text = "Press me!"
button.resize(256, 64)
button.anchor = Anchor(0.5, 0.5, 0.5, 0.5)


button.on_click =
  proc(x, y: float) =  # This called when user clicks on the button
    button.text = "Clicked in " & $x & ", " & $y & " position."


addScene(main)
setMainScene("Main")
windowLaunch()
