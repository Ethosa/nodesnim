# --- Test 2. Use Canvas node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  canvasobj: CanvasObj
  canvas = Canvas(canvasobj)

main.addChild(canvas)

canvas.fill(Color(0xffaaccff'u32))
canvas.point(5, 5, Color("#64ffffff"))
canvas.line(8, 16, 128, 64, Color("#ffff64ff"))
canvas.circle(0, 240, 32, Color("#aaff6456"))
canvas.line(200, -150, 0, 256, Color("#0e1317ff"))
canvas.resize(256, 256)
canvas.move(74.4, 89.4)


addScene(main)
setMainScene("Main")
windowLauch()
