# --- Test 33. use KinematicBody2D node. --- #
# Please, compile with `--define:debug` or with `-d:debug` for see collision shapes.
import nodesnim


Window("hello world")


var
  main = Scene("Main")

  shape1 = CollisionShape2D()
  shape2 = CollisionShape2D()
  shape3 = CollisionShape2D()
  shape4 = CollisionShape2D()

  body = KinematicBody2D()


shape1.move(100, 100)
shape2.move(125, 125)
shape4.move(360, 25)
shape1.setShapeTypeCircle(0, 0, 35)
shape2.resize(150, 50)
# shape3.setShapeTypeCircle(0, 0, 35)
shape3.setShapeTypePolygon(Vector2(0, 0), Vector2(15, 5), Vector2(28, 15), Vector2(35, 25), Vector2(5, 45))
shape4.setShapeTypePolygon(Vector2(0, 0), Vector2(150, 65), Vector2(25, 150))


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
        body.moveAndCollide(direction*speed)


main.addChild(shape1)
main.addChild(shape2)
main.addChild(shape4)
main.addChild(body)
body.addChild(shape3)
addScene(main)
setMainScene("Main")
windowLaunch()
