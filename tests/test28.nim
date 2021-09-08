# --- Test 28. Use YSort node. --- #
import nodesnim


Window("hello world", 1024, 640)

var
  main = Scene("Main")

  ysort = Ysort()

  sprite0 = Sprite("0")
  sprite1 = Sprite("1")
  sprite2 = Sprite("2")
  sprite3 = Sprite("3")
  sprite4 = Sprite("4")

  img0 = load("assets/anim/2.jpg")

sprite0.setTexture(img0)
sprite1.setTexture(img0)
sprite2.setTexture(img0)
sprite3.setTexture(img0)
sprite4.setTexture(img0)


sprite0.filter = Color(0xffccaaff'u32)
sprite1.filter = Color(0xffaaccff'u32)
sprite2.filter = Color(0xaaffccff'u32)
sprite3.filter = Color(0xccffaaff'u32)
sprite4.filter = Color(0xaaccffff'u32)


sprite4.move(92, 92)
sprite0.move(128, 128)
sprite3.move(160, 160)
sprite2.move(192, 192)
sprite1.move(224, 224)

ysort.addChilds(sprite0, sprite1, sprite2, sprite3, sprite4)


main.addChild(ysort)
addScene(main)
setMainScene("Main")
windowLaunch()
