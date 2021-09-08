# --- Test 35. use Camera2D node. --- #
import nodesnim


Window("hello world")


var
  main = Scene("Main")

  body = KinematicBody2D()

  sprite = Sprite()

  sprite1 = Sprite()

  camera = Camera2D()

  img = load("assets/anim/2.jpg")
  img1 = load("assets/anim/4.jpg")

sprite.setTexture(img)
sprite1.setTexture(img1)
body.addChild(sprite)
body.addChild(camera)

camera.setTarget(body)
camera.setLimit(-600, -400, 600, 400)
camera.setCurrent()
camera.enableSmooth()



Input.addButtonAction("left", BUTTON_LEFT)
body.on_process =
  proc(self: NodeRef) =
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
