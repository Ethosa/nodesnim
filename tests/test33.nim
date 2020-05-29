# --- Test 32. use KinematicBody2D node. --- #
# Please, compile with `--define:debug` or with `-d:debug` for see collision shapes.
import nodesnim


Window("hello world")


var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  shape1_obj: CollisionShape2DObj
  shape1 = CollisionShape2D(shape1_obj)

  shape2_obj: CollisionShape2DObj
  shape2 = CollisionShape2D(shape2_obj)

  shape3_obj: CollisionShape2DObj
  shape3 = CollisionShape2D(shape3_obj)

  body_obj: KinematicBody2DObj
  body = KinematicBody2D(body_obj)


shape1.move(100, 100)
shape2.move(125, 125)
shape1.setShapeTypeCircle(0, 0, 35)
shape2.resize(150, 50)
shape3.setShapeTypeCircle(0, 0, 35)


Input.addButtonAction("left", BUTTON_LEFT)
body.process =
  proc() =
    if Input.isActionPressed("left"):
      let
        mouse_pos = body.getGlobalMousePosition()
        distance = body.global_position.distance(mouse_pos)
        direction = body.global_position.directionTo(mouse_pos)
        speed = 3f
      if distance >= 5:
        discard body.moveAndCollide(direction*speed)


main.addChild(shape1)
main.addChild(shape2)
main.addChild(body)
body.addChild(shape3)
addScene(main)
setMainScene("Main")
windowLaunch()
