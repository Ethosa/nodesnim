# --- Test 1. Create a window and set up the main scene. --- #
import nodesnim


var
  window = newWindow(
    "hello world",  # window title
    640,  # window width
    360  # window height
  )
  main: SceneObj
  main_scene = Scene("Main", main)  # create a new scene.

window.setMainScene(main_scene)
# ^ Try to remove the line above and see what happens

window.launch()  # start main loop
