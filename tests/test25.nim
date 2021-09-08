# --- Test 25. Use TextureButton node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  button = TextureButton()

  norm_texture = load("assets/button_normal.png", GL_RGBA)
  hover_texture = load("assets/button_hover.png", GL_RGBA)
  press_texture = load("assets/button_press.png", GL_RGBA)

main.addChild(button)
env.setBackgroundColor(Color(0xf2f2f7ff'u32))

button.setText("Press me!")
button.resize(256, 64)
button.setAnchor(0.5, 0.5, 0.5, 0.5)

button.setNormalTexture(norm_texture)
button.setHoverTexture(hover_texture)
button.setPressTexture(press_texture)

button.on_touch =
  proc(self: TextureButtonRef, x, y: float) =  # This called when user clicks on the button
    button.setText("Clicked in " & $x & ", " & $y & " position.")


addScene(main)
setMainScene("Main")
windowLaunch()
