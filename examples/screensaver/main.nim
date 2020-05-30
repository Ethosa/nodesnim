import nodesnim
import random
randomize()


Window("ScreenSaver", 720, 480)


var
  main = Scene("Main")

  img = load("img.png", GL_RGBA)

  sprite = Sprite()

  direction = Vector2()
  speed = 3f

sprite.centered = false
sprite.setTexture(img)

sprite.process =
  proc() =
    let rect = Rect2(sprite.global_position, sprite.rect_size)
    if rect.x <= 0:
      direction = sprite.global_position.directionTo(Vector2(main.rect_size.x, rand(main.rect_size.y.int).float))
      sprite.filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
    elif rect.x+rect.w >= main.rect_size.x:
      direction = sprite.global_position.directionTo(Vector2(0, rand(main.rect_size.y.int).float))
      sprite.filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
    elif rect.y <= 0:
      direction = sprite.global_position.directionTo(Vector2(rand(main.rect_size.x.int).float, main.rect_size.y))
      sprite.filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
    elif rect.y+rect.h >= main.rect_size.y:
      direction = sprite.global_position.directionTo(Vector2(rand(main.rect_size.x.int).float, 0))
      sprite.filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)

    sprite.move(direction*speed)


main.addChild(sprite )
addScene(main)
setMainScene("Main")
windowLaunch()
