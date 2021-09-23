# --- Test 3. Window events handling. --- #
import nodesnim


Window("newwindow")

var
  main = Scene("Main")

  node = Node("My node")

main.addChild(node)

# Bind actions:
addKeyAction("forward", "w")
addKeyAction("backward", "s")
addKeyAction("left", "a")
addKeyAction("right", "d")
addButtonAction("click", BUTTON_LEFT)
addButtonAction("release", BUTTON_RIGHT)


node.on_process =
  proc(self: NodeRef) =  # This called every frame.
    if isActionJustPressed("click"):  # returns true, when the user clicks the left button one time.
      echo "clicked!"

    if isActionReleased("release"):  # returns true, when the user no more press on the right button.
      echo "release!"

node.on_input =
  proc(self: NodeRef, event: InputEvent) =  # This called only on user input.
    if event.isInputEventMouseButton() and event.pressed:
      echo "hi"
    if isActionPressed("forward"):  # returns true, when user press "w"
      echo "forward"
    if isActionPressed("backward"):  # returns true, when user press "s"
      echo "backward"
    if isActionPressed("left"):  # returns true, when user press "a"
      echo "left"
    if isActionPressed("right"):  # returns true, when user press "d"
      echo "right"


addScene(main)
setMainScene("Main")
windowLaunch()
