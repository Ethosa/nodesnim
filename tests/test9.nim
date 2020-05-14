# --- Test 9. Extended Control events. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  mainobj: SceneObj
  main_scene = Scene("Main", mainobj)
  colorobj: ColorRectObj
  color = ColorRect(colorobj)
  color1obj: ColorRectObj
  color1 = ColorRect(color1obj)

main_scene.addChild(color)
main_scene.addChild(color1)

color1.click =
  proc(x, y: float) =  # This called when the mouse clicks on the node.
    color1.move(3, 3)

color.click =
  proc(x, y: float) =  # This called when the mouse clicks on the node.
    echo "clicked in position: ", Vector2(x, y), "!"
    color.color.g = 0.6

color.press =
  proc(x, y: float) =  # This called when the mouse holds on.
    color.color.g += 0.01

color.focused =
  proc() =  # This called when the node gets focus.
    echo "hi"

color.unfocused =
  proc() =  # This called when the node loses focus.
    echo "bye("

color.release =
  proc() =  # This called when the mouse more not is pressed.
    echo ">.<"

window.setMainScene(main_scene)
window.launch()
