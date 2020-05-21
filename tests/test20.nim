# --- Test 20. Use Scroll node. --- #
import nodesnim


Window("scroll")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  scrollobj: ScrollObj
  scroll = Scroll(scrollobj)

  grid_boxobj: GridBoxObj     # Create a GridBoxObj.
  grid_box = GridBox(grid_boxobj)  # Create pointer to the GridBoxObj.

  redobj: ColorRectObj
  red = ColorRect(redobj)  # #ff6699

  pinkobj: ColorRectObj
  pink = ColorRect(pinkobj)  #ff64ff

  orangeobj: ColorRectObj
  orange = ColorRect(orangeobj)  # #ffaa00

  mangoobj: ColorRectObj
  mango = ColorRect(mangoobj)  # #ffcc33

  yellowobj: ColorRectObj
  yellow = ColorRect(yellowobj)  # #ffcc66

  red2obj: ColorRectObj
  red2 = ColorRect(red2obj)  # #ff6655


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
grid_box.setRaw(3)
grid_box.setSeparator(2)
scroll.addChild(grid_box)


addScene(main)
setMainScene("Main")
windowLaunch()
