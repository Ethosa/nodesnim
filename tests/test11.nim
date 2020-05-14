# --- Test 11. Canvas. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  canvasobj: CanvasObj
  canvas = Canvas(canvasobj)

main_scene.addChild(canvas)

canvas.resize(640, 360)  # because default size is 0,0

canvas.linearGradient(
  0, 0,      # first position.
  640, 360,  # second position.
  Color(0.7, 0.8, 1), Color(0.3, 0.4, 1)
)
canvas.aaline(
  0, 0,      # first position.
  640, 360,  # second position.
  Color(1, 0.6, 1)
)
canvas.roundedRect(
  256, 256,  # first position.
  512, 350,  # second position.
  8,         # corner radius.
  Color(1, 0.8, 0.5)
)
canvas.filledPie(
  512, 128,  # center position.
  64,        # radius.
  0,         # start angle.
  270,       # finish angle.
  Color(0.6, 1, 1)
)
canvas.radialGradient(
  64, 64,  # center position.
  76.23,   # radius.
  32,      # inside radius.
  Color(1, 0.6, 1), Color(0, 0, 0, 0)
)
canvas.text(  # multiline text.
  256, 32,           # start position.
  "Hello world!",   # text.
  Color(0x0e1317FF),  # fill color.
  3                 # line spacing.
)


window.setMainScene(main_scene)
window.launch()
