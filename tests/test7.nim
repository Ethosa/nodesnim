# --- Test 7. Input handling. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  mainobj: SceneObj
  main_scene = Scene("Main", mainobj)

  colorrectobj: ColorRectObj
  colorrect = ColorRect(colorrectobj)

main_scene.addChild(colorrect)

# bind actions:
Input.addKeyboardAction("forward", K_w)
Input.addKeyboardAction("left", K_a)
Input.addKeyboardAction("right", K_d)
Input.addKeyboardAction("backward", K_s)
Input.addMouseButtonAction("go", BUTTON_LEFT)


# Create one handler:
colorrect.process =
  proc() =
    let speed = 3f
    if Input.isActionPressed("forward"):  # check action
      colorrect.move(0, -speed)
    if Input.isActionPressed("left"):
      colorrect.move(-speed, 0)
    if Input.isActionPressed("right"):
      colorrect.move(speed, 0)
    if Input.isActionPressed("backward"):
      colorrect.move(0, speed)

    if Input.isActionPressed("go"):
      let target_position = colorrect.getGlobalMousePosition()
      colorrect.move(colorrect.position.directionTo(target_position)*speed)


window.setMainScene(main_scene)
window.launch()
