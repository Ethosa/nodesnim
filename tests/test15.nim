# --- Test 15. Use GridBox node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  grid_boxobj: GridBoxObj     # Create a GridBoxObj.
  grid_box = GridBox(grid_boxobj)  # Create pointer to the GridBoxObj.

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
grid_box.addChild(red)
grid_box.addChild(pink)
grid_box.addChild(orange)

main.addChild(grid_box)
grid_box.setAnchor(0, 0.5, 0, 0.5)
grid_box.setRaw(1)


addScene(main)
setMainScene("Main")
windowLaunch()
