# --- Test 2. Use Canvas node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  canvas = Canvas()

main.addChild(canvas)

canvas.resize(256, 256)
canvas.fill(Color(0xffaaccff'u32))
canvas.point(5, 5, Color("#64ffffff"))
canvas.line(8, 16, 128, 64, Color("#ffff64ff"))
canvas.circle(0, 240, 32, Color("#aaff6456"))
canvas.line(200, -150, 0, 256, Color("#0e1317ff"))
canvas.bezier(0, 0, 256, 0, 256, 256, Color("#227"))
canvas.cubic_bezier(0, 0, 256, 0, 0, 256, 256, 256, Color("#272"))
canvas.move(74.4, 89.4)
canvas.saveAs("assets/canvas.png")  # save result in file.


addScene(main)
setMainScene("Main")
windowLaunch()
