# --- Test 18. Use Scroll node. --- #
import nodesnim


Window("scroll")

var
  main = Scene("Main")

  scroll = Scroll()

  grid_box = GridBox()
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

red.resize(150, 150)
pink.resize(50, 50)
orange.resize(50, 50)
mango.resize(50, 50)
yellow.resize(50, 50)
red2.resize(150, 150)

# Add rects in the Box node.
grid_box.addChild(red)
grid_box.addChild(pink)
grid_box.addChild(orange)
grid_box.addChild(mango)
grid_box.addChild(yellow)
grid_box.addChild(red2)

main.addChild(scroll)
grid_box.setAnchor(0.5, 0.5, 0.5, 0.5)
grid_box.setRow(3)
grid_box.setSeparator(2)
scroll.addChild(grid_box)


addScene(main)
setMainScene("Main")
windowLaunch()
