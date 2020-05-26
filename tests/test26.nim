# --- Test 26. Use Sprite node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  spriteobj: SpriteObj
  sprite = Sprite(spriteobj)

  icon = load("assets/smile.png", GL_RGBA)


main.addChild(sprite)

sprite.move(128, 128)  # Move sprite.
sprite.setTexture(icon)  # Change sprite image.

sprite.centered = true  # The default value is true. Try to change it.

addScene(main)
setMainScene("Main")
windowLaunch()
