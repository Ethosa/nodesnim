# --- Test 8. Mouse setting. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  mainobj: SceneObj
  main_scene = Scene("Main", mainobj)

Input.setMouseMode(MOUSE_MODE_HIDDEN)
# available modes:
# MOUSE_MODE_HIDDEN, MOUSE_MODE_VISIBLE, MOUSE_MODE_CAPTURED

window.setMainScene(main_scene)
window.launch()
