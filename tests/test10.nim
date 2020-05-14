# --- Test 10. Anchor setting. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  mainsceneobj: SceneObj
  main_scene = Scene("Main", mainsceneobj)

  color1obj: ColorRectObj
  color2obj: ColorRectObj
  color1 = ColorRect(color1obj)
  color2 = ColorRect("ColorRect2", color2obj)


main_scene.addChild(color1)

# Prepare nodes:
color1.addChild(color2)
color1.resize(256, 128)
color1.move(64, 64)
color1.color = Color("#dd64ddff")
color2.color = Color("#64dd64ff")

color2.setAnchor(
  Anchor(
    1, 0.5,  # Parent anchor at X and Y axes.
    1, 0.5  # Self anchor at X and Y axes.
  )
)
# Try to change anchor :з


window.setMainScene(main_scene)
window.launch()
