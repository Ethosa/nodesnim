# --- Test 30. use CollisionShape2D. --- #
# Please, compile with `--define:debug` or with `-d:debug` for see collision shapes.
import nodesnim


Window("hello world")


var
  main = Scene("Main")

  shape1 = CollisionShape2D()
  shape2 = CollisionShape2D()
  shape3 = CollisionShape2D()


shape1.move(100, 100)
shape2.move(125, 125)
shape3.move(170, 125)
shape3.setShapeTypeCircle(0, 0, 35)  # by default shape type is a rect, but you can change it at any time.
shape2.disable = true  # by default shape enabled, but you can change it at any time.

echo shape1.isCollide(shape2)  # if one of two shapes is disabled - return false.
echo shape1.isCollide(shape3)
echo shape2.isCollide(shape3)


main.addChild(shape1)
main.addChild(shape2)
main.addChild(shape3)
addScene(main)
setMainScene("Main")
windowLaunch()
