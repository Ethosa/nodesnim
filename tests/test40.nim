# --- Test 40. Use SubWindow node. --- #
import nodesnim


Window("subwindow ._.")

var
  main = Scene()
  window = SubWindow()
  window1 = SubWindow()
  window2 = SubWindow()


main.addChild(window)
main.addChild(window1)
main.addChild(window2)

window.move(64, 64)
window.setIcon("assets/anim/0.jpg")
window.open()

window1.move(64, 64)
window1.setIcon("assets/anim/0.jpg")
window1.setBackgroundColor(Color("#efefef"))
window1.setTitle("Hello, lol")
window1.open()

window2.move(64, 64)
window2.setIcon("assets/anim/0.jpg")
window2.setBackgroundColor(Color("#212112"))
window2.setTitle("Aboba")
window2.open()


addMainScene(main)
windowLaunch()
