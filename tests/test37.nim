# --- Test 37. use Camera2D node. --- #
import nodesnim


Window("hello world")


var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  body_obj: KinematicBody2DObj
  body = KinematicBody2D(body_obj)

  sprite_obj: SpriteObj
  sprite = Sprite(sprite_obj)

  sprite1_obj: SpriteObj
  sprite1 = Sprite(sprite1_obj)

  cameraobj: Camera2DObj
  camera = Camera2D(cameraobj)

  img = load("assets/anim/2.jpg")
  img1 = load("assets/anim/4.jpg")

sprite.setTexture(img)
sprite1.setTexture(img1)
body.addChild(sprite)
body.addChild(camera)

sprite1.move(0, 400)
camera.setTarget(body)
camera.setLimit(-600, -400, 600, 400)
camera.setCurrent()
camera.enableSmooth()



Input.addButtonAction("left", BUTTON_LEFT)
body.on_process =
  proc(self: NodePtr) =
    if Input.isActionPressed("left"):
      let
        mouse_pos = body.getGlobalMousePosition()
        distance = body.global_position.distance(mouse_pos)
        direction = body.global_position.directionTo(mouse_pos)
        speed = 4f
      if distance >= 5:
        body.moveAndCollide(direction*speed)


main.addChild(body)
main.addChild(sprite1)
addScene(main)
setMainScene("Main")
windowLaunch()
