# --- Test 5. Environment setting. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

# warning: alpha channel does not work here
window.environment.setBackgroundColor(Color(255, 100, 255))  # #ff64ff
window.environment.setDelay(1000 div 60)  # 60 frames per second

window.setMainScene(main_scene)
window.launch()
