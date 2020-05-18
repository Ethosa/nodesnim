# --- Test 14. Use VBox node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  vboxobj: VBoxObj     # Create a VBoxObj.
  vbox = VBox(vboxobj)  # Create pointer to the VBoxObj.

  redobj: ColorRectObj
  red = ColorRect(redobj)  # #ff6699

  pinkobj: ColorRectObj
  pink = ColorRect(pinkobj)  #ff64ff

  orangeobj: ColorRectObj
  orange = ColorRect(orangeobj)  # #ffaa00


red.color = Color(0xff6699ff'u32)
pink.color = Color(0xff64ffff'u32)
orange.color = Color(0xffaa00ff'u32)

red.resize(128, 128)
pink.resize(64, 64)
orange.resize(32, 32)

# Add rects in the Box node.
vbox.addChild(red)
vbox.addChild(pink)
vbox.addChild(orange)

main.addChild(vbox)
vbox.setAnchor(0, 0.5, 0, 0.5)  # Box anchor in the scene.
vbox.child_anchor = Anchor(0, 1, 0, 1)
vbox.setSizeAnchor(1, 1)


addScene(main)
setMainScene("Main")
windowLaunch()
