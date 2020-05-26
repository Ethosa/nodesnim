# --- Test 28. Use AnimatedSprite node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  spriteobj: AnimatedSpriteObj
  sprite = AnimatedSprite(spriteobj)

  img0 = load("assets/anim/0.jpg")
  img1 = load("assets/anim/1.jpg")
  img2 = load("assets/anim/2.jpg")
  img3 = load("assets/anim/3.jpg")
  img4 = load("assets/anim/4.jpg")

sprite.addFrame("default", img0)
sprite.addFrame("default", img1)
sprite.addFrame("default", img2)
sprite.addFrame("default", img3)
sprite.addFrame("default", img4)


sprite.play("", false)  # if `name` is "" than plays current animation.
sprite.centered = false  # disable centered.


main.addChild(sprite)
addScene(main)
setMainScene("Main")
windowLaunch()
