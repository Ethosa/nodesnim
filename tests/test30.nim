# --- Test 30. Use YSort node. --- #
import nodesnim


Window("hello world", 1024, 640)

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  ysortobj: YsortObj
  ysort = Ysort(ysortobj)

  sprite0obj: SpriteObj
  sprite0 = Sprite(sprite0obj)

  sprite1obj: SpriteObj
  sprite1 = Sprite(sprite1obj)

  sprite2obj: SpriteObj
  sprite2 = Sprite(sprite2obj)

  sprite3obj: SpriteObj
  sprite3 = Sprite(sprite3obj)

  sprite4obj: SpriteObj
  sprite4 = Sprite(sprite4obj)

  img0 = load("assets/anim/2.jpg")

sprite0.setTexture(img0)
sprite1.setTexture(img0)
sprite2.setTexture(img0)
sprite3.setTexture(img0)
sprite4.setTexture(img0)


sprite0.move(92, 92)
sprite1.move(128, 128)
sprite2.move(160, 160)
sprite3.move(192, 192)
sprite4.move(224, 224)

ysort.addChild(sprite0)
ysort.addChild(sprite1)
ysort.addChild(sprite2)
ysort.addChild(sprite3)
ysort.addChild(sprite4)


main.addChild(ysort)
addScene(main)
setMainScene("Main")
windowLaunch()
