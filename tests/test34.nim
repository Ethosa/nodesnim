# --- Test 34. Rotation. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  sprite = Sprite()

main.addChild(sprite)

sprite.loadTexture("assets/anim/2.jpg")

sprite.move(128, 128)
sprite.centered = false


sprite@on_process(self):
  sprite.rotation += 0.1


addScene(main)
setMainScene("Main")
windowLaunch()
