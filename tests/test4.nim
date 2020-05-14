# --- Test 4. Use ColorRect node. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  colorobj: ColorRectObj
  color = ColorRect(colorobj)

color.move(15.872, 98.8)
color.color.g = 0.6
color.resize(color.rect_size.x+76.2, 89.7)

main_scene.addChild(color)

window.setMainScene(main_scene)
window.launch()
