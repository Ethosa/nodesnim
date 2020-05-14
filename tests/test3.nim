# --- Test 3. Use Control node. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  controlobj: ControlObj
  control = Control(controlobj)

main_scene.addChild(control)

window.setMainScene(main_scene)
window.launch()
