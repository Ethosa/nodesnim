# --- Test 40. Use SubWindow node. --- #
import nodesnim


Window("subwindow ._.")

var
  main = Scene()
  window = SubWindow()


main.addChild(window)
window.move(64, 64)
window.setIcon("assets/anim/0.jpg")
window.open()


addMainScene(main)
windowLaunch()
