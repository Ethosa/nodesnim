# --- Test 15. Use GridBox node. --- #
import nodesnim


Window("hello world")
var
  main = Scene("Main")

  grid_box = GridBox()  # Create the GridBoxObj.

  red = ColorRect()  # #ff6699
  pink = ColorRect()  #ff64ff
  orange = ColorRect()  # #ffaa00
  mango = ColorRect()  # #ffcc33
  yellow = ColorRect()  # #ffcc66
  red2 = ColorRect()  # #ff6655


red.color = Color(0xff6699ff'u32)
pink.color = Color(0xff64ffff'u32)
orange.color = Color(0xffaa00ff'u32)
mango.color = Color(0xffcc33ff'u32)
yellow.color = Color(0xffcc66ff'u32)
red2.color = Color(0xff6655ff'u32)

red.resize(128, 128)
pink.resize(128, 128)
orange.resize(128, 128)
mango.resize(128, 128)
yellow.resize(128, 128)
red2.resize(128, 128)

# Add rects in the Box node.
grid_box.addChild(red)
grid_box.addChild(pink)
grid_box.addChild(orange)
grid_box.addChild(mango)
grid_box.addChild(yellow)
grid_box.addChild(red2)

main.addChild(grid_box)
grid_box.setAnchor(0.5, 0.5, 0.5, 0.5)
grid_box.setRow(3)
grid_box.setSeparator(16)


addScene(main)
setMainScene("Main")
windowLaunch()
