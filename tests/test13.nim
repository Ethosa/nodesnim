# --- Test 13. Use HBox node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  hbox = HBox()  # Create pointer to the HBox.

  red = ColorRect()  # #ff6699

  pink = ColorRect()  #ff64ff

  orange = ColorRect()  # #ffaa00


red.color = Color(0xff6699ff'u32)
pink.color = Color(0xff64ffff'u32)
orange.color = Color(0xffaa00ff'u32)

red.resize(128, 128)
pink.resize(64, 64)
orange.resize(32, 32)

# Add rects in the Box node.
hbox.addChild(red)
hbox.addChild(pink)
hbox.addChild(orange)

main.addChild(hbox)
hbox.setAnchor(0, 0.5, 0, 0.5)  # Box anchor in the scene.


addScene(main)
setMainScene("Main")
windowLaunch()
