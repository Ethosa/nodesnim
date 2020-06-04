# --- Test 36. Rotation. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  spriteobj: SpriteObj
  sprite = Sprite(spriteobj)

main.addChild(sprite)

sprite.loadTexture("assets/anim/2.jpg")

sprite.move(128, 128)
sprite.centered = false


sprite@on_process(self):
  sprite.rotation += 0.1


addScene(main)
setMainScene("Main")
windowLaunch()
